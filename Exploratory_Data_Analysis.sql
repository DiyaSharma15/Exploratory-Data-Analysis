
----------------------------------------------- Exploratory Data Analysis -----------------------------------------------------

SELECT * 
FROM layoffs_staging2;

-- To check the date range of the dataset 
SELECT
    MIN(`date`) AS start_date,
    MAX(`date`) AS end_date
FROM
    layoffs_staging2;
    -- The data is between 2020-03-11 to 2023-03-06


-- Which industry had the max amount of layoffs in one day? 
select MAX(total_laid_off), industry
from layoffs_staging2
GROUP BY industry
order by 1 DESC;
	-- Consumer industry had the max amount of layoffs with 12000 employees laid off in one day. 


-- looking at the yearly trend of layoffs for the Consumer industry grouped by year
SELECT industry, SUM(total_laid_off), YEAR(`date`)
FROM layoffs_staging2
WHERE industry = 'Consumer'
GROUP BY 3
ORDER BY 3;


-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off), company
FROM layoffs_staging2
GROUP BY company
ORDER BY 1 DESC;
	-- There are a lot of comapanies that laid off all their employees 
	-- so, lets look at how many comapanies fully laid off all it's employees
    SELECT COUNT(company), percentage_laid_off
    FROM layoffs_staging2
    WHERE percentage_laid_off = (
    SELECT MAX(percentage_laid_off)
    FROM layoffs_staging2
	)
    GROUP BY percentage_laid_off;
    -- 116 companies laid off all its employees

    -- if we order by funcs_raised_millions we can see how big some of these companies were
	SELECT *
	FROM layoffs_staging2
	WHERE  percentage_laid_off = 1
	ORDER BY funds_raised_millions DESC;
  
  
-- Which indusrtry had the most layoffs overall?
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;
	-- Consumer industry is still at the top with 45,182 total layoffs from the year 2020 to 2023. 
    
    
-- Which countries had a lot of layoffs?
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;
	-- looks like United States had the maxium amount of layoffs with 256,559 layoffs. 


-- Let's look at companies with the most layoffs per year 
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;


-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
