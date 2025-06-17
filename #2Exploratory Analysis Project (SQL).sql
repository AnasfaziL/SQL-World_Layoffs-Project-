# Explanatory Data Analysis

Select *
from layoffs_staging2;

#Maximum lay offs
Select Max(total_laid_off)
from layoffs_staging2;

#Maximum  % lay offs (1 represents 100)
Select Max(percentage_laid_off)
from layoffs_staging2;

# All Comapnies which layed off their Emp upto 100%
Select *
from layoffs_staging2
where (percentage_laid_off) = 1
;

# Total Comapnies which layed off their Emp upto 100%
Select Count(*)
from layoffs_staging2
where (percentage_laid_off) = 1
;

#Companies which laid of Most employees
Select *
from layoffs_staging2
where (percentage_laid_off) = 1
order by total_laid_off DESC ;


#Companies which raised most funds
select *
from layoffs_staging2
order by funds_raised_millions DESC;

#Fund raised by Companies who laid off 100% 
select *
from layoffs_staging2
where (percentage_laid_off) = 1
order by funds_raised_millions DESC;

#Total laid off 
Select company, sum(total_laid_off) 
from layoffs_staging2 
group by company
order by sum(total_laid_off) DEsc;

#Time period of Data 
Select Min(`date`), Max(`date`)
from layoffs_staging2;

#Which industry did most Layoffs

Select Industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by sum(total_laid_off) Desc ;

#Employees Laid off as per Country
Select Country, sum(total_laid_off)
From layoffs_staging2
group by Country
order by sum(total_laid_off) DESC;

#Employees Laid off per year
Select Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by Year(`date`)
order by sum(total_laid_off) Desc ;

#Funding stages
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by sum(total_laid_off) Desc ;


select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by sum(percentage_laid_off) Desc ;


# Total layoffs as per month
Select substr(`date`, 1, 7) AS `Month`, sum(total_laid_off)
From layoffs_staging2
where substr(`date`, 1, 7) is Not Null
group by `Month`
order by `Month` ASC;


##ROlling total (CTE) 
WITH Rolling_Total AS
(
Select substr(`date`, 1, 7) AS `Month`, sum(total_laid_off) as Total_Cuts
From layoffs_staging2
where substr(`date`, 1, 7) is Not Null
group by `Month`
order by `Month` ASC

)

Select `Month`, Total_Cuts, Sum(Total_Cuts) Over(order by `Month`) As rolling_total
From Rolling_Total;


Select company, sum(total_laid_off) 
from layoffs_staging2 
group by company
order by sum(total_laid_off) DEsc;


Select company, year(`Date`), sum(total_laid_off) 
from layoffs_staging2 
group by company, year(`Date`)
order by 3 DESC;

WITH Company_year (company, years, Total_laid_off) AS
(
Select company, year(`Date`), sum(total_laid_off) 
from layoffs_staging2 
group by company, year(`Date`)
)

Select * , dense_rank() Over (partition by years order by Total_laid_off DESC) as Rankings
From Company_year
Where years is NOT NULL ;