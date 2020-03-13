library(httr)
library(jsonlite)

query <- function(url, query, config = list()) {
  if(!endsWith(url, "/")) {
    url = paste0(url, "/")
  }

  url = paste0(url, "query/aql/")

  response <- POST(url = url, body = list(q = query), encode = "json", config = config)

  if(http_error(response)){
    return(response)
  } else {
    content <- content(response, as = "raw")

    if (content[1]==as.raw(0xef) & content[2]==as.raw(0xbb) & content[3]==as.raw(0xbf)) {
      content = rawToChar(content[-(1:3)])
    } else {
      content = rawToChar(content)
    }

    resultSet <- fromJSON(content)

    #Create data frame
    rows = resultSet$rows;
    columnNames = resultSet$columns$name
    dataframe <- as.data.frame(rows)
    colnames(dataframe) <- columnNames

    return(dataframe)
  }
}

