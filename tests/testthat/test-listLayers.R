test_that("listLayers works", {
  skip_if_offline()
  expect_equal(class(listLayers()), "data.frame")
  expect_lte(nrow(listLayers(pattern = "trees", ignore.case = TRUE)), 5)
})
