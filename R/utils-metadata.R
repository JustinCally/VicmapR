feature_hits <- function(x) {

  x$query$resultType <- "hits"
  
  request <- httr::build_url(x)
  response <- httr::GET(request)
  
  parsed <- httr::content(response, encoding = "UTF-8")
  
  n_hits <- as.numeric(xml2::xml_attrs(parsed)["numberMatched"])
  return(n_hits)
}

feature_cols <- function(x) {
  
  x$query$count <- 1

  
  request <- httr::build_url(x)
  response <- httr::GET(request)
  
  parsed <- httr::content(response, encoding = "UTF-8")
  return(parsed[["features"]][[1]][["properties"]]) %>% names()
}
