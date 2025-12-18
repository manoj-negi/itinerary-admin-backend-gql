-- name: CreateTour :one
INSERT INTO tours (
  title,
  description,
  category_id,
  city_id,
  duration_days,
  created_by,
  status
)
VALUES ($1, $2, $3, $4, $5, $6, $7)
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

-- name: GetTour :one
SELECT
  id,
  title,
  description,
  category_id,
  city_id,
  duration_days,
  created_by,
  status,
  created_at,
  updated_at
FROM tours
WHERE id = $1;

-- name: ListTours :many
SELECT
  id,
  title,
  description,
  category_id,
  city_id,
  duration_days,
  created_by,
  status,
  created_at,
  updated_at
FROM tours
ORDER BY created_at DESC;

-- name: UpdateTour :one
UPDATE tours
SET
  title = COALESCE($2, title),
  description = COALESCE($3, description),
  category_id = COALESCE($4, category_id),
  city_id = COALESCE($5, city_id),
  duration_days = COALESCE($6, duration_days),
  status = COALESCE($7, status),
  updated_at = NOW()
WHERE id = $1
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

