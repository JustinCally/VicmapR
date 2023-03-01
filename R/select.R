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
# Modifications/state changes made to the original work: 
# + modified the select.vicmap_promise() function (e.g. removed the remove_id_col and wrote a similar line of code)
# + property name element combined with previous values slightly differently


#' Select Columns 
#'
#' See \code{dplyr::\link[dplyr]{select}} for details.
#'
#' @name select
#' @rdname select
#' @keywords internal
#' @export
#' @importFrom dplyr select
NULL

#' Select Columns  
#'
#' @param .data object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param ... Other parameters possibly used by generic
#'
#' @describeIn select select.vicmap_promise
#' @return Object of class `vicmap_promise`, which is a 'promise' of the data that can  be returned if `collect()` is used
#' @export
#'
#' @examples
#' \donttest{
#' try(
#' vicmap_query(layer = "open-data-platform:hy_watercourse") %>%
#'  select(hierarchy,  pfi)
#' )
#' }
select.vicmap_promise <- function(.data, ...){
  
  ## Eventually have to migrate to tidyselect::eval_select
  ## https://community.rstudio.com/t/evaluating-using-rlang-when-supplying-a-vector/44693/10
  cols_to_select <- c(.data$query$propertyName, rlang::exprs(...)) %>% as.character()
  
  if(.data$converted) {
    #convert to lowercase if it is a coverted layer
    cols_to_select <- tolower(cols_to_select)
  }
  
  ## id is always added in. web request doesn't like asking for it twice
  cols_to_select <- setdiff(cols_to_select, "id")
  ## Always add back in the geom
  .data$query$propertyName <- paste(geom_col_name(.data), paste0(cols_to_select, collapse = ","), sep = ",")
  
  as.vicmap_promise(.data)
  
}
