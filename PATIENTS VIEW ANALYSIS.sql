select * 
from file;

SHOW COLUMNS FROM file;

ALTER TABLE file
ADD COLUMN doctor_name VARCHAR(50);

ALTER TABLE file
MODIFY COLUMN satisfaction DECIMAL(3,1);
ALTER TABLE file
DROP COLUMN doctor_name;

DESC file;

select *
from file 
WHERE age = 18;
delete from file 
WHERE age = 18;
SELECT COALESCE(satisfaction, 84.0) + 5 AS updated_score
FROM file;
START TRANSACTION;

UPDATE file SET satisfaction = 62.0 WHERE patient_id = 'PAT-09484753';
UPDATE file SET satisfaction = 84.0 WHERE patient_id = 'PAT-f0644084';

SAVEPOINT after_two_updates;

UPDATE file SET satisfaction = 55 WHERE patient_id = 'PAT-ac6162e4';

ROLLBACK TO after_two_updates;

COMMIT;


START TRANSACTION;
DELETE FROM file WHERE name = 'Richard Rodriguez';
-- if mistake:
ROLLBACK;
-- or to keep:
COMMIT;

UPDATE file SET age = null WHERE age = '6';


SELECT patient_id,age,
       COALESCE(age, 0) AS final_age
FROM file;

DELIMITER $$

CREATE TRIGGER trg_AfterInsert_Patient2
AFTER INSERT ON file
FOR EACH ROW
BEGIN
    INSERT INTO Patient_Audit (
        patient_id,
        name,
        age,
        arrival_date,
        departure_date,
        service,
        satisfaction,
        action,
        action_time
    )
    VALUES (
        NEW.patient_id,
        NEW.name,
        NEW.age,
        NEW.arrival_date,
        NEW.departure_date,
        NEW.service,
        NEW.satisfaction,
        'New patient added',
        NOW()
    );
END$$

DELIMITER ;
INSERT INTO file (patient_id, name, age, arrival_date, departure_date, service, satisfaction)
VALUES ('P001', 'Ali Khan', 45, '2025-10-28', '2025-11-02', 'Cardiology', 5);

SELECT *
FROM File

DELIMITER $$

CREATE TRIGGER trg_after_update_file
AFTER UPDATE ON `file`
FOR EACH ROW
BEGIN
  INSERT INTO Patient_Audit (
    patient_id,
    name,
    age,
    arrival_date,
    departure_date,
    service,
    satisfaction,
    action,
    action_time
  )
  VALUES (
    NEW.patient_id,
    NEW.name,
    NEW.age,
    NEW.arrival_date,
    NEW.departure_date,
    NEW.service,
    NEW.satisfaction,
    'Patient updated',
    NOW()
  );
END$$

DELIMITER ;

UPDATE `file`
SET satisfaction = '7'
WHERE patient_id = 'P001';
select* 
from patient_Audit 


DELIMITER $$

CREATE TRIGGER trg_after_delete_file
AFTER DELETE ON `file`
FOR EACH ROW
BEGIN
  INSERT INTO Patient_Audit (
    patient_id,
    name,
    age,
    arrival_date,
    departure_date,
    service,
    satisfaction,
    action,
    action_time
  )
  VALUES (
    OLD.patient_id,
    OLD.name,
    OLD.age,
    OLD.arrival_date,
    OLD.departure_date,
    OLD.service,
    OLD.satisfaction,
    'Patient deleted',
    NOW()
  );
END$$

DELIMITER ;

DELETE FROM `file`
WHERE patient_id = 'P001';

DELIMITER $$

CREATE PROCEDURE GetPatientsByService(IN service_name VARCHAR(100))
BEGIN
    SELECT patient_id, name, age, service, satisfaction
    FROM `file`
    WHERE service = service_name;
END$$

DELIMITER ;

CALL GetPatientsByService('surgery');


DELIMITER $$

CREATE PROCEDURE AddNewPatient(
    IN p_patient_id VARCHAR(50),
    IN p_name VARCHAR(200),
    IN p_age INT,
    IN p_arrival_date VARCHAR(50),
    IN p_departure_date VARCHAR(50),
    IN p_service VARCHAR(100),
    IN p_satisfaction VARCHAR(50)
)
BEGIN
    INSERT INTO `file` (
        patient_id, name, age, arrival_date, departure_date, service, satisfaction
    ) VALUES (
        p_patient_id, p_name, p_age, p_arrival_date, p_departure_date, p_service, p_satisfaction
    );
END$$

DELIMITER ;

CALL AddNewPatient('P002', 'Sara Ahmed', 30, '2025-10-28', '2025-11-02', 'Surgery',5);

SELECT *
FROM file
WHERE service IN ('ICU', 'Surgery');
SELECT *
FROM file
WHERE patient_id IN (SELECT patient_id FROM Patient_Audit);
SELECT *
FROM file f
WHERE EXISTS (
    SELECT 1
    FROM Patient_Audit a
    WHERE a.patient_id = f.patient_id
);
SELECT *
FROM file
WHERE patient_id NOT IN (SELECT patient_id FROM Patient_Audit);



DESCRIBE `file`;
SELECT DISTINCT service FROM `file`;

ALTER TABLE `file`
  MODIFY patient_id VARCHAR(50),
  MODIFY service VARCHAR(50);
  
  UPDATE `file` SET service = 'General Medicine' WHERE LOWER(TRIM(service)) = 'general_medicine';
UPDATE `file` SET service = 'Surgery' WHERE LOWER(TRIM(service)) = 'surgery';
UPDATE `file` SET service = 'Emergency' WHERE LOWER(TRIM(service)) = 'emergency';
SELECT DISTINCT service FROM `file`;
ALTER TABLE `file` DROP PRIMARY KEY;
ALTER TABLE `file` ADD PRIMARY KEY (patient_id, service, age);

SHOW INDEXES FROM `file`;

ALTER TABLE file
ADD PRIMARY KEY (patient_id, age);

ALTER TABLE `file` REMOVE PARTITIONING;

ALTER TABLE `file`
PARTITION BY LIST COLUMNS (service) (
  PARTITION p_emergency VALUES IN ('Emergency'),
  PARTITION p_icu       VALUES IN ('ICU'),
  PARTITION p_surgery   VALUES IN ('Surgery'),
  PARTITION p_general   VALUES IN ('General Medicine')
);
SELECT PARTITION_NAME, TABLE_ROWS 
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_NAME = 'file';

ALTER TABLE `file`
PARTITION BY RANGE (age) (
  PARTITION p0 VALUES LESS THAN (20),
  PARTITION p1 VALUES LESS THAN (40),
  PARTITION p2 VALUES LESS THAN (60),
  PARTITION p3 VALUES LESS THAN MAXVALUE
);  
SELECT * FROM file WHERE age IS NULL;
SELECT * FROM file WHERE age = '' OR age IS NULL;
UPDATE file
SET age = 0
WHERE age IS NULL OR age  = '' ;
SELECT PARTITION_NAME, TABLE_ROWS;
DESCRIBE file;
ALTER TABLE file 
MODIFY COLUMN patient_id INT NOT NULL;

ALTER TABLE file
PARTITION BY HASH(id)
PARTITIONS 4;

SELECT PARTITION_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'file';

ALTER TABLE file
PARTITION BY KEY(id)
PARTITIONS 4;
SELECT PARTITION_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'file';
 
ALTER TABLE `file` ADD PRIMARY KEY ( service, age);
PARTITION BY RANGE (age)
SUBPARTITION BY HASH (service)
SUBPARTITIONS 2 (
  PARTITION p0 VALUES LESS THAN (30),
  PARTITION p1 VALUES LESS THAN (60),
  PARTITION p2 VALUES LESS THAN MAXVALUE
);



CREATE DATABASE shopDB;
USE shopDB;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


iNSERT INTO customers (name, city) VALUES
('Fatima', 'Lahore'),
('Sara', 'Islamabad');

INSERT INTO orders (customer_id, order_date, amount) VALUES
(1, '2025-10-20', 3000),
(1, '2025-10-21', 1500),
(2, '2025-10-22', 4000);

select* 
from customers;
select *
from orders;

SELECT c.city, SUM(o.amount) AS Total_Sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;

CREATE DATABASE users_shard1;
USE users_shard1;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO users VALUES (1, 'Fatima', 'Lahore');

-- Create Shard 2
CREATE DATABASE users_shard2;
USE users_shard2;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

INSERT INTO users VALUES (1000001, 'Sara', 'Islamabad');


