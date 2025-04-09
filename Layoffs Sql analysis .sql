	-- Exploratory data analysis 
    
    -- Retrieve all records from the layoffs_staging2 table for an initial overview
    select * 
    from layoffs_staging2;
    
    -- Find the maximum number of employees laid off and the maximum layoff percentage.
    
        select max(total_laid_off), max(percentage_laid_off)
    from layoffs_staging2;
  
  -- Identify companies that laid off 100% of their employees, sorted by the highest number of layoffs.
  select * 
  from layoffs_staging2
  where percentage_laid_off =1 
  order by total_laid_off desc ;
  
  -- Identify companies that laid off 100% of employees, sorted by the highest amount of funding raised.
  
  select * 
  from layoffs_staging2 
  where percentage_laid_off= 1
  order by funds_raised_millions desc;
  
  
  -- Aggregate the total number of layoffs per company and order the results by the highest number of layoffs.
  
  select company, sum(total_laid_off)
  from layoffs_staging2
  group by company
  order by 2 desc;
  
  -- Find the earliest and latest layoff events in the dataset.
  
  select min(`date`), max(`date`)
  from layoffs_staging2;
  
  -- Layoff Analysis by Various Categories
  
  -- Total layoffs by industry, ordered from highest to lowest.
  

  select industry, sum(total_laid_off)
  from layoffs_staging2
  group by industry
  order by 2 desc;  
  
-- Total layoffs by country, ordered from highest to lowest
    select country , sum(total_laid_off)
  from layoffs_staging2
  group by country
  order by 2 desc;  
  
  
-- Total layoffs per year, showing trends over time.
  select  year (`date`),sum(total_laid_off)
  from layoffs_staging2
  group by year(`date`)
  order by 1 desc;
  
  -- Total layoffs by company funding stage, ordered by the highest layoffs.
  
    select  stage ,sum(total_laid_off)
  from layoffs_staging2
  group by stage 
  order by 2 desc;
  
  -- Average layoff percentage by company, highlighting companies with the highest average layoff rates.
  
  select company,avg(percentage_laid_off)
  from layoffs_staging2
  group by company
  order by 2 desc;
  
-- Rolling Sum Analysis

-- Calculate the total layoffs per month, ordered chronologically.

select substring(`date`,1,7) as `month`,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null 
group by `month`
order by 1 ASC;
  
  -- Compute a rolling sum of total layoffs over time.
  
  with  rolling_Total as 
  (
  select substring(`date`,1,7) as `month`,sum(total_laid_off) as total_off 
from layoffs_staging2
where substring(`date`,1,7) is not null 
group by `MONTH`
order by 1 ASC
  
  
  )
  select `MONTH`, total_off,
  sum(total_off) over (order by`month`) as rolling_total
  from rolling_Total ;
  
  -- Ranking Companies by Layoffs Per Year
  
  -- Show total layoffs by company and year
  
   select company, year(`date`),sum(total_laid_off)
  from layoffs_staging2
  group by company, year(`date`)
  order by company asc;
  
  -- Identify the top 5 companies with the highest layoffs for each year.
  
  with company_year(company,years,total_laid_off) as 
 (
 
  select company, year(`date`),sum(total_laid_off)
  from layoffs_staging2
  group by company, year(`date`)
 

),  company_year_rank as 
(select *, 
dense_rank() over (partition by years order by total_laid_off desc) as ranking 
from company_year
where years is not null
)
select *
from company_year_rank
where Ranking <= 5
;
