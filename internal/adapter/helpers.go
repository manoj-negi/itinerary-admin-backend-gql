package adapter

import (
	"database/sql"
	"errors"

	"github.com/google/uuid"
)

func NullString(s *string) sql.NullString {
	if s == nil {
		return sql.NullString{}
	}
	return sql.NullString{String: *s, Valid: true}
}

func ValidateUUID(id uuid.UUID) error {
	if id == uuid.Nil {
		return errors.New("invalid id")
	}
	return nil
}

func NotFound(err error) error {
	if err == sql.ErrNoRows {
		return err
	}
	return err
}
