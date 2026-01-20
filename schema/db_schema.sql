-- =====================================================
-- LIBRARY MANAGEMENT SYSTEM - DATABASE SCHEMA
-- PostgreSQL Implementation
-- =====================================================

-- Drop existing tables if they exist (in correct order due to foreign key constraints)
DROP TABLE IF EXISTS fines CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS book_copies CASCADE;
DROP TABLE IF EXISTS books CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS publishers CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

-- =====================================================
-- 1. BRANCHES TABLE
-- Stores library branch information
-- =====================================================
CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    opening_hours VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. STAFF TABLE
-- Stores library staff/employee information
-- =====================================================
CREATE TABLE staff (
    staff_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL CHECK (position IN ('Librarian', 'Assistant', 'Manager', 'Clerk')),
    branch_id INTEGER NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    hire_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE RESTRICT
);

-- =====================================================
-- 3. MEMBERS TABLE
-- Stores library member/patron information
-- =====================================================
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    membership_type VARCHAR(20) NOT NULL CHECK (membership_type IN ('Student', 'Faculty', 'Regular', 'Premium')),
    membership_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expiry_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Suspended', 'Expired')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. CATEGORIES TABLE
-- Stores book category/genre information
-- =====================================================
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. AUTHORS TABLE
-- Stores author information
-- =====================================================
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    biography TEXT,
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. PUBLISHERS TABLE
-- Stores publisher information
-- =====================================================
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(100) UNIQUE NOT NULL,
    country VARCHAR(50),
    website VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. BOOKS TABLE
-- Stores book information (master table)
-- =====================================================
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    author_id INTEGER NOT NULL,
    publisher_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    publication_year INTEGER CHECK (publication_year >= 1000 AND publication_year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    edition VARCHAR(50),
    language VARCHAR(50) DEFAULT 'English',
    pages INTEGER CHECK (pages > 0),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE RESTRICT,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE RESTRICT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- =====================================================
-- 8. BOOK_COPIES TABLE
-- Stores individual physical copies of books
-- =====================================================
CREATE TABLE book_copies (
    copy_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    acquisition_date DATE NOT NULL DEFAULT CURRENT_DATE,
    condition VARCHAR(20) DEFAULT 'Good' CHECK (condition IN ('Excellent', 'Good', 'Fair', 'Poor', 'Damaged')),
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Borrowed', 'Reserved', 'Lost', 'Under Repair')),
    price DECIMAL(10,2) CHECK (price >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE RESTRICT
);

-- =====================================================
-- 9. LOANS TABLE
-- Stores book borrowing/loan transactions
-- =====================================================
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    copy_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    staff_id INTEGER NOT NULL,
    loan_date DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Returned', 'Overdue')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE RESTRICT,
    CHECK (due_date > loan_date)
);

-- =====================================================
-- 10. RESERVATIONS TABLE
-- Stores book reservation requests
-- =====================================================
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    book_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    reservation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Fulfilled', 'Cancelled', 'Expired')),
    expiry_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- =====================================================
-- 11. FINES TABLE
-- Stores fine/penalty information for overdue books
-- =====================================================
CREATE TABLE fines (
    fine_id SERIAL PRIMARY KEY,
    loan_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    fine_amount DECIMAL(10,2) NOT NULL CHECK (fine_amount >= 0),
    fine_date DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_status VARCHAR(20) DEFAULT 'Unpaid' CHECK (payment_status IN ('Unpaid', 'Paid', 'Waived')),
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT
);

-- =====================================================
-- INDEXES FOR BETTER PERFORMANCE
-- =====================================================

-- Frequently searched columns
CREATE INDEX idx_books_isbn ON books(isbn);
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_loans_member ON loans(member_id);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_book_copies_status ON book_copies(status);
CREATE INDEX idx_fines_payment_status ON fines(payment_status);

-- Foreign key indexes for join performance
CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_books_publisher ON books(publisher_id);
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_book_copies_book ON book_copies(book_id);
CREATE INDEX idx_book_copies_branch ON book_copies(branch_id);
CREATE INDEX idx_loans_copy ON loans(copy_id);
CREATE INDEX idx_reservations_book ON reservations(book_id);
CREATE INDEX idx_reservations_member ON reservations(member_id);
