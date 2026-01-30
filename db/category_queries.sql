-- name: CreateCategory :one
INSERT INTO categories (category_name, description)
VALUES ($1, $2)
RETURNING id, category_name, description, created_at, updated_at;

-- name: GetCategory :one
SELECT id, category_name, description, created_at, updated_at
FROM categories
WHERE id = $1;

-- name: GetCategoryByName :one
SELECT id, category_name, description, created_at, updated_at
FROM categories
WHERE category_name = $1;

-- name: ListCategories :many
SELECT id, category_name, description, created_at, updated_at
FROM categories
ORDER BY id
LIMIT $1 OFFSET $2;


-- name: UpdateCategory :one
UPDATE categories
SET
  category_name = COALESCE(NULLIF($2, ''), category_name),
  description   = COALESCE($3, description),
  updated_at    = NOW()
WHERE id = $1
RETURNING id, category_name, description, created_at, updated_at;


-- name: DeleteCategory :one
DELETE FROM categories
WHERE id = $1
RETURNING id, category_name, description, created_at, updated_at;

