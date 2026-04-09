-- create tables

CREATE TABLE clinics (
    cid VARCHAR(50),
    clinic_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE customer (
    uid VARCHAR(50),
    name VARCHAR(100),
    mobile VARCHAR(20)
);

CREATE TABLE clinic_sales (
    oid VARCHAR(50),
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount FLOAT,
    datetime DATETIME,
    sales_channel VARCHAR(50)
);

CREATE TABLE expenses (
    eid VARCHAR(50),
    cid VARCHAR(50),
    description VARCHAR(100),
    amount FLOAT,
    datetime DATETIME
);

-- insert data into tables

INSERT INTO clinics VALUES
('C1','XYZ Clinic','Hyderabad','Telangana','India'),
('C2','ABC Clinic','Vijayawada','Andhra Pradesh','India');

INSERT INTO customer VALUES
('U1','John Doe','9876543210'),
('U2','Alice','9876543211');

INSERT INTO clinic_sales VALUES
('O1','U1','C1',10000,'2021-09-10 10:00:00','Online'),
('O2','U2','C1',15000,'2021-09-15 12:00:00','Offline'),
('O3','U1','C2',20000,'2021-09-20 14:00:00','Online');

INSERT INTO expenses VALUES
('E1','C1','Medicines',5000,'2021-09-12 09:00:00'),
('E2','C2','Equipment',8000,'2021-09-18 11:00:00');

-- query 1:

SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;

-- query 2:

SELECT 
    uid,
    SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC
LIMIT 10;

-- query 3:

SELECT 
    MONTH(cs.datetime) AS month,
    SUM(cs.amount) AS revenue,
    SUM(e.amount) AS expense,
    (SUM(cs.amount) - SUM(e.amount)) AS profit,
    CASE 
        WHEN (SUM(cs.amount) - SUM(e.amount)) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM clinic_sales cs
JOIN expenses e 
    ON cs.cid = e.cid
    AND MONTH(cs.datetime) = MONTH(e.datetime)
WHERE YEAR(cs.datetime) = 2021
  AND YEAR(e.datetime) = 2021
GROUP BY MONTH(cs.datetime);

-- query 4:

SELECT 
    c.city,
    cs.cid,
    SUM(cs.amount) - SUM(e.amount) AS profit
FROM clinics c
JOIN clinic_sales cs ON c.cid = cs.cid
JOIN expenses e ON c.cid = e.cid
WHERE MONTH(cs.datetime) = 9 AND YEAR(cs.datetime) = 2021
GROUP BY c.city, cs.cid
ORDER BY c.city, profit DESC;

-- query 5:

SELECT 
    c.state,
    cs.cid,
    SUM(cs.amount) - SUM(e.amount) AS profit
FROM clinics c
JOIN clinic_sales cs ON c.cid = cs.cid
JOIN expenses e ON c.cid = e.cid
WHERE MONTH(cs.datetime) = 9 AND YEAR(cs.datetime) = 2021
GROUP BY c.state, cs.cid
ORDER BY c.state, profit ASC;