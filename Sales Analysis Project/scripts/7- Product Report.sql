-- [7] Product Report
-- SQL TASK:  
-- Purpose:
--      - This report consolidates key customer metrics and behaviors.
-- Highlights:
--      1. Gathers essential fields such as product, category, subcategory, and cost.
--      2. Segments product by revenue to identify High-Per-formers, Mid-Range, or Low-Performers.
--      3. Aggregates customers-level metrics:
--          - total orders
--          - total sales
--          - total quantity sold
--          - total customers (uniqe)
--          - lifespan (in months)
--      4. Calculates valuable KPIs:
--          - recency (months since last order)
--          - average order value (AOR)
--          - average monthly revenue
create view gold.report_product as
with base_query as(
-- 1) Base Query: Retrieves core columns from tables.
select 
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_number,
p.product_name,
p.category,
p.subcategory,
p."cost"

from gold_fact_sales f
left join gold_dim_products p
on f.product_key = p.product_key 
where f.order_date is not null
) ,
product_aggregation as (
-- 2) Product Aggregations: Summarizes key metrics at the Product level
select
       product_key,
       product_number,
       product_name,
       category,
       subcategory,
       "cost", 
--   3) Aggregates customers-level metrics:
       count(distinct order_number) as total_orders,    
       sum(sales_amount) as total_sales,
       sum(quantity) as total_product,
       count(distinct customer_key ) as total_customers,  
       date_part('year', age(max(order_date), min(order_date))) * 12 +
       date_part('month', age(max(order_date), min(order_date))) as lifespan ,      
       max(order_date) as last_order_date,
       round(avg(cast(sales_amount as float) / nullif (quantity, 0)):: numeric ,1) as avg_selling_price
from base_query 
group by 
       product_key ,
       product_number,
       product_name,
       category,
       subcategory,
       "cost"
)
select 
       product_key,
       product_name,
       category,
       subcategory,
       "cost",
       last_order_date,
--   Segments product
       case 
           when total_sales >= 50000 then 'High-Performer'
           when total_sales >= 10000 then 'Mid-Range'
           else 'Low-Performer'
       end as performance_segment,      
       total_orders,
       total_sales,
       total_product,
       total_customers,
       lifespan, 
       avg_selling_price,
--  4) KPIs: (recency )
       date_part('year', age(current_date, last_order_date)) * 12 +
       date_part('month', age(current_date, last_order_date)) as recency_in_months,
--   Copuate average order value (AVO) 
       case when total_orders = 0 then 0
            else total_sales / total_orders 
       end as avg_order_value,
--   Copuate average monthly revenue
       round(
             (case when lifespan = 0 then total_sales
                  else total_sales / lifespan 
              end)::numeric, 2 
            ) as avg_monthly_revenue

from product_aggregation ; 