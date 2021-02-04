#' Simplify polygon
#'
#' @param shape sf
#' @param ... Additional arguments to be passed to formatting
#'
#' @return
#' @noRd
polygonFormat <- function(shape, ...) {
  
  shape_crs <- sf::st_crs(shape)
  shape <- sf::st_union(shape) %>% sf::st_transform(3111)
  if(hasArg(dTolerance)) {
    tol <- dTolerance
  } else {
    if(sf::st_geometry_type(shape) %in% c("POLYGON", "MULTIPOLYGON")) {
      line <- sf::st_boundary(shape)
    } else {
      line <- shape
    }
    perim <- line %>% sf::st_length() 
    tol <- perim/500
  }
  shape %>%
    sf::st_simplify(dTolerance = tol) %>% 
    sf::st_transform(shape_crs) 
}
