-- name: CreatePackageImage :one
INSERT INTO package_images (package_id, file_url, alt_text)
VALUES ($1, $2, $3)
RETURNING *;

-- name: ListPackageImagesByPackage :many
SELECT * FROM package_images 
WHERE package_id = $1 
ORDER BY id ASC;

-- name: DeletePackageImagesByPackage :exec
DELETE FROM package_images WHERE package_id = $1;

-- name: UpdatePackageImage :one
UPDATE package_images 
SET file_url = $2, alt_text = $3 
WHERE id = $1 
RETURNING *;

-- name: GetPackageImageByID :one
SELECT * FROM package_images WHERE id = $1;
