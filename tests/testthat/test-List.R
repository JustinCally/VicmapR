VicmapClient <- newClient()

test_that("listLayers works", {
  expect_equal(class(listLayers(VicmapClient)), "data.frame")
})

test_that("listLayers filter works", {
  expect_lte(nrow(listLayers(VicmapClient, pattern = stringr::regex("trees", ignore_case = T))), 5)
})
