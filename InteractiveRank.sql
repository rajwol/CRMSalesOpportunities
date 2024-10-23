-- Step 1: Create Temporary Table 
DROP TABLE IS EXISTS #SalesMetrics
CREATE TABLE #SalesMetrics (
    Sales_Agent NVARCHAR(100),
	Manager NVARCHAR(100),
    Close_Value BIGINT,
    Wins INT,
    Losses INT,
    Average_Deal FLOAT,
    High_Value_Closes INT,
	Quick_Closes INT,
    Winrate DECIMAL(10,2)
);

-- Step 2: Insert data into temporary table using EmployeePerformance Query
INSERT INTO #SalesMetrics (Sales_Agent, Manager, Close_Value, Wins, Losses, Average_Deal, High_Value_Closes, Quick_Closes, Winrate)
SELECT 
    st.Sales_Agent,
	st.Manager,
    SUM(sp.close_value) AS Close_Value,
    SUM(CASE WHEN sp.deal_stage = 'won' THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN sp.deal_stage = 'lost' THEN 1 ELSE 0 END) AS Losses,
    AVG(CASE WHEN sp.deal_stage = 'won' THEN sp.close_value END) AS Average_Deal,
    SUM(CASE WHEN sp.close_value > 472 THEN 1 ELSE 0 END) AS High_Value_Closes,
    SUM(CASE WHEN DATEDIFF(day, sp.engage_date, sp.close_date) <= 30 THEN 1 ELSE 0 END) AS Quick_Closes,
    (SUM(CASE WHEN sp.deal_stage = 'won' THEN 1 ELSE 0 END) * 100.0 / 
		NULLIF(SUM(CASE WHEN sp.deal_stage IN ('won', 'lost') THEN 1 ELSE 0 END), 0)) AS Winrate
FROM salespipeline sp
LEFT JOIN salesteams st ON sp.sales_agent = st.sales_agent
GROUP BY st.sales_agent, st.manager;

--Step 3: Rank Sales Agents based on a specific performance metric (Steps 1 & 2 Can be Deleted)
DECLARE @metric NVARCHAR(50);
SET @metric = 'Quick_Closes';  -- Change this to 'losses', 'winrate', 'AVGdeal', etc.
SELECT 
    *,
    DENSE_RANK() OVER (ORDER BY 
        CASE 
			WHEN @metric = 'Close_value' then Close_value
            WHEN @metric = 'Wins' THEN Wins
            WHEN @metric = 'Losses' THEN Losses
            WHEN @metric = 'Winrate' THEN Winrate
            WHEN @metric = 'Average_deal' THEN Average_Deal
			WHEN @metric = 'High_Value_Closes' then High_Value_Closes
			WHEN @metric = 'Quick_closes' then Quick_Closes
            ELSE Close_Value  -- Default to closevalue if no metric is matched
        END DESC
    ) AS Overall_Rank,
	 DENSE_RANK() OVER (
        PARTITION BY manager  -- Partition by Manager to Rank Within Teams
        ORDER BY 
            CASE 
                WHEN @metric = 'Close_value' then Close_value
				WHEN @metric = 'Wins' THEN Wins
                WHEN @metric = 'Losses' THEN Losses  
                WHEN @metric = 'Winrate' THEN Winrate
                WHEN @metric = 'Average_Deal' THEN Average_Deal
				WHEN @metric = 'High_Value_Closes' then High_Value_Closes
				WHEN @metric = 'Quick_closes' then Quick_Closes
                ELSE Close_Value  -- Default to closevalue
            END DESC
    ) AS team_rank
FROM #SalesMetrics
ORDER BY Overall_Rank;
