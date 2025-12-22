-- name: CreateCountry :one
INSERT INTO countries (name)
VALUES ($1)
RETURNING id, name;

-- name: DeleteCountry :one
DELETE FROM countries
WHERE id = $1
RETURNING id, name;

-- name: GetCountry :one
SELECT id, name
FROM countries
WHERE id = $1;

-- name: GetCountryByName :one
SELECT id, name
FROM countries
WHERE name = $1;

-- name: ListCountries :many
SELECT id, name
FROM countries
ORDER BY id;

-- name: UpdateCountry :one
UPDATE countries
SET name = COALESCE($1, name)
WHERE id = $2
RETURNING id, name;
