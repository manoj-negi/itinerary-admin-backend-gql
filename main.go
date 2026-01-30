package main

import (
	"fmt"
	"log"
	"net/http"

	"graphql/database"
	"graphql/graphql"
	"graphql/graphql/generated"
	"graphql/internal/auth"

	"github.com/joho/godotenv"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
)

func enableCORS(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(w, r)
	})
}

func main() {
	// Load env first
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}

	// Init DB
	database.InitDB()
	defer database.DB.Close()

	// Resolver
	resolver := &graphql.Resolver{}

	// Schema
	schema := generated.NewExecutableSchema(
		generated.Config{Resolvers: resolver},
	)

	// GraphQL server
	srv := handler.NewDefaultServer(schema)

	// Apply middleware chain
	graphQLHandler := enableCORS(auth.Middleware(srv))

	// Routes
	http.Handle("/", playground.Handler("GraphQL playground", "/graphql"))
	http.Handle("/graphql", graphQLHandler)

	fmt.Println("Server running at http://localhost:8080")
	fmt.Println("Playground at http://localhost:8080/")
	fmt.Println("GraphQL endpoint at http://localhost:8080/graphql")
	// log.Println("JWT_SECRET:", os.Getenv("JWT_SECRET"))

	log.Fatal(http.ListenAndServe(":8080", nil))
}
