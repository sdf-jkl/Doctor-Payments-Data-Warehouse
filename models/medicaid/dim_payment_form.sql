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

form_of_payment AS (
    SELECT DISTINCT Form_of_Payment_or_Transfer_of_Value AS PAYMENT_FORM FROM RSRCH_RAW
    union 
    SELECT DISTINCT Form_of_Payment_or_Transfer_of_Value AS PAYMENT_FORM FROM concatenated_general_tables
    WHERE
        PAYMENT_FORM IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY PAYMENT_FORM) AS PAYMENT_FORM_ID,
    PAYMENT_FORM
FROM
    form_of_payment
ORDER BY PAYMENT_FORM_ID


