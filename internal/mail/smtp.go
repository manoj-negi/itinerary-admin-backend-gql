package mail

import (
	"fmt"
	"log"
	"os"
	"strconv"

	"gopkg.in/gomail.v2"
)

func newDialer() *gomail.Dialer {
	port, err := strconv.Atoi(os.Getenv("SMTP_PORT"))
	if err != nil {
		port = 587
	}
	return gomail.NewDialer(os.Getenv("SMTP_HOST"), port, os.Getenv("SMTP_USER"), os.Getenv("SMTP_PASS"))
}

func SendInquiryEmail(fullName, email, phone, destination, message string) error {
	adminEmail := os.Getenv("SMTP_USER")
	if adminEmail == "" {
		return fmt.Errorf("SMTP_USER not set")
	}

	m := gomail.NewMessage()
	m.SetHeader("From", adminEmail)
	m.SetHeader("To", adminEmail)
	m.SetHeader("Subject", "🔔 New Travel Inquiry")

	body := fmt.Sprintf(`
New Inquiry Received!

Full Name: %s
Email: %s
Phone: %s
Destination: %s

Message:
%s
`, fullName, email, phone, destination, message)

	m.SetBody("text/plain", body)

	err := newDialer().DialAndSend(m)
	if err != nil {
		log.Println("ADMIN EMAIL ERROR:", err)
	}
	log.Println("✅ Admin email sent")
	return err
}

func SendUserConfirmationEmail(userEmail, fullName, destination string) error {
	fromEmail := os.Getenv("SMTP_USER")
	if fromEmail == "" || userEmail == "" {
		return fmt.Errorf("email config missing")
	}

	m := gomail.NewMessage()
	m.SetAddressHeader("From", fromEmail, "Travel Support")
	m.SetHeader("To", userEmail)
	m.SetHeader("Subject", "We Received Your Inquiry!")

	body := fmt.Sprintf(`
Hi %s,

Thank you! We received your inquiry about %s.

Our team will reply within 24 hours.

Best,
Travel Team
`, fullName, destination)

	m.SetBody("text/plain", body)

	err := newDialer().DialAndSend(m)
	if err != nil {
		log.Println("USER EMAIL ERROR:", err)
	}
	log.Println("✅ User confirmation sent to", userEmail)
	return err
}
