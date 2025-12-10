CREATE TABLE tours (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  category_id INT NOT NULL,
  city_id INT NOT NULL,
  duration_days INT NOT NULL,
  created_by INT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('draft','published','archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(id),
  FOREIGN KEY (city_id) REFERENCES cities(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);