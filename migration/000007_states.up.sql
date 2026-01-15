CREATE TABLE states (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  country_id UUID NOT NULL,
  name VARCHAR(100) NOT NULL UNIQUE,
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
);