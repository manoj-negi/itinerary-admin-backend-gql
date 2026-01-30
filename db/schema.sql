CREATE TABLE roles (
    id UUID DEFAULT uuid_generate_v7() PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    role_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
 );
 
 CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  permission_name VARCHAR(100) NOT NULL
);

CREATE TABLE role_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  role_id UUID NOT NULL,
  permission_id UUID NOT NULL,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
  FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

CREATE TABLE countries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE states (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  country_id UUID NOT NULL,
  name VARCHAR(100) NOT NULL UNIQUE,
  FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
);

CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  state_id UUID NOT NULL,
  name VARCHAR(150) NOT NULL,
  FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE
);

CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  category_name VARCHAR(200) NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE category_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  category_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

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

CREATE TABLE tour_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  tour_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

CREATE TABLE packages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  tour_id UUID NOT NULL,
  package_name VARCHAR(200) NOT NULL UNIQUE,
  price NUMERIC(10,2) NOT NULL,
  currency VARCHAR(10),
  occupancy VARCHAR(50),
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
);

CREATE TABLE package_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  package_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);

CREATE TABLE itinerary_days (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  package_id UUID NOT NULL,
  day_number INT NOT NULL,
  title VARCHAR(200) UNIQUE NOT NULL,
  description TEXT,
  FOREIGN KEY (package_id) REFERENCES packages(id) ON DELETE CASCADE
);

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

CREATE TABLE poi_images (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  poi_id UUID NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (poi_id) REFERENCES points_of_interest(id) ON DELETE CASCADE
);

CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  user_id UUID NOT NULL,
  package_id UUID NOT NULL,
  total_price NUMERIC(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','confirmed','cancelled','completed')),
  booking_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  travel_start_date DATE NOT NULL,
  travel_end_date DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (package_id) REFERENCES packages(id)
);

CREATE TABLE booking_payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v7(),
  booking_id UUID NOT NULL,
  amount NUMERIC(10,2) NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','paid','failed','refunded')),
  method TEXT NOT NULL
    CHECK (method IN ('upi','card','bank_transfer','cash')),
  paid_at TIMESTAMPTZ,
  FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);