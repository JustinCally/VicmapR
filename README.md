
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VicmapR

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/JustinCally/VicmapR/branch/master/graph/badge.svg)](https://codecov.io/gh/JustinCally/VicmapR?branch=master)
<!-- badges: end -->

The goal of VicmapR is to provide functions to easily access Victorin
Government spatial data through their WFS (Web Feature Service). The
package is currently in an early development stage.

## Installation

You can install the the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JustinCally/VicmapR")
```

## Example

### Searching for data

``` r
library(VicmapR)
## basic example code

# Create new client
VicmapClient <- newClient()
#> Loading ISO 19139 XML schemas...
#> Loading ISO 19115 codelists...

listLayers(VicmapClient, pattern = stringr::regex("trees", ignore_case = T))
#>                                name
#> 1 datavic:WATER_ISC2010_LARGE_TREES
#>                                                           title
#> 1 2010 Index of Stream Condition - Large Trees polygon features
```

### Reading in data

``` r
data <- read_layer_sf(layer_name = "datavic:VMHYDRO_WATERCOURSE_DRAIN",
                      boundbox = boundbox(xmin = 144.25, 
                                          ymin = -38.44, 
                                          xmax = 144.50,  
                                          ymax = -38.25),  
                      filter = "HIERARCHY = 'L'")
#> Warning in CPL_read_ogr(dsn, layer, query, as.character(options), quiet, :
#> GDAL Error 1: JSON parsing error: unexpected character (at offset 0)

#> Warning in CPL_read_ogr(dsn, layer, query, as.character(options), quiet, :
#> GDAL Error 1: JSON parsing error: unexpected character (at offset 0)

str(data)
#> tibble [0 × 1] (S3: sf/tbl_df/tbl/data.frame)
#>  $ geometry:sfc_GEOMETRY of length 0 - attr(*, "sf_column")= chr "geometry"
#>  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: 
#>   ..- attr(*, "names")= chr(0)
```
