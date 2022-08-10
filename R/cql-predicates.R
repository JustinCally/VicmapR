# Modifications Copyright 2020 Justin Cally
# Copyright 2019 Province of British Columbia
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
#
# Modifications/state changes made to the original work: 
#   + sf_text() function modified to format the sf differently (using polygonFormat()) and checks GDAL version
#   + vicmap_cql_string() renamed from bcdc_cql_string()
#   + cql_geom_predicate_list remains the same


#' CQL escaping
#'
#' Write a CQL expression to escape its inputs, and return a CQL/SQL object.
#' Used when writing filter expressions in [vicmap_query()].
#'
#' See [the CQL/ECQL for Geoserver website](https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html).
#'
#' @param ... Character vectors that will be combined into a single CQL statement.
#'
#' @return An object of class `c("CQL", "SQL")`
#' 
#' @details The code for cql escaping was developed by the bcdata team: \url{https://bcgov.github.io/bcdata/reference/cql_geom_predicates.html}
#'
#' @export
#'
#' @examples
#' CQL("FOO > 12 & NAME LIKE 'A&'")
CQL <- function(...) {
  sql <- dbplyr::sql(...)
  structure(sql, class = c("CQL", class(sql)))
}

#' Create CQL filter strings from sf objects
#'
#' Convenience wrapper to convert sf objects and geometric operations into CQL
#' filter strings which can then be supplied to filter.vicmap_promise.
#' The sf object is simplified in complexity to reduce 
#' the complexity of the Web Service call. Subsequent in-memory
#' filtering may be need to achieve exact results.
#'
#'
#' @param x object of class sf, sfc or sfg
#' @param geometry_predicates Geometry predicates that allow for spatial filtering.
#' bcbdc_cql_string accepts the following geometric predicates: EQUALS,
#' DISJOINT, INTERSECTS, TOUCHES, CROSSES,  WITHIN, CONTAINS, OVERLAPS,
#' DWITHIN, BBOX.
#'
#' @seealso cql_geom_predicates
#' @noRd
vicmap_cql_string <- function(x, geometry_predicates, pattern = NULL,
                            distance = NULL, units = NULL,
                            coords = NULL, crs = NULL){
  
  if (inherits(x, "sql")) {
    stop(glue::glue("object {as.character(x)} not found.\n The object passed to {geometry_predicates} needs to be valid sf object."),
         call. = FALSE)
  }
  
  if (inherits(x, "vicmap_promise")) {
    stop("To use spatial operators, you need to use collect() to retrieve the object used to filter",
         call. = FALSE)
  }
  
  match.arg(geometry_predicates, cql_geom_predicate_list())
  
  # Only convert x to bbox if not using BBOX CQL function
  # because it doesn't take a geom
  if (!geometry_predicates == "BBOX") {
    x <- sf_text(x)
  }
  
  cql_args <-
    if (geometry_predicates == "BBOX") {
      paste0(
        paste0(coords, collapse = ", "),
        if (!is.null(crs)) paste0(", '", crs, "'")
      )
    } else if (geometry_predicates %in% c("DWITHIN", "BEYOND")) {
      paste0(x, ", ", distance, ", ", units, "")
    } else if (geometry_predicates == "RELATE") {
      paste0(x, ", ", pattern)
    } else {
      x
    }
  
  CQL(paste0(geometry_predicates,"({geom_name}, ", cql_args, ")"))
}

## Geometry Predicates

cql_geom_predicate_list <- function() {
  c("EQUALS","DISJOINT","INTERSECTS",
    "TOUCHES", "CROSSES", "WITHIN",
    "CONTAINS","OVERLAPS", "RELATE",
    "DWITHIN", "BEYOND", "BBOX")
}

#' axisorder
#'
#'
#' @return character string
#'
#' @noRd
axisorder <- function(x) {
  # check axis order against standard
p <- sf::st_read(system.file("shapes/melbourne.geojson", package="VicmapR"), quiet = TRUE) %>% 
    sf::st_union() %>%
    sf::st_centroid() %>%
    sf::st_as_text()

if(p == "POINT (144.9436 -37.81073)") {
  return("1,2")
} else {
  return("2,1")
}
}

#' Sf as text
#'
#' @param x sf object
#'
#' @return character string
#'
#' @noRd
sf_text <- function(x) {
  
  if (!inherits(x, c("sf", "sfc", "sfg", "bbox"))) {
    stop(paste(deparse(substitute(x)), "is not a valid sf object"),
         call. = FALSE)
  }
  
  ## If too big here, simplify
  if (utils::object.size(x) > getOption("vicmap.max_geom_pred_size", 4400)) {
    # Message was annoying
    # message("The object is too large to perform exact spatial operations using VicmapR. 
    #         To simplify the polygon, sf::st_simplify() was used to reduce the size of the query")
    x <- polygonFormat(x) %>%
      sf::st_transform(4283) # lat/long format
  }
  
  if (inherits(x, "bbox")) {
    x <- sf::st_as_sfc(x)
  } else {
    x <- sf::st_union(x)
  }
  
  if (sf::sf_extSoftVersion()["GDAL"] >= "3.0.0") {
    ## Flip axis for certain crs's using GDAL 3 ##
    ao <- sf::st_axis_order()
    sf::st_axis_order(FALSE)
    x <- sf::st_transform(x, pipeline = paste0("+proj=pipeline +step +proj=axisswap +order=", axisorder())) # reverse axes
    filter_string <- sf::st_as_text(x)
    sf::st_axis_order(ao)
    
  } else {
    warning("GDAL > 3.0.0 is required")
    filter_string <- sf::st_as_text(x)
  }

  return(filter_string)
}

# Separate functions for all CQL geometry predicates

#' CQL Geometry Predicates
#'
#' Functions to construct a CQL expression to be used
#' to filter results from [vicmap_query()].
#' See [the geoserver CQL documentation for details](https://docs.geoserver.org/stable/en/user/filter/ecql_reference.html#spatial-predicate).
#' The sf object is automatically simplified to a less complex sf object
#' to reduce the complexity of the Web Service call. Subsequent in-memory
#' filtering may be needed to achieve exact results. 
#' 
#' @details The code for these cql predicates was developed by the bcdata team: \url{https://bcgov.github.io/bcdata/reference/cql_geom_predicates.html}
#'
#' @param geom an `sf`/`sfc`/`sfg` or `bbox` object (from the `sf` package)
#' @name cql_geom_predicates
#' @return a CQL expression to be passed on to the WFS call
NULL

#' @rdname cql_geom_predicates
#' @export
EQUALS <- function(geom) {
  vicmap_cql_string(geom, "EQUALS")
}

#' @rdname cql_geom_predicates
#' @export
DISJOINT <- function(geom) {
  vicmap_cql_string(geom, "DISJOINT")
}

#' @rdname cql_geom_predicates
#' @export
INTERSECTS <- function(geom) {
  vicmap_cql_string(geom, "INTERSECTS")
}

#' @rdname cql_geom_predicates
#' @export
TOUCHES <- function(geom) {
  vicmap_cql_string(geom, "TOUCHES")
}

#' @rdname cql_geom_predicates
#' @export
CROSSES <- function(geom) {
  vicmap_cql_string(geom, "CROSSES")
}

#' @rdname cql_geom_predicates
#' @export
WITHIN <- function(geom) {
  vicmap_cql_string(geom, "WITHIN")
}

#' @rdname cql_geom_predicates
#' @export
CONTAINS <- function(geom) {
  vicmap_cql_string(geom, "CONTAINS")
}

#' @rdname cql_geom_predicates
#' @export
OVERLAPS <- function(geom) {
  vicmap_cql_string(geom, "OVERLAPS")
}

#' @rdname cql_geom_predicates
#' @param pattern spatial relationship specified by a DE-9IM matrix pattern.
#' A DE-9IM pattern is a string of length 9 specified using the characters
#' `*TF012`. Example: `'1*T***T**'`
#' @export
RELATE <- function(geom, pattern) {
  if (!is.character(pattern) ||
      length(pattern) != 1L ||
      !grepl("^[*TF012]{9}$", pattern)) {
    stop("pattern must be a 9-character string using the characters '*TF012'",
         call. = FALSE)
  }
  vicmap_cql_string(geom, "RELATE", pattern = pattern)
}

#' @rdname cql_geom_predicates
#' @param coords the coordinates of the bounding box as four-element numeric
#'        vector `c(xmin, ymin, xmax, ymax)`, a `bbox` object from the `sf`
#'        package (the result of running `sf::st_bbox()` on an `sf` object), or
#'        an `sf` object which then gets converted to a bounding box on the fly.
#' @param crs (Optional) A numeric value or string containing an SRS code. If
#' `coords` is a `bbox` object with non-empty crs, it is taken from that.
#' (For example, `'EPSG:3005'` or just `3005`. The default is to use the CRS of
#' the queried layer)
#' @export
BBOX <- function(coords, crs = NULL){
  
  if (inherits(coords, c("sf", "sfc"))) {
    coords <- sf::st_bbox(coords)
  }
  
  if (!is.numeric(coords) || length(coords) != 4L) {
    stop("'coords' must be a length 4 numeric vector", call. = FALSE)
  }
  
  if (inherits(coords, "bbox")) {
    crs <- sf::st_crs(coords)$epsg
    coords <- as.numeric(coords)
  }
  
  if (is.numeric(crs)) {
    crs <- paste0("EPSG:", crs)
  }
  
  if (!is.null(crs) && !(is.character(crs) && length(crs) == 1L)) {
    stop("crs must be a character string denoting the CRS (e.g., 'EPSG:4326')",
         call. = FALSE)
  }
  vicmap_cql_string(x = NULL, "BBOX", coords = coords, crs = crs)
}

#' @rdname cql_geom_predicates
#' @param distance numeric value for distance tolerance
#' @param units units that distance is specified in. One of
#' `"feet"`, `"meters"`, `"statute miles"`, `"nautical miles"`, `"kilometers"`
#' @export
DWITHIN <- function(geom, distance,
                    units = c("meters", "feet", "statute miles", "nautical miles", "kilometers")) {
  if (!is.numeric(distance)) {
    stop("'distance' must be numeric", call. = FALSE)
  }
  units <- match.arg(units)
  vicmap_cql_string(geom, "DWITHIN", distance = distance, units = units)
}

#' @rdname cql_geom_predicates
#' @export
# https://osgeo-org.atlassian.net/browse/GEOS-8922
BEYOND <- function(geom, distance,
                   units = c("meters", "feet", "statute miles", "nautical miles", "kilometers")) {
  if (!is.numeric(distance)) {
    stop("'distance' must be numeric", call. = FALSE)
  }
  units <- match.arg(units)
  vicmap_cql_string(geom, "BEYOND", distance = distance, units = units)
}
