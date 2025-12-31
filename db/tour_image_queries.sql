-- name: CreateTourImage :one
INSERT INTO tour_images (tour_id, file_url, alt_text)
VALUES ($1, $2, $3)
RETURNING *;

-- name: ListTourImagesByTour :many
SELECT * FROM tour_images 
WHERE tour_id = $1 
ORDER BY id ASC;  -- or created_at if you add it

-- name: DeleteTourImagesByTour :exec
DELETE FROM tour_images WHERE tour_id = $1;

-- name: UpdateTourImage :one
UPDATE tour_images 
SET file_url = $2, alt_text = $3 
WHERE id = $1 
RETURNING *;

-- name: GetTourImageByID :one
SELECT * FROM tour_images WHERE id = $1;
