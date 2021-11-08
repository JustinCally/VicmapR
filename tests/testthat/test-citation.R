# Copyright 2020 Justin Cally
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

geoserver_down <- !(check_geoserver(timeout = 5, quiet = TRUE))

test_that("get_metadata works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  r <- get_metadata(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN"))
  
  expect_equal(class(r), "list")
  expect_equal(length(r), 3)
  expect_true(is.data.frame(r[[1]]))
  expect_true(is.data.frame(r[[2]]))
  expect_true(is.character(r[[3]]))
  

  r2 <- get_metadata(anzlicId = "ANZVI0803002490")
  
  expect_identical(r, r2)
})

test_that("data_dictionary works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  r <- data_dictionary(vicmap_query(layer = "datavic:VMLITE_PUBLIC_LAND_COASTAL_W_SU3"))
  
  expect_true(is.data.frame(r))
  
})

test_that("data_citation works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  data_citation(vicmap_query(layer = "datavic:VMLITE_PUBLIC_LAND_COASTAL_W_SU3"))
  
  expect_output({data_citation(vicmap_query(layer = "datavic:VMLITE_PUBLIC_LAND_COASTAL_W_SU3"))})
  
})