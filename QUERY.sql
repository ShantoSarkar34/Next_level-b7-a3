-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;

DROP TABLE IF EXISTS Matches;

DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id int PRIMARY KEY,
    full_name varchar(50) NOT NULL,
    email varchar(100) UNIQUE NOT NULL,
    role varchar(20) CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number varchar(20)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id int PRIMARY KEY,
    fixture varchar(100),
    tournament_category varchar(50),
    base_ticket_price decimal(10, 2) CHECK (base_ticket_price >= 0),
    match_status varchar(20) CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id int PRIMARY KEY,
    user_id int REFERENCES users (user_id),
    match_id int REFERENCES matches (match_id),
    seat_number varchar(20),
    payment_status varchar(20) CHECK (
        payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    ),
    total_cost decimal(10, 2) CHECK (total_cost >= 0)
);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================================================
-- QUERY NO.1
-- =========================================================================
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM
    matches
WHERE
    tournament_category = 'Champions League'
    AND match_status = 'Available'

-- =========================================================================
-- QUERY NO.2
-- =========================================================================
SELECT
    user_id,
    full_name,
    email
FROM
    users
WHERE
    full_name ILIKE 'Tanvir%'
    OR full_name ILIKE '%Haque%'

-- =========================================================================
-- QUERY NO.3
-- =========================================================================
SELECT
    booking_id,
    user_id,
    match_id,
    coalesce(payment_status, 'Action Required') AS systematic_status
FROM
    bookings
WHERE
    payment_status IS NULL

-- =========================================================================
-- QUERY NO.4
-- =========================================================================
SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM
    bookings b
    INNER JOIN users u ON b.user_id = u.user_id
    INNER JOIN matches m ON b.match_id = m.match_id

-- =========================================================================
-- QUERY NO.5
-- =========================================================================
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM
    users u
    LEFT JOIN bookings b ON u.user_id = b.user_id

-- =========================================================================
-- QUERY NO.6
-- =========================================================================
SELECT
    booking_id,
    match_id,
    total_cost
FROM
    bookings
WHERE
    total_cost > (
        SELECT
            avg(total_cost)
        FROM
            bookings
    )

-- =========================================================================
-- QUERY NO.7
-- =========================================================================
SELECT
    match_id,
    fixture,
    base_ticket_price
FROM
    matches
ORDER BY
    base_ticket_price DESC
OFFSET
    1
LIMIT
    2