-- Create parent table
-- Now changed to DEFAULTS which only copies the columns and default values but not the Primary Keys, Foreign Keys, indexes and unique constraints.
CREATE TABLE operations.orders_partitioned (
    LIKE operations.orders INCLUDING DEFAULTS
) PARTITION BY RANGE (order_date);

-- alter the partitioned table to be able to accept both order_id and order_date as the Primary Keys; making this a COMPOSITE Primary Key, see glossary (coming soon) for more information.
ALTER TABLE operations.orders_partitioned
ADD PRIMARY KEY (order_id, order_date);

-- Recreate the foreign KEYS
ALTER TABLE operations.orders_partitioned
ADD CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES operations.customers(customer_id);

ALTER TABLE operations.orders_partitioned
ADD CONSTRAINT fk_orders_employee
    FOREIGN KEY (employee_id)
    REFERENCES operations.employees(employee_id);

-- Create partitions per year
CREATE TABLE operations.orders_2020 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE operations.orders_2021 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE operations.orders_2022 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE operations.orders_2023 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Peter's UPDATE
CREATE TABLE operations.orders_2024 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Tejiri's UPDATE
CREATE TABLE operations.orders_2025 PARTITION OF operations.orders_partitioned
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Insert into the orders_partitioned after partitioning from the orders table
INSERT INTO operations.orders_partitioned
SELECT * FROM operations.orders;

-- Rename tables orders_partitioned table to orders and vice versa
ALTER TABLE operations.orders RENAME TO orders_old;
ALTER TABLE operations.orders_partitioned RENAME TO orders;



-- DON'T LEAVE ANY GAPS WHEN PARTITIONING BY DATE
-- TO FIND THE EARLIEST OR LATEST DATE
SELECT MIN(order_date) FROM operations.orders; ---Even though July is the earliest date we don't want to leave any gaps when partitioning so we start from the beginning of the year
SELECT MAX(order_date) FROM operations.orders;


CREATE TABLE operations.prescriptions_partitioned (
	LIKE operations.prescriptions INCLUDING DEFAULTS
) PARTITION BY RANGE (date_prescribed);

ALTER TABLE operations.prescriptions_partitioned
ADD PRIMARY KEY (prescription_id, date_prescribed);

ALTER TABLE operations.prescriptions_partitioned
ADD CONSTRAINT fk_prescriptions_drugs
	FOREIGN KEY (drug_id)
	REFERENCES inventory.drugs(drug_id);

-- Find a way to solve this

ALTER TABLE operations.prescriptions_partitioned
ADD CONSTRAINT fk_prescriptions_orders
    FOREIGN KEY (order_id)
    REFERENCES operations.orders(order_id);



