package auth

import "github.com/google/uuid"

type UserContext struct {
	UserID uuid.UUID
	RoleID uuid.NullUUID
}
