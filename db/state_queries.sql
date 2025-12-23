-- name: CreateState :one
INSERT INTO states (country_id, name)
VALUES ($1, $2)
RETURNING id, country_id, name;

-- name: DeleteState :one
DELETE FROM states
WHERE id = $1
RETURNING id, country_id, name;

-- name: GetState :one
SELECT id, country_id, name
FROM states
WHERE id = $1;

-- name: GetStateByName :one
SELECT id, country_id, name
FROM states
WHERE name = $1;

-- name: ListStates :many
SELECT id, country_id, name
FROM states
ORDER BY id;

-- name: ListStatesByCountry :many
SELECT id, country_id, name
FROM states
WHERE country_id = $1
ORDER BY id;

-- name: UpdateState :one
UPDATE states
SET
  country_id = COALESCE($1, country_id),
  name = COALESCE($2, name)
WHERE id = $3
RETURNING id, country_id, name;
