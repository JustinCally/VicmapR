# Copyright 2019 Justin Cally
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

utils::globalVariables(c(":=", "name", "type", ".", ".data", "name_conversions", "Name", "Title", "Abstract", "metadataID"))

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("In May 2025 (version 0.3.0) `VicmapR` was renamed to `vicspatial`. Unfortunately this change has been requested by the trademark holders of `VICMAP` (Department of Transport and Planning). While redirections should be in place for GitHub and CRAN websites, please check existing code for explicit mentions of `vicspatial`.")
}
