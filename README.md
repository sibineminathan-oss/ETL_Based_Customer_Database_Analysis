# ETL_Based_Customer_Database_Analysis
This project is about analyzing Buying pattern of the consumers by data cleaning ,data processing and then finally visuvalizing it .The aim of this project is to help stakeholders get insights about consumers buying pattern to figure out the strength and improvement areas of the organization 
Customer Buying Pattern Analysis

Project Overview
This project analyzes customer purchasing behavior using Python, SQL, and Power BI.
The objective is to identify customer segments, purchasing trends, and revenue patterns based on subscription status, discounts, product categories, and age groups.

The project follows a data analytics pipeline:

Python → Data cleaning and feature engineering
SQL (PostgreSQL) → Data querying and analysis
Power BI → Dashboard visualization
Dataset Features

The dataset includes information such as:

Customer ID
Age
Product Category
Item Purchased
Purchase Amount
Review Rating
Discount Applied
Subscription Status
Delivery Method
Previous Purchases

These attributes were used to analyze customer behavior and spending patterns.

Data Preprocessing (Python)

The dataset required cleaning and transformation before analysis.

Key steps:

• Handling Missing Values
Missing values in review_rating were filled using the median rating of each product category.

df['review_rating'] = df.groupby('category')['review_rating']\
                        .transform(lambda x: x.fillna(x.median()))

• Creating Age Categories
A new column age_category was created to group customers into age segments.

• Mapping Purchase Frequency
Purchase frequency values were converted from text labels to numerical values to simplify analysis.

Data Analysis (SQL)

The cleaned dataset was exported to PostgreSQL, where SQL queries were used to analyze customer behavior.

Revenue vs Subscription Status
Select subscription_status ,
count(customer_Id),
round(avg(purchase_amount) ,2),
round(sum(purchase_amount),2)
From etl
Group By subscription_status

This helps compare average spending and revenue contribution of subscribed vs non-subscribed customers. 

ETL_1

Customer Segmentation

Customers were classified into three segments based on previous purchases:
New – First purchase
Returning – Moderate purchase history
Loyal – Frequent repeat buyers
with customer_classification as (
select customer_Id,previous_purchases,
CASE 
WHEN previous_purchases = 1 THEN 'Now'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyalty'
End As customer_segment
From etl
)

select count(customer_segment),customer_segment
From customer_classification 
Group By customer_segment

This identifies the distribution of customer loyalty segments. 

ETL_1

Top Products by Category
select *
From (
select item_purchased ,category,count(item_purchased) As count,
DENSE_RANK()OVER(PARTITION BY category ORDER By count(item_purchased) DESC) As rank 
from etl
Group By category,item_purchased
) as t
Where rank<= 3

This query finds the top 3 purchased products in each category. 

ETL_1

Discount Impact on Products
select item_purchased,
Round(100*SUM(CASE WHEN discount_applied ='Yes' THEN 1 ELSE 0 END)/count(*),2) 
As percentage_discount
From etl
Group By item_purchased
Order By percentage_discount DESC
Limit 5;

This identifies products that depend heavily on discounts for sales. 

ETL_1

Revenue Distribution by Age Group
select 
age_category,
sum(purchase_amount) as age_group_distribution
from etl
Group By age_category
Order By age_group_distribution Desc

This shows which age groups contribute most to revenue. 

ETL_1

Power BI Dashboard

Power BI was used to create an interactive dashboard showing:

Revenue by subscription status
Customer segmentation
Spending by age group
Top products by category
Impact of discounts on purchases


Tools & Technologies

Python (Pandas, NumPy)

PostgreSQL

SQL (CTE, Window Functions, Aggregations)

Power BI

Key Insights

• Loyal customers contribute a major portion of revenue
• Subscription status influences spending behavior
• Discounts significantly impact certain products
• Different age groups show different spending patterns
• Some categories have clear top-performing products

Project Structure
Customer-Buying-Pattern-Analysis
│
├── Data_Cleaning_Python.ipynb
├── ETL_1.sql
├── PowerBI_Dashboard.pbix
├── dataset.csv
└── README.md
