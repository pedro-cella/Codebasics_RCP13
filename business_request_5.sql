-- -------- << Codebasics - RCP 13 >> ----------
--
--         DATA MANIPULATION SCRIPT (DML)
--
-- Creation Date ..........: 12/07/2024
-- Author(s) ..............: Pedro Vítor de Salles Cella
-- Database System ........: MySQL 8.0 CE
-- Database Name ..........: trips_db
--
-- Changes
--  12/07/2024  => Initial script creation.
--              => Highest Revenue Month Identification:
--                  - Used `RANK()` to rank months by revenue within each city (`PARTITION BY city_name ORDER BY SUM(fare_amount) DESC`).
--                  - Filtered for the highest revenue month per city (`highest_revenue_month = 1`).
--              => Revenue Calculation:
--                  - Calculated monthly revenue for each city and month using `SUM(fare_amount)` as `revenue`.
--                  - Calculated the total city revenue across all months using `SUM(SUM(fare_amount)) OVER (PARTITION BY city_name)` as `total_city_revenue`.
--              => Percentage Contribution Calculation:
--                  - Added a derived column `percentage_contribution` to calculate the proportion of the highest revenue month to the total city revenue.
--                  - Formula: `(revenue / total_city_revenue) * 100` rounded to 2 decimal places.
--              => City-Level Grouping:
--                  - Grouped results by `city_name` and `month_name` to enable city-level analysis.
--              => Ordering by City Name:
--                  - Ordered the final results alphabetically by `city_name` for easier readability.
--
-- PROJECT => 02 Database
--         => 08 Tables
-- --------------------------------------------
SELECT
	city_name,
    month_name,
    revenue,
    ROUND((revenue / total_city_revenue) * 100, 2) AS percentage_contribution
FROM(
	SELECT
		dc.city_name,
        dd.month_name,
		RANK() OVER (PARTITION BY dc.city_name ORDER BY SUM(ft.fare_amount) DESC) AS highest_revenue_month,
        SUM(ft.fare_amount) as revenue,
		SUM(SUM(ft.fare_amount)) OVER (PARTITION BY dc.city_name) AS total_city_revenue
	FROM
		fact_trips ft
	INNER JOIN dim_city dc ON ft.city_id = dc.city_id
	INNER JOIN dim_date dd ON ft.date = dd.date
	GROUP BY
		dc.city_name, dd.month_name
) AS highest_revenue_month
WHERE highest_revenue_month = 1
ORDER BY
	city_name;