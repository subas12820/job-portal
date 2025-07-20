-- Create database
CREATE DATABASE IF NOT EXISTS job_portal3;
USE job_portal3;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('job_seeker', 'company') NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    company_name VARCHAR(255),
    company_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Jobs table
CREATE TABLE jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    salary_range VARCHAR(100),
    location VARCHAR(255) NOT NULL,
    job_type ENUM('full_time', 'part_time', 'contract', 'internship') NOT NULL,
    company_id INT NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Applications table
CREATE TABLE applications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    applicant_id INT NOT NULL,
    cover_letter TEXT,
    status ENUM('pending', 'reviewed', 'accepted', 'rejected') DEFAULT 'pending',
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (applicant_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (job_id, applicant_id)
);

-- Insert sample data
INSERT INTO users (name, email, password, role, company_name, company_description) VALUES
('Tech Solutions Ltd', 'hr@techsolutions.com', '$2a$10$example_hashed_password', 'company', 'Tech Solutions Ltd', 'Leading technology company in Nepal'),
('John Doe', 'john@example.com', '$2a$10$example_hashed_password', 'job_seeker', NULL, NULL);

INSERT INTO jobs (title, description, requirements, salary_range, location, job_type, company_id) VALUES
('Software Developer', 'We are looking for a skilled software developer to join our team.', 'Bachelor degree in Computer Science, 2+ years experience', 'NPR 50,000 - 80,000', 'Kathmandu', 'full_time', 1),
('Frontend Developer', 'Join our frontend team to build amazing user interfaces.', 'Experience with HTML, CSS, JavaScript, React', 'NPR 40,000 - 70,000', 'Pokhara', 'full_time', 1);
