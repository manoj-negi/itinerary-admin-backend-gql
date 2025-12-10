CREATE TABLE packages (
  id SERIAL PRIMARY KEY,
  tour_id INT NOT NULL,
  package_name VARCHAR(255) NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  currency VARCHAR(10) NOT NULL,
  occupancy VARCHAR(50),
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);