-- Employee evaluation table
WITH SalesAgentPerformance AS (
    SELECT 
        Sales_Agent,
        SUM(close_value) AS CloseValue,
        SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS Wins,
        SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS Losses,
        AVG(CASE WHEN deal_stage = 'Won' THEN DATEDIFF(DAY, engage_date, close_date) END) AS 'AverageTTC(Days)',
        SUM(CASE WHEN close_value > 472 THEN 1 ELSE 0 END) AS HighValueCloses,
        SUM(CASE WHEN DATEDIFF(DAY, engage_date, close_date) <= 30 THEN 1 ELSE 0 END) AS QuickCloses
    FROM salespipeline
    GROUP BY Sales_Agent
)
SELECT 
    *,
    Wins * 100.0 / (Wins + Losses) AS WinRate,
    CloseValue / Wins AS AverageDeal
FROM SalesAgentPerformance
ORDER BY Wins DESC;
