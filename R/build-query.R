#' vicmap_query
#'
#' @param layer 
#' @param CRS 
#' @param count 
#'
#' @return
#' @export
#'
#' @examples
vicmap_query <- function(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", CRS = 4283, count = getOption("vicmap.chunk_limit", default = 70000L)) {
  
  # Check if query exceeds vicmap limit 
  check_chunk_limit()
  
  url <- httr::parse_url("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs")
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetFeature",
                    typeNames = layer,
                    outputFormat = "application/json",
                    count = count,
                    srsName = paste0("EPSG:", CRS)) %>% purrr::discard(is.null)
  
  as.vicmap_promise(url)
  
}

#' show_query
#'
#' @param x 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
show_query.vicmap_promise <- function(x, ...) {
  
  request <- httr::build_url(x)
  
  return(request)
  
}

#' collect
#'
#' @param x 
#' @param quiet 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
collect.vicmap_promise <- function(x, quiet = FALSE, ...) {
  
  # check number of records
  number_of_records <- feature_hits(x)
  
  #paginate?
  if(number_of_records > x$query$count) {
    # number of times to loop
    loop_times <- ceiling(number_of_records/x$query$count)
    # inform user of delay
    if(!quiet) {
    message(paste0("There are ", number_of_records, " rows to be retrieved. This is more than the Vicmap chunk limit (70,000). The collection of data might take some time."))
    }
    # pick something to sort by
    cols <- feature_cols(x)
    sort_col <- ifelse("OBJECTID" %in% cols, "OBJECTID", cols[1])
    
    #set up list
    returned_sf <- list()
    
    #progress bar
    if(!quiet) {
    pb <- utils::txtProgressBar(min = 0, max = loop_times, initial = 0, width = 50, style = 3) 
    }
    
    for(i in 1:loop_times) {
      x$query$startIndex <- (i-1)*x$query$count
      x$query$sortBy <- sort_col 
      request <- httr::build_url(x)
      returned_sf[[i]] <- sf::read_sf(request, ...)
      
      # Update progress bar
      if(!quiet) {
        utils::setTxtProgressBar(pb,i)
      }
      
    }
    return(do.call("rbind", returned_sf))
     
  } else {
    # if less than only loop once
    request <- httr::build_url(x)
    return(sf::read_sf(request, ...))
  }
  
  
  
}

#' head
#'
#' @param x 
#' @param n 
#'
#' @return
#' @export
#'
#' @examples
head.vicmap_promise <- function(x, n = 5) {
  
  x$query$count <- n 
  
  return(x)
  
}


print.vicmap_promise <- function(x) {
  
  number_of_records <- feature_hits(x)
  
  if(number_of_records > 6) {
  x$query$count <- 6 
  }
  
  request <- httr::build_url(x)  
  
  sample_data <- sf::read_sf(request)
  
  fields <- length(sample_data)
  
  cli::cat_bullet(strwrap(glue::glue("Using {cli::col_blue('collect()')} on this object will return {cli::col_green(number_of_records)} features ",
                                "and {cli::col_green(fields)} fields")))
  cli::cat_bullet(strwrap("At most six rows of the record are printed here"))
  cli::cat_rule()
  print(sample_data)
  invisible(x)
  
}
