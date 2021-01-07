#' filter
#'
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param ... filter statements
#'
#' @return
#' @export
#'
#' @examples
filter.vicmap_promise <- function(x, ...) {
  
  current_cql = cql_translate(...)
  ## Change CQL query on the fly if geom is not GEOMETRY
  current_cql = specify_geom_name(x, current_cql)
  
  # Add cql filter statement to any existing cql filter statements.
  # ensure .data$query_list$CQL_FILTER is class sql even if NULL, so
  # dispatches on sql class and dbplyr::c.sql method is used
  x$query$CQL_FILTER <- c(dbplyr::sql(x$query_list$CQL_FILTER),
                                   current_cql,
                                   drop_null = TRUE)
  
  as.vicmap_promise(x)
}
