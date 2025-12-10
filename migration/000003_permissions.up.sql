CREATE TABLE permissions (
  id SERIAL PRIMARY KEY,
  permission_name VARCHAR(100) NOT NULL UNIQUE
);