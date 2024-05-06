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

primary_types as (
    select distinct Covered_Recipient_Primary_Type_1 as primary_type from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_2 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_3 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_4 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_5 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_6 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Primary_Type_1 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Primary_Type_2 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Primary_Type_3 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Primary_Type_4 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Primary_Type_5 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Primary_Type_6 from RSRCH_RAW
)

select
    row_number() over (order by primary_type) as PRIMARY_TYPE_ID,
    PRIMARY_TYPE
from primary_types
where primary_type IS NOT NULL
