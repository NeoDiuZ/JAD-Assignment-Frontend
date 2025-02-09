-- 1. Create the `users` table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Store hashed passwords
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    profile_pic_link VARCHAR(255),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 2. Create the `admins` table
CREATE TABLE admins (
    admin_id SERIAL PRIMARY KEY,
    profile_pic_link VARCHAR(255),
    name VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Store hashed passwords
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 3. Create the `roles` table for dynamic roles
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Create the `admin_roles` table for many-to-many relationships between admins and roles
CREATE TABLE admin_roles (
    admin_role_id SERIAL PRIMARY KEY,
    admin_id INT NOT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

-- 5. Create the `service_categories` table
CREATE TABLE service_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 6. Create the `services` table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    image_path VARCHAR(2048),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES service_categories(category_id) ON DELETE CASCADE
);

-- 7. Create the `booking_statuses` table
CREATE TABLE booking_statuses (
    status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE, -- e.g., pending, confirmed, completed
    description TEXT -- Optional: A brief explanation of the status
);

-- 8. Create the `bookings` table and reference the `booking_statuses` table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    admin_id INT,
    status_id INT NOT NULL, -- Reference to booking_statuses
    booking_time TIMESTAMP NOT NULL, -- The specific timing of the booking
    time_length float NOT NULL,
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES booking_statuses(status_id) ON DELETE SET NULL
);

-- 9. Create the `feedback` table (feedback linked to bookings)
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    booking_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
);

-- 10. Create the `reviews` table (reviews linked to services)
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);

-- 11. Create the `admin_actions` table
CREATE TABLE admin_actions (
    action_id SERIAL PRIMARY KEY,
    admin_id INT NOT NULL,
    action_type VARCHAR(50),
    description TEXT,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id) ON DELETE CASCADE
);

-- 12. Create the `addresses` table
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 13. Create the `audit_logs` table for tracking changes
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(50),
    row_data JSON,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by INT,
    FOREIGN KEY (changed_by) REFERENCES admins(admin_id) ON DELETE SET NULL
);

-- 14. Create the `records` table
CREATE TABLE records (
    record_id SERIAL PRIMARY KEY,
    actor_id INT NOT NULL, -- ID of the user or admin performing the action
    actor_type VARCHAR(50) NOT NULL CHECK (actor_type IN ('user', 'admin')), -- Specify who performed the action
    record_data JSON, -- Data describing the action (e.g., new address details)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 15. Create the `cart` table
CREATE TABLE cart (
    cart_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    service_id INT NOT NULL,
    booking_time TIMESTAMP NOT NULL,
    time_length FLOAT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);

CREATE TABLE shifts (
    shift_id SERIAL PRIMARY KEY,
    admin_id INT NOT NULL,
    shift_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(admin_id) ON DELETE CASCADE,
    CONSTRAINT check_time CHECK (start_time < end_time)
);

ALTER TABLE bookings
ADD COLUMN address_id INT,
ADD CONSTRAINT fk_address FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE SET NULL;

