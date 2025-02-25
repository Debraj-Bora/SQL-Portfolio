SELECT *
FROM loan;

-- Create staging table
CREATE TABLE loan_staging
LIKE loan;

INSERT INTO loan_staging
SELECT *
FROM loan;

SELECT *
FROM loan_staging;

-- Converting string dates to date format to facilitate date operations
SELECT 
	issue_date ,
    STR_TO_DATE(`issue_date`, '%d-%m-%Y'),
    last_credit_pull_date,
    STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date,
    STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date,
    STR_TO_DATE(next_payment_date, '%d-%m-%Y')
FROM loan_staging;

UPDATE loan_staging
SET
	issue_date = STR_TO_DATE(`issue_date`, '%d-%m-%Y'),
    last_credit_pull_date = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
    last_payment_date = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
    next_payment_date = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
    

ALTER TABLE loan_staging
MODIFY COLUMN issue_date DATE,
MODIFY COLUMN last_credit_pull_date DATE,
MODIFY COLUMN last_payment_date DATE,
MODIFY COLUMN next_payment_date DATE;

-- Calculating the count of null values across important columns to ensure data quality
SELECT COUNT(*) null_count
FROM loan_staging
WHERE
	loan_status IS NULL OR
    member_id IS NULL;

-- Checking for duplicate values
WITH duplicate_cte AS (
SELECT
	*,
    ROW_NUMBER() OVER(PARTITION BY id, address_state, application_type,emp_length, emp_title, grade, home_ownership, member_id, sub_grade) AS row_num
FROM loan_staging)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;









    