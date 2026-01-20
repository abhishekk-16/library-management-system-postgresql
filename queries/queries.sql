-- =====================================================
-- REAL-WORLD QUERIES FOR LIBRARY MANAGEMENT SYSTEM
-- Solving Practical Problems
-- =====================================================

-- =====================================================
-- SECTION 1: BOOK SEARCH & AVAILABILITY QUERIES
-- =====================================================

-- Q1: Find all available books by a specific author
-- Use Case: Member wants to browse all available books by George Orwell
SELECT 
    b.title,
    b.isbn,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    c.category_name,
    b.publication_year,
    COUNT(bc.copy_id) AS available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN book_copies bc ON b.book_id = bc.book_id
WHERE a.last_name = 'Orwell'
    AND bc.status = 'Available'
GROUP BY b.book_id, b.title, b.isbn, a.first_name, a.last_name, c.category_name, b.publication_year;

-- Q2: Search books by title (partial match) with availability status
-- Use Case: Member searches for books containing "Harry"
SELECT 
    b.title,
    b.isbn,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    br.branch_name,
    bc.status,
    bc.condition
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE b.title ILIKE '%Harry%'
ORDER BY b.title, br.branch_name;

-- Q3: Find books by category with availability count across all branches
-- Use Case: Show all Science Fiction books and where they're available
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    br.branch_name,
    COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) AS available_count,
    COUNT(bc.copy_id) AS total_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE c.category_name = 'Science Fiction'
GROUP BY b.book_id, b.title, a.first_name, a.last_name, br.branch_name
ORDER BY b.title, br.branch_name;

-- Q4: Find all books published in a specific year range
-- Use Case: Find all books published between 2010-2020
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    p.publisher_name,
    b.publication_year,
    c.category_name
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN publishers p ON b.publisher_id = p.publisher_id
JOIN categories c ON b.category_id = c.category_id
WHERE b.publication_year BETWEEN 2010 AND 2020
ORDER BY b.publication_year DESC, b.title;

-- =====================================================
-- SECTION 2: MEMBER & LOAN MANAGEMENT QUERIES
-- =====================================================

-- Q5: View complete borrowing history of a specific member
-- Use Case: Member wants to see their complete reading history
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    l.loan_date,
    l.due_date,
    l.return_date,
    l.status,
    CASE 
        WHEN l.return_date IS NULL AND l.due_date < CURRENT_DATE THEN 'Overdue'
        WHEN l.return_date IS NULL THEN 'Currently Borrowed'
        WHEN l.return_date > l.due_date THEN 'Returned Late'
        ELSE 'Returned On Time'
    END AS return_status
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
WHERE m.email = 'alice.cooper@email.com'
ORDER BY l.loan_date DESC;

-- Q6: Find all currently borrowed books by a member
-- Use Case: Check what books a member currently has
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.membership_type,
    b.title,
    b.isbn,
    l.loan_date,
    l.due_date,
    CURRENT_DATE - l.due_date AS days_overdue,
    br.branch_name
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE m.member_id = 1
    AND l.status IN ('Active', 'Overdue')
ORDER BY l.due_date;

-- Q7: List all overdue books with member details
-- Use Case: Library needs to send overdue notices
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.phone,
    b.title,
    b.isbn,
    l.loan_date,
    l.due_date,
    CURRENT_DATE - l.due_date AS days_overdue,
    (CURRENT_DATE - l.due_date) * 50.00 AS fine_amount,
    br.branch_name
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE l.status = 'Overdue'
    OR (l.return_date IS NULL AND l.due_date < CURRENT_DATE)
ORDER BY days_overdue DESC;

-- Q8: Find members who have never borrowed a book
-- Use Case: Identify inactive members for engagement campaigns
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.membership_type,
    m.membership_date,
    m.status
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
WHERE l.loan_id IS NULL
    AND m.status = 'Active'
ORDER BY m.membership_date;

-- =====================================================
-- SECTION 3: FINE & PAYMENT MANAGEMENT QUERIES
-- =====================================================

-- Q9: Calculate total unpaid fines for each member
-- Use Case: Generate outstanding fine report
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.phone,
    COUNT(f.fine_id) AS number_of_fines,
    SUM(f.fine_amount) AS total_unpaid_fines,
    MIN(f.fine_date) AS oldest_fine_date
FROM members m
JOIN fines f ON m.member_id = f.member_id
WHERE f.payment_status = 'Unpaid'
GROUP BY m.member_id, m.first_name, m.last_name, m.email, m.phone
ORDER BY total_unpaid_fines DESC;

-- Q10: Generate monthly fine collection report
-- Use Case: Track revenue from fines by month
SELECT 
    TO_CHAR(f.payment_date, 'YYYY-MM') AS payment_month,
    COUNT(f.fine_id) AS number_of_payments,
    SUM(f.fine_amount) AS total_collected,
    ROUND(AVG(f.fine_amount), 2) AS average_fine
FROM fines f
WHERE f.payment_status = 'Paid'
    AND f.payment_date IS NOT NULL
GROUP BY TO_CHAR(f.payment_date, 'YYYY-MM')
ORDER BY payment_month DESC;

-- Q11: Find members with multiple unpaid fines (high-risk borrowers)
-- Use Case: Identify members who may need suspension
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.membership_type,
    COUNT(f.fine_id) AS unpaid_fine_count,
    SUM(f.fine_amount) AS total_owed
FROM members m
JOIN fines f ON m.member_id = f.member_id
WHERE f.payment_status = 'Unpaid'
GROUP BY m.member_id, m.first_name, m.last_name, m.email, m.membership_type
HAVING COUNT(f.fine_id) >= 2
ORDER BY total_owed DESC;

-- =====================================================
-- SECTION 4: INVENTORY & ANALYTICS QUERIES
-- =====================================================

-- Q12: Book popularity - Most borrowed books
-- Use Case: Identify which books to order more copies of
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    c.category_name,
    COUNT(l.loan_id) AS total_borrows,
    COUNT(DISTINCT l.member_id) AS unique_borrowers
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN loans l ON bc.copy_id = l.copy_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name, c.category_name
ORDER BY total_borrows DESC
LIMIT 10;

-- Q13: Branch-wise inventory report
-- Use Case: Understand book distribution across branches
SELECT 
    br.branch_name,
    c.category_name,
    COUNT(bc.copy_id) AS total_copies,
    COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) AS available,
    COUNT(CASE WHEN bc.status = 'Borrowed' THEN 1 END) AS borrowed,
    COUNT(CASE WHEN bc.status = 'Reserved' THEN 1 END) AS reserved,
    COUNT(CASE WHEN bc.status IN ('Lost', 'Under Repair', 'Damaged') THEN 1 END) AS unavailable
FROM branches br
JOIN book_copies bc ON br.branch_id = bc.branch_id
JOIN books b ON bc.book_id = b.book_id
JOIN categories c ON b.category_id = c.category_id
GROUP BY br.branch_id, br.branch_name, c.category_name
ORDER BY br.branch_name, c.category_name;

-- Q14: Find books that are always borrowed (high demand, low supply)
-- Use Case: Identify books that need more copies
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    COUNT(bc.copy_id) AS total_copies,
    COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) AS available_copies,
    COUNT(CASE WHEN bc.status = 'Borrowed' THEN 1 END) AS borrowed_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN book_copies bc ON b.book_id = bc.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name
HAVING COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) = 0
    AND COUNT(bc.copy_id) > 0
ORDER BY total_copies DESC;

-- Q15: Average loan duration by category
-- Use Case: Understand reading patterns
SELECT 
    c.category_name,
    COUNT(l.loan_id) AS total_loans,
    ROUND(AVG(CASE 
        WHEN l.return_date IS NOT NULL 
        THEN l.return_date - l.loan_date 
    END), 2) AS avg_days_borrowed,
    COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) AS late_returns,
    ROUND(100.0 * COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) / 
          NULLIF(COUNT(CASE WHEN l.return_date IS NOT NULL THEN 1 END), 0), 2) AS late_return_percentage
FROM categories c
JOIN books b ON c.category_id = b.category_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN loans l ON bc.copy_id = l.copy_id
GROUP BY c.category_id, c.category_name
ORDER BY total_loans DESC;


-- =====================================================
-- SECTION 5: RESERVATION MANAGEMENT QUERIES
-- =====================================================

-- Q16: View active reservations with wait times
-- Use Case: Show members their pending reservations
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    r.reservation_date,
    r.expiry_date,
    CURRENT_DATE - r.reservation_date AS days_waiting,
    r.status
FROM reservations r
JOIN members m ON r.member_id = m.member_id
JOIN books b ON r.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
WHERE r.status = 'Pending'
ORDER BY r.reservation_date;

-- Q17: Find books with multiple pending reservations
-- Use Case: Identify high-demand books for purchasing decisions
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    COUNT(r.reservation_id) AS pending_reservations,
    COUNT(bc.copy_id) AS total_copies,
    COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) AS available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN reservations r ON b.book_id = r.book_id
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
WHERE r.status = 'Pending'
GROUP BY b.book_id, b.title, a.first_name, a.last_name
HAVING COUNT(r.reservation_id) > 1
ORDER BY pending_reservations DESC;

-- =====================================================
-- SECTION 6: STAFF PERFORMANCE & REPORTING QUERIES
-- =====================================================

-- Q18: Staff performance - Loans processed by each staff member
-- Use Case: Evaluate staff productivity
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    s.position,
    br.branch_name,
    COUNT(l.loan_id) AS loans_processed,
    COUNT(CASE WHEN l.loan_date >= CURRENT_DATE - INTERVAL '30 days' THEN 1 END) AS loans_last_30_days
FROM staff s
JOIN branches br ON s.branch_id = br.branch_id
LEFT JOIN loans l ON s.staff_id = l.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name, s.position, br.branch_name
ORDER BY loans_processed DESC;

-- Q19: Monthly circulation report
-- Use Case: Track library usage trends
SELECT 
    TO_CHAR(l.loan_date, 'YYYY-MM') AS month,
    COUNT(l.loan_id) AS total_loans,
    COUNT(DISTINCT l.member_id) AS unique_members,
    COUNT(CASE WHEN l.return_date IS NOT NULL THEN 1 END) AS returned_books,
    COUNT(CASE WHEN l.status = 'Overdue' THEN 1 END) AS overdue_books
FROM loans l
GROUP BY TO_CHAR(l.loan_date, 'YYYY-MM')
ORDER BY month DESC;

-- Q20: Member registration trends
-- Use Case: Track library membership growth
SELECT 
    TO_CHAR(m.membership_date, 'YYYY-MM') AS registration_month,
    m.membership_type,
    COUNT(m.member_id) AS new_members,
    COUNT(CASE WHEN m.status = 'Active' THEN 1 END) AS currently_active
FROM members m
GROUP BY TO_CHAR(m.membership_date, 'YYYY-MM'), m.membership_type
ORDER BY registration_month DESC, m.membership_type;

-- =====================================================
-- SECTION 7: ADVANCED ANALYTICAL QUERIES
-- =====================================================

-- Q21: Find members who borrowed books but never returned on time
-- Use Case: Identify chronic late returners
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.membership_type,
    COUNT(l.loan_id) AS total_loans,
    COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) AS late_returns,
    ROUND(100.0 * COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) / 
          NULLIF(COUNT(l.loan_id), 0), 2) AS late_return_percentage
FROM members m
JOIN loans l ON m.member_id = l.member_id
WHERE l.return_date IS NOT NULL
GROUP BY m.member_id, m.first_name, m.last_name, m.email, m.membership_type
HAVING COUNT(CASE WHEN l.return_date > l.due_date THEN 1 END) > 0
ORDER BY late_return_percentage DESC;

-- Q22: Book copies needing replacement (Poor/Damaged condition)
-- Use Case: Identify inventory that needs replacement
SELECT 
    b.title,
    b.isbn,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    br.branch_name,
    bc.condition,
    bc.acquisition_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, bc.acquisition_date)) AS years_in_inventory
FROM book_copies bc
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE bc.condition IN ('Poor', 'Damaged')
ORDER BY br.branch_name, b.title;

-- Q23: Revenue analysis - Total value of library inventory
-- Use Case: Calculate total asset value
SELECT 
    br.branch_name,
    COUNT(bc.copy_id) AS total_copies,
    SUM(bc.price) AS total_inventory_value,
    ROUND(AVG(bc.price),2) AS average_book_price
FROM branches br
JOIN book_copies bc ON br.branch_id = bc.branch_id
GROUP BY br.branch_id, br.branch_name
ORDER BY total_inventory_value DESC;

-- Q24: Member engagement score
-- Use Case: Identify most active members
SELECT 
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.membership_type,
    COUNT(DISTINCT l.loan_id) AS books_borrowed,
    COUNT(DISTINCT r.reservation_id) AS books_reserved,
    COUNT(DISTINCT l.loan_id) + COUNT(DISTINCT r.reservation_id) AS engagement_score
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN reservations r ON m.member_id = r.member_id
WHERE m.status = 'Active'
GROUP BY m.member_id, m.first_name, m.last_name, m.membership_type
ORDER BY engagement_score DESC
LIMIT 20;

-- Q25: Books never borrowed (Dead inventory)
-- Use Case: Identify books to consider removing
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author,
    c.category_name,
    p.publisher_name,
    b.publication_year,
    COUNT(bc.copy_id) AS total_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN publishers p ON b.publisher_id = p.publisher_id
JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id
WHERE l.loan_id IS NULL
GROUP BY b.book_id, b.title, a.first_name, a.last_name, c.category_name, p.publisher_name, b.publication_year
ORDER BY b.publication_year DESC;
