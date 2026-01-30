package errors

import (
	"errors"
	"fmt"
	"strings"
)

//
// ================== ERROR CODES ==================
//

type Code string

const (
	CodeUnauthorized Code = "UNAUTHORIZED"
	CodeForbidden    Code = "FORBIDDEN"
	CodeNotFound     Code = "NOT_FOUND"
	CodeInvalidInput Code = "INVALID_INPUT"
	CodeConflict     Code = "CONFLICT"
	CodeInternal     Code = "INTERNAL_ERROR"
)

//
// ================== APP ERROR ==================
//

type AppError struct {
	Code Code
	Err  error // public-safe error
}

func (e *AppError) Error() string {
	return e.Err.Error()
}

//
// ================== GENERIC ERRORS ==================
//

var (
	ErrUnauthorized = errors.New("unauthorized")
	ErrForbidden    = errors.New("forbidden")

	ErrNotFound     = errors.New("not found")
	ErrInvalidInput = errors.New("invalid input")
	ErrConflict     = errors.New("already exists")

	ErrInternal = errors.New("internal server error")
)

//
// ================== HELPERS ==================
//

func New(code Code, err error) error {
	return &AppError{
		Code: code,
		Err:  err,
	}
}

func Wrap(publicErr error, context string) error {
	return fmt.Errorf("%w: %s", publicErr, context)
}

func Unauthorized() error {
	return New(CodeUnauthorized, ErrUnauthorized)
}

func Forbidden() error {
	return New(CodeForbidden, ErrForbidden)
}

func NotFound() error {
	return New(CodeNotFound, ErrNotFound)
}

func InvalidInput() error {
	return New(CodeInvalidInput, ErrInvalidInput)
}

func Conflict() error {
	return New(CodeConflict, ErrConflict)
}

func Internal(err error) error {
	if err != nil {
		fmt.Println("REAL ERROR:", err)
	}
	return New(CodeInternal, ErrInternal)
}

//
// ================== DB ERROR MAPPING ==================
//

func FromDB(err error) error {
	if err == nil {
		return nil
	}

	msg := strings.ToLower(err.Error())

	if strings.Contains(msg, "no rows") {
		return NotFound()
	}

	if strings.Contains(msg, "unique") ||
		strings.Contains(msg, "duplicate key") {
		return Conflict()
	}

	if strings.Contains(msg, "foreign key") {
		return InvalidInput()
	}

	return Internal(err)
}
