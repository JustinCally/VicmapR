## Resubmission  
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
