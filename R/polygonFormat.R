# Copyright 2019 Justin Cally
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

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
