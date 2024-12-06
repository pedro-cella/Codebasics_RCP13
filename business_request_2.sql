-- -------- << Codebasics - RCP 13 >> ----------
--
--         DATA MANIPULATION SCRIPT (DML)
--
-- Creation Date ..........: 12/06/2024
-- Author(s) ..............: Pedro Vítor de Salles Cella
-- Database System ........: MySQL 8.0 CE
-- Database Name ..........: trips_db
--
-- Changes
--  12/06/2021  => Added a new query to analyze trip performance against monthly targets for each city.
--              Joins fact_trips, dim_city, dim_date, and monthly_target_trips tables.
--              Calculates actual trips, target trips, performance status (Above/Below Target), and percentage difference.
--              Groups results by city and month.
--
-- PROJECT => 02 Database
--         => 08 Tables
----------------------------------------------------------
SELECT
	dc.city_name,
    dd.month_name,
    COUNT(ft.trip_id) AS actual_trips,
    mtt.total_target_trips AS target_trips,
	CASE 
		WHEN COUNT(ft.trip_id) > mtt.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
	END AS performance_status,
    ROUND((COUNT(ft.trip_id) - mtt.total_target_trips) * 100.0 / NULLIF(mtt.total_target_trips, 0), 2) AS percent_difference
FROM 
	fact_trips ft
INNER JOIN dim_city dc ON ft.city_id = dc.city_id
INNER JOIN dim_date dd ON ft.date = dd.date
INNER JOIN targets_db.monthly_target_trips mtt 
	ON ft.city_id = mtt.city_id AND dd.start_of_month = mtt.month
GROUP BY
	dc.city_name, dd.month_name,  mtt.total_target_trips;
