This project serves as my second week submission to The Data Initiative (TDI) community. It involves analyzing the customer shopping dataset to gain insights on the various shopping malls, the product categories, the payment methods and the age groups to see identify possible trends and see how revenue was generated.

---Analysis Process---

-Loaded the data into a database
-Checked for datatype of columns
-Converted the price, age, quantity and date colums to their correct datatypes
-Checked for duplicates in dataset - None found
-Checked for null values in dataset - None found
-Corrected the datatypes
-Queried the data with SQL to gain some insights.
-Imported the data to PowerBI for visualizations

--EDA with SQL--
-Demographic insights--
-no of customers
-no of invoices
-no of customers per gender
-no of customers per category
-no of customers per payment method
-no of customers per shopping mall
-no of customers per invoice date
-no of customers per age group
-created queries to dive into the spending insights based on quantity ordered per category and gender
-created queries to dive into the spending insights based on quantity ordered and total revenue for the years
-calculated monthly and yearly sales growth % with CTEs
-calculated percentage revenue from category types
-calculated percentage revenue from each payment type

--See more by looking at the SQL code --


-----Insights------
-$68.55 Million was the total revenue gotten over the time period.
-Over 299,000 products were sold in total.
-There was a total of 99,457 customers.
-The overall monthly sales growth percentage isnt good, as we see a decrease in monthly sales over the months. March 2022 being the month with the highest sales growth of 14.31%.
-Females covered 59.81% to the overall customers and in terms of revenue also brought in more acoss all the shopping Malls.
-Cash Payment method was the most used payment method overall, covering 44.79% of the overall revenue generated. This is followed by use of credit cards with 35.09% of the revenue.
-For Shopping Malls, The Mall of Istanbul and Kanyon seem to be the most popular malls as they have huge amount of customers of over 19k customers and the revenue generated from there of over $13 Million for both Malls is also huge and similar.
-For Product Categories, the Clothing category was the the one with more customers (34K customers)of which the females were more. The revenue generated from there also outshine other categories as it contributes 45.33% of the overall revenue.
-Cosmetics and Food & Beverages had almost equal number of customers of over 15k customers.
-Customer Visitation % also is good in some months and equally bad in other months for each shopping mall. July 2021 and March 2022 are the months with noticable increase in customers.

 











