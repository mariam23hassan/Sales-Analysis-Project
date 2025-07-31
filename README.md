# 📊 Sales Analysis Project (PostgreSQL)

This project focuses on analyzing sales data using PostgreSQL to uncover key insights about customers, products, and overall business performance.

## 📁 Project Components:
- Raw Data: includes sales transactions, customer details, and product information  
- SQL Scripts: located in the `Script/` folder and organized by analysis type  
- README File: provides full documentation for project structure and purpose

## 🛠️ Tools Used:
- PostgreSQL  
- SQL  
- Excel (for raw data preparation)

## 🔍 What Does the Analysis Cover?
- Sales Over Time : trends in sales, customer count, and quantity sold by year and month  
- Cumulative Metrics : monthly running totals and averages of sales  
- Performance Analysis : compare product sales to averages and previous years  
- Category Contribution : identify which product categories contribute most to revenue  
- Customer Segmentation : classify customers into VIP, Regular, and New based on activity and spending  
- Product Segmentation : label products as High, Mid, or Low Performers

## 📊 Key Reports (SQL Views):
- `gold.report_customers`: shows customer KPIs like lifetime, orders, spend, and segmentation  
- `gold.report_product`: summarizes product reach, sales, order frequency, and performance level

## 🚀 How to Use:
1. Import your dataset into PostgreSQL using the following tables:  
   - `gold_fact_sales`  
   - `gold_dim_products`  
   - `gold_dim_customers`  
2. Run the SQL scripts in order or based on the analysis you need  
3. Use the created views in your reporting tool (Power BI, Tableau, etc.)

---

> This project was created as part of my journey to improve my data analysis skills using SQL and real-world business data. Feedback is always welcome!

Use the two views for dashboards or reporting tools.
