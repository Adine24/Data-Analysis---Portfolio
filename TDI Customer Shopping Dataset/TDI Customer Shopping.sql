------- create a copy of dataset --------

SELECT *
INTO TDI_CustomerShoppingCopy
FROM customer_shopping_data_TDI;

------ view the dataset -------

SELECT * 
FROM TDI_CustomerShoppingCopy;

------- view datatypes of columns ---------

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'TDI_CustomerShoppingCopy';

--------- altering datatypes of age, quantity, price and date columns to aid analysis ----------

-- altering age column to integer datatype --
ALTER TABLE TDI_CustomerShoppingCopy
ALTER COLUMN age INT;

-- altering quantity column to integer datatype --
ALTER TABLE TDI_CustomerShoppingCopy
ALTER COLUMN quantity INT;

-- altering price column to decimal datatype --
ALTER TABLE TDI_CustomerShoppingCopy
ALTER COLUMN price DECIMAL(18,2);

-- altering Invoice_Date column to date datatype --
ALTER TABLE TDI_CustomerShoppingCopy
ALTER COLUMN Invoice_Date DATE;

------------- checking for duplicate values ---------------

SELECT invoice_no, customer_id, gender, age, category, quantity, price, payment_method, Invoice_Date, shopping_mall, COUNT(*)
FROM TDI_CustomerShoppingCopy
GROUP BY invoice_no, customer_id, gender, age, category, quantity, price, payment_method, Invoice_Date, shopping_mall
HAVING COUNT(*) > 1;

----------- checking for sum of null values in columns -----------

DECLARE @tableName NVARCHAR(128) = 'TDI_CustomerShoppingCopy';
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql + 'SELECT ''' + c.name + ''' AS ColumnName, SUM(CASE WHEN ' + QUOTENAME(c.name) + ' IS NULL THEN 1 ELSE 0 END) AS NullCount FROM ' + @tableName + ' UNION ALL '
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.name = @tableName;

-- Remove the last 'UNION ALL' from the generated SQL
SET @sql = LEFT(@sql, LEN(@sql) - LEN('UNION ALL'));

-- Execute the dynamically generated SQL
EXEC sp_executesql @sql;


-------- checking for spelling errors and distinct names by grouping data ---------

-- grouping by gender --

SELECT gender, SUM(price) AS Total_Spend
FROM TDI_CustomerShoppingCopy
GROUP BY gender;

-- grouping by category --

SELECT category, SUM(price) AS Total_Spend
FROM TDI_CustomerShoppingCopy
GROUP BY category;

-- grouping by payment method --

SELECT payment_method, SUM(price) AS Total_Spend
FROM TDI_CustomerShoppingCopy
GROUP BY payment_method;

-- grouping by shopping mall --

SELECT shopping_mall, SUM(price) AS Total_Spend
FROM TDI_CustomerShoppingCopy
GROUP BY shopping_mall;

--------------- grouping customers based on different demographies --------------

SELECT SUM(quantity) as TotalQty
FROM TDI_CustomerShoppingCopy;

-- get total number of customers --
SELECT COUNT(DISTINCT(customer_id)) as Customers
FROM TDI_CustomerShoppingCopy;

-- get total number of invoices --
SELECT COUNT(DISTINCT(invoice_no)) as Orders
FROM TDI_CustomerShoppingCopy;

-- get total number of customers per gender --
SELECT gender, COUNT(customer_id) as GenderCount
FROM TDI_CustomerShoppingCopy
GROUP BY gender;

-- get percentage of gender of total customers --
SELECT 
    gender, 
    COUNT(customer_id) as GenderCount,
    ROUND((COUNT(customer_id) * 100.0 / TotalCustomers), 2) as Percentage
FROM 
    TDI_CustomerShoppingCopy
CROSS JOIN (
    SELECT COUNT(customer_id) as TotalCustomers
    FROM TDI_CustomerShoppingCopy
) AS TotalCounts
GROUP BY gender, TotalCustomers;


-- get total number of customers per category --
SELECT category, COUNT(customer_id) as GenderCount
FROM TDI_CustomerShoppingCopy
GROUP BY category;

-- get total number of customers per category --
SELECT category, gender, COUNT(customer_id) as GenderCount
FROM TDI_CustomerShoppingCopy
WHERE category = 'Cosmetics'
GROUP BY category, gender;

-- get total number of customers per payment method --
SELECT payment_method, COUNT(customer_id) as methodCount
FROM TDI_CustomerShoppingCopy
GROUP BY payment_method;

-- get total number of customers per shopping mall--
SELECT shopping_mall, COUNT(customer_id) as mallCount
FROM TDI_CustomerShoppingCopy
GROUP BY shopping_mall;

-- get total number of customers per invoice date year--
SELECT DATEPART(yyyy, Invoice_Date) as Year, COUNT(customer_id) as dateCount
FROM TDI_CustomerShoppingCopy
GROUP BY DATEPART(yyyy, Invoice_Date);

-- get total number of customers per invoice date for 2021--
SELECT DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month, COUNT(customer_id) as dateCount
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date)
ORDER BY DATEPART(mm, Invoice_Date);


---------------- Spending Insights --------------------

-- Revenue from each shopping mall by gender --
SELECT shopping_mall, gender, SUM(price) as TotalRevenue
FROM TDI_CustomerShoppingCopy
GROUP BY shopping_mall, gender
ORDER BY shopping_mall,gender;

-- Revenue from each category type --
SELECT category, SUM(price) as TotalRevenue
FROM TDI_CustomerShoppingCopy
GROUP BY category;

-- Revenue percentage from category types --
SELECT 
    category, 
    SUM(price) as TotalRevenue,
    ROUND((SUM(price) * 100.0 / TotalRevenue), 2) as Percentage
FROM 
    TDI_CustomerShoppingCopy
CROSS JOIN (
    SELECT SUM(price) as TotalRevenue
    FROM TDI_CustomerShoppingCopy
) AS Revenue
GROUP BY category, TotalRevenue;


-- Revenue from each payment type --
SELECT payment_method, SUM(price) as TotalRevenue
FROM TDI_CustomerShoppingCopy
GROUP BY payment_method;

-- Revenue percentage from payment types --
SELECT 
    payment_method, 
    SUM(price) as TotalRevenue,
    ROUND((SUM(price) * 100.0 / TotalRevenue), 2) as Percentage
FROM 
    TDI_CustomerShoppingCopy
CROSS JOIN (
    SELECT SUM(price) as TotalRevenue
    FROM TDI_CustomerShoppingCopy
) AS Revenue
GROUP BY payment_method, TotalRevenue;

-- Revenue from each category type --
SELECT AgeGroup, SUM(price) as TotalRevenue
FROM TDI_CustomerShoppingCopy
GROUP BY AgeGroup;

-- Revenue percentage from category types --
SELECT 
    AgeGroup, 
    SUM(price) as TotalRevenue,
    ROUND((SUM(price) * 100.0 / TotalRevenue), 2) as Percentage
FROM 
    TDI_CustomerShoppingCopy
CROSS JOIN (
    SELECT SUM(price) as TotalRevenue
    FROM TDI_CustomerShoppingCopy
) AS Revenue
GROUP BY AgeGroup, TotalRevenue;


-- get total number of quantity ordered per category --
SELECT category, SUM(quantity)  as QtyCount
FROM TDI_CustomerShoppingCopy
GROUP BY category;

-- get total number of quantity ordered per gender --
SELECT SUM(quantity), gender
FROM TDI_CustomerShoppingCopy
GROUP BY gender;

-- get the total quantity and total revenue for 2021 year --
SELECT DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month, SUM(quantity) as QtySold, SUM(price) as MonthRevenue
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date)
ORDER BY DATEPART(mm, Invoice_Date);

----------creating a Common Table Expression (CTE) to calculate the monthly sales growth percentage ------------
-- % Growth = ((current month - previous month) / current month) * 100

WITH MonthlySales AS (
    SELECT 
        YEAR(Invoice_Date) AS SalesYear,
        MONTH(Invoice_Date) AS SalesMonth,
        SUM(price) AS TotalSales
    FROM TDI_CustomerShoppingCopy
    GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date)
)
SELECT 
    CONCAT(SalesYear, '-', SalesMonth) AS MonthYear,
    TotalSales,
    LAG(TotalSales, 1) OVER (ORDER BY SalesYear, SalesMonth) AS PreviousMonthSales,
    CASE 
        WHEN LAG(TotalSales, 1) OVER (ORDER BY SalesYear, SalesMonth) = 0 THEN NULL
        ELSE ((TotalSales - LAG(TotalSales, 1) OVER (ORDER BY SalesYear, SalesMonth)) / TotalSales) * 100 
    END AS SalesGrowthPercentage
FROM MonthlySales;

------------creating a Common Table Expression (CTE) to calculate the yearly sales growth percentage -------------
WITH YearlySales AS (
    SELECT 
        YEAR(Invoice_Date) AS SalesYear,
        SUM(price) AS TotalSales
    FROM TDI_CustomerShoppingCopy
    GROUP BY YEAR(Invoice_Date)
)
SELECT 
    SalesYear, TotalSales,
    LAG(TotalSales, 1) OVER (ORDER BY SalesYear) AS PreviousYearSales,
    CASE 
        WHEN LAG(TotalSales, 1) OVER (ORDER BY SalesYear) = 0 THEN NULL
        ELSE ((TotalSales - LAG(TotalSales, 1) OVER (ORDER BY SalesYear)) / TotalSales) * 100 
    END AS SalesGrowthPercentage
FROM YearlySales;



---------- Customer count per month for 2021 --------------
SELECT DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month, COUNT(customer_id) as customerback
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date)
ORDER BY DATEPART(mm, Invoice_Date);

-- check customer count for each month per shopping mall --
SELECT shopping_mall,category,DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month, COUNT(customer_id) as customerback
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY shopping_mall,category, DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date)
ORDER BY shopping_mall,DATEPART(mm, Invoice_Date);


-----------creating a Common Table Expression (CTE) to calculate the customer retention percentage over the months--------------
-- Retention % = ((customers for new month - customers for previous month) / customers for new month) * 100


WITH CustomerCounts AS (
    SELECT 
        YEAR(Invoice_Date) AS SalesYear,
        MONTH(Invoice_Date) AS SalesMonth,
        COUNT(DISTINCT customer_id) AS CustomerCount
    FROM TDI_CustomerShoppingCopy
    GROUP BY YEAR(Invoice_Date), MONTH(Invoice_Date)
),
CustomerRetention AS (
    SELECT 
        SalesYear,
        SalesMonth,
        CustomerCount,
        LAG(CustomerCount, 1) OVER (ORDER BY SalesYear, SalesMonth) AS PreviousMonthCount,
        CASE 
            WHEN LAG(CustomerCount, 1) OVER (ORDER BY SalesYear, SalesMonth) = 0 
                OR CustomerCount = 0 THEN NULL
            ELSE ((CustomerCount - LAG(CustomerCount, 1) OVER (ORDER BY SalesYear, SalesMonth)) * 100.0 / NULLIF(CustomerCount, 0))
        END AS CustomerRetentionPercentage
    FROM CustomerCounts
)
SELECT 
    CONCAT(SalesYear, '-', RIGHT('00' + CAST(SalesMonth AS VARCHAR(2)), 2)) AS MonthYear,
    CustomerCount,
    PreviousMonthCount,
    ISNULL(CustomerRetentionPercentage, 0) AS CustomerRetentionPercentage
FROM CustomerRetention;



-----------creating a Common Table Expression (CTE) to calculate the customer retention percentage over the months for each shopping mall--------------
-- Retention % = ((customers for new month - customers for previous month) / customers for new month) * 100

WITH CustomerCounts AS (
    SELECT 
        shopping_mall,
        YEAR(Invoice_Date) AS SalesYear,
        MONTH(Invoice_Date) AS SalesMonth,
        COUNT(DISTINCT customer_id) AS CustomerCount
    FROM TDI_CustomerShoppingCopy
    GROUP BY shopping_mall, YEAR(Invoice_Date), MONTH(Invoice_Date)
),
CustomerRetention AS (
    SELECT 
        shopping_mall,
        SalesYear,
        SalesMonth,
        CustomerCount,
        LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall ORDER BY SalesYear, SalesMonth) AS PreviousMonthCount,
        CASE 
            WHEN LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall ORDER BY SalesYear, SalesMonth) = 0 
                THEN NULL
            WHEN CustomerCount = 0 THEN 0
            WHEN LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall ORDER BY SalesYear, SalesMonth) = CustomerCount THEN 100
            ELSE ((CustomerCount - LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall ORDER BY SalesYear, SalesMonth))) * 100.0 / NULLIF(CustomerCount, 0)
        END AS CustomerRetentionPercentage
    FROM CustomerCounts
)
SELECT 
    shopping_mall,
    CONCAT(SalesYear, '-', RIGHT('00' + CAST(SalesMonth AS VARCHAR(2)), 2)) AS MonthYear,
    CustomerCount,
    PreviousMonthCount,
    ISNULL(CustomerRetentionPercentage, 0) AS CustomerRetentionPercentage
FROM CustomerRetention
ORDER BY shopping_mall, MonthYear;


-----creating a Common Table Expression (CTE) to calculate the customer retention percentage over the months for each shopping mall per category--------------
-- Retention % = ((customers for new month - customers for previous month) / customers for new month) * 100

WITH CustomerCounts AS (
    SELECT 
        shopping_mall,category,
        YEAR(Invoice_Date) AS SalesYear,
        MONTH(Invoice_Date) AS SalesMonth,
        COUNT(DISTINCT customer_id) AS CustomerCount
    FROM TDI_CustomerShoppingCopy
    GROUP BY shopping_mall,category, YEAR(Invoice_Date), MONTH(Invoice_Date)
),
CustomerRetention AS (
    SELECT 
        shopping_mall,category,
        SalesYear,
        SalesMonth,
        CustomerCount,
        LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall,category ORDER BY SalesYear, SalesMonth) AS PreviousMonthCount,
        CASE 
            WHEN LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall,category ORDER BY SalesYear, SalesMonth) = 0 
                THEN NULL
            WHEN CustomerCount = 0 THEN 0
            WHEN LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall ORDER BY SalesYear, SalesMonth) = CustomerCount THEN 100
            ELSE ((CustomerCount - LAG(CustomerCount, 1) OVER (PARTITION BY shopping_mall, category ORDER BY SalesYear, SalesMonth))) * 100.0 / NULLIF(CustomerCount, 0)
        END AS CustomerRetentionPercentage
    FROM CustomerCounts
)
SELECT 
    shopping_mall,category,
    CONCAT(SalesYear, '-', RIGHT('00' + CAST(SalesMonth AS VARCHAR(2)), 2)) AS MonthYear,
    CustomerCount,
    PreviousMonthCount,
    ISNULL(CustomerRetentionPercentage, 0) AS CustomerRetentionPercentage
FROM CustomerRetention
ORDER BY shopping_mall,category, MonthYear;



----Check for number of times payment method is used over time -----
SELECT DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month,payment_method, COUNT(payment_method) as MethodCount
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date), payment_method
ORDER BY DATEPART(mm, Invoice_Date);


----- Revenue from each category over the months for 2021 -------
SELECT DATEPART(yyyy, Invoice_Date) as Year, DATEPART(mm, Invoice_Date) as Month,category,  SUM(price) as CategoryRevenue
FROM TDI_CustomerShoppingCopy
WHERE DATEPART(yyyy, Invoice_Date) = 2021
GROUP BY DATEPART(yyyy, Invoice_Date), DATEPART(mm, Invoice_Date), category
ORDER BY DATEPART(mm, Invoice_Date);


SELECT SUM(price) from TDI_CustomerShoppingCopy;


------------- check for minimum and maximum age in age column ------------------
SELECT MIN(age) FROM TDI_CustomerShoppingCopy;
SELECT MAX(age) FROM TDI_CustomerShoppingCopy;

SELECT age, category, sum(price)
FROM TDI_CustomerShoppingCopy
group by age, category
ORDER by age;

-- selecting age groups --

SELECT *,
    CASE
        WHEN age >= 60 THEN 'Senior Adult'
        WHEN age >= 40 THEN 'Middle Age Adult'
        WHEN age >= 20 THEN 'Adult'
        ELSE 'Teen' 
    END AS AgeGroup
FROM TDI_CustomerShoppingCopy;

----------------- creating a new column to store age group category ----------------

ALTER TABLE TDI_CustomerShoppingCopy
ADD AgeGroup NVARCHAR(50);

-- Update the age group coulmn based on age conditions --
UPDATE TDI_CustomerShoppingCopy
SET AgeGroup = 
    CASE
        WHEN age >= 60 THEN 'Senior Adult'
        WHEN age >= 40 THEN 'Middle Age Adult'
        WHEN age >= 20 THEN 'Adult'
        ELSE 'Teen'
    END;


-------- get total number of customers per age group -------------
SELECT AgeGroup, COUNT(customer_id) as Customers
FROM TDI_CustomerShoppingCopy
GROUP BY AgeGroup;

--get total number of customers per category --
SELECT category, AgeGroup, COUNT(customer_id) as CustomersCount
FROM TDI_CustomerShoppingCopy
GROUP BY category, AgeGroup
ORDER BY category, AgeGroup;


Select * from TDI_CustomerShoppingCopy;




