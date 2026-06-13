-- football ticket management system

-- Query 1
-- Retrieve all Champions League matches where status is 'Available'
SELECT match_id, fixture, base_ticket_price
FROM matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';


-- Query 2
-- Search users whose name starts with 'Tanvir' OR contains 'Haque'
-- ILIKE = case-insensitive LIKE in PostgreSQL
SELECT user_id, full_name, email
FROM users
WHERE full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%';


-- Query 3
-- Find bookings where payment_status is NULL
-- COALESCE replaces NULL with the fallback value we provide
SELECT
  booking_id,
  user_id,
  match_id,
  COALESCE(payment_status, 'Action Required') AS systematic_status
FROM bookings
WHERE payment_status IS NULL;


-- Query 4
-- Show booking details with user's full name and match fixture
-- INNER JOIN only returns rows that have a match in BOTH tables
SELECT
  b.booking_id,
  u.full_name,
  m.fixture,
  b.total_cost
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN matches m ON b.match_id = m.match_id;


-- Query 5
-- List ALL users with their booking IDs
-- LEFT JOIN keeps all users even if they have zero bookings
-- Jannat Ara has no bookings so her booking_id will show as NULL
SELECT
  u.user_id,
  u.full_name,
  b.booking_id
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id;


-- Query 6
-- Find bookings where total_cost is HIGHER than the average cost
-- Subquery inside WHERE calculates the average first
-- then the outer query compares each row against it
SELECT booking_id, match_id, total_cost
FROM bookings
WHERE total_cost > (
  SELECT AVG(total_cost)
  FROM bookings
);


-- Query 7
-- Top 2 most expensive matches — skipping the absolute highest (150)
-- OFFSET 1 skips the first row (Real Madrid vs Barcelona at 150)
-- LIMIT 2 then takes the next 2 rows
SELECT match_id, fixture, base_ticket_price
FROM matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;