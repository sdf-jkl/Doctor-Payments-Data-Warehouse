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

raw_data as (
    SELECT DISTINCT
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID AS COMPANY_MAKING_PMT_ID ,
        LOWER(Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) AS SUBMITTING_COMPANY_NAME ,
	    LOWER(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) AS COMPANY_MAKING_PMT_NAME ,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State AS COMPANY_MAKING_PMT_STATE ,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country AS COMPANY_MAKING_PMT_COUNTRY 
    FROM
        concatenated_general_tables
    UNION 
    SELECT DISTINCT
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID AS COMPANY_MAKING_PMT_ID ,
        LOWER(Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) AS SUBMITTING_COMPANY_NAME ,
	    LOWER(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) AS COMPANY_MAKING_PMT_NAME ,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State AS COMPANY_MAKING_PMT_STATE ,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country AS COMPANY_MAKING_PMT_COUNTRY 
    FROM
        RSRCH_RAW
    WHERE
        SUBMITTING_COMPANY_NAME IS NOT NULL 
        AND COMPANY_MAKING_PMT_ID IS NOT NULL 
        AND COMPANY_MAKING_PMT_NAME IS NOT NULL 
        AND COMPANY_MAKING_PMT_STATE IS NOT NULL 
        AND COMPANY_MAKING_PMT_COUNTRY IS NOT NULL 
)

SELECT DISTINCT
    row_number() OVER (ORDER BY COMPANY_MAKING_PMT_ID) AS COMPANY_ID,
    SUBMITTING_COMPANY_NAME,
    COMPANY_MAKING_PMT_ID,
    COMPANY_MAKING_PMT_NAME,
    COMPANY_MAKING_PMT_STATE,
    COMPANY_MAKING_PMT_COUNTRY
FROM
    raw_data
ORDER BY COMPANY_ID
