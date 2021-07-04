test_that("Check geoserver works", {
  skip_if_offline()
  expect_error(check_geoserver(timeout = 0.001))
  
  m <- check_geoserver(timeout = 20)
  expect_equal(m, "Success: (200) OK")
})
