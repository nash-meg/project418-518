# project418-518

library(tidycensus)
library(tidyverse)

census_api_key("67cbcd7b6d617916475eb5bd88439380a2511582")


v17 <- load_variables(2017, "acs5", cache = TRUE)

View(v17)
