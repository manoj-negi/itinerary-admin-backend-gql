package main

import (
	"encoding/json"
	"fmt"
	"graphql/database"
	"graphql/graphql"
	"graphql/graphql/generated"
	"graphql/internal/auth"
	"log"
	"net/http"
	"os"

	s3service "graphql/internal/s3"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/joho/godotenv"
)

func enableCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		// Allow your frontend origin
		w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")

		// Handle preflight request
		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func main() {
	// Initialize database connection
	database.InitDB()
	defer database.DB.Close()
	godotenv.Load()
	//  create s3 service
	s3svc, err := s3service.New(
		os.Getenv("S3_BUCKET"),
		os.Getenv("AWS_REGION"),
	)
	if err != nil {
		log.Fatal(err)
	}

	//  inject into resolver
	resolver := &graphql.Resolver{
		S3: s3svc,
	}

	// Create GraphQL executable schema
	config := generated.Config{Resolvers: resolver}
	executableSchema := generated.NewExecutableSchema(config)

	srv := handler.NewDefaultServer(executableSchema)

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	// Logout API: POST /logout returns success; client should clear token after.
	http.Handle("/logout", enableCORS(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost && r.Method != http.MethodOptions {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "message": "logged out"})
	})))
	// Middleware runs first to parse JWT and set claims in context; then RequireAuthExceptLogin checks them
	http.Handle("/query", enableCORS(auth.Middleware(auth.RequireAuthExceptLogin(srv))))
	http.Handle("/graphql", enableCORS(auth.Middleware(auth.RequireAuthExceptLogin(srv))))

	fmt.Println("Server is running on http://localhost:8080")
	fmt.Println("GraphQL playground available at http://localhost:8080/")
	fmt.Println("GraphQL endpoint available at http://localhost:8080/query")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
