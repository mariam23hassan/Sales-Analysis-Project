Sales Analysis Project (PostgreSQL)

📅 Project Overview

This project provides a comprehensive sales and customer analytics system using PostgreSQL. It covers different types of analysis and reporting from raw sales data including performance tracking, segmentation, and KPIs. The code is written as SQL scripts and designed to be used with a sales dataset that includes products, customers, and transactional records.

🌐 Data Sources

The database consists of the following core tables:

gold_fact_sales: Sales transaction facts (order_number, product_key, customer_key, sales_amount, etc.)

gold_dim_products: Product details (product_key_product_name, category, cost, etc.)

gold_dim_customers: Customer details (customer ID, customer_name, birthdate, etc.)

✍️ SQL Tasks Breakdown

[1] Change Over Time Analysis

Analyze total sales, customer count, and quantity sold per year and month to monitor trends.

[2] Cumulative Analysis

Compute monthly sales and their running totals and averages to visualize cumulative performance.

[3] Performance Analysis

Track yearly product performance:

Compare sales to average sales per product

Analyze growth/decline from the previous year

[4] Part-To-Whole

Identify which categories contribute most to total sales using percent-of-total breakdown.

[5] Data Segmentation

Segment:

Products based on their cost ranges

Customers based on spending and purchase history:

VIP: > 12 months + > $5000

Regular: > 12 months + ≤ $5000

New: < 12 months history

[6] Customer Report (gold.report_customers)

A view that aggregates and reports key customer KPIs:

Age and segmentation

Total orders, sales, quantities, and products

Recency, lifespan

Average order value & monthly spend

[7] Product Report (gold.report_product)

A view that summarizes product performance:

Category, subcategory, and cost

Customer reach, sales, and order frequency

Recency, average order value, and monthly revenue

Segmented as: High-Performer, Mid-Range, Low-Performer

📃 Outputs

SQL views: gold.report_customers, gold.report_product

Insights across time, segments, and performance levels

🚀 How to Use

Import your dataset into PostgreSQL using the gold_fact_sales, gold_dim_products, and gold_dim_customers schemas.

Run the scripts in order or as needed.

Use the two views for dashboards or reporting tools.