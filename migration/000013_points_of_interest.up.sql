CREATE TABLE points_of_interest (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  city_id INT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('landmark','hotel','restaurant','activity','transport')),
  FOREIGN KEY (city_id) REFERENCES cities(id)
);