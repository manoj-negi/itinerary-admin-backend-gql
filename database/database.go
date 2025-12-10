package database

import (
	"database/sql"
	"fmt"
	"log"

	"graphql/internal/db"
	"graphql/models"

	_ "github.com/lib/pq"
)

var (
	DB      *sql.DB
	Queries *db.Queries
)

// InitDB initializes the database connection
func InitDB() {
	connStr := "user=postgres password=Qwerty@12 dbname=itenenary sslmode=disable host=localhost port=5432"
	var err error
	DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}

	if err = DB.Ping(); err != nil {
		log.Fatal("Failed to ping database:", err)
	}

	fmt.Println("Successfully connected to database!")

	// Create users table if it doesn't exist
	createTable()

	// Initialize sqlc queries
	Queries = db.New(DB)
}

// createTable creates the users table
func createTable() {
	query := `
	CREATE TABLE IF NOT EXISTS users (
		id SERIAL PRIMARY KEY,
		full_name VARCHAR(255) NOT NULL,
		email VARCHAR(255) UNIQUE NOT NULL,
		password VARCHAR(255) NOT NULL,
		phone VARCHAR(50),
		created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
		updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
	)`

	_, err := DB.Exec(query)
	if err != nil {
		log.Fatal("Failed to create table:", err)
	}

	fmt.Println("Users table ready!")
}

// ToModelUser converts a sqlc User to the GraphQL model.
func ToModelUser(u db.User) *models.User {
	user := &models.User{
		ID:        fmt.Sprintf("%d", u.ID),
		FullName:  u.FullName,
		Email:     u.Email,
		CreatedAt: u.CreatedAt,
		UpdatedAt: u.UpdatedAt,
	}

	if u.Phone.Valid {
		phone := u.Phone.String
		user.Phone = &phone
	}

	return user
}

// ToModelUsers converts a slice of sqlc Users to GraphQL models.
func ToModelUsers(users []db.ListUsersRow) []*models.User {
	out := make([]*models.User, 0, len(users))
	for _, u := range users {
		out = append(out, ToModelUser(db.User{
			ID:        u.ID,
			FullName:  u.FullName,
			Email:     u.Email,
			Phone:     u.Phone,
			CreatedAt: u.CreatedAt,
			UpdatedAt: u.UpdatedAt,
		}))
	}
	return out
}
