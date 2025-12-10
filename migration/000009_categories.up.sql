CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  category_name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT
);