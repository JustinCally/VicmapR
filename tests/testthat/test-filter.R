test_that("filter works", {
  skip_if_offline()
  expect_warning({vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "1.0.0") %>% 
                   filter(HIERARCHY == "L", PFI == 8553127)}, 
                 regexp = "wfs_version is not 2.0.0. Filtering may not be correctly applied as certain CRS's requests require axis flips")

  r <- vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "2.0.0") %>% 
    filter(HIERARCHY == "L", PFI == 8553127)
  
  expect_equal(as.character(r[["query"]][["CQL_FILTER"]]), "((\"HIERARCHY\" = 'L') AND (\"PFI\" = 8553127.0))")
  })
