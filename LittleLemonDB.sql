-- Little Lemon database — Database Engineer Capstone
-- Author: Xingyu Lin
-- MySQL 8.0
-- Rebuild: mysql -u root -p < LittleLemonDB.sql

DROP DATABASE IF EXISTS little_lemon_db;
CREATE DATABASE little_lemon_db;
USE little_lemon_db;

CREATE TABLE Customers (
        CustomerID INT NOT NULL,
        FullName VARCHAR(100) NOT NULL,
        ContactNumber VARCHAR(20),
        Email VARCHAR(120),
        PRIMARY KEY (CustomerID)
    );

CREATE TABLE Menu (
        MenuID INT NOT NULL,
        MenuItems VARCHAR(200) NOT NULL,
        Cuisine VARCHAR(100) NOT NULL,
        PRIMARY KEY (MenuID)
    );

CREATE TABLE MenuItems (
        MenuItemID INT NOT NULL,
        CourseName VARCHAR(100) NOT NULL,
        ItemName VARCHAR(200) NOT NULL,
        ItemPrice DECIMAL(8,2) NOT NULL,
        PRIMARY KEY (MenuItemID)
    );

CREATE TABLE Bookings (
        BookingID INT NOT NULL,
        BookingDate DATE NOT NULL,
        TableNo INT NOT NULL,
        CustomerID INT NOT NULL,
        PRIMARY KEY (BookingID),
        CONSTRAINT fk_bookings_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

CREATE TABLE Orders (
        OrderID INT NOT NULL,
        OrderDate DATE NOT NULL,
        Quantity INT NOT NULL,
        TotalCost DECIMAL(10,2) NOT NULL,
        CustomerID INT NOT NULL,
        MenuID INT NOT NULL,
        PRIMARY KEY (OrderID),
        CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
        CONSTRAINT fk_orders_menu FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)
    );

INSERT INTO Customers (CustomerID, FullName, ContactNumber, Email) VALUES (1,'Anna Iversen','+1-555-0101','anna.iversen@example.com'),(2,'Joakim Iversen','+1-555-0102','joakim.iversen@example.com'),(3,'Vanessa McCarthy','+1-555-0103','vanessa.mccarthy@example.com'),(4,'Marcos Romero','+1-555-0104','marcos.romero@example.com'),(5,'Hiroki Yamane','+1-555-0105','hiroki.yamane@example.com');

INSERT INTO Menu (MenuID, MenuItems, Cuisine) VALUES (1,'Greek Salad, Pita Bread, Tzatziki','Greek'),(2,'Minestrone, Pizza, Cheesecake','Italian'),(3,'Falafel, Hummus, Kabasa','Turkish');

INSERT INTO MenuItems (MenuItemID, CourseName, ItemName, ItemPrice) VALUES (1,'Starters','Olives',5.00),(2,'Starters','Flatbread',5.00),(3,'Starters','Minestrone',8.00),(4,'Main Courses','Greek salad',15.00),(5,'Main Courses','Pizza',15.00),(6,'Desserts','Cheesecake',4.00),(7,'Drinks','Athens White wine',25.00),(8,'Drinks','Turkish Coffee',10.00);

INSERT INTO Bookings (BookingID, BookingDate, TableNo, CustomerID) VALUES (1,'2026-11-20',12,1),(2,'2026-11-20',12,2),(3,'2026-11-21',19,3),(4,'2026-11-21',15,4),(5,'2026-11-22',5,5);

INSERT INTO Orders (OrderID, OrderDate, Quantity, TotalCost, CustomerID, MenuID) VALUES (1,'2026-11-20',2,86.00,1,1),(2,'2026-11-20',1,37.00,2,2),(3,'2026-11-21',4,120.50,3,3),(4,'2026-11-21',1,40.00,4,2),(5,'2026-11-22',3,77.50,5,1);

DROP PROCEDURE IF EXISTS GetMaxQuantity;
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS 'Max Quantity in Order' FROM Orders;
END //
DELIMITER ;

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

DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN p_booking_id INT)
BEGIN
    DELETE FROM Bookings WHERE BookingID = p_booking_id;
    SELECT CONCAT('Booking ', p_booking_id, ' cancelled') AS Confirmation;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS ManageBooking;
DELIMITER //
CREATE PROCEDURE ManageBooking(IN p_booking_id INT)
BEGIN
    SELECT b.BookingID,
           b.BookingDate,
           b.TableNo,
           c.CustomerID,
           c.FullName,
           c.ContactNumber
      FROM Bookings b
      JOIN Customers c ON b.CustomerID = c.CustomerID
     WHERE b.BookingID = p_booking_id;
END //
DELIMITER ;
