-- name: GetRoleByID :one
SELECT id, role_name, created_at
FROM roles
WHERE id = $1;
