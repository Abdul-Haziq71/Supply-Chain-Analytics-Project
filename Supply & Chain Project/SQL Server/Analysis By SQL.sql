CREATE DATABASE SUPPLY_CHAIN_DATASET
USE SUPPLY_CHAIN_DATASET
SELECT * FROM SUPPLYCHAIN
--counting rows
SELECT COUNT(*) AS Total_Rows FROM SupplyCHAIN
-- 1. Total Revenue & Profit
CREATE VIEW Total_Revenue_Profit AS
SELECT 
    SUM(Revnue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM SupplyChain
-- 2. Top 5 Selling SKUs
CREATE VIEW Top_5_SellingSKUs AS
SELECT TOP 5 SKU_ID, SUM(Units_Sold) AS Total_Sales
FROM SupplyChain
GROUP BY SKU_ID
ORDER BY Total_Sales DESC
-- 3. Revenue by Warehouse
CREATE VIEW Warehouse_revenue AS
SELECT warehouse_id, SUM(Revnue) AS Revenue_By_Warehouse
FROM SupplyChain
GROUP BY Warehouse_ID
ORDER BY Revenue_By_Warehouse DESC;

-----------------------------
-- 4. Monthly Revenue Trend

CREATE VIEW MonthlyRevenueTrend AS
SELECT YEAR(Date) AS Year, MONTH(Date) AS Month, SUM(Revnue) AS Monthly_Revenue
FROM SupplyChain
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;

-----------------------------
-- 5. Low Inventory Warehouses

CREATE VIEW LowInventoryWarehouses AS
SELECT Warehouse_ID, SUM(Inventory_Level) AS Total_Inventory
FROM SupplyChain
GROUP BY Warehouse_ID
HAVING SUM(Inventory_Level) < 500;

-----------------------------
-- 6. Stockout Products

CREATE VIEW StockoutProducts AS
SELECT SKU_ID, COUNT(*) AS Stockout_Days
FROM SupplyChain
WHERE Stockout_Flag = 1
GROUP BY SKU_ID
ORDER BY Stockout_Days DESC;


-----------------------------
-- 7. Revenue by Promotion

CREATE VIEW RevenueByPromotion AS
SELECT 
    Promotion_Flag,
    SUM(Revnue) AS Revenue
FROM SupplyChain
GROUP BY Promotion_Flag;


-----------------------------
-- 8. Average Lead Time by Supplier

CREATE VIEW AvgLeadTimeBySupplier AS
SELECT Supplier_ID, AVG(Supplier_Lead_Time_Days) AS Avg_LeadTime
FROM SupplyChain
GROUP BY Supplier_ID
ORDER BY Avg_LeadTime;

-----------------------------
-- 9. Profit Margin by SKU

CREATE VIEW ProfitMarginBySKU AS
SELECT SKU_ID, 
       SUM(Profit) / NULLIF(SUM(Revnue),0) * 100 AS Profit_Margin_Percentage
FROM SupplyChain
GROUP BY SKU_ID
ORDER BY Profit_Margin_Percentage DESC;


-----------------------------
-- 10. Cumulative Monthly Revenue

CREATE VIEW CumulativeMonthlyRevenue AS
SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(Revnue) AS Monthly_Revenue,
    SUM(SUM(Revnue)) OVER (ORDER BY YEAR(Date), MONTH(Date)) AS Cumulative_Revenue
FROM SupplyChain
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;