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