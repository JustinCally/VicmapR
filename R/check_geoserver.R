# Copyright 2020 Justin Cally
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.
#' Check Geoserver Response  
#' 
#' @description VicmapR relies upon a functioning geoserver. If for whatever reason the geoserver is not functioning then the functions 
#' in this package will not work. This function will check the response of the geoserver; erroring out if the connection is down. 
#'
#' @param timeout numeric: the time (in seconds) to wait for the response before timing out (default is 15)
#' @param quiet logical: whether to silently check the connection and if working, return nothing. If `FALSE` (default), 
#' the status message will be printed (\link[httr]{http_status})
#'
#' @return logical, TRUE if the geoserver is working
#' @export
#'
#' @examples
#' \donttest{
#' check_geoserver()
#' }
check_geoserver <- function(timeout = 15, quiet = FALSE) {
  
  if(!curl::has_internet()) {
    message <- list(success = FALSE, 
                    reason = "No Internet. Please check your internet connection")
  } else{
  # Get response or timeout
  message <- tryCatch({
    # Get response
    response <- httr::GET(paste0(base_wfs_url), httr::timeout(timeout))
    # Check failure
    if(httr::http_error(response)) {
      returned_list <- list(success = FALSE, 
                            reason = httr::http_status(response)$message) 
    } else { # Get success message
    returned_list <- list(success = TRUE, 
                          reason = httr::http_status(response)$message) 
    } # return list
    returned_list
    
  }, error = function(e) {
    list(success = FALSE, 
         reason = e)
  })
  }
  
  if(quiet) {
   return(message[["success"]]) 
  } else {
    if(!message[["success"]]) {
    message(message[["reason"]])
    }
  return(message[["success"]])
  }
  
}


#' Check internet connection
#' @noRd
check_internet <- function(){

  if(!curl::has_internet()) {
    message("No Internet. Please check your internet connection")
    return(FALSE)
  } else {
    return(TRUE)
  }
}

