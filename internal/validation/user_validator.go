package validation

import (
	"errors"
	"regexp"
	"strings"
)

// regex

var (
	emailRegex   = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)
	phoneRegex   = regexp.MustCompile(`^\+?[1-9]\d{7,14}$`) // E.164
	upperRegex   = regexp.MustCompile(`[A-Z]`)
	lowerRegex   = regexp.MustCompile(`[a-z]`)
	numberRegex  = regexp.MustCompile(`[0-9]`)
	specialRegex = regexp.MustCompile(`[^A-Za-z0-9]`)
)

type CreateUserInput struct {
	FullName string
	Email    string
	Password string
	Phone    *string
}

// ValidateCreateUserInput validates user input for creating a user
func ValidateCreateUserInput(input CreateUserInput) error {

	// Full name
	if err := validateFullName(input.FullName); err != nil {
		return err
	}

	// Email
	if err := validateEmail(input.Email); err != nil {
		return err
	}

	// Password
	if err := validatePassword(input.Password); err != nil {
		return err
	}

	// Phone (optional)
	if err := validatePhone(input.Phone); err != nil {
		return err
	}

	return nil
}

func validateFullName(name string) error {
	name = strings.TrimSpace(name)

	if name == "" {
		return errors.New("full_name is required")
	}
	if len(name) < 3 {
		return errors.New("full_name must be at least 3 characters")
	}
	if len(name) > 255 {
		return errors.New("full_name must be 255 characters or less")
	}
	return nil
}

func validateEmail(email string) error {
	email = strings.TrimSpace(email)

	if email == "" {
		return errors.New("email is required")
	}
	if len(email) > 255 {
		return errors.New("email must be 255 characters or less")
	}
	if !emailRegex.MatchString(email) {
		return errors.New("invalid email format")
	}
	return nil
}

func validatePassword(password string) error {
	password = strings.TrimSpace(password)

	if password == "" {
		return errors.New("password is required")
	}
	if len(password) < 8 {
		return errors.New("password must be at least 8 characters long")
	}
	if !upperRegex.MatchString(password) ||
		!lowerRegex.MatchString(password) ||
		!numberRegex.MatchString(password) ||
		!specialRegex.MatchString(password) {
		return errors.New(
			"password must contain uppercase, lowercase, number, and special character",
		)
	}
	return nil
}

func validatePhone(phone *string) error {
	if phone == nil {
		return nil // optional field
	}
	if !phoneRegex.MatchString(strings.TrimSpace(*phone)) {
		return errors.New("invalid phone number format")
	}
	return nil
}
