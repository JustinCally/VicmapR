test_that("vicmap_query works", {
  skip_if_offline()
  q <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", CRS = 3111, wfs_version = "1.0.0")
  q2 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "2.0.0")
  expect_error(vicmap_query(), regexp = 'argument "layer" is missing, with no default')
  expect_is(q, c("vicmap_promise", "url"))
  expect_setequal(names(q$query), c("service", 
                                    "version", 
                                    "request",
                                    "typeNames",
                                    "outputFormat", 
                                    "maxFeatures",
                                    "srsName"))
  expect_setequal(names(q2$query), c("service", 
                                    "version", 
                                    "request",
                                    "typeNames",
                                    "outputFormat", 
                                    "count",
                                    "srsName"))
  expect_equal(q$query$srsName, "EPSG:3111")
  expect_equal(q$query$version, "1.0.0")
})

test_that("print.vicmap_promise works", {
  skip_if_offline()
  expect_error(print(vicmap_query('not a layer')), regexp = "No data available to query. Check your layer and query parameters")
  expect_output(print(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "2.0.0")), regexp = NULL)
})

test_that("head.vicmap_promise works", {
  skip_if_offline()
  r <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
    head(10) %>%
    collect() %>% 
    nrow()
  r2 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "1.0.0") %>%
    head(10) %>%
    collect() %>% 
    nrow()
  expect_equal(r2, 10)
})

test_that("collect.vicmap_promise works", {
  skip_if_offline()
  d <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
    head(10) %>% 
    collect()
  
  expect_is(d, c("data.frame", "sf", "tbl_df", "tbl"))
  
  options(vicmap.chunk_limit = 100)
  expect_message(object = {d2 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
    head(101) %>% select(id) %>%
    collect()}, regexp = NULL)
  
  options(vicmap.chunk_limit = 70000)
})

test_that("show_query.vicmap_promise works", {
  skip_if_offline()
  expect_output({vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
                  show_query()}, regexp = NULL)
})
