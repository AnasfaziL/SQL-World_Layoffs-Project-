Select *
from layoffs
;

Create Table Layoffs_staging
Like layoffs ;

Select *
from layoffs_staging
;


Insert   layoffs_staging
Select *
from layoffs;




With Duplicates_CTE AS
(
Select *,
row_number() Over(
partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)as row_num
from layoffs_staging
)

Select * 
from Duplicates_CTE
where row_num > 1
;

Select *
from layoffs_staging
where Company = 'Cazoo'
;





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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert Into layoffs_staging2
Select *,
row_number() Over(
partition by Company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)as row_num
from layoffs_staging;

Select *
from layoffs_staging2 ;

Select *
from layoffs_staging2 
Where row_num > 1 ;


Delete 
from layoffs_staging2 
Where row_num > 1 ;


# Standardising Data 
# Trim()

Select company, Trim(Company)
from layoffs_staging2;

Update layoffs_staging2
Set company = Trim(Company);

Select distinct industry 
from layoffs_staging2
order by 1;

Select * 
from layoffs_staging2
where industry Like 'Crypto%' ;

SET SQL_SAFE_UPDATES = 0;

Update layoffs_staging2
Set industry ='Crypto'
where industry Like 'Crypto%';


Select country, trim(Trailing '.' From Country)
from layoffs_staging2
order by country;

Update layoffs_staging2
Set Country = trim(Trailing '.' From Country)
Where Country Like 'United States%' ;

SELECT `date`
FROM layoffs_staging2;

Update layoffs_staging2
Set `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

Alter Table layoffs_staging2
MODIFY COLUMN `date` DATE;




SELECT  *
FROM layoffs_staging2
where industry is Null 
OR industry = ' ';



select  *
from layoffs_staging2
where company Like 'Bally%';


SELECT *
FROM layoffs_staging2
WHERE industry = ''
OR industry is NULL ;

Update layoffs_staging2
Set industry = NULL
where industry = ' ' ;

#Step 2
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


#Step 3
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


#Step 1 
UPDATE layoffs_staging2
SET industry = NULL
WHERE TRIM(industry) = '';


SELECT *
FROM layoffs_staging2
Where total_laid_off is NULL
AND percentage_laid_off is NULL;


Alter Table layoffs_staging2
Drop column row_num;


