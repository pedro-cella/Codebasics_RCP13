-- -------- << Codebasics - RCP 13 >> ----------
--
--         DATA MANIPULATION SCRIPT (DML)
--
-- Creation Date ..........: 12/08/2024
-- Author(s) ..............: Pedro Vítor de Salles Cella
-- Database System ........: MySQL 8.0 CE
-- Database Name ..........: trips_db
--
-- Changes
--  12/08/2024  => Initial script creation.
--              => Monthly Repeat Passenger Rate Calculation:
--                  - Added a derived column `monthly_repeat_passenger_rate` to calculate the repeat passenger rate for each city and month.
--                  - Formula: `SUM(fps.repeat_passengers) / SUM(fps.total_passengers) * 100` rounded to 2 decimal places.
--              => City-Wide Repeat Passenger Rate Calculation:
--                  - Added a derived column `city_repeat_passenger_rate` to calculate the overall repeat passenger rate for each city across all months.
--                  - Used `SUM(...) OVER (PARTITION BY dc.city_name)` to calculate the total repeat and total passengers across all months within each city.
--                  - Formula: `SUM(SUM(fps.repeat_passengers)) OVER (PARTITION BY city_name) / SUM(SUM(fps.total_passengers)) OVER (PARTITION BY city_name) * 100` rounded to 2 decimal places.
--              => Chronological Month Ordering:
--                  - Used `dd.start_of_month` in the `ORDER BY` clause to ensure months are sorted in chronological order.
--              => City and Month-Level Grouping:
--                  - Grouped results by `dc.city_name`, `dd.month_name`, and `dd.start_of_month` for detailed city and month-level analysis.
--              => Enhanced Readability:
--                  - Ordered the final results first by `city_name` (alphabetically) and then by `dd.start_of_month` (chronologically).
--
-- PROJECT => 02 Database
--         => 08 Tables
-- --------------------------------------------

SELECT
    dc.city_name,
    dd.month_name AS month,
    fps.total_passengers,
    fps.repeat_passengers,
    ROUND(SUM(fps.repeat_passengers) / SUM(fps.total_passengers) * 100.0, 2) AS monthly_repeat_passenger_rate,
    ROUND(SUM(SUM(fps.repeat_passengers)) OVER (PARTITION BY dc.city_name) /
          SUM(SUM(fps.total_passengers)) OVER (PARTITION BY dc.city_name) * 100.0, 2) AS city_repeat_passenger_rate
FROM
    fact_passenger_summary fps
INNER JOIN dim_city dc ON fps.city_id = dc.city_id
INNER JOIN dim_date dd ON fps.month = dd.start_of_month
GROUP BY
    dc.city_name, fps.total_passengers, dd.month_name, dd.start_of_month, fps.repeat_passengers
ORDER BY
    dc.city_name, dd.start_of_month;