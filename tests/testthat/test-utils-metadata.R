# Copyright 2022 Justin Cally
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

test_that("feature_hits() works", {
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  expect_equal(vicmap_query("datavic:VMHYDRO_WATERCOURSE_DRAIN", wfs_version = "2.0.0") %>% 
                 filter(HIERARCHY == "L", PFI == 8553127) %>%
                 feature_hits(), 1)
})
