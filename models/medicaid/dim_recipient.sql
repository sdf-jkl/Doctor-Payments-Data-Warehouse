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
	    Covered_Recipient_NPI AS RECIPIENT_NPI,
        Recipient_Primary_Business_Street_Address_Line1 AS RECIPIENT_ADDRESS_LINE_1,
        Recipient_Primary_Business_Street_Address_Line2 AS RECIPIENT_ADDRESS_LINE_2,
	    Recipient_City AS RECIPIENT_CITY,
	    Recipient_State AS RECIPIENT_STATE,
	    Recipient_Zip_Code AS RECIPIENT_ZIP_CODE,
	    Recipient_Country AS RECIPIENT_COUNTRY,
	    Recipient_Province AS RECIPIENT_PROVINCE,
	    Recipient_Postal_Code AS RECIPIENT_POSTAL_CODE
    FROM
        concatenated_general_tables
    union
    SELECT DISTINCT
	    Covered_Recipient_NPI AS RECIPIENT_NPI,
        Recipient_Primary_Business_Street_Address_Line1 AS RECIPIENT_ADDRESS_LINE_1,
        Recipient_Primary_Business_Street_Address_Line2 AS RECIPIENT_ADDRESS_LINE_2,
	    Recipient_City AS RECIPIENT_CITY,
	    Recipient_State AS RECIPIENT_STATE,
	    Recipient_Zip_Code AS RECIPIENT_ZIP_CODE,
	    Recipient_Country AS RECIPIENT_COUNTRY,
	    Recipient_Province AS RECIPIENT_PROVINCE,
	    Recipient_Postal_Code AS RECIPIENT_POSTAL_CODE
    FROM
        RSRCH_RAW
)

SELECT DISTINCT
    row_number() OVER (ORDER BY RECIPIENT_NPI) AS RECIPIENT_ID,
    RECIPIENT_NPI,
	RECIPIENT_ADDRESS_LINE_1,
	RECIPIENT_ADDRESS_LINE_2,
	RECIPIENT_CITY,
	RECIPIENT_STATE,
	Recipient_Zip_Code,
	RECIPIENT_COUNTRY
FROM
    raw_data
ORDER BY RECIPIENT_ID