Select subscription_status ,count(customer_Id),round(avg(purchase_amount) ,2) ,round(sum(purchase_amount),2)
From etl
Group By subscription_status

select item_purchased,
Round(100*SUM(CASE WHEN discount_applied ='Yes' THEN 1 ELSE 0 END)/count(*),2) As percentage_discount
From etl
Group By item_purchased
Order By percentage_discount DESC
Limit 5;

with customer_classification as (
select customer_Id,previous_purchases,CASE 
WHEN previous_purchases = 1 THEN 'Now'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyalty'
End As customer_segment
From etl
)

select count(customer_segment),customer_segment
From customer_classification 
Group By customer_segment

select *
From (select item_purchased ,category,count(item_purchased) As count,DENSE_RANK()OVER(PARTITION BY category ORDER By count(item_purchased) DESC) As rank 
from etl
Group By category,item_purchased
) as t
Where rank<= 3
ORDER BY category ,iterank DESC


with customer_classification as (
select customer_Id,previous_purchases,subscription_status,CASE 
WHEN previous_purchases = 1 THEN 'Now'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
ELSE 'Loyalty'
End As customer_segment
From etl
)

SELECT subscription_status ,COUNT(subscription_status) 
from customer_classification
Where customer_segment ='Loyalty'
GROUP By subscription_status


select 
age_category,sum(purchase_amount) as age_group_distribution
from etl
Group By age_category
Order By age_group_distribution Desc

