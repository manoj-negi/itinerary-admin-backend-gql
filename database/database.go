package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"graphql/internal/db"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

var (
	DB      *sql.DB
	Queries *db.Queries
)

// getEnvFromFile returns the value of an environment variable from .env file, or empty string if not set
func getEnvFromFile(key string) string {
	return os.Getenv(key)
}

// InitDB initializes the database connection using .env file only
func InitDB() {
	// Load .env file - fail if file doesn't exist
	if err := godotenv.Load(); err != nil {
		log.Fatal("Failed to load .env file. Please create .env file with database credentials. Error: ", err)
	}

	// Get database configuration from .env file only
	dbUser := getEnvFromFile("DB_USER")
	dbPassword := getEnvFromFile("DB_PASSWORD")
	dbName := getEnvFromFile("DB_NAME")
	dbHost := getEnvFromFile("DB_HOST")
	dbPort := getEnvFromFile("DB_PORT")
	dbSSLMode := getEnvFromFile("DB_SSLMODE")

	// Build connection string from .env file values
	connStr := fmt.Sprintf(
		"user=%s password=%s dbname=%s sslmode=%s host=%s port=%s",
		dbUser, dbPassword, dbName, dbSSLMode, dbHost, dbPort,
	)

	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	if err = DB.Ping(); err != nil {
		log.Fatal("Failed to ping database:", err)
	}
	fmt.Println("Successfully connected to database!")
	// Initialize sqlc queries
	Queries = db.New(DB)
}
