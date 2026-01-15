CREATE TABLE tour_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  tour_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);