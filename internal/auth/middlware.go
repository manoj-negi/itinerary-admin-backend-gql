package auth

import (
	"context"
	"net/http"
	"os"
	"strings"

	jwt "github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type contextKey string

const UserCtxKey contextKey = "user"

func Middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		authHeader := r.Header.Get("Authorization")
		if authHeader == "" || !strings.HasPrefix(authHeader, "Bearer ") {
			next.ServeHTTP(w, r)
			return
		}

		secret := os.Getenv("JWT_SECRET")
		if secret == "" {
			next.ServeHTTP(w, r)
			return
		}

		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		token, err := jwt.Parse(tokenStr, func(t *jwt.Token) (interface{}, error) {
			return []byte(secret), nil
		})
		if err != nil || !token.Valid {
			next.ServeHTTP(w, r)
			return
		}

		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			next.ServeHTTP(w, r)
			return
		}

		userID, err := uuid.Parse(claims["sub"].(string))
		if err != nil {
			next.ServeHTTP(w, r)
			return
		}

		var roleID uuid.NullUUID
		if roleStr, ok := claims["role"].(string); ok && roleStr != "" {
			if rid, err := uuid.Parse(roleStr); err == nil {
				roleID = uuid.NullUUID{UUID: rid, Valid: true}
			}
		}

		user := &UserContext{
			UserID: userID,
			RoleID: roleID,
		}

		ctx := context.WithValue(r.Context(), UserCtxKey, user)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
