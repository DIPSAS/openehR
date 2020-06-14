query <- function(url, query, config = list()) {
  if (!endsWith(url, "/")) {
    url = paste0(url, "/")
  }

  url = paste0(url, "query/aql")

  response <- httr::POST(
    url = url,
    body = list(q = query),
    encode = "json",
    config = config
  )

  if (http_error(response)) {
    stop(
      paste0(
        "Could not execute query. HTTP ",
        response$status_code,
        "Response:\n",
        httr::content(response)
      )
    )
    return(response)
  } else {
    content <- httr::content(response, as = "raw")

    # Strip away UTF-8 BOM in response if present
    if (content[1] == as.raw(0xef)
        && content[2] == as.raw(0xbb)
        && content[3] == as.raw(0xbf)) {
      content = rawToChar(content[-(1:3)])
    } else {
      content = rawToChar(content)
    }

    # Parse resultset json
    resultSet <- jsonlite::fromJSON(content)

    # Create data frame and use the correct column names from the response
    rows = resultSet$rows
    columnNames = resultSet$columns$name
    dataframe <- as.data.frame(rows)

    # ResultSet could have 0 rows and the dataframe would be empty. Only assign
    # column names if the resultset contains any data.
    if (ncol(dataframe) > 0) {
      colnames(dataframe) <- columnNames
    }

    return(dataframe)
  }

}
