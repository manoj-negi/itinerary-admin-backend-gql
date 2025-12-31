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
ORDER BY id;

-- name: UpdateTour :one
UPDATE tours
SET
  title         = COALESCE($1, title),
  description   = COALESCE($2, description),
  category_id   = COALESCE($3, category_id),
  city_id       = COALESCE($4, city_id),
  duration_days = COALESCE($5, duration_days),
  created_by    = COALESCE($6, created_by),
  status        = COALESCE($7, status),
  updated_at    = NOW()
WHERE id = $8
RETURNING id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at;

-- name: DeleteTour :one
DELETE FROM tours
WHERE id = $1
RETURNING id, title, description, category_id, city_id, duration_days, created_by, status, created_at, updated_at;
