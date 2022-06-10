## Resubmission 0.1.9 (2022-06-10)  
+ Addition of tutorial for new users, written by Rachel Swain (Vicmap for Beginners) (PR#36, #41)   
+ Several bug fixes for the release of dbplyr 2.2.0 (PR#39, #40)   
+ Now moving to new edition of dbplyr and users will require dbplyr > 2.0.0    
+ `feature_hits()` now works with filters (#38)   
+ Remove annoying simplifying warning when using geometric filters (users already know as it is described in tutorials) (#37)   


## Resubmission 0.1.8 (2020-12-09)  
+ Add the ability to create bibtex citations of data through `data_citation()`, as well as obtain a data dictionary (`data_dictionary()`) and other metadata (`get_metadata()`).  
+ Prevent examples failing on CRAN by adding `try()`  
+ codecov url changed

## Resubmission 0.1.7 (2020-07-26)  

+ Fixed the check errors and check warnings associated with temporarily unavailable internet resources. If internet resources (geoserver instance) is down the checks should still pass as per CRAN policy.   
+ Also, this submission reduces the default chunk limit to 1500 to avoid a bug whereby the default geoserver instance only returns 1500 features (when the stated limit is 70,000). See: https://github.com/JustinCally/VicmapR/issues/29  

## Resubmission 0.1.6 (2020-07-06)
Changed {bcdata} to 'bcdata' in the DESCRIPION file

## Resubmission 0.1.6 (2020-07-05)
Fixed two NOTES as part of the previous CRAN submission:  

+ Apache licence is now located at: https://www.apache.org/licenses/LICENSE-2.0.txt, replaced references to this throughout the package (including Readme.Rmd)   
+ The doi address for Teucher et al. (2021) {bcdata} R package paper is now formatted correctly: <doi:10.21105/joss.02927>   

## Resubmission 0.1.5  (2020-07-04)
This is a resubmission (0.1.5 from 0.1.3; version 0.1.4 was unreleased on CRAN). Briefly, this upgrade makes two main additions to the package:  

+ 0.1.4: Functions amended to include more informative errors when the geoserver is not responding (see NEWS.md).  
+ 0.1.5: VicmapR now using Apache licencing and properly recognising and stating modifications in cases where code was developed in [bcdata](https://github.com/bcgov/bcdata) (see NEWS.md).  

## Resubmission 0.1.3 
This is a resubmission (0.1.3 from 0.1.2). The following items were ammended as part of this resubmission:  

- [x] link to the used webservices added to the description field of your DESCRIPTION file in the form <http:...> or <https:...> with angle brackets for auto-linking and no space after 'http:' and 'https:'.

- [x] Used only undirected quotation marks in the description text. e.g. `sf` --> 'sf'

- [x] Added \value to .Rd files regarding exported methods and explain the functions results in the documentation. Missing Rd-tags were:

      collect-methods.Rd: \value (now collect)
      filter.Rd: \value
      head.Rd: \value
      pipe.Rd: \value
      select.Rd:  \value
      show_query.Rd:  \value

- [x] \dontrun{} replaced with with \donttest{} for examples requirying connection to WFS. WFS speeds may vary and in some cases examples could take > 5 seconds. 

## Resubmission 0.1.2 
This is a resubmission (0.1.2 from 0.1.1). Two cran notes were ammended as part of this resubmission:  

* Global variables for `:=`, `name`, `type` and `.` were included with `utils::globalVariables()`  
* `\dontrun{}` added to examples collecting or filtering data and `listLayers()`, as these took over 10 seconds in CRAN checks.  

## Test environments
* local R installation, R 3.6.3
* ubuntu 16.04 (on travis-ci), R 3.6.3
* win-builder (devel)
* Github Actions (windows-latest): release  
* Github Actions (MacOS-latest): release  
* Github Actions (ubuntu 18.04): 3.5, oldrel, release, devel

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
