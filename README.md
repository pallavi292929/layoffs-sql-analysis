# Layoffs Data Analysis Using SQL

## 📌 Project Overview

An end-to-end **SQL data analysis project** exploring company layoffs from 2020 to 2023.

The project starts with a raw CSV dataset and uses MySQL to perform data cleaning, standardization, missing-value handling, and exploratory data analysis. The cleaned dataset is then analyzed to identify patterns in layoffs across companies, industries, countries, funding stages, and time periods.

The project demonstrates practical SQL skills used in a typical data analyst workflow, from preparing raw data to extracting business insights.

---

## 🎯 Objectives

- Clean and prepare a raw layoffs dataset for analysis.
- Identify and remove duplicate records.
- Standardize inconsistent categorical values.
- Handle NULL and blank values.
- Convert date fields into the appropriate data type.
- Analyze layoffs across companies, industries, countries, and company stages.
- Identify trends in layoffs over time.
- Calculate cumulative layoffs using window functions.
- Identify the top 5 companies by layoffs for each year.

---

## 🗂️ Dataset

The project uses a CSV dataset containing information about company layoffs.

### Dataset features

| Column | Description |
|---|---|
| `company` | Company name |
| `location` | Company location |
| `industry` | Industry of the company |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Percentage of workforce laid off |
| `date` | Date of the layoff |
| `stage` | Company funding/stage |
| `country` | Country |
| `funds_raised_millions` | Funds raised by the company in millions |

The raw dataset contains **2,361 records** across **9 columns**.

After applying the data-cleaning workflow, **1,992 records** remain for analysis.

---

# 🧹 Data Cleaning

The raw dataset was copied into a staging table before performing the cleaning process.

```sql
CREATE TABLE layoffs_staging 
LIKE layoffs;
```

The following cleaning steps were performed:

### 1. Duplicate Removal

Duplicate records were identified using `ROW_NUMBER()` with a partition across relevant columns.

Duplicate records were then removed from the staging table.

### 2. Company Name Standardization

Leading and trailing spaces were removed from company names using `TRIM()`.

### 3. Industry Standardization

Industry values beginning with `"Crypto"` were standardized to `"Crypto"`.

```sql
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

### 4. Country Standardization

Trailing periods were removed from country values beginning with `"United States"`.

### 5. Date Conversion

The original date field was stored as text and converted into a proper `DATE` value using `STR_TO_DATE()`.

```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
```

### 6. Missing and Blank Values

Blank industry values were converted to `NULL`.

Missing industry values were then populated using other records belonging to the same company.

Rows where both `total_laid_off` and `percentage_laid_off` were NULL were removed because they did not contain useful layoff information.

### 7. Temporary Column Removal

The temporary `row_num` column used for duplicate identification was removed after the cleaning process.

---

# 📊 Exploratory Data Analysis

The cleaned dataset was analyzed using aggregation functions, CTEs, joins, and window functions.

## Business Questions

The analysis answers questions such as:

1. What was the maximum number of layoffs recorded in a single entry?
2. Which companies reported 100% workforce layoffs?
3. Which companies had the highest total reported layoffs?
4. Which industries experienced the most layoffs?
5. Which countries recorded the highest number of layoffs?
6. How did layoffs change across different years?
7. How did layoffs vary by company stage?
8. Which months recorded the highest layoffs?
9. What was the cumulative number of reported layoffs over time?
10. Which companies ranked among the top 5 for layoffs each year?

---

# 🔍 Key Insights

### 1. Total reported layoffs

After cleaning, the dataset contains approximately **383,320 reported layoffs**.

The data covers the period from **March 2020 through March 2023**.

---

### 2. The United States accounted for the largest share

The United States recorded approximately **256,420 reported layoffs**, representing around **66.9% of all reported layoffs** in the cleaned dataset.

India ranked second with approximately **35,793 reported layoffs**.

---

### 3. Consumer and Retail were the most affected industries

The industries with the highest reported layoffs were:

| Industry | Reported Layoffs |
|---|---:|
| Consumer | 45,182 |
| Retail | 43,613 |
| Other | 36,209 |
| Transportation | 33,548 |
| Finance | 28,344 |

Consumer and Retail together accounted for approximately **88,795 reported layoffs**.

---

### 4. Post-IPO companies accounted for the largest share by company stage

Post-IPO companies recorded approximately **204,073 reported layoffs**, representing about **53.2%** of all reported layoffs in the cleaned dataset.

This was substantially higher than any other individual company stage.

---

### 5. 2022 recorded the highest annual layoffs

Annual reported layoffs were:

| Year | Reported Layoffs |
|---|---:|
| 2020 | 80,998 |
| 2021 | 15,823 |
| 2022 | 160,322 |
| 2023* | 125,677 |

\*2023 only includes data available through March 6 in this dataset.

**2022 recorded the highest total number of reported layoffs.**

---

### 6. January 2023 recorded the highest monthly layoffs

The monthly analysis shows that **January 2023** recorded approximately **84,714 reported layoffs**, making it the highest-layoff month in the dataset.

The rolling-total analysis was used to track the cumulative increase in reported layoffs over time.

---

### 7. Amazon had the highest cumulative reported layoffs

The companies with the highest total reported layoffs were:

| Company | Reported Layoffs |
|---|---:|
| Amazon | 18,150 |
| Google | 12,000 |
| Meta | 11,000 |
| Salesforce | 10,090 |
| Microsoft | 10,000 |
| Philips | 10,000 |
| Ericsson | 8,500 |
| Uber | 7,585 |
| Dell | 6,650 |
| Booking.com | 4,601 |

Amazon recorded the highest cumulative number of reported layoffs in the cleaned dataset.

---

### 8. Some companies reported complete workforce layoffs

The dataset contains **116 records** where `percentage_laid_off = 1`, indicating that the reported layoff represented 100% of the workforce for that record.

The largest example by reported layoffs was **Katerra**, with **2,434 layoffs**.

---

### 9. Yearly ranking identifies changing companies at the top

The analysis uses `DENSE_RANK()` with partitioning by year to identify the top 5 companies by layoffs for each year.

For example:

- **2020:** Uber ranked first with 7,525 reported layoffs.
- **2021:** Bytedance ranked first with 3,600.
- **2022:** Meta ranked first with 11,000.
- **2023:** Google ranked first with 12,000.

This demonstrates the use of SQL window functions for **year-over-year ranking analysis**.

---

# 🧠 SQL Concepts Demonstrated

### Data Cleaning
- Staging tables
- Duplicate detection
- `ROW_NUMBER()`
- `TRIM()`
- `LIKE`
- `UPDATE`
- `DELETE`
- NULL handling
- `STR_TO_DATE()`
- `ALTER TABLE`

### Data Analysis
- `SUM()`
- `MAX()`
- `MIN()`
- `GROUP BY`
- `ORDER BY`
- `WHERE`
- `JOIN`
- Common Table Expressions (`CTEs`)
- Window functions
- `SUM() OVER()`
- `DENSE_RANK()`
- `YEAR()`
- `SUBSTRING()`

---

# 📁 Project Structure

```text
Layoffs-SQL-Analysis/
│
├── data/
│   └── layoffs.csv
│
├── sql/
│   ├── 01_data_cleaning.sql
│   └── 02_exploratory_data_analysis.sql
│
└── README.md
```

---

# 🚀 Project Outcome

This project demonstrates an end-to-end SQL workflow:

**Raw CSV → Data Cleaning → Data Standardization → Missing-Value Handling → Exploratory Analysis → Time-Series Analysis → Business Insights**

The project showcases practical SQL skills including **data cleaning, joins, CTEs, aggregation, and window functions**, while using business-oriented questions to analyze real-world layoffs data.