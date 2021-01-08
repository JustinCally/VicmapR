#### Format Polygon ####
polygonFormat <- function(shape, ...) {
  UseMethod("polygonFormat", shape)
}

polygonFormat.sf <- function(shape, ...) {
  shape_crs <- sf::st_crs(shape)
  shape <- sf::st_union(shape) %>% sf::st_transform(3111)
  if(hasArg(dTolerance)) {
    tol <- dTolerance
  } else {
    perim <- sf::st_boundary(shape) %>% sf::st_length() 
    tol <- perim/100
  }
    shape %>%
    sf::st_simplify(dTolerance = tol) %>% 
    sf::st_transform(shape_crs) %>%
    sf::st_as_text()
}
  
filterGeo <- function(Client, method, shape = NULL, add_args = NULL) {
  
  Client2 <- Client$clone()

  if(length(add_args) > 0) {
  args <- paste(paste0(", ", add_args), collapse = "")
  } else {
    args <- ""
  }
  
  if(is.null(Client2$selectLayer)) {
    stop(paste0("No layer has been selected from ", 
                deparse(substitute(Client)), 
                ". Select layer using selectWFS"))
  }
  
  if(is.null(Client2$geomField)) {
    # Name of spatial field
    Client2$geomField <- Client2$
      getCapabilities()$
      findFeatureTypeByName(Client2$selectLayer)$
      getDescription(pretty = TRUE) %>%
      dplyr::filter(type == "geometry") %>%
      dplyr::pull(name) 
  } 
  
  if(method == "bbox") {
    add_filter <- paste0(method, "(", Client2$geomField, args, ")")
  } else {
  add_filter <- paste0(method, "(", Client2$geomField, ", ", polygonFormat(shape), args, ")")
  }
  
  if(is.null(Client2$filter)) {
    Client2$filter <- add_filter
  } else{
    Client2$filter <- paste(Client2$filter, "AND", add_filter)
  }
  return(Client2)
}


#### Exported functions ####

disjoint <- function(Client, shape, ...) {
  filterGeo(Client, "DISJOINT", shape , ...)
}

intersects <- function(Client, shape, ...) {
  filterGeo(Client, "intersects", shape , ...)
}

equals <- function(Client, shape, ...) {
  filterGeo(Client, "equals", shape , ...)
}

touches <- function(Client, shape, ...) {
  filterGeo(Client, "touches", shape , ...)
}

crosses <- function(Client, shape, ...) {
  filterGeo(Client, "crosses", shape , ...)
}

within <- function(Client, shape, ...) {
  filterGeo(Client, "within", shape , ...)
}

contains <- function(Client, shape, ...) {
  filterGeo(Client, "contains", shape , ...)
}

overlaps <- function(Client, shape, ...) {
  filterGeo(Client, "overlaps", shape , ...)
}

relate <- function(Client, shape, pattern) {
  ... <- pattern
  filterGeo(Client, "overlaps", shape , ...)
}

dwithin <- function(Client, shape, distance, units) { # units is one of feet, meters, statute miles, nautical miles, kilometers
  ... <- c(distance, units)
  filterGeo(Client, "dwithin", shape , ...)
}

beyond <- function(Client, shape, distance, units) { # units is one of feet, meters, statute miles, nautical miles, kilometers
  ... <- c(distance, units)
  filterGeo(Client, "beyond", shape , ...)
}

bbox <- function(Client, xmin, ymin, xmax, ymax) { 
  add_args <- c(xmin, ymin, xmax, ymax)
  filterGeo(Client, "bbox", add_args = add_args)
}

#### filter ####

filterWFS <- function(Client, ...) {
  UseMethod("filterWFS", Client)
}

filterWFS.OWSClient <- function(Client, ...) {
  add_filter <- dbplyr::translate_sql(..., )
  add_filter <- gsub(pattern = "`", replacement = "", x = add_filter, )
  if(is.null(Client$filter)) {
    Client$filter <- add_filter
  } else{
    Client$filter <- paste(Client$filter, "AND", add_filter)
  }
  return(Client)
}

#### functions to export ####
# selectWFS
# filterWFS
# geom filters
# buildQuery

#  VicmapClient <- newClient()
#  melbourne <- st_read(system.file("shapes/melbourne.geojson", package="VicmapR"))
# test <- VicmapClient %>%
#   selectWFS("datavic:VMTRANS_TR_ROAD") %>%
#   filterWFS(CLASS_CODE < 6 & ROAD_TYPE %in% c("STREET", "CRESCENT")) %>%
#   #bbox(xmin = 144.25, ymin = -38.44, xmax = 144.50, ymax = -38.25) %>%
#   intersects(shape = melbourne) %>%
#   buildQuery() %>%
#   sf::read_sf(as_tibble = T)
# 
# plot(test["CLASS_CODE"], key.pos = 1, axes = TRUE, key.width = lcm(1.3), key.length = 1.0)

