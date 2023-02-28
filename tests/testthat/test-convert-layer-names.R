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

test_that("convert layer name works", {
  
  skip_if_offline()
  skip_on_cran()
  skip_if(geoserver_down)
  
  r1 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
    head(10) %>%
    collect()
  
  r2 <- vicmap_query("open-data-platform:hy_watercourse") %>%
    filter(feature_type_code == 'watercourse_channel_drain') %>%
    head(10) %>% 
    collect()
  
  expect_equal(r1, r2)
  
  expect_message(vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN"), regexp = "You are using old layer names. We converted your layer to hy_watercourse with a CQL filter of feature_type_code='watercourse_channel_drain'. To suppress this message, update your code to use the new layer names [(]see VicmapR::name_conversions for more details[)]")
})
