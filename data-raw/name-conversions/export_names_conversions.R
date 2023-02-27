# Upload new table names  

# read in data 
name_conversions <- readr::read_csv(here::here("data-raw", "name-conversions", "FAQ_Appendix_1.csv"))

usethis::use_data(name_conversions, overwrite = TRUE)
