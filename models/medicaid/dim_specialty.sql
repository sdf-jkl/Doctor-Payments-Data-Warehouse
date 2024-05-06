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

specialty_types as (
    select distinct Covered_Recipient_Specialty_1 as specialty_type from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_2 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_3 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_4 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_5 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_6 from concatenated_general_tables
    union
    select distinct Covered_Recipient_Specialty_1 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Specialty_2 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Specialty_3 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Specialty_4 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Specialty_5 from RSRCH_RAW
    union
    select distinct Covered_Recipient_Specialty_6 from RSRCH_RAW
    union
    select distinct Principal_Investigator_1_Specialty_1 from RSRCH_RAW
    union
    select distinct Principal_Investigator_2_Specialty_1 from RSRCH_RAW
    union
    select distinct Principal_Investigator_3_Specialty_1 from RSRCH_RAW
    union
    select distinct Principal_Investigator_4_Specialty_1 from RSRCH_RAW
    union
    select distinct Principal_Investigator_5_Specialty_1 from RSRCH_RAW
)

select
    row_number() over (order by specialty_type) as SPECIALTY_ID,
    specialty_type as SPECIALTY
from specialty_types
where specialty_type IS NOT NULL
