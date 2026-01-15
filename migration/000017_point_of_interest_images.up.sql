CREATE TABLE poi_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  poi_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (poi_id) REFERENCES points_of_interest(id) ON DELETE CASCADE
);