-- [4] Part-To-Whole :  Which Categories Contribute The Most To Overall Sales.
with category_sales as(
select
      p.category ,
     sum(f.sales_amount) as total_sales
from gold_fact_sales f
left join gold_dim_products p 
on f.product_key = p.product_key
group by p.category )
select
      category,
      total_sales,
      sum(total_sales) over() as overall_sales,
      concat( round( ((total_sales::numeric) / sum(total_sales) over()) * 100, 2) , '%') as percentage_of_total
from category_sales
order by total_sales desc;