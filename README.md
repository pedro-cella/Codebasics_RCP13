# Codebasics Challenge #13: Provide Insights to Chief of Operations in Transportation Domain

## About the project

**Goodcabs**, a cab service company established two years ago, has gained a strong foothold in the Indian market by focusing on tier-2 cities. Unlike other cab service providers, Goodcabs is committed to supporting local drivers, helping them make a sustainable living in their hometowns while ensuring excellent service to passengers. With operations in ten tier-2 cities across India, Goodcabs has set ambitious performance targets for 2024 to drive growth and improve passenger satisfaction. 

As part of this initiative, the Goodcabs management team aims to assess the company’s performance across key metrics, including trip volume, passenger satisfaction, repeat passenger rate, trip distribution, and the balance between new and repeat passengers. 

However, the Chief of Operations, Bruce Haryali, wanted this immediately but the analytics manager Tony is engaged on another critical project. Tony decided to give this work to Peter Pandey who is the curious data analyst of Goodcabs. Since these insights will be directly reported to the Chief of Operations, Tony also provided some notes to Peter to support his work.

**Contest Description:** https://codebasics.io/challenge/codebasics-resume-project-challenge

## **Business Request 1: City-Level Fare and Trip Summary Report**
### Query
```sql
SELECT
    dc.city_name,
    COUNT(DISTINCT ft.trip_id) AS total_trips,
    ROUND(SUM(ft.fare_amount)/NULLIF(SUM(ft.distance_travelled_km), 0), 1) AS avg_fare_per_km,
    ROUND(SUM(ft.fare_amount)/NULLIF(COUNT(DISTINCT ft.trip_id), 0), 1) AS avg_fare_per_trip,
    ROUND(100.0 * COUNT(DISTINCT ft.trip_id) / 
          (SELECT COUNT(DISTINCT trip_id) FROM fact_trips), 2) AS trip_percentage
FROM
    fact_trips ft
INNER JOIN dim_city dc ON ft.city_id = dc.city_id
GROUP BY 
    dc.city_name
ORDER BY 
    trip_percentage DESC;
```
### Result
![Query Result](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_1.png)

## **Business Request 2: Monthly City-Level Trips Target Performance Report**
### Query
```sql
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
    dc.city_name, dd.month_name, mtt.total_target_trips;

```
### Result
![Query Result 2](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_2.png)

## **Business Request 3: City-Level Repeat Passenger Trip Frequency Report**
### Query
```sql
SELECT
    dc.city_name AS "City Name",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "2-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "2-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "3-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "3-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "4-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "4-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "5-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "5-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "6-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "6-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "7-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "7-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "8-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "8-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "9-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "9-Trips",
    ROUND(
        SUM(CASE WHEN drt.trip_count = "10-Trips" THEN drt.repeat_passenger_count ELSE 0 END) * 100.0 /
        SUM(drt.repeat_passenger_count), 1
    ) AS "10-Trips"
FROM
    dim_repeat_trip_distribution drt
INNER JOIN dim_city dc ON drt.city_id = dc.city_id
GROUP BY
    dc.city_name
ORDER BY
    dc.city_name;

```
### Result
![Query Result 3](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_3.png)

## **Business Request 4: Identify Cities with Highest and Lowest Total New Passengers**
### Query
```sql
SELECT
    city_name,
    total_new_passengers,
    'Top 3' AS city_category
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
    LIMIT 3
) AS top_cities

UNION ALL

SELECT
    city_name,
    total_new_passengers,
    'Bottom 3' AS city_category
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
    LIMIT 3
) AS bottom_cities;

```
### Result
![Query Result 3](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_4.png)

## **Business Request 5: Identify Month with Highest Revenue for Each City**
### Query
```sql
SELECT
    city_name,
    month_name,
    revenue,
    ROUND((revenue / total_city_revenue) * 100, 2) AS percentage_contribution
FROM (
    SELECT
        dc.city_name,
        dd.month_name,
        RANK() OVER (PARTITION BY dc.city_name ORDER BY SUM(ft.fare_amount) DESC) AS highest_revenue_month,
        SUM(ft.fare_amount) AS revenue,
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

```
### Result
![Query Result 3](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_5.png)

## **Business Request 6: Repeat Passenger Rate Analysis**
### Query
```sql
SELECT
    dc.city_name,
    dd.month_name AS month,
    fps.total_passengers,
    fps.repeat_passengers,
    ROUND(SUM(fps.repeat_passengers) / SUM(fps.total_passengers) * 100.0, 2) AS monthly_repeat_passenger_rate,
    ROUND(
        SUM(SUM(fps.repeat_passengers)) OVER (PARTITION BY dc.city_name) /
        SUM(SUM(fps.total_passengers)) OVER (PARTITION BY dc.city_name) * 100.0, 2
    ) AS city_repeat_passenger_rate
FROM
    fact_passenger_summary fps
INNER JOIN dim_city dc ON fps.city_id = dc.city_id
INNER JOIN dim_date dd ON fps.month = dd.start_of_month
GROUP BY
    dc.city_name, fps.total_passengers, dd.month_name, dd.start_of_month, fps.repeat_passengers
ORDER BY
    dc.city_name, dd.start_of_month;

```
### Result
![Query Result 3](https://github.com/pedro-cella/Codebasics_RCP13/blob/main/img/business_request_6.png)
