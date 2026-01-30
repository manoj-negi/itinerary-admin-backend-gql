-- name: CreatePOIImage :one
INSERT INTO poi_images (poi_id, file_url, alt_text)
VALUES ($1, $2, $3)
RETURNING id, poi_id, file_url, alt_text, created_at, updated_at;

-- name: ListPOIImagesByPOI :many
SELECT id, poi_id, file_url, alt_text, created_at, updated_at
FROM poi_images
WHERE poi_id = $1
ORDER BY id ASC;

-- name: DeletePOIImagesByPOI :exec
DELETE FROM poi_images WHERE poi_id = $1;

-- name: UpdatePOIImage :one
UPDATE poi_images 
SET file_url = $2, alt_text = $3 
WHERE id = $1 
RETURNING id, poi_id, file_url, alt_text, created_at, updated_at;

-- name: GetPOIImageByID :one
SELECT id, poi_id, file_url, alt_text, created_at, updated_at
FROM poi_images
WHERE id = $1;
