# openehR
openehR is an R package for retrieving data from an openEHR server using the
[openEHR REST API](https://specifications.openehr.org/releases/ITS-REST/Release-1.0.1/). 

# Usage
To use openehR, simply install it with 

```
devtools::install_github('dipsas/openehR')
```

and use it in your R scripts like so

```R

query <- "
select
    o/data[at0001]/events[at0006]/time/value as datetime,
    o/data[at0001]/events[at0006]/data[at0003]/items[at0004]/value/magnitude AS systolic,
    o/data[at0001]/events[at0006]/data[at0003]/items[at0005]/value/magnitude AS diastolic
from
    composition c
        contains observation o[openEHR-EHR-OBSERVATION.blood_pressure.v1]
"

url = "https://openEHR-server/openehr/v1" 
data <- openehR::query(url, query)

head(data)

# datetime			systolic		diastolic
# 1974-09-16T16:04:10.192+02:00	115.974085828937	76.9071249676342
# 2010-06-23T05:48:49.751+02:00	117.079215488876	72.4198362220667
# 2010-06-26T05:15:34.312+02:00	132.302621087754	73.1356662638138
# 2009-10-10T03:22:05.666+02:00	123.306499231151	76.388229647742
# 2010-07-07T00:21:22.182+02:00	128.873904091379	75.7725081884796
# 2010-10-17T05:50:07.97+02:00	112.089627114461	83.3618799992845

```

# Help
You can view the documentation and help pages by running `?openehR` in your R
interpreter.


