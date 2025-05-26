
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vicspatial 

<img src='man/figures/logo.png' align="right" height="100" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/JustinCally/vicspatial/branch/master/graph/badge.svg)](https://app.codecov.io/gh/JustinCally/vicspatial?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- [![R build status](https://github.com/JustinCally/vicspatial/workflows/R-CMD-check/badge.svg)](https://github.com/JustinCally/vicspatial/actions) -->
[![CRAN
status](https://www.r-pkg.org/badges/version/vicspatial)](https://CRAN.R-project.org/package=vicspatial)
[![](http://cranlogs.r-pkg.org/badges/grand-total/vicspatial?color=ff69b4)](https://cran.r-project.org/package=vicspatial)
<!-- [![Devel version](https://img.shields.io/badge/devel%20version-0.1.3-blue.svg)](https://github.com/JustinCally/vicspatial) -->
<!-- [![Code size](https://img.shields.io/github/languages/code-size/JustinCally/vicspatial.svg)](https://github.com/JustinCally/vicspatial) -->
[![R-CMD-check](https://github.com/JustinCally/vicspatial/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JustinCally/vicspatial/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

**In May 2025 (version 0.3.0) `VicmapR` was renamed to `vicspatial`.
Unfortunately this change has been requested by the trademark holders of
`VICMAP` (Department of Transport and Planning). While redirections
should be in place for GitHub and CRAN websites, please check existing
code for explicit mentions of `VicmapR`.**

The goal of vicspatial is to provide functions to easily access
Victorian Government spatial data through their WFS (Web Feature
Service). vicspatial leverages code and a lazy querying approach
developed by [Teucher et
al. (2021)](https://joss.theoj.org/papers/10.21105/joss.02927) for the
[{bcdata} R package](https://bcgov.github.io/bcdata/), which allows for
a responsive and precise querying process.

## Migration of Victoria’s Open Data Geoserver

**From March 2023 (`vicspatial v0.2.0`) the way `vicspatial` obtains
data has changed**

In March 2023 the data platform used by `vicspatial` will be migrated
with the legacy platform discontinued. Changes have been to the
`vicspatial` package to allow for the conversion and translation of of
code in an effort to ensure legacy code still works. However, the
migration may have unseen consequences and users are encouraged to
review code.

## Installation

You can install the released version from CRAN with:

``` r
install.packages("vicspatial")
```

Or you can install the the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JustinCally/vicspatial")
```

### Dependencies

Currently, the ability to use accurate geometric filters using
`vicspatial` requires GDAL \> 3.0. To see how to upgrade your version of
GDAL and link it to the `sf` package visit:
<https://r-spatial.github.io/sf/#installing>

``` r
library(sf)
#> Warning: package 'sf' was built under R version 4.3.3
#> Linking to GEOS 3.13.0, GDAL 3.8.5, PROJ 9.5.1; sf_use_s2() is TRUE
sf::sf_extSoftVersion()
#>           GEOS           GDAL         proj.4 GDAL_with_GEOS     USE_PROJ_H 
#>       "3.13.0"        "3.8.5"        "9.5.1"         "true"         "true" 
#>           PROJ 
#>        "9.5.1"
```

## Example

### Searching for data

``` r
library(vicspatial)
#> From November 2024 (version 0.3.0) `vicspatial` will be renamed to `vicspatial`. Unfortunately this change has been requested by the trademark holders of `VICMAP` (Department of Transport and Planning). While redirections should be in place for GitHub and CRAN websites, please check existing code for explicit mentions of `vicspatial`.
#> 
#> Attaching package: 'vicspatial'
#> The following object is masked from 'package:stats':
#> 
#>     filter

# Check to see if the geoserver is working. It will error if it is not working  
check_geoserver()
#> [1] TRUE

listLayers(pattern = "watercourse", ignore.case = T)
#>                                       Name                 Title
#> 1 open-data-platform:hy_water_area_polygon hy_water_area_polygon
#> 2        open-data-platform:hy_watercourse        hy_watercourse
#> 3 open-data-platform:vmlite_hy_watercourse vmlite_hy_watercourse
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Abstract
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                        This layer is part of Vicmap Hydro and contains polygon features delineating hydrological features.\nIncludes; Lakes, Flats (subject to inundation),  Wetlands, Pondages (saltpan & sewrage), Watercourse Areas, Rapids & Waterfalls\nAttributed for name.\nCentroid layer also available.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                This layer is part of Vicmap Hydro and contains line features delineating hydrological features.\nIncludes; Watercourses (ie channels, rivers & streams) & Connectors.\nAttributed for name.  Arcs run downstream.
#> 3 This layer is part of Vicmap Lite and contains line features delineating hydrological features. Vicmap Lite datasets are suited for use between scales of 1: 250,000 and 1 : 5 million.  The linework was sourced from Vicmap Hydro. The level of attribute information, the number of features and the number of vertices has been simplified to suit the 1: 250,000  - 1 : 5 million scale range. The concept of a Scale Use Code has been introduced to help control the level of detail displayed.\n\nIf this dataset is used in conjunction with vmlite_hy_water_area, then the draw order should be such that vmlite_hy_watercourse is drawn 1st and vmlite_hy_water_area is drawn ontop.\n\nTHIS DATASET WAS LAST UPDATED IN NOVEMBER 2015
#>                             metadataID
#> 1 3984e659-2487-512d-b390-0de817979f21
#> 2 cc373943-7848-5c21-9be4-7a92632e624c
#> 3 9753ed02-4f2a-59a0-a673-73fbe934f58a
```

### Reading in data

As of vicspatial version `0.1.0` data is read in using a lazy evaluation
method with the convenience of pipe operators (`%>%`). A lot of the
methods and code have already been written for a similar package
([bcdata](https://github.com/bcgov/bcdata)) that downloads data from the
British Columbia WFS catalogues. Using a similar approach, vicspatial
allows users to construct a WFS query in a step-wise format. In doing so
a query is reserved until `collect()` is used on the `vicmap_promise`.
The example below shows an extensive example of how the to easily read
in spatial data:

``` r
# Read in an example shape to restrict our query to using geometric filtering
melbourne <- sf::st_read(system.file("shapes/melbourne.geojson", package="vicspatial"), quiet = T)

# Obtain a promise of what data will be returned for a given layer
vicmap_query(layer = "open-data-platform:hy_watercourse")
#> • Using collect() on this object will return 1832868 features and 21
#> • fields
#> • At most six rows of the record are printed here
#> ────────────────────────────────────────────────────────────────────────────────
#> Simple feature collection with 6 features and 20 fields
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 141.8898 ymin: -39.01699 xmax: 146.3676 ymax: -34.36471
#> Geodetic CRS:  GDA94
#> # A tibble: 6 × 21
#>   id                  ufi    pfi feature_type_code name  named_feature_id origin
#>   <chr>             <int>  <int> <chr>             <chr> <chr>            <chr> 
#> 1 hy_watercourse.1 3.63e6 9.63e6 watercourse_stre… <NA>  <NA>             1     
#> 2 hy_watercourse.2 3.63e6 9.63e6 watercourse_stre… <NA>  <NA>             1     
#> 3 hy_watercourse.3 3.63e6 9.63e6 watercourse_stre… <NA>  <NA>             1     
#> 4 hy_watercourse.4 2.55e6 8.55e6 watercourse_chan… <NA>  <NA>             2     
#> 5 hy_watercourse.5 2.55e6 8.55e6 watercourse_chan… <NA>  <NA>             2     
#> 6 hy_watercourse.6 2.55e6 8.55e6 watercourse_chan… <NA>  <NA>             2     
#> # ℹ 14 more variables: construction <chr>, usage <chr>, hierarchy <chr>,
#> #   auth_org_code <chr>, auth_org_id <chr>, auth_org_verified <chr>,
#> #   feature_quality_id <int>, task_id <chr>, create_date_pfi <dttm>,
#> #   superceded_pfi <chr>, feature_ufi <int>, feature_create_date_ufi <dttm>,
#> #   create_date_ufi <dttm>, geometry <LINESTRING [°]>

# Build a more specific query and collect the results
vicmap_query(layer = "open-data-platform:hy_watercourse") %>% # layer to query
  filter(hierarchy == "L" & feature_type_code == 'watercourse_channel_drain') %>% # simple filter for a column
  filter(INTERSECTS(melbourne)) %>% # more advanced geometric filter
  select(hierarchy, pfi) %>% 
  collect()
#> Simple feature collection with 8 features and 3 fields
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 144.909 ymin: -37.81511 xmax: 144.9442 ymax: -37.78198
#> Geodetic CRS:  GDA94
#> # A tibble: 8 × 4
#>   id                          pfi hierarchy                             geometry
#>   <chr>                     <int> <chr>                         <LINESTRING [°]>
#> 1 hy_watercourse.676580  19272791 L         (144.9287 -37.8033, 144.9186 -37.80…
#> 2 hy_watercourse.1134745 14608551 L         (144.9201 -37.79069, 144.9202 -37.7…
#> 3 hy_watercourse.189593  14615146 L         (144.9442 -37.78198, 144.944 -37.78…
#> 4 hy_watercourse.189600  14608434 L         (144.9403 -37.78253, 144.9401 -37.7…
#> 5 hy_watercourse.1079520 14577596 L         (144.929 -37.81409, 144.9294 -37.81…
#> 6 hy_watercourse.1677768 17520306 L         (144.9415 -37.78232, 144.9414 -37.7…
#> 7 hy_watercourse.1765811 14577602 L         (144.9288 -37.81417, 144.9292 -37.8…
#> 8 hy_watercourse.1792496 14608731 L         (144.9365 -37.81511, 144.9359 -37.8…
```

vicspatial translates numerous geometric filter functions available in
the Victorian Government’s WFS Geoserver supports numerous [geometric
filters](https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html#geometric-filters):

- `EQUALS`  
- `DISJOINT`  
- `INTERSECTS`  
- `TOUCHES`  
- `CROSSES`  
- `WITHIN`  
- `CONTAINS`
- `OVERLAPS`  
- `DWITHIN`  
- `BEYOND`  
- `BBOX`

These filters can be used within the `filter()` function by providing
them an object of class `sf/sfc/sfg/bbox` as shown above with the
`melbourne` object.

### Using other WFS urls

Using `options(vicmap.base_url)` vicspatial can query data from other
WFS services; while this remains somewhat untested it is relatively easy
to point vicspatial to another WFS url. This option would need to be set
every session to override the base vicspatial url. For instance, the BOM
WFS can be used as follows:

``` r
# set the new base url
options(vicmap.base_url = "http://geofabric.bom.gov.au/simplefeatures/ahgf_shcatch/wfs")

# collect a data sample
catchments <- vicmap_query("ahgf_shcatch:AHGFCatchment") %>% 
  head(10) %>% 
  collect()
```

***Note**: Using other Geoserver WFS urls will not necessarily work as
expected due to the potential differences in the capabilities of the
Geoserver instance*

### License

Copyright 2018 Province of British Columbia  
Modifications Copyright 2020 Justin Cally

Licensed under the Apache License, Version 2.0 (the “License”); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

<https://www.apache.org/licenses/LICENSE-2.0.txt>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
