package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"graphql/database"
	"graphql/graphql"
	"graphql/graphql/generated"
	"graphql/models"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

func main() {
	// Initialize database connection
	database.InitDB()
	defer database.DB.Close()

	// Create GraphQL resolver
	resolver := &graphql.Resolver{}

	// Create GraphQL executable schema
	config := generated.Config{Resolvers: resolver}
	executableSchema := generated.NewExecutableSchema(config)

	// Create GraphQL handler
	srv := handler.NewDefaultServer(executableSchema)

	// Setup routes
	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)
	http.HandleFunc("/graphql", func(w http.ResponseWriter, r *http.Request) {
		srv.ServeHTTP(w, r)
	})

	// REST login endpoint
	http.HandleFunc("/login", loginHandler)

	fmt.Println("Server is running on http://localhost:8080")
	fmt.Println("GraphQL playground available at http://localhost:8080/")
	fmt.Println("GraphQL endpoint available at http://localhost:8080/query")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

// loginHandler implements a simple REST login endpoint.
// Accepts JSON { "email": "...", "password": "..." }
// Returns { "token": "...", "user": { ... } }
func loginHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, "invalid request", http.StatusBadRequest)
		return
	}

	ctx := r.Context()

	var (
		id        int32
		fullName  string
		email     string
		storedPwd string
		phone     sql.NullString
		roleID    sql.NullInt32
		createdAt time.Time
		updatedAt time.Time
	)

	err := database.DB.QueryRowContext(ctx, `SELECT id, full_name, email, password, phone, role_id, created_at, updated_at FROM users WHERE email = $1`, req.Email).Scan(
		&id, &fullName, &email, &storedPwd, &phone, &roleID, &createdAt, &updatedAt,
	)
	if err == sql.ErrNoRows {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}
	if err != nil {
		http.Error(w, "internal error", http.StatusInternalServerError)
		return
	}

	// Password verification: support bcrypt hashes and plaintext (rehash on first login)
	var ok bool
	if strings.HasPrefix(storedPwd, "$2a$") || strings.HasPrefix(storedPwd, "$2b$") || strings.HasPrefix(storedPwd, "$2y$") {
		if err := bcrypt.CompareHashAndPassword([]byte(storedPwd), []byte(req.Password)); err == nil {
			ok = true
		}
	} else {
		if storedPwd == req.Password {
			ok = true
			// re-hash and update stored password
			if hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost); err == nil {
				_, _ = database.DB.ExecContext(ctx, `UPDATE users SET password = $1 WHERE id = $2`, string(hash), id)
			}
		}
	}

	if !ok {
		http.Error(w, "invalid credentials", http.StatusUnauthorized)
		return
	}

	// Create JWT
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "devsecret"
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": fmt.Sprintf("%d", id),
		"exp": time.Now().Add(24 * time.Hour).Unix(),
	})
	tokenStr, err := token.SignedString([]byte(secret))
	if err != nil {
		http.Error(w, "failed to create token", http.StatusInternalServerError)
		return
	}

	user := models.User{
		ID:        fmt.Sprintf("%d", id),
		FullName:  fullName,
		Email:     email,
		CreatedAt: createdAt,
		UpdatedAt: updatedAt,
	}
	if phone.Valid {
		p := phone.String
		user.Phone = &p
	}
	if roleID.Valid {
		r := fmt.Sprintf("%d", roleID.Int32)
		user.RoleID = &r
	}

	resp := map[string]any{"token": tokenStr, "user": user}
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(resp)
}
