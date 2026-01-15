CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  state_id UUID NOT NULL,
  name VARCHAR(150) NOT NULL,
  FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE
);