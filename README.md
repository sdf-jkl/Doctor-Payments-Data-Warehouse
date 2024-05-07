# Doctor-Payments-Data-Warehouse

## Business Problem and Requirements:

The Centers for Medicare and Medicaid Services wants to know the profession and the popularity of the all the doctors that are getting paid by State.

**The requirements are:**
* Total Doctors by State
* Total Companies by State
* Ratings by County and Zip Code For each Specialty
* Break down by General and research 
* Payment by State and for each, you should be able to breakdown by General and Research
* During the year 2018-2022 
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

### Users of the System:

Healthcare Policy Makers: Use the insights gathered to make/adjust healthcare policies.

Healthcare Providers: Interested in understanding how their payments compare with others across different states or specialties.

Public Health Officials: Use the data to ensure compliance with healthcare standards and fairness in provider payments.

Researchers and Academics: Interested in studying healthcare economics and provider behaviors.

### System Actors:

Data Engineers: Structure and manage vast amounts of data into usable formats.

Data Scientists and Analysts: Analyze the data to identify trends, correlations, and insights.


## Data

The datasets used come from CMS Open Payments Data website. https://openpaymentsdata.cms.gov/

There are two payment type datasets we used: generala and research payments.
On average a general payment dataset was about 7Gb and research payment dataset 700Mb.


## Methods 

The choice of ELT (Extract, Load, Transform) process is beneficial for several reasons:

Extracting raw data first preserves its integrity, while loading it into a centralized repository like Snowflake ensures scalable storage and processing capabilities.
Transforming data within the data warehouse simplifies the pipeline and maximizes the computational power of the warehouse for efficient transformations.
ELT methodology enables scalable processing of large datasets by leveraging the scalable storage and computational capabilities of modern data warehouses, achieved through the initial loading of raw data into the warehouse.


## Data Tools

**Data Storage:** Using Azure Container as a storage solution provides flexibility and scalability for storing large datasets securely.

**Data Processing:** Loading the dataset from Azure Container to Snowflake data warehouse facilitates efficient processing and analysis, leveraging Snowflake's capabilities for data manipulation and transformation. Utilizing dbt (data build tool) streamlines the process of data transformation and generation of dimensional and fact tables, enhancing automation and repeatability in the data pipeline.

## Interface

We used powerbi/apache superset
