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

test_that("vicmap_options works", {
  expect_is(vicmap_options(), c("tbl_df","tbl","data.frame"))
  expect_length(vicmap_options(), 3)
})

test_that("check_chunk_limit works", {
  options(vicmap.chunk_limit = 999999999L)
  expect_error(VicmapR:::check_chunk_limit(), regexp = "Your chunk value of 999999999 exceed the Vicmap Data Catalogue chunk limit")
  options(vicmap.chunk_limit = 1500)
})
