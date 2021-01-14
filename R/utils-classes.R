#' vicmap promise
#'
#' @param res 
#'
#' @return
#' @export
#'
#' @examples
as.vicmap_promise <- function(res) {
  
  structure(res,
            class = c("vicmap_promise", setdiff(class(res), "vicmap_promise"))
  )
}

# collapse vector of cql statements into one
#' finalize cql
#'
#' @param x 
#' @param con 
#'
#' @return
#' @export
#'
#' @examples
finalize_cql <- function(x, con = wfs_con) {
  
  if (is.null(x) || !length(x)) return(NULL)
  dbplyr::sql_vector(x, collapse = " AND ", con = con)
}