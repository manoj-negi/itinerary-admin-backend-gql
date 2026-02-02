-- name: CreatePackage :one
INSERT INTO packages (tour_id, package_name, price, currency, occupancy, is_featured)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at;

-- name: GetPackage :one
SELECT id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at
FROM packages
WHERE id = $1;

-- name: ListPackages :many
SELECT id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at
FROM packages
ORDER BY id;

-- name: ListPackagesByTour :many
SELECT id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at
FROM packages
WHERE tour_id = $1
ORDER BY id;

-- name: UpdatePackage :one
UPDATE packages
SET
  tour_id      = COALESCE($1, tour_id),
  package_name = COALESCE($2, package_name),
  price        = COALESCE($3, price),
  currency     = COALESCE($4, currency),
  occupancy    = COALESCE($5, occupancy),
  is_featured  = COALESCE($6, is_featured)
WHERE id = $7
RETURNING id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at;

-- name: DeletePackage :one
DELETE FROM packages
WHERE id = $1
RETURNING id, tour_id, package_name, price, currency, occupancy, is_featured, created_at, updated_at;

-- name: ListPackagesWithTour :many
SELECT
  p.id,
  p.tour_id,
  p.package_name,
  p.price,
  p.currency,
  p.occupancy,
  p.is_featured,
  p.created_at,
  p.updated_at,

  t.id as tour_id_join,
  t.title as tour_title
FROM packages p
LEFT JOIN tours t ON t.id = p.tour_id
ORDER BY p.created_at DESC;