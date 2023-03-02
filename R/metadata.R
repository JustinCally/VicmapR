# Copyright 2019 Justin Cally
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.


#' Layer Metadata
#' @description formatted metadata attributes of a given vicmap layer (`vicmap_query(layer)`). 
#' Metadata is retrieved from the Vicmap catalogue. `data_citation()` prints a BibTex style citation for a given record; 
#' similar to `base::citation()`. `data_dictionary()` returns a table with names, types and descriptions of the data within the
#' selected layer (see details). `get_metdata()` returns a list with three elements, containing metadata, the data dictionary and the url of the 
#' metadata for the record.   
#'
#' @param x Object of class `vicmap_promise` (likely passed from [vicmap_query()])
#' @param metadataID character: ID of data (useful if data is not available through WFS)
#'
#' @return citation, data.frame or list
#' @export
#'
#' @examples
#' \donttest{
#' try(
#' data_citation(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN"))
#' )
#' }

data_citation <- function(x = NULL, metadataID = NULL) {
  
  md <- get_metadata(x, metadataID)
  nl <- as.character(md[[1]][[2]])
  names(nl) <- as.character(md[[1]][[1]])
  
  cat("  @ELECTRONIC{", nl["Resource Name"], ",", sep = "")
  cat("\n")
  cat("        author = {", nl["Custodian"], "},", sep = "")
  cat("\n")
  cat("        title = {", nl["Title"], "},", sep = "")
  cat("\n")
  cat("        year = {", lubridate::year(as.POSIXct(nl["Metadata Date"])), "},", sep = "")
  cat("\n")
  cat("        url = {", md[[3]] , "},", sep = "")
  cat("\n")
  cat("        owner = {", nl["Owner"], "},", sep = "")
  cat("\n")
  cat("        timestamp = {", format(Sys.Date(), "%Y.%m.%d"), "},", sep = "")
  cat("\n")
  cat("}")
}

#' @rdname data_citation
#' @export
#' @examples
#' \donttest{
#' try(
#' data_dictionary(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN"))
#' )
#' }
data_dictionary <- function(x = NULL, metadataID = NULL) {
  
  get_metadata(x, metadataID)[[2]]
}

get_metadataID <- function(x) {
  url <- httr::parse_url(getOption("vicmap.base_url", default = base_wfs_url))
  url$query <- list(service = "wfs",
                    version = "2.0.0",
                    request = "GetCapabilities")
  
  request <- httr::build_url(url)
  response <- httr::GET(request)
  
  # stop if broken
  httr::stop_for_status(response)
  
  parsed <- httr::content(response, encoding = "UTF-8") %>% xml2::xml_child(4)
  attr_list <- xml2::as_list(parsed)
  
  feat_names <- unlist(lapply(attr_list, function(x) x[["Name"]]))
  
  feat <- which(x[["query"]][["typeNames"]] == feat_names)
  
  keywords <- unlist(attr_list[[feat]][["Keywords"]]) %>% 
    unique()
  
  key_lookup <- grep(pattern = "^MetadataID", x = keywords, value = TRUE)
  key_lookup_sub <- sub(pattern = "MetadataID=", replacement = "", x = key_lookup)
  return(key_lookup_sub)
}

#' @rdname data_citation
#' @export
#' @examples
#' \donttest{
#' try(
#' get_metadata(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN"))
#' )
#' }
get_metadata <- function(x = NULL, metadataID = NULL) {
  
  if(is.null(x) & is.null(metadataID)) {
    stop("x or anzlicId must be provided")
  }
  
  if(is.null(metadataID)) {

key_lookup <- get_metadataID(x)

  } else {
  key_lookup <- metadataID
}

key_url <- paste0("https://metashare.maps.vic.gov.au/geonetwork/srv/api/records/",key_lookup,"/formatters/sdm-html?root=html&output=html")

doc <- rvest::read_html(key_url) 
tab <- rvest::html_elements(doc, "table") %>% rvest::html_table(na.strings = "")

tab_filtered <- tab[c(3,length(tab))]

tab_filtered[[1]] <- tab_filtered[[1]] %>%
  dplyr::select(.data$`Metadata Name`, .data$`Descriptions`) %>%
  dplyr::mutate(`Metadata Name` = gsub(pattern = ":$", replacement = "", x = .data$`Metadata Name`))

tab_filtered[[1]] <- dplyr::filter(tab_filtered[[1]], !is.na(.data$`Metadata Name`))

suppressWarnings({
tab_filtered[[1]] <- tab_filtered[[1]] %>% 
  dplyr::filter(is.na(as.numeric(.data$`Metadata Name`)))
})

tab_filtered[[3]] <- key_url

return(tab_filtered)

}

