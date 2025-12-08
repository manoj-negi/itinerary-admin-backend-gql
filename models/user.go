package models

import (
	"database/sql"
	"strconv"
	"time"
)

// User represents a user in the database
type User struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Age       *int      `json:"age"`
	CreatedAt time.Time `json:"created_at"`
}

// UserDB represents a user in the database with integer ID
type UserDB struct {
	ID        int
	Name      string
	Email     string
	Age       sql.NullInt64
	CreatedAt time.Time
}

// ToUser converts UserDB to User (converting int ID to string)
func (u *UserDB) ToUser() *User {
	user := &User{
		ID:        strconv.Itoa(u.ID),
		Name:      u.Name,
		Email:     u.Email,
		CreatedAt: u.CreatedAt,
	}
	if u.Age.Valid {
		ageInt := int(u.Age.Int64)
		user.Age = &ageInt
	}
	return user
}
