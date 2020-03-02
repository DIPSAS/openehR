# ROpenEHR
ROpenEHR is a simple *openEHR* endpoint interface intended to make results of AQL queries against a chosen openEHR-endpoint available as data frame.

### Usage
To use ROpenEHR, simply install and import it to your R script.

**Example of usage:**
```
response <- aqlquery(OpenEHRUrl, aql)
```
The response from each query will be availabe as a data frame if the query is successful, otherwise the response will be the response object returned by the provided endpoint.
