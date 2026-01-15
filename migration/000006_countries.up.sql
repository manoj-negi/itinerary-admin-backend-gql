CREATE TABLE countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  name VARCHAR(100) NOT NULL UNIQUE
);