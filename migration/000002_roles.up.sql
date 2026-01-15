CREATE TABLE roles (
    id UUID DEFAULT uuid_generate_v7() PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );
