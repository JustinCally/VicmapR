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
# + as.vicmap_promise() adapted from as.bcdc_promise()

#' vicmap promise
#'
#' @param res httr query object
#'
#' @return object of class `vicmap_promise`
#' @noRd
as.vicmap_promise <- function(res) {
  
  structure(res,
            class = c("vicmap_promise", setdiff(class(res), "vicmap_promise"))
  )
}

# collapse vector of cql statements into one
#' finalize cql
#'
#' @param x cql filter list from the query of an object of class `vicmap_promise`
#' @param con dummy wfs connection (wfs_con)
#'
#' @return cql character string
#' @noRd
finalize_cql <- function(x, con = wfs_con) {
  
  if (is.null(x) || !length(x)) return(NULL)
  dbplyr::sql_vector(x, collapse = " AND ", con = con)
}
