#' options
#' 
#' @description 
#' #' This function retrieves bcdata specific options that can be set. These options can be set
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
#' @return data.frame
#' @export
vicmap_options <- function() {
  
  null_to_na <- function(x) {
    ifelse(is.null(x), NA, as.numeric(x))
  }
  
  dplyr::tribble(
    ~ option, ~ value, ~default,
    "vicmap.max_geom_pred_size", null_to_na(getOption("vicmap.max_geom_pred_size")), as.character(4400),
    "vicmap.chunk_limit",null_to_na(getOption("vicmap.chunk_limit")), as.character(70000),
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

