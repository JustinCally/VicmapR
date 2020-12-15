vicmap_query <- function(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", CRS = 4283) {
  url <- httr::parse_url("http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs")
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetFeature",
                    typename = layer,
                    outputFormat = "application/json",
                    srsName = paste0("EPSG:", CRS),
                    count = 6) %>% purrr::discard(is.null)
  
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
  
  request <- httr::build_url(x)  
  
  sample_data <- sf::read_sf(request)
  
  print(sample_data)
  
}
