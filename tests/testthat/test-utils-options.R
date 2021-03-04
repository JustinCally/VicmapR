test_that("vicmap_options works", {
  expect_is(vicmap_options(), c("tbl_df","tbl","data.frame"))
  expect_length(vicmap_options(), 3)
})

test_that("check_chunk_limit works", {
  options(vicmap.chunk_limit = 999999999L)
  expect_error(VicmapR:::check_chunk_limit(), regexp = "Your chunk value of 999999999 exceed the Vicmap Data Catalogue chunk limit")
  options(vicmap.chunk_limit = 70000L)
})
