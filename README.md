# project418-518
library(tidycensus)
library(tidyverse)

census_api_key("67cbcd7b6d617916475eb5bd88439380a2511582")


v17 <- load_variables(2017, "acs5", cache = TRUE)

View(v17)


documentation:
https://rstudio-pubs-static.s3.amazonaws.com/541247_e7b707cd2f71405bb5624517877785ff.html

resource for acs package:
https://cran.r-project.org/web/packages/acs/readme/README.html

more documentation:
https://www.census.gov/programs-surveys/acs/guidance/handbooks/general.html

**still working to understand the R package. I think it'll be super useful data it's just massive so once we get this hurdle the rest of the reporting/analysis should be straighforward



This Repository could help with the tidycensus package. https://github.com/walkerke/umich-workshop
