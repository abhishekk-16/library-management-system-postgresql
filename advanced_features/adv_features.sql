-- =====================================================
-- ADVANCED POSTGRESQL FEATURES
-- Functions, Triggers, Views, and Stored Procedures
-- =====================================================

-- =====================================================
-- SECTION 1: CUSTOM FUNCTIONS
-- =====================================================

-- Function 1: Calculate fine amount for overdue books
CREATE OR REPLACE FUNCTION calculate_fine(
    p_loan_id INTEGER
) RETURNS DECIMAL(10,2) AS $$
DECLARE
    v_due_date DATE;
    v_return_date DATE;
    v_days_overdue INTEGER;
    v_fine_amount DECIMAL(10,2);
    v_daily_rate DECIMAL(10,2) := 50.00; -- Rs. 50 per day
BEGIN
    -- Get loan details
    SELECT due_date, return_date 
    INTO v_due_date, v_return_date
    FROM loans
    WHERE loan_id = p_loan_id;

    -- Calculate days overdue
    IF v_return_date IS NULL THEN
        v_days_overdue := CURRENT_DATE - v_due_date;
    ELSE
        v_days_overdue := v_return_date - v_due_date;
    END IF;

    -- Calculate fine (only if overdue)
    IF v_days_overdue > 0 THEN
        v_fine_amount := v_days_overdue * v_daily_rate;
    ELSE
        v_fine_amount := 0.00;
    END IF;

    RETURN v_fine_amount;
END;
$$ LANGUAGE plpgsql;

-- Function 2: Get member's borrowing eligibility
CREATE OR REPLACE FUNCTION check_borrowing_eligibility(
    p_member_id INTEGER
) RETURNS TEXT AS $$
DECLARE
    v_status VARCHAR(20);
    v_active_loans INTEGER;
    v_unpaid_fines DECIMAL(10,2);
    v_membership_type VARCHAR(20);
    v_max_books INTEGER;
BEGIN
    -- Get member details
    SELECT status, membership_type 
    INTO v_status, v_membership_type
    FROM members
    WHERE member_id = p_member_id;

    -- Check membership status
    IF v_status != 'Active' THEN
        RETURN 'Member account is not active';
    END IF;

    -- Get active loans count
    SELECT COUNT(*) INTO v_active_loans
    FROM loans
    WHERE member_id = p_member_id 
        AND status IN ('Active', 'Overdue');

    -- Get unpaid fines
    SELECT COALESCE(SUM(fine_amount), 0) INTO v_unpaid_fines
    FROM fines
    WHERE member_id = p_member_id 
        AND payment_status = 'Unpaid';

    -- Check unpaid fines
    IF v_unpaid_fines > 0 THEN
        RETURN 'Cannot borrow: Unpaid fines of Rs. ' || v_unpaid_fines;
    END IF;

    -- Set max books based on membership type
    v_max_books := CASE v_membership_type
        WHEN 'Student' THEN 5
        WHEN 'Faculty' THEN 10
        WHEN 'Regular' THEN 3
        WHEN 'Premium' THEN 15
        ELSE 3
    END;

    -- Check loan limit
    IF v_active_loans >= v_max_books THEN
        RETURN 'Cannot borrow: Maximum loan limit reached';
    END IF;

    RETURN 'Eligible to borrow';
END;
$$ LANGUAGE plpgsql;

-- Function 3: Get book availability by ISBN
CREATE OR REPLACE FUNCTION get_book_availability(
    p_isbn VARCHAR(13)
) RETURNS TABLE(
    branch_name VARCHAR(100),
    total_copies BIGINT,
    available_copies BIGINT,
    borrowed_copies BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        br.branch_name,
        COUNT(bc.copy_id) AS total_copies,
        COUNT(CASE WHEN bc.status = 'Available' THEN 1 END) AS available_copies,
        COUNT(CASE WHEN bc.status = 'Borrowed' THEN 1 END) AS borrowed_copies
    FROM books b
    JOIN book_copies bc ON b.book_id = bc.book_id
    JOIN branches br ON bc.branch_id = br.branch_id
    WHERE b.isbn = p_isbn
    GROUP BY br.branch_name
    ORDER BY br.branch_name;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- SECTION 2: TRIGGERS
-- =====================================================

-- Trigger 1: Automatically update book copy status when loaned
CREATE OR REPLACE FUNCTION update_copy_status_on_loan()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the book copy status to 'Borrowed'
    UPDATE book_copies
    SET status = 'Borrowed'
    WHERE copy_id = NEW.copy_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_loan_update_copy_status
AFTER INSERT ON loans
FOR EACH ROW
EXECUTE FUNCTION update_copy_status_on_loan();

-- Trigger 2: Update book copy status when returned
CREATE OR REPLACE FUNCTION update_copy_status_on_return()
RETURNS TRIGGER AS $$
BEGIN
    -- Only update if return_date is set (book is returned)
    IF NEW.return_date IS NOT NULL AND OLD.return_date IS NULL THEN
        UPDATE book_copies
        SET status = 'Available'
        WHERE copy_id = NEW.copy_id;

        -- Update loan status
        NEW.status := 'Returned';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_return_update_copy_status
BEFORE UPDATE ON loans
FOR EACH ROW
EXECUTE FUNCTION update_copy_status_on_return();

-- Trigger 3: Automatically create fine for overdue books
CREATE OR REPLACE FUNCTION create_fine_for_overdue()
RETURNS TRIGGER AS $$
DECLARE
    v_fine_amount DECIMAL(10,2);
BEGIN
    -- Check if book is returned late
    IF NEW.return_date IS NOT NULL 
        AND NEW.return_date > NEW.due_date 
        AND OLD.return_date IS NULL THEN

        -- Calculate fine
        v_fine_amount := calculate_fine(NEW.loan_id);

        -- Insert fine record
        INSERT INTO fines (loan_id, member_id, fine_amount, fine_date, payment_status)
        VALUES (NEW.loan_id, NEW.member_id, v_fine_amount, CURRENT_DATE, 'Unpaid');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_create_fine_on_late_return
AFTER UPDATE ON loans
FOR EACH ROW
EXECUTE FUNCTION create_fine_for_overdue();

-- Trigger 4: Update loan status to overdue
CREATE OR REPLACE FUNCTION update_overdue_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Update loans that are past due date
    UPDATE loans
    SET status = 'Overdue'
    WHERE due_date < CURRENT_DATE
        AND return_date IS NULL
        AND status = 'Active';

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Note: This trigger would typically be called by a scheduled job
-- For demonstration, we create it on the loans table
CREATE TRIGGER trg_check_overdue_daily
AFTER INSERT OR UPDATE ON loans
FOR EACH STATEMENT
EXECUTE FUNCTION update_overdue_status();

-- =====================================================
-- SECTION 3: VIEWS
-- =====================================================

-- View 1: Available books with full details
CREATE OR REPLACE VIEW vw_available_books AS
SELECT 
    b.book_id,
    b.isbn,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    c.category_name,
    p.publisher_name,
    b.publication_year,
    b.language,
    br.branch_name,
    bc.copy_id,
    bc.condition,
    bc.status
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
JOIN publishers p ON b.publisher_id = p.publisher_id
JOIN book_copies bc ON b.book_id = bc.book_id
JOIN branches br ON bc.branch_id = br.branch_id
WHERE bc.status = 'Available';

-- View 2: Current loans with member and book details
CREATE OR REPLACE VIEW vw_current_loans AS
SELECT 
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email AS member_email,
    m.phone AS member_phone,
    m.membership_type,
    b.title AS book_title,
    b.isbn,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    br.branch_name,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    l.loan_date,
    l.due_date,
    l.status,
    CASE 
        WHEN l.due_date < CURRENT_DATE THEN CURRENT_DATE - l.due_date
        ELSE 0
    END AS days_overdue
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN authors a ON b.author_id = a.author_id
JOIN branches br ON bc.branch_id = br.branch_id
JOIN staff s ON l.staff_id = s.staff_id
WHERE l.status IN ('Active', 'Overdue');

-- View 3: Member summary with statistics
CREATE OR REPLACE VIEW vw_member_summary AS
SELECT 
    m.member_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.membership_type,
    m.status,
    m.membership_date,
    m.expiry_date,
    COUNT(DISTINCT l.loan_id) AS total_books_borrowed,
    COUNT(DISTINCT CASE WHEN l.status IN ('Active', 'Overdue') THEN l.loan_id END) AS current_loans,
    COALESCE(SUM(CASE WHEN f.payment_status = 'Unpaid' THEN f.fine_amount ELSE 0 END), 0) AS unpaid_fines,
    COUNT(DISTINCT r.reservation_id) AS active_reservations
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
LEFT JOIN fines f ON m.member_id = f.member_id
LEFT JOIN reservations r ON m.member_id = r.member_id AND r.status = 'Pending'
GROUP BY m.member_id, m.first_name, m.last_name, m.email, m.membership_type, 
         m.status, m.membership_date, m.expiry_date;

-- View 4: Book statistics
CREATE OR REPLACE VIEW vw_book_statistics AS
SELECT 
    b.book_id,
    b.isbn,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    c.category_name,
    COUNT(DISTINCT bc.copy_id) AS total_copies,
    COUNT(DISTINCT CASE WHEN bc.status = 'Available' THEN bc.copy_id END) AS available_copies,
    COUNT(DISTINCT CASE WHEN bc.status = 'Borrowed' THEN bc.copy_id END) AS borrowed_copies,
    COUNT(DISTINCT l.loan_id) AS total_times_borrowed,
    COUNT(DISTINCT l.member_id) AS unique_borrowers
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id
LEFT JOIN book_copies bc ON b.book_id = bc.book_id
LEFT JOIN loans l ON bc.copy_id = l.copy_id
GROUP BY b.book_id, b.isbn, b.title, a.first_name, a.last_name, c.category_name;

-- View 5: Overdue loans summary
CREATE OR REPLACE VIEW vw_overdue_summary AS
SELECT 
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    m.email,
    m.phone,
    b.title,
    b.isbn,
    l.due_date,
    CURRENT_DATE - l.due_date AS days_overdue,
    (CURRENT_DATE - l.due_date) * 50.00 AS calculated_fine,
    COALESCE(f.fine_amount, 0) AS recorded_fine,
    COALESCE(f.payment_status, 'Not Recorded') AS fine_status,
    br.branch_name
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN branches br ON bc.branch_id = br.branch_id
LEFT JOIN fines f ON l.loan_id = f.loan_id
WHERE l.status = 'Overdue'
    OR (l.return_date IS NULL AND l.due_date < CURRENT_DATE);

-- =====================================================
-- SECTION 4: STORED PROCEDURES
-- =====================================================

-- Procedure 1: Process book return
CREATE OR REPLACE PROCEDURE return_book(
    p_loan_id INTEGER
) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_copy_id INTEGER;
    v_member_id INTEGER;
BEGIN
    -- Get loan details
    SELECT copy_id, member_id INTO v_copy_id, v_member_id
    FROM loans
    WHERE loan_id = p_loan_id;

    -- Update loan with return date
    UPDATE loans
    SET return_date = CURRENT_DATE,
        status = 'Returned'
    WHERE loan_id = p_loan_id;

    -- Update book copy status
    UPDATE book_copies
    SET status = 'Available'
    WHERE copy_id = v_copy_id;

    RAISE NOTICE 'Book returned successfully';
END;
$$;

-- Procedure 2: Issue book to member
CREATE OR REPLACE PROCEDURE issue_book(
    p_copy_id INTEGER,
    p_member_id INTEGER,
    p_staff_id INTEGER,
    p_loan_days INTEGER DEFAULT 14
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_eligibility TEXT;
    v_copy_status VARCHAR(20);
BEGIN
    -- Check member eligibility
    v_eligibility := check_borrowing_eligibility(p_member_id);

    IF v_eligibility != 'Eligible to borrow' THEN
        RAISE EXCEPTION '%', v_eligibility;
    END IF;

    -- Check copy availability
    SELECT status INTO v_copy_status
    FROM book_copies
    WHERE copy_id = p_copy_id;

    IF v_copy_status != 'Available' THEN
        RAISE EXCEPTION 'Book copy is not available';
    END IF;

    -- Create loan record
    INSERT INTO loans (copy_id, member_id, staff_id, loan_date, due_date, status)
    VALUES (p_copy_id, p_member_id, p_staff_id, CURRENT_DATE, 
            CURRENT_DATE + p_loan_days, 'Active');

    -- Update copy status
    UPDATE book_copies
    SET status = 'Borrowed'
    WHERE copy_id = p_copy_id;

    RAISE NOTICE 'Book issued successfully';
END;
$$;

-- =====================================================
-- USAGE EXAMPLES
-- =====================================================

-- Example: Calculate fine for a loan
-- SELECT calculate_fine(1);

-- Example: Check member eligibility
-- SELECT check_borrowing_eligibility(1);

-- Example: Get book availability
-- SELECT * FROM get_book_availability('9780141439518');

-- Example: Issue a book
-- CALL issue_book(1, 1, 1, 14);

-- Example: Return a book
-- CALL return_book(1);

-- Example: Query views
-- SELECT * FROM vw_available_books LIMIT 10;
-- SELECT * FROM vw_current_loans;
-- SELECT * FROM vw_member_summary WHERE status = 'Active';
-- SELECT * FROM vw_book_statistics ORDER BY total_times_borrowed DESC LIMIT 10;
-- SELECT * FROM vw_overdue_summary;
