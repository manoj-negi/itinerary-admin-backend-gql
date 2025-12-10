-- name: GetUser :one
SELECT id, full_name, email, phone, created_at, updated_at
FROM users
WHERE id = $1;

-- name: ListUsers :many
SELECT id, full_name, email, phone, created_at, updated_at
FROM users
ORDER BY id;

-- name: CreateUser :one
INSERT INTO users (full_name, email, password, phone)
VALUES ($1, $2, $3, $4)
RETURNING id, full_name, email, phone, created_at, updated_at;

-- name: UpdateUser :one
UPDATE users
SET
  full_name = COALESCE(sqlc.narg('full_name'), full_name),
  email = COALESCE(sqlc.narg('email'), email),
  password = COALESCE(sqlc.narg('password'), password),
  phone = COALESCE(sqlc.narg('phone'), phone),
  updated_at = NOW()
WHERE id = sqlc.arg(id)
RETURNING id, full_name, email, phone, created_at, updated_at;

-- name: DeleteUser :one
DELETE FROM users
WHERE id = $1
RETURNING id, full_name, email, phone, created_at, updated_at;

