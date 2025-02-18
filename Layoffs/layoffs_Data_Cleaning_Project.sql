SELECT *
FROM layoffs;

-- 1. Remove Duplicates.
-- 2. Standardize the Data.
-- 3. Remove/Replace Null Values or Blank Values.
-- 4. Remove Any Columns.
    
-- Create Staging Table

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT 
    *
FROM
    layoffs_staging;
    
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Remove Duplicates

SELECT * , 
	ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

WITH duplicates_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num>1;

-- Magnify; Check each row

SELECT *
FROM layoffs_staging
WHERE company IN ('Beyond Meat', 'Cazoo')
ORDER BY company;

-- create a new table because we cannot perform delete operations with the help of CTE.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- insert new relevant column for duplicates

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

-- delete duplicates

DELETE
FROM layoffs_staging2
WHERE row_num >1;

-- Standardizing data

-- trim evident whitespaces

SELECT company, trim(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = trim(company);

-- standardize some values that are basically same

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- some values ending in unrelated characters e.g. periods

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Turn date column into date datatype

SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
STR_TO_DATE(`date`, '%Y-%m-%d')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Removing carriage return characters (Enter) from initial import 

SELECT funds_raised
FROM layoffs_staging2
WHERE funds_raised LIKE '%\r';

UPDATE layoffs_staging2
SET funds_raised = REPLACE(funds_raised, '%\r', '');

SELECT funds_raised
FROM layoffs_staging2;

-- Turn funds_raised column into INT and round percentage_laid_off to 2 decimal points

SELECT funds_raised
FROM layoffs_staging2
ORDER BY 1 DESC;

UPDATE layoffs_staging2
SET funds_raised = NULL 
WHERE funds_raised = 'NULL';

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised INT;

SELECT percentage_laid_off, round(percentage_laid_off,2)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET percentage_laid_off = ROUND(percentage_laid_off, 2);

-- NULL/BLANK VALUES

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off = '' OR total_laid_off IS NULL)
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL);

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Appsmith%';

-- Populating NULL/Blank Values with known data

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry = '' OR t1.industry IS NULL)
AND t2.industry IS NOT NULL;

/* Had to turn blanks to NULL values because it ran into issues
when we tried to update with a where clause that has an OR */

UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Remove rows with no value to us,i.e, where the relevant values are NULL

SELECT *
FROM layoffs_staging2
WHERE (total_laid_off = '' OR total_laid_off IS NULL)
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL);

DELETE 
FROM layoffs_staging2
WHERE (total_laid_off = '' OR total_laid_off IS NULL)
AND (percentage_laid_off = '' OR percentage_laid_off IS NULL);

SELECT *
FROM layoffs_staging2;

-- remove any columns which is of no use to us anymore, in this case, row_num. 

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;













