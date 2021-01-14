#### Format Polygon ####
#' Simplify polygon
#'
#' @param shape 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
polygonFormat <- function(shape, ...) {
  
  UseMethod("polygonFormat", shape)
}

#' Simplify polygon
#'
#' @param shape 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
polygonFormat.sf <- function(shape, ...) {
  
  shape_crs <- sf::st_crs(shape)
  shape <- sf::st_union(shape) %>% sf::st_transform(3111)
  if(hasArg(dTolerance)) {
    tol <- dTolerance
  } else {
    perim <- sf::st_boundary(shape) %>% sf::st_length() 
    tol <- perim/10
  }
  shape %>%
    sf::st_simplify(dTolerance = tol) %>% 
    sf::st_transform(shape_crs) 
}
