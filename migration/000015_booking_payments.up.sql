CREATE TABLE booking_payments (
  id SERIAL PRIMARY KEY,
  booking_id INT NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending','paid','failed','refunded')),
  method TEXT NOT NULL CHECK (method IN ('upi','card','bank_transfer','cash')),
  paid_at TIMESTAMPTZ NULL,
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);