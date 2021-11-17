library(tidycensus)
library(tidyverse)

census_api_key("e9df2097261bae1ad446e25f6d7a62746f68e2a4", install = TRUE)

all_vars_acs5 <-
  load_variables(year = 2019, dataset = "acs5")
