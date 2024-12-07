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
--              => Top 3 Cities Selection: Used a subquery to rank cities based on the total number of new passengers (`SUM(fps.new_passengers)`).
--                  - Ordered the results by `total_new_passengers` in descending order.
--                  - Limited the result to the top 3 cities using `LIMIT 3`.
--              => Bottom 3 Cities Selection: Used a similar subquery to rank cities in ascending order of `total_new_passengers` to identify the bottom 3 cities.
--                  - Ordered the results by `total_new_passengers` in ascending order.
--                  - Limited the result to the bottom 3 cities using `LIMIT 3`.
--              => City Category Labeling: Added a column alias `city_category` to differentiate between "Top 3" and "Bottom 3" city categories in the final result.
--              => UNION ALL: Combined the results from the top 3 cities and bottom 3 cities into a single output for comparison.
--
-- PROJECT => 02 Database
--         => 08 Tables
-- --------------------------------------------
SELECT
	city_name,
    total_new_passengers,
    'Top 3' as city_category
FROM (
	SELECT
		dc.city_name,
		SUM(fps.new_passengers) AS total_new_passengers
	FROM fact_passenger_summary fps
	INNER JOIN dim_city dc ON fps.city_id = dc.city_id
	GROUP BY
		dc.city_name
	ORDER BY
        total_new_passengers DESC
	limit 3
) AS top_cities

UNION ALL

SELECT
	city_name,
    total_new_passengers,
    'Bottom 3' as city_category
FROM (
	SELECT
		dc.city_name,
		SUM(fps.new_passengers) AS total_new_passengers
	FROM fact_passenger_summary fps
	INNER JOIN dim_city dc ON fps.city_id = dc.city_id
	GROUP BY
		dc.city_name
	ORDER BY
        total_new_passengers ASC
	limit 3
) AS bottom_cities
