Create TABLE warehouse_retail_sales (
    year INT,
    month VARCHAR(20),
    supplier VARCHAR(255),
    item_code VARCHAR(50),
    item_description TEXT,
    item_type VARCHAR(100),
    retail_sales DECIMAL(10,2),
    retail_transfers DECIMAL(10,2),
    warehouse_sales DECIMAL(10,2)
);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/Warehouse_and_Retail_Sales.csv"
INTO TABLE warehouse_retail_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@year, @month, @supplier, @item_code, @item_description, @item_type, 
 @retail_sales, @retail_transfers, @warehouse_sales)
SET
    year = @year,
    month = @month,
    supplier = @supplier,
    item_code = @item_code,
    item_description = @item_description,
    item_type = @item_type,
    retail_sales = NULLIF(@retail_sales, ''),
    retail_transfers = NULLIF(@retail_transfers, ''),
    warehouse_sales = NULLIF(@warehouse_sales, '');

SELECT 
    year,
    SUM(retail_sales) AS total_retail_sales,
    SUM(warehouse_sales) AS total_warehouse_sales
FROM warehouse_retail_sales
GROUP BY year
ORDER BY year;


SELECT 
    supplier,
    SUM(COALESCE(retail_sales, 0) + COALESCE(warehouse_sales, 0)) AS total_sales
FROM warehouse_retail_sales
GROUP BY supplier
ORDER BY total_sales DESC
LIMIT 5;

SELECT 
    item_code,
    item_description,
    item_type,
    SUM(COALESCE(retail_sales, 0) + COALESCE(warehouse_sales, 0)) AS total_sales
FROM warehouse_retail_sales
GROUP BY item_code, item_description, item_type
ORDER BY total_sales DESC
LIMIT 10;


SELECT 
    item_code,
    item_description,
    item_type,
    SUM(COALESCE(retail_sales, 0) + COALESCE(warehouse_sales, 0)) AS total_sales
FROM warehouse_retail_sales
GROUP BY item_code, item_description, item_type
ORDER BY total_sales DESC
LIMIT 10;


SELECT 
    year,
    AVG(retail_sales) AS avg_retail_sales,
    AVG(warehouse_sales) AS avg_warehouse_sales
FROM warehouse_retail_sales
GROUP BY year
ORDER BY year;


SELECT 
    month,
    SUM(retail_sales) AS total_retail_sales,
    SUM(warehouse_sales) AS total_warehouse_sales
FROM warehouse_retail_sales
GROUP BY month
ORDER BY 
    FIELD(month, 'January', 'February', 'March', 'April', 'May', 'June', 
                  'July', 'August', 'September', 'October', 'November', 'December');


SELECT 
    item_type,
    SUM(COALESCE(retail_sales, 0) + COALESCE(warehouse_sales, 0)) AS total_sales
FROM warehouse_retail_sales
GROUP BY item_type
ORDER BY total_sales DESC;
