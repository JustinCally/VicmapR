VicmapR_layer.character <- function(layer_id, crs = 4283) {
  if (length(layer_id) != 1) {
    stop("Only one record my be queried at a time.", call. = FALSE)
  }
  
  # Fist catch if a user has passed the name of a warehouse object directly,
  # then can skip all the record parsing and make the API call directly
 # if (is_whse_object_name(record)) {
    ## Parameters for the API call
    query_list <- make_query_list(layer_name = layer_id, crs = crs)
    
    ## Drop any NULLS from the list
    query_list <- purrr::compact(query_list)
    
    ## GET and parse data to sf object
    cli <- vic_wfs_client()
    
    cols_df <- feature_helper(layer_id)
    
    return(
      as.vicmap_promise(list(query_list = query_list, cli = cli, record = NULL,
                           cols_df = cols_df))
    )
 # }
  
#   obj <- bcdc_get_record(layer_id)
# 
#   bcdc_query_geodata(obj, crs)
}

vicmap_query_geodata <- function(record, crs = 4283) {
  if (!has_internet()) stop("No access to internet", call. = FALSE) # nocov
  UseMethod("vicmap_query_geodata")
}

#' @export
vicmap_query_geodata.default <- function(record, crs = vicmap) {
  stop("No vicmap_query_geodata method for an object of class ", class(record),
       call. = FALSE)
}

#' @export
vicmap_query_geodata.character <- function(record, crs = 3005) {
  
  if (length(record) != 1) {
    stop("Only one record my be queried at a time.", call. = FALSE)
  }
  
  # Fist catch if a user has passed the name of a warehouse object directly,
  # then can skip all the record parsing and make the API call directly
  if (is_whse_object_name(record)) {
    ## Parameters for the API call
    query_list <- make_query_list(layer_name = record, crs = crs)
    
    ## Drop any NULLS from the list
    query_list <- purrr::compact(query_list)
    
    ## GET and parse data to sf object
    cli <- vic_wfs_client()
    
    cols_df <- feature_helper(record)
    
    return(
      as.bcdc_promise(list(query_list = query_list, cli = cli, record = NULL,
                           cols_df = cols_df))
    )
  }
  
  # if (grepl("/resource/", record)) {
  #   #  A full url was passed including record and resource compenents.
  #   # Grab the resource id and strip it off the url
  #   record <- gsub("/resource/.+", "", record)
  # }
  
  obj <- vicmap_get_record(record)
  
  bcdc_query_geodata(obj, crs)
}

#' @export
bcdc_query_geodata.bcdc_record <- function(record, crs = 3005) {
  if (!any(wfs_available(record$resource_df))) {
    stop("No Web Service resource available for this data set.",
         call. = FALSE
    )
  }
  
  layer_name <- basename(dirname(
    record$resource_df$url[record$resource_df$format == "wms"]
  ))
  
  ## Parameters for the API call
  query_list <- make_query_list(layer_name = layer_name, crs = crs)
  
  ## Drop any NULLS from the list
  query_list <- compact(query_list)
  
  ## GET and parse data to sf object
  cli <- bcdc_wfs_client()
  
  cols_df <- feature_helper(query_list$typeNames)
  
  as.bcdc_promise(list(query_list = query_list, cli = cli, record = record,
                       cols_df = cols_df))
}

