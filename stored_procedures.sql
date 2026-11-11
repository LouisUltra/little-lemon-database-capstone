-- Little Lemon Database — stored procedures
-- MySQL 8.0   |   run: mysql -u root -p little_lemon_db < stored_procedures.sql

-- 1) GetMaxQuantity: the largest quantity in any single order
DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS 'Max Quantity in Order' FROM Orders;
END //
DELIMITER ;

-- 2) AddBooking: create a new booking and confirm it
DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(
    IN p_booking_id INT,
    IN p_customer_id INT,
    IN p_table_no INT,
    IN p_booking_date DATE)
BEGIN
    INSERT INTO Bookings (BookingID, CustomerID, TableNo, BookingDate)
    VALUES (p_booking_id, p_customer_id, p_table_no, p_booking_date);
    SELECT CONCAT('New booking ', p_booking_id, ' added for customer ',
                  p_customer_id, ' at table ', p_table_no, ' on ', p_booking_date)
           AS Confirmation;
END //
DELIMITER ;

-- 3) UpdateBooking: change the date of an existing booking
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(
    IN p_booking_id INT,
    IN p_booking_date DATE)
BEGIN
    UPDATE Bookings
       SET BookingDate = p_booking_date
     WHERE BookingID = p_booking_id;
    SELECT CONCAT('Booking ', p_booking_id, ' updated to ', p_booking_date)
           AS Confirmation;
END //
DELIMITER ;

-- 4) CancelBooking: remove a booking
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN p_booking_id INT)
BEGIN
    DELETE FROM Bookings WHERE BookingID = p_booking_id;
    SELECT CONCAT('Booking ', p_booking_id, ' cancelled') AS Confirmation;
END //
DELIMITER ;

-- 5) ManageBooking: look up one booking together with its customer
DROP PROCEDURE IF EXISTS ManageBooking;
DELIMITER //
CREATE PROCEDURE ManageBooking(IN p_booking_id INT)
BEGIN
    SELECT b.BookingID, b.BookingDate, b.TableNo,
           c.CustomerID, c.FullName, c.ContactNumber
      FROM Bookings b
      JOIN Customers c ON b.CustomerID = c.CustomerID
     WHERE b.BookingID = p_booking_id;
END //
DELIMITER ;
