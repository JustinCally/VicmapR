
<!-- README.md is generated from README.Rmd. Please edit that file -->

# VicmapR

<!-- badges: start -->

<!-- badges: end -->

The goal of VicmapR is to provide functions to easily access Victorin
Government spatial data through their WFS (Web Feature Service).

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
#> tibble [45 x 16] (S3: sf/tbl_df/tbl/data.frame)
#>  $ gml_id            : chr [1:45] "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17457a9736c_-51d3" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17457a9736c_-51d2" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17457a9736c_-51d1" "VMHYDRO_WATERCOURSE_DRAIN.fid-61502c02_17457a9736c_-51d0" ...
#>  $ PFI               : num [1:45] 8916168 8916172 13480993 13481015 13481019 ...
#>  $ UFI               : num [1:45] 2915212 2915216 20931940 20931966 20931973 ...
#>  $ FEATURE_TYPE_CODE : chr [1:45] "watercourse_channel_drain" "watercourse_channel_drain" "watercourse_channel_drain" "watercourse_channel_drain" ...
#>  $ NAME              : chr [1:45] NA NA NA NA ...
#>  $ NAMED_FEATURE_ID  : num [1:45] NA NA NA NA NA NA 0 0 NA NA ...
#>  $ ORIGIN            : chr [1:45] "2" "2" "2" "2" ...
#>  $ CONSTRUCTION      : chr [1:45] NA NA "2" "2" ...
#>  $ USAGE             : chr [1:45] NA NA NA NA ...
#>  $ HIERARCHY         : chr [1:45] "L" "L" "L" "L" ...
#>  $ FEATURE_QUALITY_ID: num [1:45] 100 100 100 100 100 100 100 100 100 100 ...
#>  $ CREATE_DATE_PFI   : chr [1:45] "2001-04-04T02:54:03" "2001-04-04T02:54:04" "2008-11-20T08:22:38" "2008-11-20T08:22:39" ...
#>  $ SUPERCEDED_PFI    : num [1:45] NA NA 8915893 8915893 8915988 ...
#>  $ CREATE_DATE_UFI   : chr [1:45] "2001-04-04T02:54:03" "2001-04-04T02:54:04" "2008-11-20T08:22:38" "2008-11-20T08:22:39" ...
#>  $ OBJECTID          : num [1:45] 193900 193901 1467760 1467812 1467819 ...
#>  $ SHAPE             :sfc_LINESTRING of length 45; first list element:  'XY' num [1:2, 1:2] 144.4 144.4 -38.3 -38.3
#>  - attr(*, "sf_column")= chr "SHAPE"
#>  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA NA NA NA NA NA ...
#>   ..- attr(*, "names")= chr [1:15] "gml_id" "PFI" "UFI" "FEATURE_TYPE_CODE" ...
```
