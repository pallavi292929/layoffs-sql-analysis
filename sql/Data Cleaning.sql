-- DATA CLEANING 

SELECT * 
FROM layoffs;

-- 1. Remove Duplicates 
-- 2. Standardize the data 
-- 3. Null values or blank values 
-- 4. Remove any columns 

CREATE TABLE layoffs_staging 
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- 1. Remove Duplicates 

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF, 'DATE') AS ROW_NUM
FROM layoffs_staging;

WITH DUPLICATE_CTE AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF,'DATE', STAGE, COUNTRY, funds_raised_millions) AS ROW_NUM
FROM layoffs_staging
)
SELECT * 
FROM DUPLICATE_CTE 
WHERE ROW_NUM > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'CASPER';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY COMPANY, LOCATION, INDUSTRY, TOTAL_LAID_OFF, PERCENTAGE_LAID_OFF,'DATE', STAGE, COUNTRY, funds_raised_millions) AS ROW_NUM
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

SELECT *
FROM layoffs_staging2;

-- STANDARDIZING DATA 

SELECT company , TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT  DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; -- now only crypto shows when we do distinct industry 

-- we look at all the columns of the table while cleaninf the data to check how can we clean it 

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2 
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- changing date from text column to date column 

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2;

-- NULLS AND BLANK SPACES 

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL ;

update layoffs_staging2
set industry = null 
where industry = '';

SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

select * 
from layoffs_staging2
where company = 'airbnb';

select * 
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where t1.industry is null 
and t2.industry is not null;

UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

SELECT * 
FROM layoffs_staging2;

select * 
from layoffs_staging2
where company  like 'bally%';

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL ;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL ;

ALTER TABLE layoffs_staging2
DROP column row_num;

select * 
from layoffs_staging2;






