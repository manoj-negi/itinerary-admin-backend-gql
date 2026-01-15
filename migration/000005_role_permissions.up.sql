CREATE TABLE role_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  role_id UUID NOT NULL,
  permission_id UUID NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);