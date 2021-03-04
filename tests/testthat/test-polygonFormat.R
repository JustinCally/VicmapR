test_that("polygonFormat works", {
  polygon <- sf::st_read(system.file("shapes/melbourne.geojson", package="VicmapR"))
  formatted_polygon <- VicmapR:::polygonFormat(polygon)
  
  expect_lt(utils::object.size(formatted_polygon), utils::object.size(polygon))
  expect_is(formatted_polygon, c("sfc_POLYGON", "sfc"))
})
