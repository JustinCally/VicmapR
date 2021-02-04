#' List available WFS layers
#' @description Lists layers available from Vicmap
#'
#' @param ... Additional arguments passed to \link[stringr]{str_detect}. The `pattern` argument can be used to search for specific layers with matching names or titles. 
#'
#' @return data.frame
#' @export
#'
#' @examples
#' listLayers(pattern = stringr::regex("flood height contour", ignore_case = TRUE))

listLayers <- function(...) {
  url <- httr::parse_url("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs")
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
    df <- dplyr::filter_all(df, dplyr::any_vars(stringr::str_detect(string = ., ...)))
  }
  return(df)
}  
