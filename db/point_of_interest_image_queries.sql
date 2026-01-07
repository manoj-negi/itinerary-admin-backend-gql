-- name: CreatePOIImage :one
INSERT INTO point_of_interest_images (poi_id, file_url, alt_text)
VALUES ($1, $2, $3)
RETURNING *;

-- name: ListPOIImagesByPOI :many
SELECT * FROM point_of_interest_images 
WHERE poi_id = $1 
ORDER BY id ASC;

-- name: DeletePOIImagesByPOI :exec
DELETE FROM point_of_interest_images WHERE poi_id = $1;

-- name: UpdatePOIImage :one
UPDATE point_of_interest_images 
SET file_url = $2, alt_text = $3 
WHERE id = $1 
RETURNING *;

-- name: GetPOIImageByID :one
SELECT * FROM point_of_interest_images WHERE id = $1;
