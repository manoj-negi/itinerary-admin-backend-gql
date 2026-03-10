CREATE TABLE tours (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  title VARCHAR(300) NOT NULL UNIQUE,
  description TEXT,
  category_id UUID NOT NULL,
  city_id UUID NOT NULL,
  duration_days INT NOT NULL,
  created_by UUID NOT NULL,
  status TEXT NOT NULL DEFAULT 'draft'
    CHECK (status IN ('draft','published','archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
  FOREIGN KEY (city_id) REFERENCES cities(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE
);
ALTER TABLE tours DROP CONSTRAINT tours_created_by_fkey;
ALTER TABLE tours DROP COLUMN created_by;
