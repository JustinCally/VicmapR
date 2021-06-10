#' List Available WFS Layers
#' @description Lists layers available from the WFS geoserver. This is similar to sending the 
#' WFS request of `getFeatureTypes`. `listLayers()` returns a data.frame with the 'Name' and title of the
#' layers available. The 'Name' is what is used within `vicmap_query()` while the title provides somewhat of a 
#' description/clarification about the layer.
#'
#' @param ... Additional arguments passed to \link[base]{grep}. The `pattern` argument can be used to search for specific layers with matching names or titles. 
#'
#' @return data.frame
#' @export
#'
#' @examples
#' \donttest{
#' listLayers(pattern = "trees", ignore.case = TRUE)
#' }

listLayers <- function(...) {
  url <- httr::parse_url(getOption("vicmap.base_url", default = base_wfs_url))
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetCapabilities")
  
  request <- httr::build_url(url)
  response <- httr::GET(request)
  
  parsed <- httr::content(response, encoding = "UTF-8") %>% xml2::xml_child(4)
  attr_list <- xml2::as_list(parsed)
  
  df <- lapply(attr_list, function(x) {
    data.frame(x[["Name"]], x[["Title"]], stringsAsFactors = F) %>% `colnames<-`(c("Name", "Title"))
  }) %>% dplyr::bind_rows()
  
  if(methods::hasArg('pattern')){
    df <- dplyr::filter_all(df, dplyr::any_vars(grepl(x = ., ...)))
  }
  return(df)
}  
