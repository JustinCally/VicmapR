#### Setup WFSClient Base URL ####
wfs_url <- "http://services.land.vic.gov.au/catalogue/publicproxy/guest/dv_geoserver/wms"

#' New WFSClient
#' 
#' @description Establishes a new WFSClient for Victoria's spatial data using \link[ows4R]{WFSClient}
#'
#' @param version Version of WFS to use
#' @param ... Additional arguments passed to \link[ows4R]{WFSClient}$new
#'
#' @return Object of \link[R6]{R6Class} with methods for interfacing an OGC Web Feature Service.
#' @export
#'
#' @examples
#' VicmapClient <- newClient()

newClient <- function(version = "1.1.1", ...) {

ows4R::WFSClient$new(wfs_url, 
                     serviceVersion = version, 
                     ...)
}