{{
    config(
        materialized="table"
    )
}}

with raw_data_titles as (
    select 'ResearchPayment' as payment_type
    union all
    select 'GeneralPayment' as payment_type
)

select
    row_number() over(order by payment_type) as PAYMENT_TYPE_ID,
    payment_type as PAYMENT_TYPE
from raw_data_titles