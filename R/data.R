#' Name conversions between old and new geoserver
#'
#' A dataset containing the names of the old and corresponding new data on geoserver, including relevent CQL filters
#'
#' \itemize{
#'   \item Original_Layer_Name. The name of the original data 'typeNames', without the 'datavic:' prefix
#'   \item New_Layer_Name. The new 'typeNames' for the corresponding data stored on the AWS cloud geoserver
#'   \item CQL_FILTER. The CQL filter that needs to be applied to the new data to match the old datset
#' }
#'
#' @docType data
#' @keywords datasets
#' @name name_conversions
#' @usage data(name_conversions)
#' @format A data frame with 630 rows and 3 variables
NULL