#' vicmap_query
#'
#' @param layer vicmap layer to query. Options are listed in `VicmapR::listLayers()``
#' @param CRS Coordinate Reference System (default is 4283)
#' @param wfs_version The current version of WFS is 2.0.0. GeoServer supports versions 2.0.0, 1.1.0, and 1.0.0. However in order for filtering to be correctly applied wfs_version must be 2.0.0 (default is 2.0.0)
#'
#' @return
#' @export
#'
#' @examples
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN")
vicmap_query <- function(layer, CRS = 4283, wfs_version = "2.0.0") {
  
  # Check if query exceeds vicmap limit 
  check_chunk_limit()
  
  url <- httr::parse_url("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs")
  url$query <- list(service = "wfs",
                    version = wfs_version,
                    request = "GetFeature",
                    typeNames = layer,
                    outputFormat = "application/json",
                    count = getOption("vicmap.chunk_limit", default = 70000L),
                    maxFeatures = getOption("vicmap.chunk_limit", default = 70000L),
                    srsName = paste0("EPSG:", CRS))
  
  #maxFeatures or count depends on version
  
  if(url$query$version == "2.0.0") {
    url$query$maxFeatures <- NULL 
  } else {
    url$query$count <- NULL 
  }
  
  url$query <- purrr::discard(url$query, is.null)
  
  as.vicmap_promise(url)
  
}

#' show_query
#'
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#'
#' @return
#' @export
#'
#' @examples
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#' head(50) %>%
#' show_query()

show_query.vicmap_promise <- function(x, ...) {
  
  x$query$CQL_FILTER <- finalize_cql(x$query$CQL_FILTER)
  
  request <- httr::build_url(x)
  
  return(request)
  
}

#' collect
#'
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param quiet logical; whether to suppress the printing of messages and progress
#' @param paginate logical; whether to allow pagination of results to extract all records (default is TRUE)
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#' head(50) %>%
#' collect()
collect.vicmap_promise <- function(x, quiet = FALSE, paginate = TRUE, ...) {
  
  x$query$CQL_FILTER <- finalize_cql(x$query$CQL_FILTER)
  
  # check number of records
  number_of_records <- feature_hits(x)
  
  #get queried count
  if(x$query$version == "2.0.0") {
    the_count <- x$query$count
  } else {
    the_count <- x$query$maxFeatures 
  }
  
  #paginate?
  if(number_of_records > getOption("vicmap.chunk_limit", default = 70000L) & paginate == TRUE & the_count == getOption("vicmap.chunk_limit", default = 70000L)) {
    # number of times to loop
    loop_times <- ceiling(number_of_records/the_count)
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
      x$query$startIndex <- (i-1)*the_count
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
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param n number of rows to return
#'
#' @return
#' @export
#'
#' @examples
#' vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
#' head(50) %>%
#' collect()

head.vicmap_promise <- function(x, n = 5) {
  
  # Different names for versions
  
  if(x$query$version == "2.0.0") {
  x$query$count <- n 
  } else {
    x$query$maxFeatures <- n 
  }
  
  return(x)
  
}


#' print
#'
#' @param x object of class `vicmap_promise` (likely passed from [vicmap_query()])
#'
#' @return 
#' @export
#'
#' @examples
print.vicmap_promise <- function(x) {
  
  x$query$CQL_FILTER <- finalize_cql(x$query$CQL_FILTER)
  
  number_of_records <- feature_hits(x)
  
  if(number_of_records > 6) {
    if(x$query$version == "2.0.0") {
      x$query$count <- 6 
    } else {
      x$query$maxFeatures <- 6 
    }
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
