-- -------- << Codebasics - RCP 13 >> ----------
--
--         DATA MANIPULATION SCRIPT (DML)
--
-- Creation Date ..........: 12/05/2024
-- Author(s) ..............: Pedro Vítor de Salles Cella
-- Database System ........: MySQL 8.0 CE
-- Database Name ..........: trips_db
--
-- Changes
--  12/05/2021  => Initial script creation
--              => Added columns `city_name` and `total_trips` to the query
--               by joining with the `dim_city` table and using aggregate functions.
--  12/06/2021  => Added the avg_fare_per_km to the query, by using a division
--                 operation
--              => Added a new metric: `avg_fare_per_trip` to calculate the average fare per trip in each city.
--               This is calculated by dividing the total fare amount by the number of unique trips. 
--              => Added the `trip_percentage` metric to calculate the percentage of trips in each city compared to the total number of trips.
--               This is calculated by dividing the number of trips in each city by the total number of trips and multiplying by 100 
--              => Sorted the results by `trip_percentage` in descending order.
--
-- PROJECT => 02 Database
-- PROJECT => 02 Database
--         => 08 Tables
----------------------------------------------------------
SELECT
	dc.city_name,
    COUNT(DISTINCT ft.trip_id) AS total_trips,
    ROUND(SUM(ft.fare_amount)/NULLIF(SUM(ft.distance_travelled_km),0), 1) AS avg_fare_per_km,
    ROUND(SUM(ft.fare_amount)/NULLIF(COUNT(DISTINCT ft.trip_id),0),1) AS avg_fare_per_trip,
	ROUND(100.0 * COUNT(DISTINCT ft.trip_id) / 
          (SELECT COUNT(DISTINCT trip_id) FROM fact_trips), 2) AS trip_percentage
FROM
	fact_trips ft
INNER JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY 
	dc.city_name
ORDER BY 
	trip_percentage DESC;