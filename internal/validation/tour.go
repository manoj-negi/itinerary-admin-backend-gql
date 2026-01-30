package validation

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"graphql/internal/db"
	appErr "graphql/internal/errors"

	"github.com/google/uuid"
)

/*
────────────────────────────────
STATUS VALIDATION (EXISTING)
────────────────────────────────
*/

var validTourStatuses = map[string]struct{}{
	"draft":     {},
	"published": {},
	"archived":  {},
}

func ValidateTourStatus(status string) error {
	if _, ok := validTourStatuses[status]; !ok {
		return fmt.Errorf("status must be one of: draft, published, archived")
	}
	return nil
}

/*
────────────────────────────────
FOREIGN KEY VALIDATIONS (NEW)
────────────────────────────────
*/

// ValidateCategoryID ensures category exists
func ValidateCategoryID(ctx context.Context, q *db.Queries, id uuid.UUID) error {
	_, err := q.GetCategory(ctx, id)
	if err == sql.ErrNoRows {
		return errors.New("category not found")
	}
	return err
}

// ValidateCityID ensures city exists
func ValidateCityID(ctx context.Context, qtx *db.Queries, cityID uuid.UUID) error {
	if cityID == uuid.Nil {
		return appErr.InvalidInput()
	}

	exists, err := qtx.CityExists(ctx, cityID)
	if err != nil {
		return appErr.Internal(err)
	}

	if !exists {
		return appErr.InvalidInput()
	}

	return nil
}

// ValidateUserID ensures user exists
func ValidateUserID(ctx context.Context, q *db.Queries, id uuid.UUID) error {
	_, err := q.GetUser(ctx, id)
	if err == sql.ErrNoRows {
		return errors.New("user not found")
	}
	return err
}
