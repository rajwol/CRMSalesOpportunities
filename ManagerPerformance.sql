WITH ManagerPerformance AS (
	SELECT 
		st.Manager,
		SUM(sp.Close_Value) AS CloseValue,
		SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS Wins,
		SUM(CASE WHEN sp.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS losses,
		AVG(CASE WHEN sp.deal_stage = 'Won' then DATEDIFF(DAY, sp.engage_date, sp.close_date) END) AS 'AverageTTC(Days)',
		SUM(CASE WHEN sp.close_value > 472 THEN 1 ELSE 0 END) AS high_value_closes,
		SUM(CASE WHEN DATEDIFF(DAY, sp.engage_date, sp.close_date) <= 30 THEN 1 ELSE 0 END) AS Quick_Closes
FROM salespipeline sp 
	LEFT JOIN salesteams st ON sp.sales_agent=st.sales_agent
GROUP BY st.manager)

SELECT
	*, 
	Wins * 100.0 / (Wins + Losses) AS WinRate,
	CloseValue / Wins AS AverageDeal
FROM ManagerPerformance
ORDER BY CloseValue DESC
