library(httr)
library(jsonlite)

aqlquery <- function(OpenEHRurl, query) {
  url = paste0(OpenEHRurl, "/openehr/v1/query/aql/")
  response <- POST(url = url, body = list(q = query), encode = "json")

  if(http_error(response)){
    return(response)
  } else {
    content <- content(response, as = "text")
    resultSet <- fromJSON(content)

    #Create data frame
    rows = resultSet$rows;
    columnNames = resultSet$columns$name
    dataframe <- as.data.frame(rows)
    colnames(dataframe) <- columnNames

    return(dataframe)
  }
}

