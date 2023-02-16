base.url <- getOption("vicmap.base_url", default = VicmapR:::base_wfs_url)
new.url <- "https://opendata.maps.vic.gov.au/geoserver/wfs"
options(vicmap.base_url = new.url)
options(vicmap.backend = "AWS")
melbourne <- sf::st_read(system.file("shapes/melbourne.geojson", package="VicmapR"), quiet = T)
poi <- data.frame(x = 144.7250, 
                  y = -36.2894) %>%
  sf::st_as_sf(., coords = c("x", "y"), crs = 4283) %>%
  sf::st_transform(3111) %>%
  sf::st_buffer(dist = 2500)

test_that("new url works", {
  testthat::expect_true(check_geoserver())
})

test_that("listLayers url works", {
  testthat::expect_equal(class(listLayers()), "data.frame")
})

test_that("filter and feature hits works", {
  testthat::expect_equal(vicmap_query("open-data-platform:extent_100y_ari") %>% 
                           filter(method == "Mixed") %>% 
                           feature_hits(), 1)
})

test_that("geometric filter works", {
  
  testthat::expect_equal(vicmap_query("open-data-platform:extent_100y_ari") %>% 
                           filter(INTERSECTS(poi)) %>% 
                           feature_hits(), 2)
})

test_that("select works", {
  
  testthat::expect_equal(ncol(vicmap_query("open-data-platform:extent_100y_ari") %>% 
                           select(method) %>% 
                           head(1) %>%
                           collect()), 3)
})

options(vicmap.base_url = VicmapR:::base_wfs_url)

