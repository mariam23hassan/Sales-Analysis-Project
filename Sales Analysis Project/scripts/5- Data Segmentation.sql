-- [5] Data Segmentation :  Segment Products into Cost Ranges and Count 
--                          How Many Products Fall into each Segmen.
with product_segments as (
select 
       p.product_key,
       p.product_name ,
       p."cost" ,
       case when p."cost" < 100 then 'Below 100'
            when p."cost" between 100 and 500 then '100 - 500'
            when p."cost" between 500 and 1000 then '500 - 1000'
            else 'Above 1000'
       end cost_range
from gold_dim_products p 
)
select 
      cost_range,
      count(product_key) as total_products
from product_segments
group by cost_range 
order by total_products desc ;


-- Group customers into three segments based on their spending behavioe:
--      - VIP: Customers with at least 12 months of history and spending more then $5,000.
--      - Regular: Customers with at least 12 months of history but spending $5,000 or less.
--      - New: Customers with a lifespan less then 12 months.
-- And find the total number of customers by each group.
with customer_spending as(
select 
       c.customer_key,
       sum(f.sales_amount) as total_spending,
       min(f.order_date) as first_order,
       max(f.order_date ) as last_order,
       DATE_PART('year', AGE(MAX(f.order_date), MIN(f.order_date))) * 12 +
       DATE_PART('month', AGE(MAX(f.order_date), MIN(f.order_date))) 
       AS lifespan
from gold_fact_sales f
left join gold_dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key
)
select 
customer_key,
total_spending,
lifespan,
case when lifespan >= 12 and total_spending > 5000 then 'VIP'
     when lifespan >= 12 and total_spending <= 5000 then 'Regular'
     else 'New'
end customer_segment
from customer_spending ;
