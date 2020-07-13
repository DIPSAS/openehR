#' Execute an AQL query on the specified openEHR server.
#'@export
#'@param url The url of the openEHR server including the openEHR REST API
#'  endpoint
#'@param query The AQL query. Newlines and unnecessary whitespaces are stripped
#'  from the query before posting on an openEHR server.
#'@param config Optional config to the `httr` package.  (optional)
#'@param ... additional configuration settings
#'@return the result from the executed query
#'@examples
#'\dontrun{
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5")
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5",
#'      httr::add_headers(c("name" = "value")))
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5",
#'      httr::set_cookies(c(a = 1)))
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5",
#'      httr::authenticate("username", "password"))
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5",
#'      httr::add_headers(c("name" = "value")),
#'      httr::authenticate("username", "password"))
#'query("http://localhost:8080/openehr/v1",
#'      "select c/name/value from composition c limit 5",
#'      httr::verbose())
#'}
query <-
  function(url,
           query,
           config = list(),
           ...) {

    if (!endsWith(url, "/")) {
      url = paste0(url, "/")
    }

    # Remove any newlines
    stripped_query = stringr::str_replace_all(query, "\n", " ")

    # Remove any unnecessary whitespaces
    stripped_query = stringr::str_squish(stripped_query)

    url = paste0(url, "query/aql")

    response <-
      httr::POST(
        url = url,
        body = list(q = stripped_query),
        encode = "json",
        config = config,
        ...
      )

    if (httr::http_error(response)) {
      stop(
        paste0(
          "Could not execute query. HTTP ",
          response$status_code,
          " Response:\n",
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


#' openehR: A package for retrieving data from an openEHR server using the openEHR REST API.
#'
#' `openehR` is an R package for retrieving data from an openEHR server using the
#' \href{https://specifications.openehr.org/releases/ITS-REST/Release-1.0.1/}{openEHR REST API}.
#'
#' @section Available functions:
#'
#' The available functions are:
#' \itemize{
#' \item{\code{\link{query}}}
#' }
#'
#' @docType package
#' @name openehR
NULL
