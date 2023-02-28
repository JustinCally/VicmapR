# Upload new table names  
library(dplyr)
# read in data 
name_conversions <- readr::read_csv(here::here("data-raw", "name-conversions", "FAQ_Appendix_1.csv")) %>% 
  dplyr::mutate(full_original_name = paste0("datavic:", Original_Layer_Name), 
                full_new_name = paste0("open-data-platform:", New_Layer_Name))

usethis::use_data(name_conversions, overwrite = TRUE)
