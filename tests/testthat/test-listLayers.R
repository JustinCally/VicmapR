test_that("listLayers works", {
  skip_if_offline()
  expect_equal(class(listLayers()), "data.frame")
  expect_lte(nrow(listLayers(pattern = stringr::regex("trees", ignore_case = T))), 5)
})
