#' Simplify polygon
#'
#' @param shape sf
#' @param dTol dTolerance for `sf::st_simplify()``
#'
#' @return sf
#' @noRd
polygonFormat <- function(shape, dTol) {
  
  shape_crs <- sf::st_crs(shape)
  shape <- sf::st_union(shape) %>% sf::st_transform(3111)
  if(hasArg(dTol)) {
    tol <- dTol
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
