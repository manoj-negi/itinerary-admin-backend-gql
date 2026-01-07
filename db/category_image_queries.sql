-- name: CreateCategoryImage :one
INSERT INTO category_images (category_id, file_url, alt_text)
VALUES ($1, $2, $3)
RETURNING *;

-- name: ListCategoryImagesByCategory :many
SELECT * FROM category_images 
WHERE category_id = $1 
ORDER BY id ASC;

-- name: DeleteCategoryImagesByCategory :exec
DELETE FROM category_images WHERE category_id = $1;

-- name: UpdateCategoryImage :one
UPDATE category_images 
SET file_url = $2, alt_text = $3 
WHERE id = $1 
RETURNING *;

-- name: GetCategoryImageByID :one
SELECT * FROM category_images WHERE id = $1;
