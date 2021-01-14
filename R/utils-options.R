#' options
#'
#' @return
#' @export
#'
#' @examples
vicmap_options <- function() {
  
  null_to_na <- function(x) {
    ifelse(is.null(x), NA, as.numeric(x))
  }
  
  dplyr::tribble(
    ~ option, ~ value, ~default,
    "vicmap.chunk_limit",null_to_na(getOption("vicmap.chunk_limit")), 70000
  )
}

#' check chunk limit
#'
#' @return
#' @export
#'
#' @examples
check_chunk_limit <- function(){
  
  chunk_value <- options("vicmap.chunk_limit")$vicmap.chunk_limit
  
  if(!is.null(chunk_value) && chunk_value > 70000){
    stop(glue::glue("Your chunk value of {chunk_value} exceed the Vicmap Data Catalogue chunk limit"), call. = FALSE)
  }
}

