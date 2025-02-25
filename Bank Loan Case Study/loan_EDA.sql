SELECT *
FROM loan_staging;

-- data date scope
SELECT MIN(issue_date), MAX(issue_date)
FROM loan_staging;

-- Total loan applications
SELECT COUNT(id)
FROM loan_staging;

-- total loan application per month analysis
SELECT 
	MONTH(issue_date) AS `month`,
	COUNT(id) AS total_applications
FROM loan_staging
GROUP BY `month`
ORDER BY total_applications DESC;

-- month on month change in loan applications
SELECT
	MONTH(issue_date) AS `month`,
    COUNT(id) AS total_applications,
    (COUNT(id) - LAG(count(id), 1) OVER(ORDER BY MONTH(issue_date)))/ 
		LAG(count(id), 1) OVER(ORDER BY MONTH(issue_date)) * 100 AS mom_percentage_change
FROM
	loan_staging
GROUP BY `month`;

-- total loan disbursed
SELECT 
	SUM(loan_amount) AS amount_disbursed
FROM loan_staging;

SELECT
	MONTH(issue_date) AS `month`,
	SUM(loan_amount) AS amount_disbursed
FROM loan_staging
GROUP BY `month`
ORDER BY `month`;

-- month on month change in loan disbursement
SELECT
	MONTH(issue_date) AS `month`,
    SUM(loan_amount) AS total_amount,
    (SUM(loan_amount) - LAG(SUM(loan_amount),1) OVER(ORDER BY MONTH(issue_date)))/ LAG(SUM(loan_amount),1) OVER(ORDER BY MONTH(issue_date)) * 100 AS mom_percentage_change
FROM loan_staging
GROUP BY `month`;

-- repayment analysis
SELECT 
	SUM(total_payment) AS amount_received
FROM loan_staging;

SELECT
	MONTH(issue_date) AS `month`,
	SUM(total_payment) AS amount_received
FROM loan_staging
GROUP BY `month`
ORDER BY `month`;

-- mom change in repayment amount
SELECT
	MONTH(issue_date) AS `month`,
    SUM(total_payment) AS amount_received,
    (SUM(total_payment) - LAG(SUM(total_payment),1) OVER(ORDER BY MONTH(issue_date)))/ 
    LAG(SUM(total_payment),1) OVER(ORDER BY MONTH(issue_date)) * 100 AS mom_percentage_change
FROM loan_staging
GROUP BY `month`;

-- average interest rate
SELECT
	ROUND(AVG(int_rate),2) * 100 AS avg_interest_rate
FROM
	loan_staging;
    
SELECT
	MONTH(issue_date) AS `month`,
	ROUND(AVG(int_rate), 4) * 100 AS avg_interest_rate
FROM loan_staging
GROUP BY MONTH(issue_date)
ORDER BY `month`;
    
-- analysing debt to income ratio
SELECT 
	ROUND(AVG(dti),4) * 100 AS avg_dti
FROM loan_staging;

-- identifying high risk individauls by ordering dti in descending order
SELECT
	member_id,
    ROUND(dti * 100, 4) as dti
FROM loan_staging
ORDER BY dti DESC;

SELECT DISTINCT(loan_status) FROM loan_staging;
-- summarizing loan details based on Loan Status
SELECT
	loan_status,
    COUNT(id) AS total_applications,
    SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    AVG(int_rate * 100) AS interest_date,
    AVG(dti * 100) AS DTI
FROM loan_staging
GROUP BY loan_status;

-- month on month trend
SELECT
	MONTHNAME(issue_date) as `month`,
    loan_status,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid
FROM loan_staging
GROUP BY `month`, loan_status
ORDER BY `month`;

/* We will analyze the percentage of good loan/ bad loan applications
	For this we will use the loan_status column. The positive KPIs are "Fully Paid", "Current"
    Negative KPI = "Charged Off"
*/

-- analysis of good loan applications
SELECT 
	COUNT(id) AS good_loan_applications,
    SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    ROUND(AVG(dti) *100,2) AS avg_dti,
	SUM(total_payment) - SUM(loan_amount)  AS PNL
FROM loan_staging
WHERE loan_status IN ('Fully Paid', 'Current');

-- analysis of bad loan applications
SELECT 
	COUNT(id) AS good_loan_applications,
    SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    ROUND(AVG(dti) *100,4) AS avg_dti,
    SUM(total_payment) - SUM(loan_amount)  AS PNL
FROM loan_staging
WHERE loan_status = 'Charged Off';

-- comaparison between good and bad loan applications
SELECT
	(COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END)) / COUNT(id) * 100 AS good_loan_percentage,
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END)) / COUNT(id) * 100 AS bad_loan_percentage
FROM
	loan_staging;
    
-- analysis based on demographic
SELECT
    address_state,
    COUNT(id) as total_applications,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    SUM(total_payment) - SUM(loan_amount) AS PNL
FROM loan_staging
GROUP BY address_state
ORDER BY PNL DESC;

-- checking the term on loans
SELECT
    term,
    COUNT(id) as total_applications,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    SUM(total_payment) - SUM(loan_amount) AS PNL
FROM loan_staging
GROUP BY term
ORDER BY PNL DESC;

-- loan data based on employment length
SELECT
    emp_length,
    COUNT(id) as total_applications,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    SUM(total_payment) - SUM(loan_amount) AS PNL
FROM loan_staging
GROUP BY emp_length
ORDER BY PNL DESC;

-- loan purpose breakdown
SELECT
    purpose,
    COUNT(id) as total_applications,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    SUM(total_payment) - SUM(loan_amount) AS PNL
FROM loan_staging
GROUP BY purpose
ORDER by total_applications DESC;

-- loan applications based on home ownership 
SELECT
    home_ownership,
    COUNT(id) as total_applications,
	SUM(loan_amount) AS amount_disbursed,
    SUM(total_payment) AS amount_repaid,
    SUM(total_payment) - SUM(loan_amount) AS PNL
FROM loan_staging
GROUP BY home_ownership
ORDER by total_applications DESC;
