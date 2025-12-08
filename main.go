package main

import (
	"fmt"
	"graphql/database"
	"graphql/graphql"
	"graphql/graphql/generated"
	"log"
	"net/http"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
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

	fmt.Println("Server is running on http://localhost:8080")
	fmt.Println("GraphQL playground available at http://localhost:8080/")
	fmt.Println("GraphQL endpoint available at http://localhost:8080/query")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
