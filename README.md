# Exploratory Data Analysis on Layoffs (2020-2023) Description

This project demonstrates my ability to perform SQL-based exploratory data analysis (EDA) on a dataset containing information about layoffs from March 2020 to March 2023.

## SQL Highlights

- **Date Range Identification**: Verified the dataset's date range.
  ```sql
  SELECT MIN(`date`) AS start_date, MAX(`date`) AS end_date FROM layoffs_staging2;
  
- **Max Layoffs by Industry**: Identified the industry with the highest number of layoffs in a single day.
  ```sql
  SELECT MAX(total_laid_off), industry FROM layoffs_staging2 GROUP BY industry ORDER BY 1 DESC;

- **Complete Company Layoffs**: Counted the companies that laid off 100% of their employees.
  ```sql
  SELECT COUNT(company), percentage_laid_off FROM layoffs_staging2 WHERE percentage_laid_off = 1 GROUP BY percentage_laid_off;

- **Total Layoffs by Country**: Summarized layoffs by country to identify the most impacted regions.
  ```sql
  SELECT country, SUM(total_laid_off) FROM layoffs_staging2 GROUP BY country ORDER BY 2 DESC;

- **Rolling Total of Layoffs**: Calculated a rolling total of layoffs to track cumulative impacts over time.
  ```sql
  WITH DATE_CTE AS (
    SELECT SUBSTRING(date, 1, 7) AS dates, SUM(total_laid_off) AS total_laid_off
    FROM layoffs_staging2
    GROUP BY dates
  )
  SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
  FROM DATE_CTE ORDER BY dates ASC;

This project highlights my proficiency in SQL for data analysis, including date manipulation, aggregation, and rolling calculations.
