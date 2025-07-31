-- [3] Performance Analysis :  Analyze the yearly performance of products by comparing 
--                             their sales to both the average dales performance of 
--                             the product and the previous year's sales.
select
      date_trunc('year', f.order_date) as order_year,
      p.product_name,
      sum(f.sales_amount) as total_sales
from gold_fact_sales f
left join gold_dim_products p
on f.product_key = p.product_key
where f.order_date is not null
group by order_year, p.product_name
order by order_year ;

with yealy_product_sales as (
select
      to_char(f.order_date, 'yyyy') as order_year,
      p.product_name,
      sum(f.sales_amount) as current_sales
from gold_fact_sales f
left join gold_dim_products p
on f.product_key = p.product_key
where f.order_date is not null
group by order_year, p.product_name
)
select 
      order_year,
      product_name,
      current_sales,
      avg(current_sales) over (partition by product_name) as avg_sales,
      current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
      case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above AVG'
           when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below AVG'
           else 'AVG'
      end avg_change,
      lag(current_sales) over(partition by product_name order by order_year) py_sales,
      current_sales - lag(current_sales) over(partition by product_name order by order_year) diff_py,
       case when current_sales - lag(current_sales) over(partition by product_name order by order_year) > 0 then 'Increase'
            when current_sales - lag(current_sales) over(partition by product_name order by order_year) < 0 then 'Decrease'     
            else 'No change'
       end py_change
from yealy_product_sales
order by product_name, order_year ;