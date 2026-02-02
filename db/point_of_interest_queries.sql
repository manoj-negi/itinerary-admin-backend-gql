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
ORDER BY id ASC;

-- name: ListPOIsByCity :many
SELECT id, name, description, city_id, type, created_at, updated_at
FROM points_of_interest
WHERE city_id = $1
ORDER BY id ASC;

-- name: UpdatePOI :one
UPDATE points_of_interest
SET
  name        = COALESCE($2, name),
  description = COALESCE($3, description),
  city_id     = COALESCE($4, city_id),
  type        = COALESCE($5, type)
WHERE id = $1
RETURNING id, name, description, city_id, type, created_at, updated_at;

-- name: DeletePOI :one
DELETE FROM points_of_interest
WHERE id = $1
RETURNING id, name, description, city_id, type, created_at, updated_at;

-- name: ListPOIsWithCity :many
SELECT
  poi.id,
  poi.name as poi_name,
  poi.description,
  poi.city_id,
  poi.type,
  poi.created_at,
  poi.updated_at,

  ci.id as city_id_join,
  ci.name as city_name
FROM points_of_interest poi
LEFT JOIN cities ci ON ci.id = poi.city_id
ORDER BY poi.created_at DESC;
