# Copyright 2020 Justin Cally
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
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

