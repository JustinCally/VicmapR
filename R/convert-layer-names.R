#' Convert layer names from old platform naming convention to the new platform naming convention
#'
#' @param x object of class `vicmap_promise`
#'
#' @return object of class `vicmap_promise`
#' @export
#'
#' @examples
#' 
convert_layer_name <- function(x) {
  
  # All oldlayers should have #datavic:
  if(!grepl(pattern="datavic:", x = x$query$typeNames)) {
    return(as.vicmap_promise(x))
  }
  
  x_new <- x 
  type_name_full <- sub(pattern = "datavic:", replacement = "", x = x$query$typeNames)
  
  new_name_row <- name_conversions %>%
    dplyr::filter(Original_Layer_Name == type_name_full) 
  
  if(nrow(new_name_row) == 0) {
    stop("No matching data found on new geoserver platform. Please search for a new layer with listLayers()")
  }
  
  new_name <- new_name_row %>% 
    dplyr::pull(`New_Layer_Name`)
  
  cql_filter <- new_name_row %>% 
    dplyr::pull(CQL_FILTER)
  
  message(paste0("You are using old layer names. We converted your layer to ", 
                 new_name, " with a CQL filter of ", cql_filter,
                 ". To suppress this message, update your code to use the new layer names (see VicmapR::name_conversions for more details)"))
  
  # assign new values to x_new 
  x_new$query$typeNames <- new_name
  
  if(!is.na(cql_filter)) {
    
    # Add cql filter statement to any existing cql filter statements.
    x_new$query$CQL_FILTER <- c(dbplyr::sql(x$query$CQL_FILTER),
                                dbplyr::sql(cql_filter),
                                drop_null = TRUE)
  }
  
  as.vicmap_promise(x_new)
  
}
