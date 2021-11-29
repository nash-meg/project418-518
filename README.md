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

https://dcl-wrangle.stanford.edu/census.html#census-bureau-basics

https://walker-data.com/isds-webinar/#34

https://walker-data.com/tidycensus/articles/spatial-data.html

https://walker-data.com/tidycensus/articles/basic-usage.html#geography-in-tidycensus

https://walker-data.com/census-r/wrangling-census-data-with-tidyverse-tools.html









Variables:



GROUP QUARTERS TYPE (5 TYPES) BY EDUCATIONAL ATTAINMENT - Abby Table #: B26201

(Or type 3)

Can allow us to compare educational attainment to people in correctional facility (crime rates)





MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS) BY SEX BY EDUCATIONAL ATTAINMENT - Meghan table #: B20004

Gives education by income and segments for sex (male/female)





POVERTY STATUS IN THE PAST 12 MONTHS OF FAMILIES BY HOUSEHOLD TYPE BY EDUCATIONAL ATTAINMENT - Alex table #: B17018



POVERTY STATUS IN THE PAST 12 MONTHS OF INDIVIDUALS BY SEX BY EDUCATIONAL ATTAINMENT - Alex table #: B17003

Both allow to compare:

-People above or equal to federal poverty level (within last 12 months)

-Below fed poverty level in last 12 months

Can get info either by family structures or by sex (male/female)





SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER - Alex table #: B15001

Sex by education (all over 18 but breaks down age groups if we wanted to look at old vs younger etc, but probably age isn’t relevant for just “did they graduate HS”) but allows us to compare male/female education levels





SEX BY SCHOOL ENROLLMENT BY EDUCATIONAL ATTAINMENT BY EMPLOYMENT STATUS - Abby table #: B14005

Allows us to look at sex by employment/school status

Would allow us to see if they graduated HS and are enrolled in school (meaning continued to college) or just in the workforce





EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME - Meghan table #: B16010

Can infer if they are native English speakers and compare education levels (can break down by individual languages or just native English/non)



CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT - Meghan table #: B29002

Just a count of those older than 18 and what their education level is. Will let us easily get the graduation rates for the entire population.
