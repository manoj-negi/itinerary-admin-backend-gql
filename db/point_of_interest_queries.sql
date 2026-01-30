-- name: CreatePOI :one
INSERT INTO points_of_interest (name, description, city_id, type)
VALUES ($1, $2, $3, $4)
RETURNING id, name, description, city_id, type, created_at, updated_at;

-- name: GetPOI :one
SELECT id, name, description, city_id, type, created_at, updated_at
FROM points_of_interest
WHERE id = $1;

-- name: ListPOIs :many
SELECT id, name, description, city_id, type, created_at, updated_at
FROM points_of_interest
ORDER BY id ASC
LIMIT $1 OFFSET $2;

-- name: ListPOIsByCity :many
SELECT id, name, description, city_id, type, created_at, updated_at
FROM points_of_interest
WHERE city_id = $1
ORDER BY id ASC;

-- name: UpdatePOI :one
UPDATE points_of_interest
SET
  name        = COALESCE(NULLIF(sqlc.arg(name), ''), name),
  description = COALESCE(sqlc.arg(description), description),
  city_id     = COALESCE(sqlc.arg(city_id), city_id),
  type        = COALESCE(NULLIF(sqlc.arg(type), ''), type),
  updated_at  = NOW()
WHERE id = sqlc.arg(id)
RETURNING
  id,
  name,
  description,
  city_id,
  type,
  created_at,
  updated_at;


-- name: DeletePOI :one
DELETE FROM points_of_interest
WHERE id = $1
RETURNING id, name, description, city_id, type, created_at, updated_at;
