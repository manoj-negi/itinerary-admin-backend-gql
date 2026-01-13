package main

import (
	"fmt"
	"graphql/database"
	"graphql/graphql"
	"graphql/graphql/generated"
	"log"
	"net/http"

	"github.com/joho/godotenv"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
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
	// Create GraphQL resolver
	resolver := &graphql.Resolver{}

	// Create GraphQL executable schema
	config := generated.Config{Resolvers: resolver}
	executableSchema := generated.NewExecutableSchema(config)

	srv := handler.NewDefaultServer(executableSchema)

	http.Handle("/", playground.Handler("GraphQL playground", "/query"))
	http.Handle("/query", srv)
	http.Handle("/graphql", enableCORS(srv))

	fmt.Println("Server is running on http://localhost:8080")
	fmt.Println("GraphQL playground available at http://localhost:8080/")
	fmt.Println("GraphQL endpoint available at http://localhost:8080/query")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
