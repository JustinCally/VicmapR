
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VicmapR

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/JustinCally/VicmapR/branch/master/graph/badge.svg)](https://codecov.io/gh/JustinCally/VicmapR?branch=master)
<!-- badges: end -->

The goal of VicmapR is to provide functions to easily access Victorian
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

str(data)
#> tibble [45 × 16] (S3: sf/tbl_df/tbl/data.frame)
#>  $ id                : chr [1:45] "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17466c42042_31c3" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17466c42042_31c4" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17466c42042_31c5" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17466c42042_31c6" ...
#>  $ PFI               : int [1:45] 8916168 8916172 13480993 13481015 13481019 13481028 18874078 18874081 13481047 13481048 ...
#>  $ UFI               : int [1:45] 2915212 2915216 20931940 20931966 20931973 20931984 53138805 53138808 20932003 20932004 ...
#>  $ FEATURE_TYPE_CODE : chr [1:45] "watercourse_channel_drain" "watercourse_channel_drain" "watercourse_channel_drain" "watercourse_channel_drain" ...
#>  $ NAME              : chr [1:45] NA NA NA NA ...
#>  $ NAMED_FEATURE_ID  : int [1:45] NA NA NA NA NA NA 0 0 NA NA ...
#>  $ ORIGIN            : chr [1:45] "2" "2" "2" "2" ...
#>  $ CONSTRUCTION      : chr [1:45] NA NA "2" "2" ...
#>  $ USAGE             : chr [1:45] NA NA NA NA ...
#>  $ HIERARCHY         : chr [1:45] "L" "L" "L" "L" ...
#>  $ FEATURE_QUALITY_ID: int [1:45] 100 100 100 100 100 100 100 100 100 100 ...
#>  $ CREATE_DATE_PFI   : POSIXct[1:45], format: "2001-04-04 02:54:03" "2001-04-04 02:54:04" ...
#>  $ SUPERCEDED_PFI    : int [1:45] NA NA 8915893 8915893 8915988 8915988 13481057 13481063 8915977 8915977 ...
#>  $ CREATE_DATE_UFI   : POSIXct[1:45], format: "2001-04-04 02:54:03" "2001-04-04 02:54:04" ...
#>  $ OBJECTID          : int [1:45] 193900 193901 1467760 1467812 1467819 1467832 2637380 2637383 1468494 1468495 ...
#>  $ geometry          :sfc_LINESTRING of length 45; first list element:  'XY' num [1:2, 1:2] 144.4 144.4 -38.3 -38.3
#>  - attr(*, "sf_column")= chr "geometry"
#>  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "names")= chr [1:15] "id" "PFI" "UFI" "FEATURE_TYPE_CODE" ...
```
