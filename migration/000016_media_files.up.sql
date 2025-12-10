CREATE TABLE media_files (
  id SERIAL PRIMARY KEY,
  related_type TEXT NOT NULL CHECK (related_type IN ('tour','package','poi')),
  related_id INT NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  file_type TEXT NOT NULL CHECK (file_type IN ('image','video'))
);