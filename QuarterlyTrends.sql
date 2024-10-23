--Quarterly Trends
WITH SalesPipelineWithQuarters AS (
    SELECT *,
    CASE
		WHEN close_date BETWEEN '2017-01-01' AND '2017-03-31' THEN 'Quarter 1'
		WHEN close_date BETWEEN '2017-04-01' AND '2017-06-30' THEN 'Quarter 2'
		WHEN close_date BETWEEN '2017-07-01' AND '2017-09-30' THEN 'Quarter 3'
		WHEN close_date BETWEEN '2017-10-01' AND '2017-12-31' THEN 'Quarter 4'
        ELSE 'n/a'
    END AS Quarter
    FROM salespipeline
    WHERE YEAR(close_date) = 2017
)
SELECT 
    Quarter,
    COUNT(*) AS total_deals,
    SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS Won_deals,
    SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS losses,
    SUM(close_value) AS Total_Revenue
FROM SalesPipelineWithQuarters
GROUP BY Quarter
ORDER BY Quarter

--Product Deals and Revenue by Quarter
WITH SalesPipelineWithQuarters AS (
    SELECT sp.*, p.series,
        CASE 
            WHEN close_date BETWEEN '2017-01-01' AND '2017-03-31' THEN 'Quarter 1'
            WHEN close_date BETWEEN '2017-04-01' AND '2017-06-30' THEN 'Quarter 2'
            WHEN close_date BETWEEN '2017-07-01' AND '2017-09-30' THEN 'Quarter 3'
            WHEN close_date BETWEEN '2017-10-01' AND '2017-12-31' THEN 'Quarter 4'
            ELSE 'n/a' 
        END AS Quarter
    FROM salespipeline sp
    JOIN products p ON sp.product = p.product
    WHERE YEAR(close_date) = 2017
)
SELECT 
    Quarter, 
    product, 
    COUNT(*) AS total_deals, 
    SUM(close_value) AS total_revenue
FROM 
    SalesPipelineWithQuarters
GROUP BY 
    Quarter, product
ORDER BY 
    Quarter, product;

