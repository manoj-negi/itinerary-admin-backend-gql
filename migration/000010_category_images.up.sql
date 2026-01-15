CREATE TABLE category_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  category_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);