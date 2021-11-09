# Copyright 2019 Justin Cally
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
#' try(
#' listLayers(pattern = "trees", ignore.case = TRUE)
#' )
#' }

listLayers <- function(...) {
  
  if(!check_geoserver()) {
    return(NULL)
  }
  
  url <- httr::parse_url(getOption("vicmap.base_url", default = base_wfs_url))
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetCapabilities")
  
  request <- httr::build_url(url)
  response <- httr::GET(request)
  
  # stop if broken
  httr::stop_for_status(response)
  
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
