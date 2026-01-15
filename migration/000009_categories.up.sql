CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  category_name VARCHAR(200) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);