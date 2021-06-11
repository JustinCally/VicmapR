#' Check Geoserver Response  
#' 
#' @description VicmapR relies upon a functioning geoserver. If for whatever reason the geoserver is not functioning then the functions 
#' in this package will not work. This function will check the response of the geoserver; erroring out if the connection is down. 
#'
#' @param timeout numeric: the time (in seconds) to wait for the response before timing out (default is 10)
#' @param quiet logical: whether to silently check the connection and if working, return nothing. If `FALSE` (default), 
#' the status message will be printed (\link[httr]{http_status})
#'
#' @return character (if successful), error message if geoserver is not working 
#' @export
#'
#' @examples
#' \donttest{
#' check_geoserver()
#' }
check_geoserver <- function(timeout = 10, quiet = FALSE) {
  
  check_internet()
  
  # Get response or timeout
  response <- httr::GET(paste0(base_wfs_url, "?request=getCapabilities"), httr::timeout(timeout))
  
  httr::stop_for_status(response)
  
  message <- httr::http_status(response)$message
  
  if(quiet) {
   return(invisible(message)) 
  } else {
  return(message)
  }
  
}


#' Check internet connection
#' @noRd
check_internet <- function(){

  if(!curl::has_internet()) {
    stop("Please check your internet connection")
  }
}

