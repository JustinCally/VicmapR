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

# Check conversion of select and filter works
test_that("convert layer filter works", {
  r3 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
    filter(HIERARCHY == "L" & PFI == 8547514) %>%
    collect()
  
  r4 <- vicmap_query("open-data-platform:hy_watercourse") %>%
    filter(feature_type_code == 'watercourse_channel_drain') %>%
    filter(hierarchy == "L" & pfi == 8547514) %>%
    collect()
  
  expect_equal(r3, r4)
  
})

test_that("convert layer select works", {
  r5 <- vicmap_query(layer = "datavic:VMHYDRO_WATERCOURSE_DRAIN") %>% 
    select(HIERARCHY, PFI) %>%
    head(5) %>%
    collect()
  
  r6 <- vicmap_query("open-data-platform:hy_watercourse") %>%
    filter(feature_type_code == 'watercourse_channel_drain') %>%
    select(hierarchy, pfi) %>%
    head(5) %>%
    collect()
  
  expect_equal(r5, r6)
})