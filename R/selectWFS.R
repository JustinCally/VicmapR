#' selectWFS
#' @description 
#'
#' @param Client 
#' @param layer 
#'
#' @return
#' @export
#'
#' @examples
selectWFS <- function(Client, layer) {
  UseMethod("selectWFS", Client)
}

selectWFS.OWSClient <- function(Client, layer) {
  Client2 <- Client$clone()
  if(layer %in% listLayers(Client = Client2)$name) {
    Client2$selectLayer <- layer
  } else {
    stop(paste("Layer:", layer, "is not available from", deparse(substitute(Client))))
  }
  return(Client2)
}
