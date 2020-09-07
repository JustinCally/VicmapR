test_that("Establish client works", {
  VicmapClient <- newClient()
  expect_true(all(class(VicmapClient) %in% c("R6", "WFSClient", "OWSClient","OGCAbstractObject")))
})
