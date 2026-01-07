  CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );

  CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    role_id INT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );

  CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    category_name VARCHAR(150) NOT NULL UNIQUE,
    description TEXT
  );

  CREATE TABLE tours (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    city_id INT NOT NULL,
    duration_days INT NOT NULL,
    created_by INT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
  );

  CREATE TABLE countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE
  );

  CREATE TABLE states (
    id SERIAL PRIMARY KEY,
    country_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(id) ON DELETE CASCADE
  );

  CREATE TABLE cities (
    id SERIAL PRIMARY KEY,
    state_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(id) ON DELETE CASCADE
  );

  CREATE TABLE packages (
    id SERIAL PRIMARY KEY,
    tour_id INT NOT NULL,
    package_name VARCHAR(255) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    occupancy VARCHAR(50),
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (tour_id) REFERENCES tours(id) ON DELETE CASCADE
  );

  CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    package_id INT NOT NULL,
    total_price NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending','confirmed','cancelled','completed')),
    booking_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    travel_start_date DATE NOT NULL,
    travel_end_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (package_id) REFERENCES packages(id)
  );

  CREATE TABLE tour_images (
  id SERIAL PRIMARY KEY,
  tour_id INT NOT NULL REFERENCES tours(id) ON DELETE CASCADE,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255)
);

CREATE TABLE package_images (
  id SERIAL PRIMARY KEY,
  package_id INT NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255)
);

CREATE TABLE points_of_interest (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  city_id INT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('landmark','hotel','restaurant','activity','transport')),
  FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE point_of_interest_images (
  id SERIAL PRIMARY KEY,
  poi_id INT NOT NULL REFERENCES points_of_interest(id) ON DELETE CASCADE,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255)
);

CREATE TABLE category_images (
  id SERIAL PRIMARY KEY,
  category_id INT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  file_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255)
);

