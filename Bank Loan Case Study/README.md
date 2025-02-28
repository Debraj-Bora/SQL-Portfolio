## Dataset Details
Each entry in the [datset](https://github.com/Debraj-Bora/SQL-Portfolio/blob/main/Bank%20Loan%20Case%20Study/financial_loan.csv) includes information such as the loan status, purpose, annual income and loan amount. This data has been utilized to conduct a comprehensive analysis to discover trends and to separate out good loan and bad loan applications.

## Project Overview
The primary objective of this analysis was to identify KPIs and create insights into the loan applications, to classify them as good or bad. Using SQL queries, the project delves into several aspects:
- KPIs
  - Total Loan Applications: Total number of loan applications received segmented over months.
  - Total Funded Amount: Understanding the total amount of funds disbursed.
  - Total Amount Received: Tracking the total amount received from borrowers.
  - Average Interest Rate: Calculating the average intrest rate across all loans and monitoring the month-on-month variation to gain insight into the lending portfolio's overall cost.
  - Average Debt-To-Income Ratio(DTI): Evaluating the average DTIs of our borrowers to gauge their financial health.

In order to evaluate the performance of our lending activities and assess the quality of our loan portfolio, a comprehensive report that distinguishes between 'Good Loans' and 'Bad Loans' based on specific loan status criteria hs been created.

Good Loan KPIs:
- Good Loan Application Percentage: We need to calculate the percentage of loan applications classified as 'Good Loans.' This category includes loans with a loan status of 'Fully Paid' and 'Current.'
- Good Loan Applications: Identifying the total number of loan applications falling under the 'Good Loan' category, which consists of loans with a loan status of 'Fully Paid' and 'Current.'
- Good Loan Funded Amount: Determining the total amount of funds disbursed as 'Good Loans.' This includes the principal amounts of loans with a loan status of 'Fully Paid' and 'Current.'
- Good Loan Total Received Amount: Tracking the total amount received from borrowers for 'Good Loans,' which encompasses all payments made on loans with a loan status of 'Fully Paid' and 'Current.'

Bad Loan KPIs:
- Bad Loan Application Percentage: Calculating the percentage of loan applications categorized as 'Bad Loans.' This category specifically includes loans with a loan status of 'Charged Off.'
- Bad Loan Applications: Identifying the total number of loan applications categorized as 'Bad Loans,' which consists of loans with a loan status of 'Charged Off.'
- Bad Loan Funded Amount: Determining the total amount of funds disbursed as 'Bad Loans.' This comprises the principal amounts of loans with a loan status of 'Charged Off.'
- Bad Loan Total Received Amount: Tracking the total amount received from borrowers for 'Bad Loans,' which includes all payments made on loans with a loan status of 'Charged Off.'

- SQL Skills Used: Table Creation, Removing Duplicates, Data Type Conversion, String Manipulation, Aggregations, Group By, Joins, Date Functions, Window Functions.
- [View Data Cleaning SQL Script](https://github.com/Debraj-Bora/SQL-Portfolio/blob/main/Bank%20Loan%20Case%20Study/loan_DataCleaning.sql)
- [View EDA SQL Script](https://github.com/Debraj-Bora/SQL-Portfolio/blob/main/Bank%20Loan%20Case%20Study/loan_EDA.sql)
