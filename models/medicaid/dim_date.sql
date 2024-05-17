{{ config(
    materialized="table"
)}}

with concatenated_general_tables as (
    select * from GENERAL2018_RAW
    union all
    select * from GENERAL2019_RAW
    union all
    select * from GENERAL2020_RAW
    union all
    select * from GENERAL2021_RAW
    union all
    select * from GENERAL2022_RAW
),

date_series AS (
    SELECT DISTINCT CAST(Date_of_Payment AS timestamp) AS date FROM RSRCH_RAW
    union
    SELECT DISTINCT CAST(Date_of_Payment AS timestamp) AS date FROM concatenated_general_tables
)
SELECT 
    EXTRACT(YEAR FROM date) * 10000+ EXTRACT(MONTH FROM date) * 100 + EXTRACT(DAY FROM date) AS DATE_ID,
    TO_CHAR(date, 'YYYY-MM-DD') AS ISO_DATE,
    EXTRACT(YEAR FROM date) AS YEAR,
    EXTRACT(QUARTER FROM date) AS QUARTER,
    EXTRACT(MONTH FROM date) AS MONTH,
    EXTRACT(DAY FROM date) AS DAY,
    LEFT(TO_CHAR(date, 'Month'),3) AS MONTH_NAME,
    CASE
        WHEN DAYOFWEEK(date) = 0 THEN 'sunday'
        WHEN DAYOFWEEK(date) = 1 THEN 'monday'
        WHEN DAYOFWEEK(date) = 2 THEN 'tuesday'
        WHEN DAYOFWEEK(date) = 3 THEN 'wednesday'
        WHEN DAYOFWEEK(date) = 4 THEN 'thursday'
        WHEN DAYOFWEEK(date) = 5 THEN 'friday'
        WHEN DAYOFWEEK(date) = 6 THEN 'saturday'
    END AS DAY_NAME,
    EXTRACT(WEEK FROM date) AS WEEK_OF_THE_YEAR
FROM date_series