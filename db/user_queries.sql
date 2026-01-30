-- name: CreateUser :one
INSERT INTO users (full_name, email, password, phone, role_id)
VALUES ($1, $2, $3, $4, $5)
RETURNING id, full_name, email, phone, role_id, created_at, updated_at;

-- name: DeleteUser :one
DELETE FROM users
WHERE id = $1
RETURNING id, full_name, email, phone, created_at, updated_at;

-- name: GetUser :one
SELECT id, full_name, email, phone, role_id, created_at, updated_at
FROM users
WHERE id = $1;

-- name: GetUserByEmail :one
SELECT id, full_name, email, password, phone, role_id, created_at, updated_at
FROM users
WHERE email = $1;

-- name: ListUsers :many
SELECT id, full_name, email, phone, role_id, created_at, updated_at
FROM users
ORDER BY id;

-- name: UpdateUser :one
UPDATE users
SET
  full_name = COALESCE($1, full_name),
  email = COALESCE($2, email),
  password  = COALESCE(NULLIF($3, ''), password),
  phone = COALESCE($4, phone),
  role_id = COALESCE($5, role_id),
  updated_at = NOW()
WHERE id = $6
RETURNING id, full_name, email, phone, role_id, created_at, updated_at;

