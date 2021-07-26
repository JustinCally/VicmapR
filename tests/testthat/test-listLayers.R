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

test_that("listLayers works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  expect_equal(class(listLayers()), "data.frame")
  expect_lte(nrow(listLayers(pattern = "trees", ignore.case = TRUE)), 5)
})
