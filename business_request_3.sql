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
--  12/07/2021  => Initial script creation
--              => Column Alias Creation: Renamed dc.city_name to "City Name" for better readability in the query output.
-- 				=> Conditional Aggregation for Percentage Distribution:
-- 					Added CASE statements to calculate the percentage distribution of repeat passengers for each trip_count category (2-Trips, 3-Trips, ..., 10-Trips).
-- 					Used SUM(CASE...) to aggregate the repeat_passenger_count for each category.
-- 					Divided the result of each category by the total repeat_passenger_count for the city to calculate percentages.
-- 					Used ROUND(..., 1) to limit the percentage values to one decimal place.
-- 				=> Join with dim_city: Added an INNER JOIN with the dim_city table on city_id to retrieve city names.
-- 				=> City-Level Grouping: Grouped results by dc.city_name to compute the metrics for each city.
-- 				=> Ordering by City Name: Ordered the final results alphabetically by city_name for clarity and easier analysis.
--
-- PROJECT => 02 Database
--         => 08 Tables
-- --------------------------------------------
SELECT
	dc.city_name AS "City Name",
    ROUND(SUM(CASE WHEN drt.trip_count="2-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "2-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="3-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "3-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="4-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "4-Trips",
	ROUND(SUM(CASE WHEN drt.trip_count="5-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "5-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="6-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "6-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="7-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "7-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="8-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "8-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="9-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "9-Trips",
    ROUND(SUM(CASE WHEN drt.trip_count="10-Trips"THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
		SUM(drt.repeat_passenger_count), 1) AS "10-Trips"
FROM
	dim_repeat_trip_distribution drt
INNER JOIN dim_city dc ON drt.city_id = dc.city_id
GROUP BY
	dc.city_name
ORDER BY
	dc.city_name;