CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  package_id INT NOT NULL,
  total_price NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('pending','confirmed','cancelled','completed')),
  booking_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  travel_start_date DATE NOT NULL,
  travel_end_date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (package_id) REFERENCES packages(id)
);