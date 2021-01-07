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

geom_col_name <- function(x) {
  
  x$query$count <- 1
  
  request <- httr::build_url(x)
  response <- httr::GET(request)
  
  parsed <- httr::content(response, encoding = "UTF-8")
  return(parsed[["features"]][[1]][["geometry_name"]])
  
}

specify_geom_name <- function(x, CQL_statement){
  # Find the geometry field and get the name of the field
  geom_col <- geom_col_name(x)
  
  # substitute the geometry column name into the CQL statement and add sql class
  dbplyr::sql(glue::glue(CQL_statement, geom_name = geom_col))
}
