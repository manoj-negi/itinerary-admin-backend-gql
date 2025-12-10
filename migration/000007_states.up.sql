CREATE TABLE states (
  id SERIAL PRIMARY KEY,
  country_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
);