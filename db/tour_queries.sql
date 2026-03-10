
-- name: CreateTour :one
INSERT INTO tours (title, description, category_id, city_id, duration_days, status)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING id, title, description, category_id, city_id, duration_days, status, created_at, updated_at;

-- name: GetTour :one
SELECT id, title, description, category_id, city_id, duration_days, status, created_at, updated_at
FROM tours
WHERE id = $1;

-- name: ListTours :many
SELECT id, title, description, category_id, city_id, duration_days, status, created_at, updated_at
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
  status        = COALESCE($6, status),
  updated_at    = NOW()
WHERE id = $7
RETURNING id, title, description, category_id, city_id, duration_days, status, created_at, updated_at;

-- name: DeleteTour :one
DELETE FROM tours
WHERE id = $1
RETURNING id, title, description, category_id, city_id, duration_days, status, created_at, updated_at;

-- name: ListToursWithCategoryCity :many
SELECT
  t.id,
  t.title,
  t.description,
  t.category_id,
  t.city_id,
  t.duration_days,
  t.status,
  t.created_at,
  t.updated_at,

  c.id as category_id_join,
  c.category_name as category_name,

  ci.id as city_id_join,
  ci.name as city_name
FROM tours t
LEFT JOIN categories c ON c.id = t.category_id
LEFT JOIN cities ci ON ci.id = t.city_id
ORDER BY t.created_at DESC;