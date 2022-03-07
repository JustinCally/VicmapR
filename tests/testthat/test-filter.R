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

test_that("filter works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  expect_warning({vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "1.0.0") %>% 
                   filter(HIERARCHY == "L", PFI == 8553127)}, 
                 regexp = "wfs_version is not 2.0.0. Filtering may not be correctly applied as certain CRS's requests require axis flips")

  r <- vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "2.0.0") %>% 
    filter(HIERARCHY == "L", PFI == 8553127)
  
  expect_equal(as.character(r[["query"]][["CQL_FILTER"]]), "((\"HIERARCHY\" = 'L') AND (\"PFI\" = 8553127.0))")
  })

test_that("passing an non-existent object to a geom predicate", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  expect_error(vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN") %>%
                 filter(INTERSECTS(districts)),
               'object "districts" not found.\nThe object passed to INTERSECTS needs to be valid sf object.')
})
