vicmap_query <- function(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", CRS = 4283, count = getOption("vicmap.chunk_limit", default = 70000L)) {
  
  # Check if query exceeds vicmap limit 
  check_chunk_limit()
  
  url <- httr::parse_url("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs")
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetFeature",
                    typename = layer,
                    outputFormat = "application/json",
                    count = count,
                    srsName = paste0("EPSG:", CRS)) %>% purrr::discard(is.null)
  
  as.vicmap_promise(url)
  
}

show_query.vicmap_promise <- function(x, ...) {
  
  request <- httr::build_url(x)
  
  return(request)
  
}

collect.vicmap_promise <- function(x, ...) {
  
  request <- httr::build_url(x)
  
  return(sf::read_sf(request, ...))
  
}

head.vicmap_promise <- function(x, n = 5) {
  
  x$query$count <- n 
  
  return(x)
  
}


print.vicmap_promise <- function(x) {
  
  x$query$count <- 6 
  
  number_of_records <- feature_hits(x)
  
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
