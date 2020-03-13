# openehR
openehR is a simple *openEHR* endpoint interface intended to make results of AQL queries against a chosen openEHR-endpoint available as data frame.

### Usage
To use openehR, simply install and import it to your R script.

**Example of usage:**
```
query <- "select
    c/composer/name as composer,
    c/uid/value as uid, 
    c/content[openEHR-EHR-OBSERVATION.blood_pressure.v1]/data[at0001]/events[at0006]/time/value as datetime,
    c/content[openEHR-EHR-OBSERVATION.blood_pressure.v1]/data[at0001]/events[at0006]/data[at0003]/items[at0004]/value/units AS unit,
    c/content[openEHR-EHR-OBSERVATION.blood_pressure.v1]/data[at0001]/events[at0006]/data[at0003]/items[at0004]/value/magnitude AS magnitude 
from
    composition c
    contains observation o[openEHR-EHR-OBSERVATION.blood_pressure.v1]
"
url = "https://vt-lab7-ehr01.testlab.local:4443/openehr/v1" 
response <- query(url, query)
```
The response from each query will be availabe as a data frame if the query is successful, otherwise the response will be the response object returned by the provided endpoint.
