test_that("listLayers works", {
  expect_equal(class(listLayers()), "data.frame")
})

test_that("listLayers filter works", {
  expect_lte(nrow(listLayers(pattern = stringr::regex("trees", ignore_case = T))), 5)
})
