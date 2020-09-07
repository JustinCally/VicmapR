# # Map layer 
# 
# library(leaflet)
# library(leaflet.extras)
# 
# 
# leaflet() %>% 
#   
#   setView(zoom=9, lng = 144.25, lat = -38.44) %>% 
#   
#   # Defines open-source base maps
#   addProviderTiles(group = "OpenSM", providers$OpenStreetMap) %>% 
#   
#   # Defines ancient woodland WMS from Natural England
#   addVicmapWMS("137	datavic:WATER_ESTUARIES", group = "Esturies") %>% 
#   
#   addLayersControl(
#     baseGroups = c("OpenSM"),
#     overlayGroups = c("Esturies"),
#     options = layersControlOptions(collapsed = FALSE)
#     
#   ) 
# 
# addVicmapWMS <- function(map, layer, group, ...) {
#   addWMSTiles(map = map, 
#               group = group, 
#               baseUrl = wfs_url, 
#               layers = layer, 
#               options = WMSTileOptions(format = "image/png", transparent = TRUE, crs = "EPSG:4283", interactive = TRUE, minZoom = 7, maxZoom = 15)) 
# }

