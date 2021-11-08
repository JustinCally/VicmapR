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
# + filter method renamed to filter.vicmap_promise()
# + warning added  
# + returned promise object is not a list: only 1 element (.data)


#' Filter Data
#'
#' See \code{dplyr::\link[dplyr]{filter}} for details.
#'
#' @name filter
#' @rdname filter
#' @keywords internal
#' @export
#' @importFrom dplyr filter
NULL

#' Filter Data
#'
#' @param .data object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param ... filter statements
#'
#' @describeIn filter filter.vicmap_promise
#' @return Object of class `vicmap_promise`, which is a 'promise' of the data that can  be returned if `collect()` is used
#' @export
#'
#' @examples
#' \donttest{
#' try(
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#'  filter(HIERARCHY == "L", PFI == 8553127)
#'  )
#'  }
filter.vicmap_promise <- function(.data, ...) {
  
  if(.data$query$version != "2.0.0") {
    warning("wfs_version is not 2.0.0. Filtering may not be correctly applied as certain CRS's requests require axis flips")
  }
  
  current_cql = cql_translate(...)
  ## Change CQL query on the fly if geom is not GEOMETRY
  current_cql = specify_geom_name(.data, current_cql)
  
  if(is.null(current_cql)) {
    return(NULL)
  }
  
  # Add cql filter statement to any existing cql filter statements.
  # ensure .data$query_list$CQL_FILTER is class sql even if NULL, so
  # dispatches on sql class and dbplyr::c.sql method is used
  .data$query$CQL_FILTER <- c(dbplyr::sql(.data$query$CQL_FILTER),
                                   current_cql,
                                   drop_null = TRUE)
  
  as.vicmap_promise(.data)
}
