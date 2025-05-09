-- Library Management System Database
-- This SQL file creates a complete library management database with tables,
-- constraints, and relationships

-- Create database
CREATE DATABASE IF NOT EXISTS library_management_system;
USE library_management_system;

-- Members table (1-M with Borrowings)
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    membership_date DATE NOT NULL,
    membership_expiry DATE NOT NULL,
    status ENUM('Active', 'Inactive', 'Suspended') DEFAULT 'Active',
    CONSTRAINT chk_expiry CHECK (membership_expiry > membership_date)
);

-- Authors table (M-M with Books through BookAuthors)
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_year YEAR,
    nationality VARCHAR(50),
    biography TEXT
);

-- Publishers table (1-M with Books)
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- Categories table (M-M with Books through BookCategories)
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Books table (1-M with BookCopies, M-M with Authors/Categories)
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publication_year YEAR,
    edition VARCHAR(20),
    publisher_id INT,
    page_count INT,
    language VARCHAR(30),
    summary TEXT,
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
);

-- BookAuthors junction table (M-M relationship)
CREATE TABLE BookAuthors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE
);

-- BookCategories junction table (M-M relationship)
CREATE TABLE BookCategories (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- BookCopies table (1-M with Borrowings)
CREATE TABLE BookCopies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    acquisition_date DATE NOT NULL,
    status ENUM('Available', 'Checked Out', 'Lost', 'Damaged', 'In Repair') DEFAULT 'Available',
    location VARCHAR(50),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Borrowings table (M-1 with Members and BookCopies)
CREATE TABLE Borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date DATETIME,
    status ENUM('Checked Out', 'Returned', 'Overdue', 'Lost') DEFAULT 'Checked Out',
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (copy_id) REFERENCES BookCopies(copy_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CONSTRAINT chk_due_date CHECK (due_date > checkout_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= checkout_date)
);

-- Fines table (1-1 with Borrowings)
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    borrowing_id INT UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL,
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    FOREIGN KEY (borrowing_id) REFERENCES Borrowings(borrowing_id)
);

-- Staff table (for library employees)
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Staff(staff_id)
);

-- Reservations table (M-1 with Members and Books)
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATETIME NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Pending',
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    CONSTRAINT chk_reservation_expiry CHECK (expiry_date > reservation_date)
);

-- Create indexes for performance
CREATE INDEX idx_books_title ON Books(title);
CREATE INDEX idx_members_name ON Members(last_name, first_name);
CREATE INDEX idx_borrowings_dates ON Borrowings(checkout_date, due_date);
CREATE INDEX idx_bookcopies_status ON BookCopies(status);