package auth

import (
	"context"
	"errors"

	"github.com/google/uuid"
)

// Replace these with REAL role IDs from your DB
var (
	RoleAdmin = uuid.MustParse("019bc552-0850-777b-aec5-64bddb75bc19")
)

func RequireRole(ctx context.Context, allowedRoles ...uuid.UUID) error {
	user, ok := ctx.Value(UserCtxKey).(*UserContext)
	if !ok {
		return errors.New("unauthorized")
	}

	if !user.RoleID.Valid {
		return errors.New("forbidden")
	}

	for _, role := range allowedRoles {
		if user.RoleID.UUID == role {
			return nil
		}
	}

	return errors.New("forbidden")
}
