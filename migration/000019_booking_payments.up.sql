CREATE TABLE booking_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  booking_id UUID NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','paid','failed','refunded')),
  method TEXT NOT NULL
    CHECK (method IN ('upi','card','bank_transfer','cash')),
  paid_at TIMESTAMPTZ,
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);