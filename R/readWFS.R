
#' Formats boundbox for WFS query
#' @description Convenience function that formats a spatial bounding box into a character string that can be passed to the WFS query. 
#' The function accepts either a `bbox` from \link[sf]{st_bbox} or the coordinates for the box edges (`xmin`, `ymin`, `xmax`, `ymax`).
#'
#' @param xmin numeric; minimum x coordinate (longitude)
#' @param ymin numeric; minimum y coordinate (latitude)
#' @param xmax numeric; maximum x coordinate (longitude)
#' @param ymax numeric; maximum y coordinate (latitude)
#' @param st_bbox bbox; object generated using \link[sf]{st_bbox}
#'
#' @return character string formatted for WFS query and use in \link[VicmapR]{read_layer_sf}
#' @export
#'
#' @examples
#' #### Using an sf object ####
#' sf_data <- sf::st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' boundbox(st_bbox = sf::st_bbox(sf_data))
#' 
#' #### Using coordinates ####
#' boundbox(xmin = 144.05, ymin = -38.44, xmax = 144.50, ymax = -38.10)
boundbox <- function(xmin, ymin, xmax, ymax, st_bbox = NULL) {
  
  if(!is.null(st_bbox)) {
    if(class(st_bbox) != "bbox") {
      stop("st_bbox is not of class 'bbox'. Use sf::st_bbox to generate a valid bbox")
    }
    box <- paste(st_bbox, collapse = ",")
  } else {
    box <- paste(c(xmin, ymin, xmax, ymax), collapse = ",")
  }
  return(box)
}




#' Read Vicmap WFS layer as sf 
#' @description Reads in a Vicmap layer as an \link[sf]{sf}. Filters can be made using a bounding box or with additional CQL filtering statements.  
#'
#' @param layer_name character; name of Vicmap layer/feature to read in.
#' @param filter character; \strong{optional} CQL filter statement. See \link[https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html]{CQL tutorial} for more information. 
#' @param boundbox character; \strong{optional} string of coordinates to restrict query within. Can be generated using the \link[VicmapR]{boundbox} function or formatted as a character string following: `"xmin,ymin,xmax,ymax"`.
#' @param CRS numeric; coordinate reference system for query (default is 4283).
#' @param Client Object of \link[R6]{R6Class}; Vicmap client generated with \link[VicmapR]{newClient}. Mandatory when using a boundbox; however default is \link[VicmapR]{newClient}
#' @param ... Additional arguments passed to \link[sf]{read_sf} (e.g. `quiet` and `as_tibble`).
#'
#' @return sf/data.frame/tibble
#' @export
#'
#' @examples
#' VicmapClient <- newClient()
#' data <- read_layer_sf(layer_name = "datavic:VMHYDRO_WATERCOURSE_DRAIN", 
#'                       boundbox = boundbox(xmin = 144.25, 
#'                                           ymin = -38.44, 
#'                                           xmax = 144.50, 
#'                                           ymax = -38.25), 
#'                       filter = "HIERARCHY = 'L'", 
#'                       Client = VicmapClient)

read_layer_sf <- function(layer_name, 
                          filter = NULL, 
                          boundbox = NULL, 
                          CRS = 4283,
                          Client = newClient(), ...) {
  
  if(!is.null(boundbox)) {
    
    # Get geometry column
    geom_field <- Client$
      getCapabilities()$
      findFeatureTypeByName(layer_name)$
      getDescription(pretty = TRUE) %>%
      dplyr::filter(type == "geometry") %>%
      dplyr::pull(name)  
    
    # Format CQL filter 
    bbox_format <- paste0("bbox(", geom_field, ",", boundbox, ")")
    filter <- paste(c(bbox_format, filter), collapse = " AND ")
  }
  
  # Set up URL query and request
  url <- httr::parse_url(wfs_url)
  url$query <- list(service = "wfs",
                    version = "1.0.0",
                    request = "GetFeature",
                    typename = layer_name,
                    outputFormat = "application/json",
                    srsName = paste0("EPSG:", CRS),
                    CQL_FILTER = filter) %>% purrr::discard(is.null)
  
  request <- httr::build_url(url)
  
  # Return an sf object
  return(sf::read_sf(request, ...))
  
}