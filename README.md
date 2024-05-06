# Doctor-Payments-Data-Warehouse

## Business Problem and Requirements:

The Centers for Medicare and Medicaid Services wants to know the profession and the popularity of the all the doctors that are getting paid by State.

**The requirements are:**
* Total Doctors by State
* Total Companies by State
* Ratings by County and Zip Code For each Specialty.
* Break down by General Payment, Ownership, by research 
* Payment by State and for each, you should be able to breakdown by Genera Pay, Ownership and Research
* During the year 2017-2022 (give me the populations for each state) 
* Do an analysis and see if the number of payment made match with the total populations
* Do not identify the doctors 
* Payment by Primary Type 
* Payment by Specialty
* Number of doctor per specialty, by state
* Form of Payment
* Nature Of Payment 

## Business Impact

### Risks
Data Privacy: When handling the personal data of healthcare providers, strict adherence to privacy laws and regulations is crucial.
Data Accuracy and Integrity: Incorrect or incomplete data can result in inaccurate conclusions, affecting policy decisions and CMS's operations.

### Costs
Data Infrastructure: Costs associated with data storage, processing, and analysis tools.
Personnel: Data scientists, engineers, and analysts who maintain the datasets and analyze the data.

### Benefits

Transparency and Accountability: Enhancing transparency in healthcare payments can help in reducing fraudulent practices and ensure fair compensation practices across states.
Policy Making and Enforcement: Insights from the data can inform policy decisions related to healthcare funding and provider behaviors.


## Business Persona

## Data

The datasets used come from CMS Open Payments Data website. https://openpaymentsdata.cms.gov/

There are two payment type datasets we used: generala and research payments.
On average a general payment dataset was about 7Gb and research payment dataset 700Mb.

## Methods 

We used ELT?

## Data Tools

**Data Storage:** Microsoft Azure

**Data Processing:** Snowflake and Dbt

## Interface

We used powerbi/apache superset
