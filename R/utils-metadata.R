#' number of rows
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
feature_hits <- function(x) {

  x$query$resultType <- "hits"
  x$query$outputFormat <- "text/xml"
  x$query$version <- "2.0.0"
  
  request <- httr::build_url(x)
  response <- httr::GET(request)
  
  parsed <- httr::content(response, encoding = "UTF-8")
  
  n_hits <- as.numeric(xml2::xml_attrs(parsed)["numberMatched"])
  return(n_hits)
}

#' feature column names
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
feature_cols <- function(x) {
  
  return(get_col_df(x)$name)

}

#' geom column name
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
geom_col_name <- function(x) {
  
  geom_col <- get_col_df(x) %>% 
    dplyr::filter(stringr::str_detect(string = type, pattern = "gml:")) %>%
    dplyr::pull(name)
  
  return(geom_col)
  
}

#' apply cql to geom
#'
#' @param x 
#' @param CQL_statement 
#'
#' @return
#' @export
#'
#' @examples
specify_geom_name <- function(x, CQL_statement){
  # Find the geometry field and get the name of the field
  geom_col <- geom_col_name(x)
  
  # substitute the geometry column name into the CQL statement and add sql class
  dbplyr::sql(glue::glue(CQL_statement, geom_name = geom_col))
}

#' return df of column names and types 
#'
#' @param x 
#'
#' @return
#' @export
#'
#' @examples
get_col_df <- function(x) {
  
  layer <- x$query$version
  r <- httr::GET(paste0("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/", x$query$typeNames, "/wfs?service=wfs&version=", x$query$version, "&request=DescribeFeatureType"))
  c <- httr::content(r, encoding = "UTF-8", type="text/xml") 
  
  list <- xml2::xml_child(xml2::xml_child(xml2::xml_child(xml2::xml_child(c, "xsd:complexType"), 
                                      "xsd:complexContent"), 
                            "xsd:extension"), 
                  "xsd:sequence") %>% 
    xml2::as_list()
  
  data <- data.frame(name = sapply(list, function(x) attr(x, "name")),
                     type = sapply(list, function(x) attr(x, "type")), stringsAsFactors = F)

  return(data)
}


