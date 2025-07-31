-- [1] Change-over-time : Analyze Sales Performance Over Time

-- Over The Year
select date_trunc('year', f.order_date) as  sales_year,
       sum(f.sales_amount) as total_sales,
       count(distinct f.customer_key) as total_customer,
       sum(f.quantity) as total_quantities
from gold_fact_sales f
where f.order_date is not null
group by sales_year
order by sales_year ;

-- Over The Month
select date_trunc('month',f.order_date) as sales_month,  
       sum(f.sales_amount) as total_sales,
       count(distinct f.customer_key) as total_customer,
       sum(f.quantity) as total_quantities
from gold_fact_sales f
where f.order_date is not null
group by sales_month
order by sales_month ;