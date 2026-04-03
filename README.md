# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Intermediate 
**Database**: `ashutoshdb`

This project demonstrates essential SQL skills used in data analysis, including data cleaning, exploration, and extracting business insights from retail sales data.

## Objectives

1) To build a retail sales database and load the given data into it.
2) To find and fix (Impute) or remove missing and incorrect values.
3) To analyze the dataset for understanding patterns and trends.
4) To gain useful insights from the sales data to solve business problems.

#### Dataset Information

The dataset contains transactional retail sales data with the following fields:

## Column Name & Description
transactions_id	--> Unique transaction ID
sale_date -->	Date of transaction
sale_time -->	Time of transaction
customer_id -->	Customer identifier
gender -->	Customer gender
age	--> Customer age
category -->	Product category
quantity -->	Units purchased
price_per_unit -->	Price per item
cogs -->	Cost of goods sold
total_sale -->	Total transaction value

## ⚙️ Project Workflow
🔹 1. Data Cleaning
*Converted empty values to NULL
*Removed invalid records (critical missing values)
*Handled missing data using: Mean imputation (age, quantity, price, etc.) Mode imputation (gender, category)
🔹 2. Data Transformation
*Created cleaned table retail_sales_clean
*Converted data types: VARCHAR → INT, DATE, TIME, FLOAT
🔹 3. Data Validation
*Checked NULL values across all columns
*Verified row counts and data consistency

📊 Exploratory Data Analysis
🔸 Basic Analysis
*Total Revenue
*Average Order Value
*Top Categories
🔸 Intermediate Analysis
*Revenue by Month
*Revenue by Gender
*Sales by Age Group

🚀 Advanced Analysis

🔹 Customer Analysis
Customer Segmentation (High / Medium / Low spenders)
Repeat Customers
Top Customers Ranking

🔹 Sales Analysis
Peak Sales Hour
Daily Sales Trend
Running Revenue (Cumulative Sales)

🔹 Product Analysis
Top Categories by Revenue
Top 3 Categories per Month

🔹 Time-Based Analysis
Monthly Growth Analysis
Best Performing Month per Year
Sales by Time of Day

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


## 👨‍💻 Author
Ashutosh Dalal

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles.


