base.url <- getOption("vicmap.base_url", default = VicmapR:::base_wfs_url)
new.url <- "https://opendata-uat.maps.vic.gov.au/geoserver/wfs"
options(vicmap.base_url = new.url)
options(vicmap.backend = "AWS")

test_that("new url works", {
  testthat::expect_true(check_geoserver())
})

test_that("listLayers url works", {
  testthat::expect_equal(class(listLayers()), "data.frame")
})

options(vicmap.base_url = base.url)

