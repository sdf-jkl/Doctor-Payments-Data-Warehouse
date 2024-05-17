{{
    config(
        materialized="table"
    )
}}

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

raw_data AS (
    SELECT DISTINCT
        Nature_of_Payment_or_Transfer_of_Value AS PAYMENT_NATURE_FORM
    FROM
        concatenated_general_tables
    WHERE
        PAYMENT_NATURE_FORM IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY PAYMENT_NATURE_FORM) AS PAYMENT_NATURE_ID,
    PAYMENT_NATURE_FORM
FROM
    raw_data
ORDER BY PAYMENT_NATURE_ID

