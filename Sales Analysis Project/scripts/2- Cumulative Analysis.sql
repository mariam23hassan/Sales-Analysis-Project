-- [2] Cumulative Analysis : Calculate the total sales per month and the 
--                           running total of sales over time.
select order_month,
       total_sales,
       sum(total_sales) over (order by order_month) as running_total_sales,
       avg(total_sales) over (order by order_month) as running_avg_sales
from(
     select 
           date_trunc('month', f.order_date) as order_month,
           sum(f.sales_amount) as total_sales,
           avg(f.price) as avg_price
     from gold_fact_sales f 
     where f.order_date is not null
     group by order_month
) as monthly_sales;