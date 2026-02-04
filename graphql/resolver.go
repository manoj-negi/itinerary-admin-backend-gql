package graphql

import (
	 s3service "graphql/internal/s3"
	
)

// This file will not be regenerated automatically.
// It serves as dependency injection for your app.

type Resolver struct {
	S3 *s3service.Service
}
