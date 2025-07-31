-- [6] Customer Report 
-- Purpose:
--      - This report consolidates key customer metrics and behaviors.
-- Highlights:
--      1. Gathers essential fields such as names, ages, and transaction details.
--      2. Segments customers into categories (VIP, Regular, New) and age groups.
--      3. Aggregates customers-level metrics:
--          - total orders
--          - total sales
--          - total quantity purchased
--          - total products
--          - total (in months)
--      4. Calculates valuable KPIs:
--          - recency (months since last order)
--          - average order value
--          - average monthly spend
CREATE SCHEMA gold;

create view gold.report_customers as 
with base_query as (
-- 1) Base Query: Retrieves core columns from tables.
select 
f.order_number ,
f.product_key,
f.order_date,
f.sales_amount ,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name , ' ',c.last_name ) as customer_name,
date_part('year', age(current_date, to_date(c.birthdate, 'YYYY-MM-DD'))) as age

from gold_fact_sales f
left join gold_dim_customers c
on f.customer_key = c.customer_key 
where order_date is not null ) ,

customer_aggregation as(
-- 2) Customer Aggregations: Summarizes key metrics at the customer level
select
    customer_key,
    customer_number,
    customer_name,
    age,
    max(order_date) as last_order_date,
--   3) Aggregates customers-level metrics:
    count(distinct order_number) as total_orders,
    sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
    count(distinct product_key) as total_products,
    date_part('year', age(max(order_date), min(order_date))) * 12 +
    date_part('month', age(max(order_date), min(order_date)))  AS lifespan
from base_query
group by 
    customer_key,
    customer_number,
    customer_name,
    age
)
select
      customer_key,
      customer_number,
      customer_name,
      age,
--   Segments customers
      case when age < 20 then 'under 20'
           when age between 20 and 29 then '20-29'
           when age between 30 and 39 then '30-39'
           when age between 40 and 49 then '40-49'
           else '50 and above'
      end as age_group,
      case when lifespan >= 12 and total_sales > 5000 then 'VIP'
           when lifespan >= 12 and total_sales <= 5000 then 'Regular'
           else 'New'
      end customer_segment ,
      last_order_date,
      total_orders,
      total_sales,
      total_quantity,
      total_products,
      lifespan,
--   4) KPIs: (recency)
      date_part('year', age(current_date, last_order_date)) * 12 +
      date_part('month',age(current_date, last_order_date))  as recency , 
--   Copuate average order value (AVO) 
      case when total_sales = 0 then 0
           else total_sales / total_orders
      end as avg_order_value,
--   Copuate average monthly spend 
      round(
            (case when lifespan = 0 then total_sales
                   else total_sales / lifespan
             end) ::numeric, 2
           )as avg_monthly_spend

from customer_aggregation  ;