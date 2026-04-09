
-- create tables 
CREATE TABLE users (
    user_id VARCHAR(50),
    name VARCHAR(100),
    phone_number VARCHAR(20),
    mail_id VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id VARCHAR(50),
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

CREATE TABLE booking_commercials (
    id VARCHAR(50),
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity FLOAT
);

CREATE TABLE items (
    item_id VARCHAR(50),
    item_name VARCHAR(100),
    item_rate FLOAT
);

-- insert data into tables 
INSERT INTO users VALUES
('U1','John Doe','9876543210','john@example.com','Address1'),
('U2','Alice','9876543211','alice@example.com','Address2');

INSERT INTO bookings VALUES
('B1','2021-11-10 10:00:00','R1','U1'),
('B2','2021-11-15 12:00:00','R2','U1'),
('B3','2021-10-05 09:00:00','R3','U2');

INSERT INTO items VALUES
('I1','Tawa Paratha',20),
('I2','Mix Veg',100),
('I3','Paneer',200);

INSERT INTO booking_commercials VALUES
('C1','B1','BL1','2021-11-10 11:00:00','I1',2),
('C2','B1','BL1','2021-11-10 11:00:00','I2',1),
('C3','B2','BL2','2021-11-15 13:00:00','I3',5),
('C4','B3','BL3','2021-10-05 10:00:00','I2',15);

-- queries

-- query 1:
SELECT b.user_id, b.room_no
FROM bookings b
WHERE b.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = b.user_id
);

-- query 2:
SELECT bc.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 11
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.booking_id;

-- query 3:
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

-- query 4:
SELECT 
    MONTH(bc.bill_date) AS month,
    i.item_name,
    SUM(bc.item_quantity) AS total_qty
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
GROUP BY MONTH(bc.bill_date), i.item_name
ORDER BY month, total_qty DESC;


-- query 5:
SELECT 
    MONTH(bc.bill_date) AS month,
    b.user_id,
    SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM booking_commercials bc
JOIN bookings b ON bc.booking_id = b.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021
GROUP BY MONTH(bc.bill_date), b.user_id
ORDER BY month, total_bill DESC;