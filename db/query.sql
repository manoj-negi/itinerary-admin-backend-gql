-- name: GetUser :one
SELECT id, full_name, email, phone, role_id, created_at, updated_at
FROM users
WHERE id = $1;

-- name: ListUsers :many
SELECT id, full_name, email, phone, role_id, created_at, updated_at
FROM users
ORDER BY id;

-- name: CreateUser :one
INSERT INTO users (full_name, email, password, phone, role_id)
VALUES ($1, $2, $3, $4, $5)
RETURNING id, full_name, email, phone, role_id, created_at, updated_at;

-- name: UpdateUser :one
UPDATE users
SET
  full_name = COALESCE(sqlc.narg('full_name'), full_name),
  email = COALESCE(sqlc.narg('email'), email),
  password = COALESCE(sqlc.narg('password'), password),
  phone = COALESCE(sqlc.narg('phone'), phone),
  role_id = COALESCE(sqlc.narg('role_id'), role_id),
  updated_at = NOW()
WHERE id = sqlc.arg(id)
RETURNING id, full_name, email, phone, role_id, created_at, updated_at;

-- name: DeleteUser :one
DELETE FROM users
WHERE id = $1
RETURNING id, full_name, email, phone, created_at, updated_at;

-- name: GetUserByEmail :one
SELECT id, full_name, email, password, phone, role_id, created_at, updated_at
FROM users
WHERE email = $1;

-- tour related queries
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
