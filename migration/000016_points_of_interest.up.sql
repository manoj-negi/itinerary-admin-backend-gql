CREATE TABLE points_of_interest (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  name VARCHAR(200) NOT NULL UNIQUE,
  description TEXT,
  city_id UUID NOT NULL,
  type TEXT NOT NULL
    CHECK (type IN ('landmark','hotel','restaurant','activity','transport')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE
);