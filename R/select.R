#' select
#'
#' See \code{dplyr::\link[dplyr]{select}} for details.
#'
#' @name select
#' @rdname select
#' @keywords internal
#' @export
#' @importFrom dplyr select
NULL

#' select
#'
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param ... 
#'
#' @return object of class `vicmap_promise`
#' @export
#'
#' @examples
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#' select(HIERARCHY, PFI)
select.vicmap_promise <- function(x, ...){
  
  ## Eventually have to migrate to tidyselect::eval_select
  ## https://community.rstudio.com/t/evaluating-using-rlang-when-supplying-a-vector/44693/10
  cols_to_select <- c(x$query$propertyName, rlang::exprs(...)) %>% as.character()
  
  ## id is always added in. web request doesn't like asking for it twice
  cols_to_select <- setdiff(cols_to_select, "id")
  ## Always add back in the geom
  x$query$propertyName <- paste(geom_col_name(x), paste0(cols_to_select, collapse = ","), sep = ",")
  
  as.vicmap_promise(x)
  
}