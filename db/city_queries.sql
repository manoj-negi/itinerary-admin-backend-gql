-- Table creation
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  state_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE
);

-- ---------------------- CRUD QUERIES ----------------------

-- name: CreateCity :one
INSERT INTO cities (state_id, name)
VALUES ($1, $2)
RETURNING id, state_id, name;

-- name: DeleteCity :one
DELETE FROM cities
WHERE id = $1
RETURNING id, state_id, name;

-- name: GetCity :one
SELECT id, state_id, name
FROM cities
WHERE id = $1;

-- name: ListCities :many
SELECT id, state_id, name
FROM cities
ORDER BY id;

-- name: ListCitiesByState :many
SELECT id, state_id, name
FROM cities
WHERE state_id = $1
ORDER BY id;

-- name: UpdateCity :one
UPDATE cities
SET
  state_id = COALESCE($1, state_id),
  name = COALESCE($2, name)
WHERE id = $3
RETURNING id, state_id, name;
