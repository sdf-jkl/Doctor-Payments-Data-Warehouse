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

Research_raw AS(
    SELECT 
        Total_Amount_of_Payment_USDollars AS PMT_AMOUNT,
        1 AS NUMBER_OF_PAYMENTS,
        'ResearchPayment' AS PAYMENT_TYPE,
        Form_of_Payment_or_Transfer_of_Value AS PAYMENT_FORM,
        NULL AS PAYMENT_NATURE,
        Date_of_Payment AS DATE,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID AS COMPANY_MAKING_PMT_ID,
        LOWER(Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) AS SUBMITTING_COMPANY_NAME,
	    LOWER(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) AS COMPANY_MAKING_PMT_NAME,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State AS COMPANY_MAKING_PMT_STATE,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country AS COMPANY_MAKING_PMT_COUNTRY,
        Covered_Recipient_NPI AS RECIPIENT_NPI,
        Recipient_Primary_Business_Street_Address_Line1 AS RECIPIENT_ADDRESS_LINE_1,
        Recipient_Primary_Business_Street_Address_Line2 AS RECIPIENT_ADDRESS_LINE_2,
	    Recipient_City AS RECIPIENT_CITY,
	    Recipient_State AS RECIPIENT_STATE,
	    Recipient_Zip_Code AS RECIPIENT_ZIP_CODE,
	    Recipient_Country AS RECIPIENT_COUNTRY,
	    Recipient_Province AS RECIPIENT_PROVINCE,
	    Recipient_Postal_Code AS RECIPIENT_POSTAL_CODE,
        Covered_Recipient_Specialty_1,
        Covered_Recipient_Specialty_2,
        Covered_Recipient_Specialty_3,
        Covered_Recipient_Specialty_4,
        Covered_Recipient_Specialty_5,
        Covered_Recipient_Specialty_6,
        Covered_Recipient_Primary_Type_1,
        Covered_Recipient_Primary_Type_2,
        Covered_Recipient_Primary_Type_3,
        Covered_Recipient_Primary_Type_4,
        Covered_Recipient_Primary_Type_5,
        Covered_Recipient_Primary_Type_6,
        Principal_Investigator_1_NPI,
        Principal_Investigator_2_NPI,
        Principal_Investigator_3_NPI,
        Principal_Investigator_4_NPI,
        Principal_Investigator_5_NPI
    FROM RSRCH_RAW
    WHERE PMT_AMOUNT IS NOT NULL
),

General_raw AS(
    SELECT 
        Total_Amount_of_Payment_USDollars AS PMT_AMOUNT,
        Number_of_Payments_Included_in_Total_Amount AS NUMBER_OF_PAYMENTS,
        'GeneralPayment' AS PAYMENT_TYPE,
        Form_of_Payment_or_Transfer_of_Value AS PAYMENT_FORM,
        Nature_of_Payment_or_Transfer_of_Value AS PAYMENT_NATURE,
        Date_of_Payment AS DATE,
        Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_ID AS COMPANY_MAKING_PMT_ID,
        LOWER(Submitting_Applicable_Manufacturer_or_Applicable_GPO_Name) AS SUBMITTING_COMPANY_NAME,
	    LOWER(Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Name) AS COMPANY_MAKING_PMT_NAME,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_State AS COMPANY_MAKING_PMT_STATE,
	    Applicable_Manufacturer_or_Applicable_GPO_Making_Payment_Country AS COMPANY_MAKING_PMT_COUNTRY,
        Covered_Recipient_NPI AS RECIPIENT_NPI,
        Recipient_Primary_Business_Street_Address_Line1 AS RECIPIENT_ADDRESS_LINE_1,
        Recipient_Primary_Business_Street_Address_Line2 AS RECIPIENT_ADDRESS_LINE_2,
	    Recipient_City AS RECIPIENT_CITY,
	    Recipient_State AS RECIPIENT_STATE,
	    Recipient_Zip_Code AS RECIPIENT_ZIP_CODE,
	    Recipient_Country AS RECIPIENT_COUNTRY,
	    Recipient_Province AS RECIPIENT_PROVINCE,
	    Recipient_Postal_Code AS RECIPIENT_POSTAL_CODE,
        Covered_Recipient_Specialty_1,
        Covered_Recipient_Specialty_2,
        Covered_Recipient_Specialty_3,
        Covered_Recipient_Specialty_4,
        Covered_Recipient_Specialty_5,
        Covered_Recipient_Specialty_6,
        Covered_Recipient_Primary_Type_1,
        Covered_Recipient_Primary_Type_2,
        Covered_Recipient_Primary_Type_3,
        Covered_Recipient_Primary_Type_4,
        Covered_Recipient_Primary_Type_5,
        Covered_Recipient_Primary_Type_6,
        NULL AS Principal_Investigator_1_NPI,
        NULL AS Principal_Investigator_2_NPI,
        NULL AS Principal_Investigator_3_NPI,
        NULL AS Principal_Investigator_4_NPI,
        NULL AS Principal_Investigator_5_NPI
    FROM concatenated_general_tables
    WHERE PMT_AMOUNT IS NOT NULL
), 

raw_data AS(
    SELECT *
    FROM Research_raw
    UNION 
    SELECT *
    FROM General_raw
), 

data AS (
    SELECT 
        row_number() over (order by PMT_AMOUNT) as FACT_ID, 
        r.PMT_AMOUNT,
        r.NUMBER_OF_PAYMENTS, 
        dt.DATE_ID,
        co.COMPANY_ID,
        pf.PAYMENT_FORM_ID,
        pn.PAYMENT_NATURE_ID,
        pt.PAYMENT_TYPE_ID,
        re.RECIPIENT_ID,
        prt1.PRIMARY_TYPE_ID AS PRIMARY_TYPE1_ID,
        prt2.PRIMARY_TYPE_ID AS PRIMARY_TYPE2_ID,
        prt3.PRIMARY_TYPE_ID AS PRIMARY_TYPE3_ID,
        prt4.PRIMARY_TYPE_ID AS PRIMARY_TYPE4_ID,
        prt5.PRIMARY_TYPE_ID AS PRIMARY_TYPE5_ID,
        prt6.PRIMARY_TYPE_ID AS PRIMARY_TYPE6_ID,
        sp1.SPECIALTY_ID AS SPECIALTY1_ID,
        sp2.SPECIALTY_ID AS SPECIALTY2_ID,
        sp3.SPECIALTY_ID AS SPECIALTY3_ID,
        sp4.SPECIALTY_ID AS SPECIALTY4_ID,
        sp5.SPECIALTY_ID AS SPECIALTY5_ID,
        sp6.SPECIALTY_ID AS SPECIALTY6_ID,
        re1.RECIPIENT_ID AS PRINCIPAL_INVESTIGATOR1_ID,
        re2.RECIPIENT_ID AS PRINCIPAL_INVESTIGATOR2_ID,
        re3.RECIPIENT_ID AS PRINCIPAL_INVESTIGATOR3_ID,
        re4.RECIPIENT_ID AS PRINCIPAL_INVESTIGATOR4_ID,
        re5.RECIPIENT_ID AS PRINCIPAL_INVESTIGATOR5_ID
    FROM raw_data r
    LEFT JOIN dim_date dt
        ON r.DATE = dt.ISO_DATE
    LEFT JOIN dim_company co
        ON r.COMPANY_MAKING_PMT_ID = co.COMPANY_MAKING_PMT_ID
    LEFT JOIN dim_payment_form pf
        ON r.PAYMENT_FORM = pf.PAYMENT_FORM
    LEFT JOIN dim_payment_nature pn
        ON r.PAYMENT_NATURE = pn.PAYMENT_NATURE_FORM
    LEFT JOIN dim_payment_type pt
        ON r.PAYMENT_TYPE = pt.PAYMENT_TYPE
    LEFT JOIN 
        dim_primary_type prt1 ON r.COVERED_RECIPIENT_PRIMARY_TYPE_1 = prt1.PRIMARY_TYPE
    LEFT JOIN
        dim_primary_type prt2 ON r.Covered_Recipient_Primary_Type_2 = prt2.PRIMARY_TYPE
    LEFT JOIN
        dim_primary_type prt3 ON r.Covered_Recipient_Primary_Type_3 = prt3.PRIMARY_TYPE
    LEFT JOIN
        dim_primary_type prt4 ON r.Covered_Recipient_Primary_Type_4 = prt4.PRIMARY_TYPE
    LEFT JOIN
        dim_primary_type prt5 ON r.Covered_Recipient_Primary_Type_5 = prt5.PRIMARY_TYPE
    LEFT JOIN
        dim_primary_type prt6 ON r.Covered_Recipient_Primary_Type_6 = prt6.PRIMARY_TYPE
    LEFT JOIN dim_recipient re
        ON r.RECIPIENT_NPI = re.RECIPIENT_NPI 
    LEFT JOIN 
        dim_recipient re1 ON r.PRINCIPAL_INVESTIGATOR_1_NPI = re1.RECIPIENT_NPI
    LEFT JOIN 
        dim_recipient re2 ON r.PRINCIPAL_INVESTIGATOR_2_NPI = re2.RECIPIENT_NPI
    LEFT JOIN 
        dim_recipient re3 ON r.PRINCIPAL_INVESTIGATOR_3_NPI = re3.RECIPIENT_NPI
    LEFT JOIN 
        dim_recipient re4 ON r.PRINCIPAL_INVESTIGATOR_4_NPI = re4.RECIPIENT_NPI
    LEFT JOIN 
        dim_recipient re5 ON r.PRINCIPAL_INVESTIGATOR_5_NPI = re5.RECIPIENT_NPI
    LEFT JOIN 
        dim_specialty sp1 ON r.Covered_Recipient_Specialty_1 = sp1.SPECIALTY
    LEFT JOIN
        dim_specialty sp2 ON r.Covered_Recipient_Specialty_2 = sp2.SPECIALTY
    LEFT JOIN
        dim_specialty sp3 ON r.Covered_Recipient_Specialty_3 = sp3.SPECIALTY
    LEFT JOIN
        dim_specialty sp4 ON r.Covered_Recipient_Specialty_4 = sp4.SPECIALTY
    LEFT JOIN
        dim_specialty sp5 ON r.Covered_Recipient_Specialty_5 = sp5.SPECIALTY
    LEFT JOIN
        dim_specialty sp6 ON r.Covered_Recipient_Specialty_6 = sp6.SPECIALTY
)

SELECT 
    FACT_ID,
    PMT_AMOUNT,
	NUMBER_OF_PAYMENTS,
	PAYMENT_TYPE_ID,
	PAYMENT_FORM_ID,
	PAYMENT_NATURE_ID,
	DATE_ID,
	COMPANY_ID,
	RECIPIENT_ID,
	SPECIALTY1_ID,
	SPECIALTY2_ID,
	SPECIALTY3_ID,
	SPECIALTY4_ID,
	SPECIALTY5_ID,
    SPECIALTY6_ID,
	PRIMARY_TYPE1_ID,
	PRIMARY_TYPE2_ID,
	PRIMARY_TYPE3_ID,
	PRIMARY_TYPE4_ID,
	PRIMARY_TYPE5_ID,
    PRIMARY_TYPE6_ID,
	PRINCIPAL_INVESTIGATOR1_ID,
	PRINCIPAL_INVESTIGATOR2_ID,
	PRINCIPAL_INVESTIGATOR3_ID,
	PRINCIPAL_INVESTIGATOR4_ID,
	PRINCIPAL_INVESTIGATOR5_ID
FROM data
