-- name: CreateCategory :one
INSERT INTO categories (category_name, description)
VALUES ($1, $2)
RETURNING id, category_name, description;

-- name: GetCategory :one
SELECT id, category_name, description
FROM categories
WHERE id = $1;

-- name: GetCategoryByName :one
SELECT id, category_name, description
FROM categories
WHERE category_name = $1;

-- name: ListCategories :many
SELECT id, category_name, description
FROM categories
ORDER BY category_name;

-- name: UpdateCategory :one
UPDATE categories
SET
  category_name = COALESCE($2, category_name),
  description = COALESCE($3, description)
WHERE id = $1
RETURNING id, category_name, description;

-- name: DeleteCategory :one
DELETE FROM categories
WHERE id = $1
RETURNING id, category_name, description;

