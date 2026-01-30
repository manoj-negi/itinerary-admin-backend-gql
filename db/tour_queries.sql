-- name: CreateTour :one
INSERT INTO tours (title, description, category_id, city_id, duration_days, created_by, status)
VALUES ($1, $2, $3, $4, $5, $6, $7)
RETURNING id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at;

-- name: GetTour :one
SELECT id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at
FROM tours
WHERE id = $1;

-- name: ListTours :many
SELECT id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at
FROM tours
ORDER BY id
LIMIT $1 OFFSET $2;


-- name: UpdateTour :one
UPDATE tours
SET
  title         = CASE WHEN @title::text IS NOT NULL THEN @title ELSE title END,
  description   = CASE WHEN @description::text IS NOT NULL THEN @description ELSE description END,
  category_id   = CASE WHEN @category_id::uuid IS NOT NULL THEN @category_id ELSE category_id END,
  city_id       = CASE WHEN @city_id::uuid IS NOT NULL THEN @city_id ELSE city_id END,
  duration_days = CASE WHEN @duration_days::int IS NOT NULL THEN @duration_days ELSE duration_days END,
  created_by    = CASE WHEN @created_by::uuid IS NOT NULL THEN @created_by ELSE created_by END,
  status        = CASE WHEN @status::text IS NOT NULL THEN @status ELSE status END,
  updated_at    = NOW()
WHERE id = @id
RETURNING
  id,
  title,
  description,
  category_id,
  city_id,
  duration_days,
  created_by,
  status,
  created_at,
  updated_at;


-- name: DeleteTour :one
DELETE FROM tours
WHERE id = $1
RETURNING id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at;
