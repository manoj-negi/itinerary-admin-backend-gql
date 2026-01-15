CREATE TABLE itinerary_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  package_id UUID NOT NULL,
  day_number INT NOT NULL,
  title VARCHAR(200) UNIQUE NOT NULL,
  description TEXT,
  FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);