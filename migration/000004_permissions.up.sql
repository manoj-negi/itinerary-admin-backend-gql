CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  permission_name VARCHAR(100) NOT NULL
);
