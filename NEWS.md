# VicmapR 0.1.7  
* __BUG FIX:__ Accoriding to the capabilities of the Victorian Land Services geoserver (https://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wfs?request=getCapabilities) the maximum records/features able to be returned is 70,000. This value was set as the default chunk limit (`options(vicmap.chunk_limit)`). However, it appears various layers have a limit of 1,500. As such the default has now been changed to 1,500. Users should either allow pagination during collect (the default); or if the user is sure 70,000 features can be returned for a layer they can change the default using `options(vicmap.chunk_limit = 70000)`. If this chunk limit is set to greater than 1,500 but the maximum chunk limit for that layer is restricted to 1,500 then only 1,500 features will be returned and there will be no pagination. This may mean incomplete data is returned.  
* CRAN checks now do not throw an error or warning if there is an issue with the geoserver as the `check_geoserver()` function has been amended and included in other functions to avoid errors being thrown for examples. 

# VicmapR 0.1.6  
* Apache licence is now located at: https://www.apache.org/licenses/LICENSE-2.0.txt, replaced references to this throughout the package (including Readme.Rmd)  
* The doi address for Teucher et al. (2021) {bcdata} R package paper is now formatted correctly in the DESCRIPTION

# VicmapR 0.1.5
* Pull request [#26](https://github.com/JustinCally/VicmapR/pull/26) added Apache licencing to the VicmapR package (changed from MIT). The Apache licencing is the same as [bcdata](https://github.com/bcgov/bcdata) and properly recognises the contributions of the authors. R scripts that used code from bcdata now have modifications listed as per the Apache 2.0 guidelines. 
* Andy Teucher, Sam Albers and Stephanie Hazlitt added as authors.  

# VicmapR 0.1.4
* Add `httr::stop_for_status()` in several places for more informative errors  
* Add a `check_geoserver()` function to test whether the geoserver is operational (tests added)  
* Add pkgdown favicons  

# VicmapR 0.1.3  
* Fixed issues relating to CRAN submission for version 0.1.2. They were:  
    - Link to the used webservices added to the description field of DESCRIPTION.
    - Used only undirected quotation marks in the description text. e.g. `sf` --> 'sf'
    - Added \value to .Rd files regarding exported methods and explain the functions results in the documentation. Missing Rd-tags were:
    - `\dontrun{}` replaced with with `\donttest{}` for examples requirying connection to WFS. WFS speeds may vary and in some cases examples could take > 5 seconds.  
* Edited github actions to only run on push for main/master and pull requests

# VicmapR 0.1.2
* Global variables for `:=`, `name`, `type` and `.` were included with `utils::globalVariables()`  
* `\dontrun{}` added to examples collecting or filtering data and `listLayers()`, as these took over 10 seconds in CRAN checks.  
* Improvements to github actions  

# VicmapR 0.1.1

* `options(vicmap.base_url)` now accepts other base wfs urls to be used instead of the Vicplan one (e.g. the BOM wfs: `options(vicmap.base_url = "http://geofabric.bom.gov.au/simplefeatures/ahgf_shcatch/wfs")`)  
* A vignette on how to use Vicmap has been added
* Enhanced documentation and references
* Specified that GDAL > 3.0.0 is required  
* Additional tests have been written
* Checks for CRAN Submission and automated pkgdown deployment on Github 

# VicmapR 0.1.0

* VicmapR now builds queries in a step-wise fashion through the use of a `vicmap_promise` class. Similar to how [bcdata](https://github.com/bcgov/bcdata) works 
* Generic functions like `filter`, `select`, `head` can be used to refine the query.
* Data is returned using `collect`
* No longer relying on the `ows4R` package
* Other supporting functions such as `feature_cols`, `feature_hits`, `show_query` exist to help refine a query

# VicmapR 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package  
* Wrote functions for basic WFS querying of data names and fields (`listLayers` and `listFields`)  
* Wrote a function to download and read in spatial data from Vicmap as `sf` objects (`read_layer_sf`)  

