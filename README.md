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
