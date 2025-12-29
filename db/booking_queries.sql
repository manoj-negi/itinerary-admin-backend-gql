-- name: CreateBooking :one
INSERT INTO bookings (
  user_id,
  package_id,
  total_price,
  status,
  booking_date,
  travel_start_date,
  travel_end_date
) VALUES (
  $1, $2, $3, $4, COALESCE($5, NOW()), $6, $7
)
RETURNING
  id, user_id, package_id, total_price, status,
  booking_date, travel_start_date, travel_end_date;

-- name: DeleteBooking :one
DELETE FROM bookings
WHERE id = $1
RETURNING
  id, user_id, package_id, total_price, status,
  booking_date, travel_start_date, travel_end_date;

-- name: GetBooking :one
SELECT
  id, user_id, package_id, total_price, status,
  booking_date, travel_start_date, travel_end_date
FROM bookings
WHERE id = $1;

-- name: ListBookings :many
SELECT
  id, user_id, package_id, total_price, status,
  booking_date, travel_start_date, travel_end_date
FROM bookings
ORDER BY id;

-- name: UpdateBooking :one
UPDATE bookings
SET
  user_id           = COALESCE($1, user_id),
  package_id        = COALESCE($2, package_id),
  total_price       = COALESCE($3, total_price),
  status            = COALESCE($4, status),
  booking_date      = COALESCE($5, booking_date),
  travel_start_date = COALESCE($6, travel_start_date),
  travel_end_date   = COALESCE($7, travel_end_date)
WHERE id = $8
RETURNING
  id, user_id, package_id, total_price, status,
  booking_date, travel_start_date, travel_end_date;
