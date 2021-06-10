#' The Number of Rows of the Promised Data
#' 
#' @description `feature_hits()` returns an integer of the number of rows that match the passed query/promise. 
#' This is similar to how `nrow()` works for a data.frame, however it will evaluate the number of rows to be returned
#' without having to download the data. 
#'
#' @param x object of class `vicmap_promise`
#'
#' @return integer
#' @export
#'
#' @examples
#' \donttest{
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#'  feature_hits()
#'  }
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

#' Get Column Information
#' @description `geom_col_name` returns a single value for the name of the geometry column for the 
#' WFS layer selected in the `vicmap_promise` object (e.g. `SHAPE`). This column will become the `geometry` column 
#' when using `collect()`. `feature_cols()` provides a vector of all column names for the WFS layer selected in the 
#' `vicmap_promise` object and  `get_col_df()` returns a data.frame with the column names and their XML schema string 
#' datatypes.
#'
#' @param x object of class `vicmap_promise`
#'
#' @return character/data.frame
#' @export
#'
#' @examples
#' \donttest{
#' # Return the name of the geometry column
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
#'   geom_col_name()
#'  }
geom_col_name <- function(x) {
  
  geom_col <- get_col_df(x) %>% 
    dplyr::filter(grepl(x = type, pattern = "gml:")) %>%
    dplyr::pull(name)
  
  return(geom_col)
  
}

#' feature column names
#' @rdname geom_col_name
#' @export
#' @examples
#' \donttest{
#' # Return the column names as a character vector
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
#'   feature_cols()
#' }   
feature_cols <- function(x) {
  
  return(get_col_df(x)$name)
  
}

#' apply cql to geom
#'
#' @param x object of class `vicmap_promise` 
#' @param CQL_statement CQL filter statement
#' @noRd
specify_geom_name <- function(x, CQL_statement){
  # Find the geometry field and get the name of the field
  geom_col <- geom_col_name(x)
  
  # substitute the geometry column name into the CQL statement and add sql class
  dbplyr::sql(glue::glue(CQL_statement, geom_name = geom_col))
}

#' @rdname geom_col_name  
#' @export
#' @examples
#' \donttest{
#' # Return a data.frame of the columns and their XML schema string datatypes
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
#'   get_col_df()
#'  }
get_col_df <- function(x) {
  
  layer <- x$query$version
  base_url_n_wfs <- substr(getOption("vicmap.base_url", default = base_wfs_url), start = 0, stop = nchar(getOption("vicmap.base_url", default = base_wfs_url)) - 3)
  
  r <- httr::GET(paste0(base_url_n_wfs, x$query$typeNames, "/wfs?service=wfs&version=", x$query$version, "&request=DescribeFeatureType"))
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


