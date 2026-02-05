package s3service

import (
	"context"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Service struct {
	client *s3.Client
	bucket string
	region string
}

func New(bucket, region string) (*Service, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(region),
	)
	if err != nil {
		return nil, err
	}

	return &Service{
		client: s3.NewFromConfig(cfg),
		bucket: bucket,
		region: region,
	}, nil
}

/* presigned upload */
func (s *Service) PresignUpload(ctx context.Context, key, contentType string) (string, string, error) {

	presigner := s3.NewPresignClient(s.client)

	req, err := presigner.PresignPutObject(ctx, &s3.PutObjectInput{
		Bucket:      &s.bucket,
		Key:         &key,
		ContentType: &contentType,
	}, s3.WithPresignExpires(5*time.Minute))

	if err != nil {
		return "", "", err
	}

	publicUrl := fmt.Sprintf(
		"%s",
		key,
	)

	return req.URL, publicUrl, nil
}
