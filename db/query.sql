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

