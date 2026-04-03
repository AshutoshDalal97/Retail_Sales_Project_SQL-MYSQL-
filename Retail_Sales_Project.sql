#CREATE TABLE use ashutoshdb; 
DROP TABLE if exists retail_sales;
################
CREATE TABLE retail_sales (
transactions_id VARCHAR(20),
sale_date VARCHAR(20),
sale_time VARCHAR(20),
customer_id VARCHAR(20),
gender VARCHAR(20),
age VARCHAR(20),
category VARCHAR(50),
quantity VARCHAR(20),
price_per_unit VARCHAR(20),
cogs VARCHAR(20),
total_sale VARCHAR(20)
);
############
SET SQL_SAFE_UPDATES = 0;
update retail_sales
set
transactions_id=nullif(transactions_id,''),
sale_date = NULLIF(sale_date, ''),
sale_time = NULLIF(sale_time, ''),
customer_id = NULLIF(customer_id, ''),
gender = NULLIF(gender, ''),
age = NULLIF(age, ''),
category = NULLIF(category, ''),
quantity = NULLIF(quantity, ''),
price_per_unit = NULLIF(price_per_unit, ''),
cogs = NULLIF(cogs, ''),
total_sale = NULLIF(total_sale, '');
SET SQL_SAFE_UPDATES = 1;      ##Note: these two safe update 0 and 1 is needed otherwise need to use where clause
########################
#Important Note: change in CSV then directly import without saving CSV (Too much time wasted)
select * from retail_sales;
######Convert to actual data types
#DROP TABLE if exists retail_sales_clean;
CREATE TABLE retail_sales_clean ( 
transactions_id INT PRIMARY KEY, 
sale_date DATE, 
sale_time TIME, 
customer_id INT, 
gender VARCHAR(15), 
age INT, 
category VARCHAR(15), 
quantity INT, 
price_per_unit FLOAT, 
cogs FLOAT, 
total_sale INT );
##############################
#DROP TABLE if exists retail_sales_clean;
INSERT INTO retail_sales_clean
SELECT 
CAST(transactions_id AS UNSIGNED),
STR_TO_DATE(sale_date,'%Y-%m-%d'),
sale_time,
CAST(customer_id AS UNSIGNED),
gender,
CAST(age AS UNSIGNED),
category,
CAST(quantity AS UNSIGNED),
CAST(price_per_unit AS DECIMAL(10,2)),
CAST(cogs AS DECIMAL(10,2)),
CAST(total_sale AS UNSIGNED)
FROM retail_sales
WHERE transactions_id IS NOT NULL;
#AND transactions_id <> ''
#AND transactions_id REGEXP '^[0-9]+$';
############################################
select * from retail_sales_clean;
################################################
select * from retail_sales_clean order by transactions_id asc limit 100; #To see first 100 rows
#To count no of rows
select count(*) from retail_sales_clean;
###Check for null values
select count(*) as total_rows_as_null,
sum(case when transactions_id is null then 1 else 0 end) as transactions_id_null from retail_sales_clean;
#####Now for all the columns
SELECT 
COUNT(*) AS total_rows,
SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS transactions_id_nulls,
SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS sale_date_nulls,
SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS sale_time_nulls,
SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_nulls,
SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_nulls,
SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS total_sale_nulls
FROM retail_sales_clean;

#####################
select * from retail_sales_clean;
select count(*) from retail_sales_clean;



########Handle NULL values
DELETE FROM retail_sales_clean
WHERE transactions_id IS NULL;

DELETE FROM retail_sales_clean
WHERE transactions_id IN (
    SELECT transactions_id FROM (
        SELECT transactions_id
        FROM retail_sales_clean
        WHERE sale_date IS NULL
    ) t
);  ##Deleted rows containing NULL in column sale_date

##for sale_time column
DELETE FROM retail_sales_clean
WHERE transactions_id IN (
    SELECT transactions_id FROM (
        SELECT transactions_id
        FROM retail_sales_clean
        WHERE sale_time IS NULL
    ) t
);  ##Deleted rows containing NULL in column sale_time

DELETE FROM retail_sales_clean
WHERE transactions_id IN (
    SELECT transactions_id FROM (
        SELECT transactions_id
        FROM retail_sales_clean
        WHERE customer_id IS NULL
    ) t
);  ##Deleted rows containing NULL in column customer_id

############ rest NULLs we will impute
select * from retail_sales_clean;
#######GENDER imputation
select gender, count(*) as freq
from retail_sales_clean
where gender is not null and gender <> ''
group by gender
order by freq desc limit 1; #female 1006 times

##now impute
SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set gender = 'Female'
where gender is null or gender = '';
SET SQL_SAFE_UPDATES = 1;

###AGE imputation
select avg(age) from retail_sales_clean
where age is not null;

SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set age = 41  #mean  41.3551
where age is null or age = '';
SET SQL_SAFE_UPDATES = 1;

#######CATEGORY imputation
select * from retail_sales_clean;
#########
select category, count(*) as freq
from retail_sales_clean
where category is not null and category <> ''
group by category
order by freq desc limit 1; #Clothing 693 times

#Now impute value
SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set category = 'Clothing'
where category is null or category = '';
SET SQL_SAFE_UPDATES = 1;

######QUANTITY imputation  
select avg(quantity) from retail_sales_clean
where quantity is not null;

SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set quantity = 3  #mean  2.5117
where quantity is null or quantity = '';
SET SQL_SAFE_UPDATES = 1;

###Price per unit imputation
select avg(price_per_unit) from retail_sales_clean
where price_per_unit is not null;

SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set price_per_unit = 179.18  #mean  '179.17891535732386'
where price_per_unit is null or price_per_unit = '';
SET SQL_SAFE_UPDATES = 1;


####COGS imputation
select avg(cogs) from retail_sales_clean
where cogs is not null;

SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set cogs = 94.62  #mean  '94.6212766027982'
where cogs is null or cogs = '';
SET SQL_SAFE_UPDATES = 1;

###TOTAL SALE imputation
select avg(total_sale) from retail_sales_clean
where total_sale is not null;

SET SQL_SAFE_UPDATES = 0;
update retail_sales_clean
set total_sale = 453  #mean  '452.5748'
where total_sale is null or total_sale = '';
SET SQL_SAFE_UPDATES = 1;

#######Exploratory Data Analysis
#Q1. Total Revenue
select sum(total_sale) as Total_Revenue from retail_sales_clean ;

#Q2. Avg Order Value?
select avg(total_sale) as Average_Order_value from retail_sales_clean;

#Q3. Top 3 Catagories?
select category,
sum(total_sale) as revenue
from retail_sales_clean 
group by category 
order by revenue desc limit 3;

#Q4. Revenue by month?
select date_format(sale_date,'%Y-%m') as month,
sum(total_sale) as revenue
from retail_sales_clean
group by month
order by month;

#Q5. Revenue by gender?

select gender, sum(total_sale) as Revenue_by_gender
from retail_sales_clean
group by gender;

#Q6. Sales by age group?

select case
when age<20 then 'Teen'
when age>=20 and age<35 then 'Young'
when age>=35 and age <55 then 'Adult'
else 'Senior'
end as Age_group,
sum(total_sale) as Revenue
from retail_sales_clean
group by Age_group
order by Revenue desc;

#Q7. Customer segmentation (total spend) ?
select customer_id,
 sum(total_sale) as total_spent,
 case when sum(total_sale) >5000 then 'High Value'
 when sum(total_sale) between 2000 and 5000 then 'Medium Value'
 else 'Low Value'
 end as segment
 from retail_sales_clean
 group by customer_id;
 
 #Q8. Repeat customers?
 select customer_id, count(*) as purchase_count
 from retail_sales_clean
 group by customer_id
 having count(*)>1
 order by purchase_count desc;
 
 #Q9. Peak Sales time? (Hour wise)
 select hour(sale_time) as hour,
 sum(total_sale) as revenue
 from retail_sales_clean
 group by hour
 order by revenue desc;
 
 #Q10. Top products (or categories)
 select category, sum(total_sale) as revenue,
 rank() over(order by sum(total_sale) desc) as rank_category
 from retail_sales_clean
 group by category;
 
 #Q11. Top Customers?
select customer_id,
sum(total_sale) as total_spent,
dense_rank() over(order by sum(total_sale) desc) as rank_customer
from retail_sales_clean
group by customer_id;

#Q12. Sales trend (Day-wise)?
select
sale_date,
sum(total_sale) as day_wise,
lag(sum(total_sale)) over(order by sale_date) as previous_day_sales
from retail_sales_clean
group by sale_date;

#Q13. Running Revenue → SUM() OVER()
SELECT 
sale_date,
SUM(total_sale) AS daily_sales,
SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_revenue
FROM retail_sales_clean
GROUP BY sale_date;

#Q14. Top 3 categories per month

SELECT *
FROM (
    SELECT 
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    category,
    SUM(total_sale) AS revenue,
    RANK() OVER (PARTITION BY DATE_FORMAT(sale_date, '%Y-%m') 
                 ORDER BY SUM(total_sale) DESC) AS rnk
    FROM retail_sales_clean
    GROUP BY month, category
) t
WHERE rnk <= 3;
#Q15. Which month had highest growth? (Growth = difference from previous month)
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(sale_date, '%Y-%m') AS month,
        SUM(total_sale) AS revenue
    FROM retail_sales_clean
    GROUP BY month
)
SELECT 
month,
revenue,
revenue - LAG(revenue) OVER (ORDER BY month) AS growth
FROM monthly_sales
ORDER BY growth DESC
LIMIT 1;

#Q16. What time of day has highest sales?
SELECT 
CASE 
    WHEN HOUR(sale_time) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(sale_time) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Night'
END AS time_of_day,
SUM(total_sale) AS revenue
FROM retail_sales_clean
GROUP BY time_of_day
ORDER BY revenue DESC
LIMIT 1;

#Q17. Retrive all columns for sales made on '2022-11-05'

select * from retail_sales_clean
where sale_date='2022-11-05';

#Q18. Retrive all transactions where category is Clothing and the quantity sold is more than 3 in Nov,2022
SELECT *
FROM retail_sales_clean
WHERE category = 'Clothing'
AND quantity > 3
AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

#Q19. Average age of customers who purchased from Beuty category?
select category,
round(avg(age)) as avg_age from retail_sales_clean
where category='Beauty';

#Q20. Total number of transaction made by each gender in each category?
select category, gender,
count(*) as total_no_transactions from retail_sales_clean
group by category, gender
order by 1; #category will come together

#Q21. Average sale for each month and best selling month in each year?
select * from
(select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_total_sale,
rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank_by_sale
from retail_sales_clean
group by 1,2) as t
where rank_by_sale=1;


#Q22. Unique customers from each category

select
 category,count(distinct(customer_id))
from retail_sales_clean
group  by category;

#END OF THE PROJECT.................