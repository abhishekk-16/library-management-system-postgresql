-- =====================================================
-- DUMMY DATA FOR LIBRARY MANAGEMENT SYSTEM
-- =====================================================

-- =====================================================
-- 1. INSERT BRANCHES DATA
-- =====================================================
INSERT INTO branches (branch_name, address, phone, email, opening_hours) VALUES
('Central Library', '123 Main Street, Downtown', '555-0101', 'central@library.com', 'Mon-Sat: 9AM-8PM, Sun: 10AM-6PM'),
('North Branch', '456 Oak Avenue, North District', '555-0102', 'north@library.com', 'Mon-Fri: 10AM-7PM, Sat: 9AM-5PM'),
('South Branch', '789 Pine Road, South Hills', '555-0103', 'south@library.com', 'Mon-Sat: 9AM-6PM'),
('East Branch', '321 Elm Street, East Side', '555-0104', 'east@library.com', 'Mon-Fri: 9AM-7PM, Sat-Sun: 10AM-5PM'),
('West Branch', '654 Maple Drive, West End', '555-0105', 'west@library.com', 'Tue-Sat: 10AM-6PM');

-- =====================================================
-- 2. INSERT STAFF DATA
-- =====================================================
INSERT INTO staff (first_name, last_name, email, phone, position, branch_id, salary, hire_date) VALUES
('Sarah', 'Johnson', 'sarah.j@library.com', '555-1001', 'Manager', 1, 65000.00, '2020-01-15'),
('Michael', 'Chen', 'michael.c@library.com', '555-1002', 'Librarian', 1, 48000.00, '2021-03-20'),
('Emily', 'Williams', 'emily.w@library.com', '555-1003', 'Librarian', 2, 47000.00, '2020-06-10'),
('David', 'Martinez', 'david.m@library.com', '555-1004', 'Assistant', 2, 35000.00, '2022-01-05'),
('Jennifer', 'Taylor', 'jennifer.t@library.com', '555-1005', 'Librarian', 3, 49000.00, '2019-09-12'),
('Robert', 'Anderson', 'robert.a@library.com', '555-1006', 'Clerk', 3, 32000.00, '2022-04-18'),
('Lisa', 'Thomas', 'lisa.t@library.com', '555-1007', 'Librarian', 4, 48500.00, '2021-07-22'),
('James', 'Garcia', 'james.g@library.com', '555-1008', 'Assistant', 4, 36000.00, '2022-09-01'),
('Maria', 'Rodriguez', 'maria.r@library.com', '555-1009', 'Librarian', 5, 47500.00, '2020-11-30'),
('Christopher', 'Lee', 'chris.l@library.com', '555-1010', 'Clerk', 5, 33000.00, '2023-02-14');

-- =====================================================
-- 3. INSERT MEMBERS DATA
-- =====================================================
INSERT INTO members (first_name, last_name, email, phone, address, membership_type, membership_date, expiry_date, status) VALUES
('Alice', 'Cooper', 'alice.cooper@email.com', '555-2001', '12 Apple St', 'Student', '2024-01-10', '2025-01-10', 'Active'),
('Bob', 'Smith', 'bob.smith@email.com', '555-2002', '34 Birch Ave', 'Faculty', '2023-06-15', '2025-06-15', 'Active'),
('Carol', 'Davis', 'carol.davis@email.com', '555-2003', '56 Cedar Rd', 'Regular', '2024-03-20', '2025-03-20', 'Active'),
('Daniel', 'Brown', 'daniel.brown@email.com', '555-2004', '78 Dogwood Ln', 'Premium', '2024-02-28', '2025-02-28', 'Active'),
('Emma', 'Wilson', 'emma.wilson@email.com', '555-2005', '90 Elm St', 'Student', '2024-04-05', '2025-04-05', 'Active'),
('Frank', 'Moore', 'frank.moore@email.com', '555-2006', '23 Fir Ave', 'Regular', '2023-12-10', '2024-12-10', 'Expired'),
('Grace', 'Taylor', 'grace.taylor@email.com', '555-2007', '45 Grove Rd', 'Student', '2024-05-12', '2025-05-12', 'Active'),
('Henry', 'Anderson', 'henry.anderson@email.com', '555-2008', '67 Hill St', 'Faculty', '2024-01-25', '2026-01-25', 'Active'),
('Irene', 'Thomas', 'irene.thomas@email.com', '555-2009', '89 Iris Ln', 'Premium', '2024-06-18', '2025-06-18', 'Active'),
('Jack', 'Jackson', 'jack.jackson@email.com', '555-2010', '12 Jasmine Ave', 'Regular', '2024-03-03', '2025-03-03', 'Active'),
('Kelly', 'White', 'kelly.white@email.com', '555-2011', '34 King St', 'Student', '2024-07-22', '2025-07-22', 'Active'),
('Leo', 'Harris', 'leo.harris@email.com', '555-2012', '56 Lake Rd', 'Regular', '2024-02-14', '2025-02-14', 'Active'),
('Mia', 'Martin', 'mia.martin@email.com', '555-2013', '78 Lark Ave', 'Student', '2024-08-09', '2025-08-09', 'Active'),
('Nathan', 'Thompson', 'nathan.thompson@email.com', '555-2014', '90 Maple St', 'Faculty', '2023-11-11', '2025-11-11', 'Active'),
('Olivia', 'Garcia', 'olivia.garcia@email.com', '555-2015', '23 Oak Ln', 'Premium', '2024-09-30', '2025-09-30', 'Active'),
('Peter', 'Martinez', 'peter.martinez@email.com', '555-2016', '45 Park Ave', 'Regular', '2024-01-08', '2025-01-08', 'Suspended'),
('Quinn', 'Robinson', 'quinn.robinson@email.com', '555-2017', '67 Pine St', 'Student', '2024-04-17', '2025-04-17', 'Active'),
('Rachel', 'Clark', 'rachel.clark@email.com', '555-2018', '89 River Rd', 'Regular', '2024-05-25', '2025-05-25', 'Active'),
('Sam', 'Rodriguez', 'sam.rodriguez@email.com', '555-2019', '12 Rose Ave', 'Student', '2024-06-30', '2025-06-30', 'Active'),
('Tina', 'Lewis', 'tina.lewis@email.com', '555-2020', '34 Spring St', 'Premium', '2024-07-15', '2025-07-15', 'Active');

-- =====================================================
-- 4. INSERT CATEGORIES DATA
-- =====================================================
INSERT INTO categories (category_name, description) VALUES
('Fiction', 'Fictional narratives and novels'),
('Non-Fiction', 'Factual and informational books'),
('Science', 'Scientific research and knowledge'),
('Technology', 'Computer science and technology books'),
('History', 'Historical accounts and research'),
('Biography', 'Life stories of notable individuals'),
('Mystery', 'Mystery and detective fiction'),
('Romance', 'Romantic fiction and love stories'),
('Fantasy', 'Fantasy and magical realism'),
('Self-Help', 'Personal development and improvement'),
('Business', 'Business and management books'),
('Children', 'Books for children and young readers'),
('Philosophy', 'Philosophical texts and discussions'),
('Poetry', 'Collections of poems and poetry'),
('Science Fiction', 'Futuristic and sci-fi literature');

-- =====================================================
-- 5. INSERT AUTHORS DATA
-- =====================================================
INSERT INTO authors (first_name, last_name, biography, country) VALUES
('Jane', 'Austen', 'English novelist known for Pride and Prejudice', 'United Kingdom'),
('George', 'Orwell', 'English novelist and essayist', 'United Kingdom'),
('J.K.', 'Rowling', 'British author of Harry Potter series', 'United Kingdom'),
('Stephen', 'King', 'American author of horror and supernatural fiction', 'United States'),
('Agatha', 'Christie', 'English writer known for detective novels', 'United Kingdom'),
('Isaac', 'Asimov', 'Science fiction and popular science author', 'United States'),
('Harper', 'Lee', 'American novelist known for To Kill a Mockingbird', 'United States'),
('J.R.R.', 'Tolkien', 'English writer and philologist', 'United Kingdom'),
('Mark', 'Twain', 'American writer and humorist', 'United States'),
('Charles', 'Dickens', 'English writer and social critic', 'United Kingdom'),
('F. Scott', 'Fitzgerald', 'American novelist', 'United States'),
('Ernest', 'Hemingway', 'American novelist and short-story writer', 'United States'),
('Virginia', 'Woolf', 'English writer and modernist', 'United Kingdom'),
('Leo', 'Tolstoy', 'Russian writer', 'Russia'),
('Fyodor', 'Dostoevsky', 'Russian novelist and philosopher', 'Russia'),
('Gabriel Garcia', 'Marquez', 'Colombian novelist', 'Colombia'),
('Paulo', 'Coelho', 'Brazilian lyricist and novelist', 'Brazil'),
('Haruki', 'Murakami', 'Japanese writer', 'Japan'),
('Margaret', 'Atwood', 'Canadian poet and novelist', 'Canada'),
('Toni', 'Morrison', 'American novelist', 'United States');

-- =====================================================
-- 6. INSERT PUBLISHERS DATA
-- =====================================================
INSERT INTO publishers (publisher_name, country, website) VALUES
('Penguin Random House', 'United States', 'www.penguinrandomhouse.com'),
('HarperCollins', 'United States', 'www.harpercollins.com'),
('Simon & Schuster', 'United States', 'www.simonandschuster.com'),
('Hachette Book Group', 'United States', 'www.hachettebookgroup.com'),
('Macmillan Publishers', 'United States', 'www.macmillan.com'),
('Oxford University Press', 'United Kingdom', 'www.oup.com'),
('Cambridge University Press', 'United Kingdom', 'www.cambridge.org'),
('Scholastic', 'United States', 'www.scholastic.com'),
('Bloomsbury', 'United Kingdom', 'www.bloomsbury.com'),
('Vintage Books', 'United States', 'www.vintagebooks.com'),
('Wiley', 'United States', 'www.wiley.com'),
('Springer', 'Germany', 'www.springer.com'),
('O''Reilly Media', 'United States', 'www.oreilly.com'),
('McGraw Hill', 'United States', 'www.mheducation.com'),
('Pearson', 'United Kingdom', 'www.pearson.com');

-- =====================================================
-- 7. INSERT BOOKS DATA
-- =====================================================
INSERT INTO books (isbn, title, author_id, publisher_id, category_id, publication_year, edition, language, pages, description) VALUES
('9780141439518', 'Pride and Prejudice', 1, 1, 1, 1813, 'Reprint', 'English', 432, 'A romantic novel of manners'),
('9780451524935', '1984', 2, 2, 1, 1949, 'Reprint', 'English', 328, 'Dystopian social science fiction'),
('9780439708180', 'Harry Potter and the Sorcerer''s Stone', 3, 8, 9, 1997, 'First Edition', 'English', 309, 'Fantasy novel about a young wizard'),
('9780307277671', 'The Shining', 4, 10, 7, 1977, 'Reprint', 'English', 447, 'Horror novel'),
('9780062073488', 'Murder on the Orient Express', 5, 2, 7, 1934, 'Reprint', 'English', 256, 'Detective fiction novel'),
('9780553293357', 'Foundation', 6, 3, 15, 1951, 'First Edition', 'English', 255, 'Science fiction novel'),
('9780060935467', 'To Kill a Mockingbird', 7, 2, 1, 1960, 'Reprint', 'English', 324, 'Coming-of-age story'),
('9780618640157', 'The Lord of the Rings', 8, 4, 9, 1954, 'Special Edition', 'English', 1178, 'Epic fantasy novel'),
('9780486280615', 'Adventures of Huckleberry Finn', 9, 1, 1, 1884, 'Reprint', 'English', 366, 'Adventure novel'),
('9780141439600', 'Great Expectations', 10, 1, 1, 1861, 'Reprint', 'English', 544, 'Coming-of-age novel'),
('9780743273565', 'The Great Gatsby', 11, 3, 1, 1925, 'Reprint', 'English', 180, 'Tragedy of the American dream'),
('9780684801223', 'The Old Man and the Sea', 12, 3, 1, 1952, 'Reprint', 'English', 127, 'Story of an epic struggle'),
('9780156907392', 'To the Lighthouse', 13, 2, 1, 1927, 'Reprint', 'English', 209, 'Modernist novel'),
('9780143039990', 'War and Peace', 14, 1, 5, 1869, 'Reprint', 'English', 1296, 'Historical novel'),
('9780374528379', 'The Brothers Karamazov', 15, 3, 1, 1880, 'Reprint', 'English', 796, 'Philosophical novel'),
('9780060883287', 'One Hundred Years of Solitude', 16, 2, 1, 1967, 'Reprint', 'English', 417, 'Magical realism'),
('9780062315007', 'The Alchemist', 17, 2, 1, 1988, 'Reprint', 'English', 208, 'Allegorical novel'),
('9780307949486', 'Norwegian Wood', 18, 10, 1, 1987, 'Reprint', 'English', 296, 'Coming-of-age romance'),
('9780385490818', 'The Handmaid''s Tale', 19, 4, 15, 1985, 'Reprint', 'English', 311, 'Dystopian novel'),
('9781400033416', 'Beloved', 20, 10, 1, 1987, 'Reprint', 'English', 324, 'Historical fiction'),
('9780596007126', 'Head First Java', 6, 13, 4, 2005, '2nd Edition', 'English', 720, 'Java programming guide'),
('9780134685991', 'Effective Java', 6, 15, 4, 2018, '3rd Edition', 'English', 416, 'Java best practices'),
('9781449355739', 'Learning Python', 6, 13, 4, 2013, '5th Edition', 'English', 1648, 'Python programming'),
('9780262033848', 'Introduction to Algorithms', 6, 6, 4, 2009, '3rd Edition', 'English', 1312, 'Algorithm textbook'),
('9780073523323', 'Database System Concepts', 6, 14, 4, 2010, '6th Edition', 'English', 1376, 'Database fundamentals'),
('9781617294136', 'Atomic Habits', 17, 1, 10, 2018, 'First Edition', 'English', 320, 'Habit formation guide'),
('9780062316097', 'Sapiens', 6, 2, 5, 2011, 'Reprint', 'English', 443, 'Brief history of humankind'),
('9780307887894', 'Thinking Fast and Slow', 6, 10, 2, 2011, 'First Edition', 'English', 499, 'Psychology of decision-making'),
('9780062457714', 'The Subtle Art of Not Giving a F*ck', 17, 2, 10, 2016, 'First Edition', 'English', 224, 'Self-help philosophy'),
('9781501110368', 'It', 4, 3, 7, 1986, 'Reprint', 'English', 1138, 'Horror novel');

-- =====================================================
-- 8. INSERT BOOK_COPIES DATA
-- =====================================================
INSERT INTO book_copies (book_id, branch_id, acquisition_date, condition, status, price) VALUES
-- Central Library (Branch 1)
(1, 1, '2023-01-15', 'Excellent', 'Available', 12.99),
(2, 1, '2023-01-15', 'Good', 'Borrowed', 14.99),
(3, 1, '2023-02-20', 'Excellent', 'Available', 19.99),
(4, 1, '2023-02-20', 'Good', 'Borrowed', 15.99),
(5, 1, '2023-03-10', 'Excellent', 'Available', 13.99),
(6, 1, '2023-03-10', 'Fair', 'Available', 14.99),
(7, 1, '2023-04-05', 'Excellent', 'Borrowed', 16.99),
(8, 1, '2023-04-05', 'Good', 'Available', 29.99),
(9, 1, '2023-05-12', 'Excellent', 'Available', 11.99),
(10, 1, '2023-05-12', 'Good', 'Available', 13.99),
-- North Branch (Branch 2)
(1, 2, '2023-02-10', 'Good', 'Available', 12.99),
(3, 2, '2023-03-15', 'Excellent', 'Borrowed', 19.99),
(5, 2, '2023-04-20', 'Good', 'Available', 13.99),
(7, 2, '2023-05-08', 'Excellent', 'Available', 16.99),
(11, 2, '2023-06-12', 'Good', 'Borrowed', 14.99),
(13, 2, '2023-06-20', 'Excellent', 'Available', 15.99),
(15, 2, '2023-07-05', 'Good', 'Available', 18.99),
(17, 2, '2023-07-18', 'Excellent', 'Available', 12.99),
(19, 2, '2023-08-22', 'Good', 'Reserved', 16.99),
(21, 2, '2023-09-10', 'Excellent', 'Available', 49.99),
-- South Branch (Branch 3)
(2, 3, '2023-02-28', 'Good', 'Available', 14.99),
(4, 3, '2023-03-22', 'Excellent', 'Available', 15.99),
(6, 3, '2023-04-15', 'Good', 'Borrowed', 14.99),
(8, 3, '2023-05-20', 'Excellent', 'Available', 29.99),
(12, 3, '2023-06-25', 'Good', 'Available', 12.99),
(14, 3, '2023-07-10', 'Excellent', 'Borrowed', 22.99),
(16, 3, '2023-08-05', 'Good', 'Available', 17.99),
(18, 3, '2023-08-28', 'Excellent', 'Available', 14.99),
(20, 3, '2023-09-15', 'Good', 'Available', 16.99),
(22, 3, '2023-10-01', 'Excellent', 'Available', 44.99),
-- East Branch (Branch 4)
(9, 4, '2023-03-12', 'Good', 'Available', 11.99),
(10, 4, '2023-04-08', 'Excellent', 'Available', 13.99),
(11, 4, '2023-05-15', 'Good', 'Borrowed', 14.99),
(12, 4, '2023-06-18', 'Excellent', 'Available', 12.99),
(23, 4, '2023-07-22', 'Good', 'Available', 54.99),
(24, 4, '2023-08-10', 'Excellent', 'Borrowed', 89.99),
(25, 4, '2023-09-05', 'Good', 'Available', 119.99),
(26, 4, '2023-09-20', 'Excellent', 'Available', 24.99),
(27, 4, '2023-10-08', 'Good', 'Available', 28.99),
(28, 4, '2023-10-15', 'Excellent', 'Available', 32.99),
-- West Branch (Branch 5)
(13, 5, '2023-04-10', 'Good', 'Available', 15.99),
(14, 5, '2023-05-05', 'Excellent', 'Available', 22.99),
(15, 5, '2023-06-12', 'Good', 'Borrowed', 18.99),
(16, 5, '2023-07-08', 'Excellent', 'Available', 17.99),
(17, 5, '2023-08-15', 'Good', 'Available', 12.99),
(29, 5, '2023-09-12', 'Excellent', 'Available', 19.99),
(30, 5, '2023-10-05', 'Good', 'Borrowed', 16.99),
(3, 5, '2023-10-20', 'Excellent', 'Available', 19.99),
(5, 5, '2023-10-25', 'Good', 'Available', 13.99),
(7, 5, '2023-10-28', 'Excellent', 'Available', 16.99);

-- =====================================================
-- 9. INSERT LOANS DATA
-- =====================================================
INSERT INTO loans (copy_id, member_id, staff_id, loan_date, due_date, return_date, status) VALUES
-- Active loans (not yet returned)
(2, 1, 2, '2024-10-15', '2024-10-29', NULL, 'Active'),
(4, 3, 2, '2024-10-18', '2024-11-01', NULL, 'Active'),
(7, 5, 2, '2024-10-20', '2024-11-03', NULL, 'Active'),
(12, 2, 3, '2024-10-12', '2024-10-26', NULL, 'Active'),
(15, 7, 3, '2024-10-22', '2024-11-05', NULL, 'Active'),
(23, 8, 5, '2024-10-10', '2024-10-24', NULL, 'Overdue'),
(26, 4, 5, '2024-10-08', '2024-10-22', NULL, 'Overdue'),
(34, 11, 7, '2024-10-25', '2024-11-08', NULL, 'Active'),
(45, 9, 9, '2024-10-05', '2024-10-19', NULL, 'Overdue'),
(47, 13, 9, '2024-10-28', '2024-11-11', NULL, 'Active'),
-- Returned loans
(1, 1, 2, '2024-09-10', '2024-09-24', '2024-09-23', 'Returned'),
(3, 2, 2, '2024-09-12', '2024-09-26', '2024-09-25', 'Returned'),
(5, 3, 2, '2024-09-15', '2024-09-29', '2024-10-02', 'Returned'),
(6, 4, 2, '2024-08-20', '2024-09-03', '2024-09-01', 'Returned'),
(8, 5, 2, '2024-08-25', '2024-09-08', '2024-09-08', 'Returned'),
(11, 6, 3, '2024-09-05', '2024-09-19', '2024-09-18', 'Returned'),
(13, 7, 3, '2024-09-08', '2024-09-22', '2024-09-20', 'Returned'),
(14, 8, 3, '2024-08-15', '2024-08-29', '2024-08-28', 'Returned'),
(16, 9, 3, '2024-08-18', '2024-09-01', '2024-09-05', 'Returned'),
(17, 10, 3, '2024-09-20', '2024-10-04', '2024-10-03', 'Returned'),
(20, 11, 5, '2024-08-10', '2024-08-24', '2024-08-30', 'Returned'),
(21, 12, 5, '2024-08-12', '2024-08-26', '2024-08-25', 'Returned'),
(22, 13, 5, '2024-09-01', '2024-09-15', '2024-09-14', 'Returned'),
(24, 14, 5, '2024-09-10', '2024-09-24', '2024-09-22', 'Returned'),
(25, 15, 5, '2024-08-22', '2024-09-05', '2024-09-10', 'Returned');

-- =====================================================
-- 10. INSERT RESERVATIONS DATA
-- =====================================================
INSERT INTO reservations (book_id, member_id, reservation_date, status, expiry_date) VALUES
(2, 10, '2024-10-25', 'Pending', '2024-11-08'),
(4, 12, '2024-10-26', 'Pending', '2024-11-09'),
(19, 14, '2024-10-20', 'Fulfilled', '2024-11-03'),
(8, 15, '2024-10-28', 'Pending', '2024-11-11'),
(3, 17, '2024-10-15', 'Cancelled', '2024-10-29'),
(7, 18, '2024-10-22', 'Pending', '2024-11-05'),
(11, 19, '2024-09-20', 'Expired', '2024-10-04'),
(15, 20, '2024-10-29', 'Pending', '2024-11-12'),
(21, 1, '2024-10-27', 'Pending', '2024-11-10'),
(24, 5, '2024-10-24', 'Pending', '2024-11-07');

-- =====================================================
-- 11. INSERT FINES DATA
-- =====================================================
INSERT INTO fines (loan_id, member_id, fine_amount, fine_date, payment_status, payment_date) VALUES
-- Fines for overdue returns (from returned loans)
(13, 3, 150.00, '2024-10-03', 'Paid', '2024-10-05'),
(19, 9, 200.00, '2024-09-06', 'Paid', '2024-09-08'),
(21, 11, 300.00, '2024-08-31', 'Paid', '2024-09-02'),
(25, 15, 250.00, '2024-09-11', 'Paid', '2024-09-15'),
-- Fines for currently overdue books
(6, 8, 350.00, '2024-10-25', 'Unpaid', NULL),
(7, 4, 450.00, '2024-10-23', 'Unpaid', NULL),
(9, 9, 600.00, '2024-10-20', 'Unpaid', NULL);
