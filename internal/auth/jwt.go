package auth

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/vektah/gqlparser/v2/ast"
	"github.com/vektah/gqlparser/v2/parser"
)

type contextKey string

const claimsContextKey contextKey = "claims"

// Claim names used in the JWT (so login and middleware stay in sync).
const (
	ClaimSub   = "sub" // user ID (UUID string)
	ClaimEmail = "email"
	ClaimRole  = "role"
	ClaimExp   = "exp"
	ClaimIat   = "iat"
)

// Claims holds the payload your middleware needs to authorize requests.
type Claims struct {
	UserID uuid.UUID
	Email  string
	Role   string
}

// ParseToken validates the JWT and returns claims for use in middleware.
// Secret is read from JWT_SECRET if empty.
func ParseToken(tokenString string, secret string) (*Claims, error) {
	if secret == "" {
		secret = os.Getenv("JWT_SECRET")
	}
	if secret == "" {
		secret = "devsecret"
	}

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("unexpected signing method")
		}
		return []byte(secret), nil
	})
	if err != nil {
		return nil, err
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || !token.Valid {
		return nil, errors.New("invalid token")
	}

	sub, _ := claims[ClaimSub].(string)
	userID, err := uuid.Parse(sub)
	if err != nil {
		return nil, errors.New("invalid sub claim")
	}

	email, _ := claims[ClaimEmail].(string)
	role, _ := claims[ClaimRole].(string)

	return &Claims{
		UserID: userID,
		Email:  email,
		Role:   role,
	}, nil
}

// FromContext returns the Claims stored in ctx by the middleware, or nil.
func FromContext(ctx context.Context) *Claims {
	c, _ := ctx.Value(claimsContextKey).(*Claims)
	return c
}

// Middleware parses Authorization: Bearer <token> when present and puts Claims
// into the request context. If the header is missing or invalid, context has no
// claims; resolvers can check auth.FromContext(ctx) == nil and return "unauthorized".
// Use this so login (no token) still works while other operations require a valid token.
func Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		authHeader := r.Header.Get("Authorization")
		if strings.HasPrefix(authHeader, "Bearer ") {
			tokenString := strings.TrimPrefix(authHeader, "Bearer ")
			if claims, err := ParseToken(tokenString, ""); err == nil {
				ctx = context.WithValue(ctx, claimsContextKey, claims)
			}
		}
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// RequireAuth is HTTP middleware that returns 401 if the request has no valid
// Bearer token. Use for non-GraphQL routes that must be authenticated.
func RequireAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if !strings.HasPrefix(authHeader, "Bearer ") {
			http.Error(w, `{"errors":[{"message":"missing authorization header"}]}`, http.StatusUnauthorized)
			return
		}
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		claims, err := ParseToken(tokenString, "")
		if err != nil {
			http.Error(w, `{"errors":[{"message":"invalid or expired token"}]}`, http.StatusUnauthorized)
			return
		}
		ctx := context.WithValue(r.Context(), claimsContextKey, claims)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}

// graphqlRequest is the standard GraphQL HTTP request body.
type graphqlRequest struct {
	Query         string                 `json:"query"`
	OperationName string                 `json:"operationName"`
	Variables     map[string]interface{} `json:"variables"`
}

// isPublicOperation returns true if the request is only the login or logout mutation.
// Must be called after Middleware so context may already have claims.
func isPublicOperation(body []byte) bool {
	var req graphqlRequest
	if err := json.Unmarshal(body, &req); err != nil {
		return false
	}
	query := strings.TrimSpace(req.Query)
	if query == "" {
		return false
	}
	doc, err := parser.ParseQuery(&ast.Source{Input: query})
	if err != nil || len(doc.Operations) == 0 {
		return false
	}
	var op *ast.OperationDefinition
	for _, o := range doc.Operations {
		if req.OperationName != "" {
			if o.Name == req.OperationName {
				op = o
				break
			}
		} else {
			op = o
			break
		}
	}
	if op == nil {
		return false
	}
	if op.Operation != ast.Mutation || len(op.SelectionSet) != 1 {
		return false
	}
	field, ok := op.SelectionSet[0].(*ast.Field)
	if !ok {
		return false
	}
	return field.Name == "login" || field.Name == "logout"
}

// RequireAuthExceptLogin runs after Middleware. It requires a valid JWT for every
// GraphQL request except when the operation is the login mutation. Use for
// /query and /graphql so only login can be called without a token.
func RequireAuthExceptLogin(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			next.ServeHTTP(w, r)
			return
		}
		body, err := io.ReadAll(r.Body)
		if err != nil {
			http.Error(w, `{"errors":[{"message":"failed to read request"}]}`, http.StatusBadRequest)
			return
		}
		r.Body = io.NopCloser(bytes.NewReader(body))

		if isPublicOperation(body) {
			next.ServeHTTP(w, r)
			return
		}

		if FromContext(r.Context()) == nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusUnauthorized)
			w.Write([]byte(`{"errors":[{"message":"unauthorized"}]}`))
			return
		}
		next.ServeHTTP(w, r)
	})
}
