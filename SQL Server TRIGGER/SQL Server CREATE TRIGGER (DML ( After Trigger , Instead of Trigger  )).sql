-- Create table for trips with trip details
CREATE TABLE trips (
    trip_id INT PRIMARY KEY,
    trip_destination VARCHAR(30),
    trip_date DATE,
    trip_price DECIMAL(10, 2),
    seats_available INT
);

-- Create table for reservations with reservation details
CREATE TABLE reservation (
    reservation_id INT IDENTITY PRIMARY KEY,
    trip_id INT,
    trip_destination VARCHAR(30),
    traveller_name VARCHAR(30),
    reservation_date DATE,
    no_of_tickets INT
);


-- Define an available trips
INSERT INTO trips (trip_id, trip_destination , trip_date, trip_price, seats_available)
VALUES 
    (1, 'Makkah', '2023-08-10', 150.00, 40),
    (2, 'Madinah', '2023-08-15', 100.00, 30),
    (3, 'Riyadh', '2023-08-20', 200.00, 50),
    (4, 'Jeddah', '2023-08-25', 180.00, 45),
    (5, 'Dammam', '2023-08-30', 120.00, 35),
    (7, 'Tabuk', '2023-09-10', 160.00, 20),
    (10, 'Najran', '2023-09-25', 130.00, 35);


--Ensure that trips are defined correctly
SELECT * FROM trips



CREATE OR ALTER TRIGGER Update_Avialable_Seates ON reservation AFTER INSERT 
AS 
BEGIN
SET NOCOUNT ON 
	UPDATE trips
	SET seats_available = t.seats_available - i.no_of_tickets 
	FROM trips t
	INNER JOIN  inserted i ON t.trip_id = i.trip_id
END;


CREATE OR ALTER TRIGGER check_available_ticket ON reservation INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if there are enough seats available for each reservation
    IF EXISTS (
        SELECT * 
        FROM trips t
        INNER JOIN inserted i ON t.trip_id = i.trip_id
        WHERE t.seats_available >= i.no_of_tickets
    )
    BEGIN
        -- Insert valid reservations
        INSERT INTO reservation (trip_id, traveller_name, reservation_date, no_of_tickets)
        SELECT trip_id, traveller_name, reservation_date, no_of_tickets
        FROM inserted;
    END
    ELSE
    BEGIN
        -- Raise an error if there are not enough seats available
        RAISERROR('Sorry, No Available seats', 16, 1);
    END
END;


-- Make a reservation 
INSERT INTO reservation (trip_id,trip_destination, traveller_name, reservation_date,no_of_tickets)
VALUES ( 3 , 'Riyadh' , ' MO Nasser ' , GETDATE () , 5)

--3) Testing the trigger
-- Display all reservations
SELECT * FROM reservation;

-- Display updated seats availability in trips table
SELECT * FROM trips;

--#####################################################################
--EXAMPLE -2
--#####################################################################

--1) Create a table for logging the changes
	CREATE TABLE production.product_audits(
		change_id INT IDENTITY PRIMARY KEY,
		product_id INT NOT NULL,
		product_name VARCHAR(255) NOT NULL,
		brand_id INT NOT NULL,
		category_id INT NOT NULL,
		model_year SMALLINT NOT NULL,
		list_price DEC(10,2) NOT NULL,
		updated_at DATETIME NOT NULL,
		operation CHAR(3) NOT NULL,
		CHECK(operation = 'INS' or operation='DEL')
	);


--2) Creating an after DML trigger
	CREATE OR ALTER TRIGGER production.trg_product_audit ON production.products AFTER INSERT, DELETE
	AS
	BEGIN
		SET NOCOUNT ON;
		INSERT INTO production.product_audits(
			product_id,       
			product_name,
			brand_id,
			category_id,
			model_year,
			list_price, 
			updated_at, 
			operation
		)
		SELECT
			i.product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			i.list_price,
			GETDATE(),
			'INS'
		FROM
			inserted i
		UNION ALL
		SELECT
			d.product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			d.list_price,
			GETDATE(),
			'DEL'
		FROM
			deleted d;
	END



	--2) Creating an INSTEAD OF DML trigger
CREATE TRIGGER production.trg_product_audit_instead_of ON production.products INSTEAD OF INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    -- Handle INSERT operation
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO production.product_audits (
            product_id,       
            product_name,
            brand_id,
            category_id,
            model_year,
            list_price, 
            updated_at, 
            operation
        )
        SELECT
            i.product_id,
            i.product_name,
            i.brand_id,
            i.category_id,
            i.model_year,
            i.list_price,
            GETDATE(),
            'INS'
        FROM
            inserted i;
    END;

    -- Handle DELETE operation
    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO production.product_audits (
            product_id,       
            product_name,
            brand_id,
            category_id,
            model_year,
            list_price, 
            updated_at, 
            operation
        )
        SELECT
            d.product_id,
            d.product_name,
            d.brand_id,
            d.category_id,
            d.model_year,
            d.list_price,
            GETDATE(),
            'DEL'
        FROM
            deleted d;
    END;
END;


-- Testing the trigger
-- Insert more sample data into the products table
		INSERT INTO production.products(product_name,brand_id,category_id,model_year,list_price)
		VALUES ('Test product',1,1,2018,599);

-- View the contents of the product_audits table after insert
		SELECT * 
		FROM production.product_audits;

-- Delete sample data from the products table
		DELETE FROM production.products
		WHERE product_name = 'Test product';

-- View the contents of the product_audits table after delete
		SELECT * 
		FROM production.product_audits;


--#####################################################################
--EXAMPLE -3
--#####################################################################

-- 1) Create a table for brand approvals
CREATE TABLE production.brand_approvals(
    brand_id INT IDENTITY PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

SELECT * FROM production.brand_approvals

-- 2) Create a view combining approved and pending approval brands
CREATE VIEW production.vw_brands 
AS 
SELECT brand_name,'Approved' approval_status
FROM production.brands
UNION
SELECT brand_name,'Pending Approval' approval_status
FROM production.brand_approvals;

-- 3) Create an INSTEAD OF INSERT trigger for the view
CREATE TRIGGER production.trg_vw_brands ON production.vw_brands INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.brand_approvals (brand_name)
    SELECT i.brand_name
    FROM inserted i
    WHERE i.brand_name NOT IN (
            SELECT brand_name
            FROM production.brands
    );
END

-- 4) Select brand names and their approval statuses from the view
SELECT brand_name, approval_status
FROM production.vw_brands;

-- 5) Select all data from the brand_approvals table
SELECT *
FROM production.brand_approvals;
 --################################################################
 -- 1) Create a table for brand approvals with more details
CREATE TABLE production.brand_approvals(
    brand_id INT IDENTITY PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL,
    approval_date DATETIME,
    approved_by VARCHAR(255),
    reason_for_pending VARCHAR(500)
);

-- Insert some sample data into production.brands for testing
INSERT INTO production.brands (brand_name) 
VALUES 
	('Nike'), ('Adidas');

-- 2) Create a view combining approved and pending approval brands with more details
CREATE VIEW production.vw_brands AS 
SELECT brand_name,'Approved' AS approval_status,approval_date,approved_by,NULL AS reason_for_pending
FROM production.brands
UNION
SELECT brand_name,'Pending Approval' AS approval_status,approval_date,approved_by,reason_for_pending
FROM production.brand_approvals;

-- 3) Create an INSTEAD OF INSERT trigger for the view
CREATE TRIGGER production.trg_vw_brands ON production.vw_brands INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.brand_approvals (brand_name, reason_for_pending)
    SELECT i.brand_name,'New brand waiting for approval'
    FROM inserted i
    WHERE i.brand_name NOT IN (SELECT brand_name FROM production.brands);
END;


-- 4) Select brand names and their approval statuses from the view
SELECT brand_name,approval_status,approval_date,approved_by,reason_for_pending
FROM production.vw_brands;

-- 5) Select all data from the brand_approvals table
SELECT * 
FROM production.brand_approvals;

-- Additional testing data
-- Insert a new brand into the view to trigger the INSTEAD OF INSERT trigger
INSERT INTO production.vw_brands (brand_name) VALUES ('Puma');

-- Approve a pending brand
UPDATE production.brand_approvals
SET 
    approval_date = GETDATE(),
    approved_by = 'Admin',
    reason_for_pending = NULL
WHERE 
    brand_name = 'Puma';

-- Add the approved brand to the production.brands table
INSERT INTO production.brands (brand_name)
SELECT brand_name
FROM production.brand_approvals
WHERE brand_name = 'Puma';

-- Delete the approved brand from brand_approvals table
DELETE FROM production.brand_approvals
WHERE brand_name = 'Puma';

-- Check the final state of vw_brands and brand_approvals
SELECT * FROM production.vw_brands;
SELECT * FROM production.brand_approvals;
