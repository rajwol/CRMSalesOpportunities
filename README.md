# Sales Performance Analysis SQL Project

## Project Overview

This project focuses on developing SQL-based data analysis to extract key insights about the **performance of sales agents**, **managers**, and the **organization as a whole** from a sales dataset. By leveraging structured SQL queries, this project enables efficient performance measurement and ranking at multiple levels—agents, teams, and managers—helping stakeholders make data-driven decisions. RDBMS used was Microsoft SQL Server and queries were created using SQL Server Management Studio (SSMS).

**Link to Dataset:** https://mavenanalytics.io/challenges/maven-sales-challenge/8f59bcfa-d310-4947-b3d8-917b3cce270e

The project uses various SQL techniques such as:
- **Aggregations** (`SUM`, `COUNT`, `AVG`)
- **Window functions** (`DENSE_RANK`)
- **CTEs (Common Table Expressions)** for cleaner queries
- **Temporary Tables** to store intermediate results
- **Joins** between datasets for data enrichment
- **Time-based filtering** for quarterly and yearly trends

The insights generated include:
1. **Agent-level performance metrics** (wins, losses, win rate, quick closes, high-value deals, etc.).
2. **Manager-level performance metrics**, aggregating team performance.
3. **Quarterly trends** in deals and revenue to assess seasonal performance.
4. **Product-based analysis by quarter** to identify key drivers of revenue.
5. **Dynamic ranking** within team and organization to assess sales agents performance against specific key performance indicators.

---
