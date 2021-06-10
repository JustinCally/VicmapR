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
