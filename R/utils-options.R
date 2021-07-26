# Modifications Copyright 2020 Justin Cally
# Copyright 2019 Province of British Columbia
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
#
# Modifications/State changes made to original work: 
# + Modified the options in vicmap_options() (from bcdc_options()) and changed their descriptions to be suited for the vicmap wfs
# + Added vicmap.base_url as an options
# + check_chunk_limit() rewritten for the vicmap WFS


#' options
#' 
#' @description 
#' This function retrieves bcdata specific options that can be set. These options can be set
#' using `option({name of the option} = {value of the option})`. The default options are purposefully
#' set conservatively to hopefully ensure successful requests. Resetting these options may result in
#' failed calls to the data catalogue. Options in R are reset every time R is re-started.
#'
#' `vicmap.max_geom_pred_size` is the maximum size of an object used for a geometric operation. Objects
#' that are bigger than this value will be simplified in the request call using sf::st_simplify().
#' This is done to reduce the size of the query being sent to the WFS geoserver.
#'
#' `vicmap.chunk_limit` is an option useful when dealing with very large data sets. When requesting large objects
#' from the catalogue, the request is broken up into smaller chunks which are then recombined after they've
#' been downloaded. VicmapR does this all for you but using this option you can set the size of the chunk
#' requested. On faster internet connections, a bigger chunk limit could be useful while on slower connections,
#' it is advisable to lower the chunk limit. Chunks must be less than 70000.
#' 
#' `vicmap.base_url` is the base wfs url used to query the geoserver.
#'
#' @return vicmap_options() returns a \code{data.frame}
#' @export
#' @examples 
#' vicmap_options()
vicmap_options <- function() {
  
  null_to_na <- function(x) {
    ifelse(is.null(x), NA, as.numeric(x))
  }
  
  dplyr::tribble(
    ~ option, ~ value, ~default,
    "vicmap.max_geom_pred_size", null_to_na(getOption("vicmap.max_geom_pred_size")), as.character(4400),
    "vicmap.chunk_limit",null_to_na(getOption("vicmap.chunk_limit")), as.character(1500),
    "vicmap.base_url", getOption("vicmap.base_url"), base_wfs_url
  )
}

#' check chunk limit
#' @rdname vicmap_options
check_chunk_limit <- function(){
  
  chunk_value <- options("vicmap.chunk_limit")$vicmap.chunk_limit
  
  if(!is.null(chunk_value) && chunk_value > 70000){
    stop(glue::glue("Your chunk value of {chunk_value} exceed the Vicmap Data Catalogue chunk limit"), call. = FALSE)
  }
}
