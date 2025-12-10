CREATE TABLE itinerary_days (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL,
  day_number INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);