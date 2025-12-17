package models

import "time"

// User represents a user in the GraphQL layer
type User struct {
	ID        string    `json:"id"`
	FullName  string    `json:"full_name"`
	Email     string    `json:"email"`
	Phone     *string   `json:"phone"`
	RoleID    *string   `json:"role_id"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}
type Tour struct {
	ID           int32     `json:"id"`
	Title        string    `json:"title"`
	Description  *string   `json:"description"`
	CategoryID   int32     `json:"category_id"`
	CityID       int32     `json:"city_id"`
	DurationDays int32     `json:"duration_days"`
	CreatedBy    int32     `json:"created_by"`
	Status       string    `json:"status"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}
