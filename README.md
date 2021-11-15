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

draft code:

library(tidyverse)
library(tidycensus)
options(tigris_use_cache = TRUE)

census_api_key("67cbcd7b6d617916475eb5bd88439380a2511582", install = TRUE)
readRenviron("~/.Renviron")

all_vars_acs5 <- 
    load_variables(year = 2019, dataset = "acs5")

all_vars_acs5 %>% 
  filter(concept == "EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME FOR THE POPULATION 25 YEARS AND OVER") %>%
  view()

all_vars_acs5 %>% 
  view()

vars_acs5_test <-
  c(
    lessthanhs_inlaborforce = "B16010_004",
    lessthanhs_notinlaborforce = "B16010_009"
  )

#CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT
voting_age_total <- ("B29002_002")
voting_age_hs_grad <- ("B29002_004")
#voting_age_below_9 <- ("B29002_002")
voting_age_hs <- ("B29002_003")
voting_age_some_college <- ("B29002_005")
voting_age_assoc <- ("B29002_006")
voting_age_bachelor <- ("B29002_007")
voting_age_graduate <- ("B29002_008")

#SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER
voting_age_female_total <- ("B15001_043")
voting_age_male_total <- ("B15001_002")
female_1824_hs_grad <- ("B15001_047")
male_1824_hs_grad <- ("B15001_006")

#HEALTH INSURANCE COVERAGE STATUS AND TYPE BY AGE BY EDUCATIONAL ATTAINMENT 
#age 24 to 65
total_ins <- ("B27019_001")
total_lessthan_hs <- ("B27019_003")
lt_hs_with_ins <- ("B27019_004")
lt_hs_no_ins <- ("B27019_007")
ls_hs_public_ins <- ("B27019_006")
hsgrad_with_ins <- ("B27019_009")
hsgrad_no_ins <- ("B27019_012")
hs_grad_public_ins <- ("B27019_011")
total_hs_grads <- ("B27019_008")

test <-
  get_acs(
    geography = 'state',
    state = 'MI',
    #county = 'Kent',
    geometry = FALSE,
    table = 'B27019',
    year = 2019
  )

variables <- (voting_age_total, voting_age_hs_grad,voting_age_hs,voting_age_some_college, voting_age_assoc, 
              voting_age_bachelor,voting_age_graduate)

test %>% 
  pivot_wider(
    names_from = variables, 
    values_from = c(estimate, moe)
  )

testwide <- get_acs(geography = "state", state = "MI", table = "B27019", 
                    output = "wide")
testwide



allocation_rate <-
  c(
  allocated = "B99151_002",
  total_response = "B99151_001"
)

df_acs <-
  get_acs(
    geography = 'county',
    state = 'MI',
    #county = 'Kent',
    geometry = TRUE,
    variables = voting_age_hs_grad, 
    year = 2019
  )
df_acs2 <-
  get_acs(
    geography = 'state',
    state = 'MI',
    #county = 'Kent',
    #geometry = TRUE,
    variables = allocation_rate, 
    year = 2019
  )

df_acs %>% 
  pivot_wider(
    names_from = variable, 
    values_from = c(estimate, moe)
  )


test_geo <- get_acs(state = "MI", county = "Kent", geography = "tract", 
                  variables = "B16010_004", geometry = TRUE)
#heat map:
df_acs %>%
  ggplot(aes(fill = estimate)) + 
  geom_sf(color = NA) + 
  coord_sf(crs = 26911) + 
  scale_fill_viridis_c(option = "magma")
  
  
  




variables to use:
GROUP QUARTERS TYPE (5 TYPES) BY EDUCATIONAL ATTAINMENT

(Or type 3)

Can allow us to compare educational attainment to people in correctional facility (crime rates)





HEALTH INSURANCE COVERAGE STATUS AND TYPE BY AGE BY EDUCATIONAL ATTAINMENT

How educational attainment affects healthcare access





MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS) BY SEX BY EDUCATIONAL ATTAINMENT

Gives education by income and segments for sex (male/female)





PLACE OF BIRTH BY EDUCATIONAL ATTAINMENT IN THE UNITED STATES

Allows us to compare:

-Born in US (live in the same state they were born)

-Born in US (live in different state than where born)

-Born outside US

give education levels for each category



POVERTY STATUS IN THE PAST 12 MONTHS OF FAMILIES BY HOUSEHOLD TYPE BY EDUCATIONAL ATTAINMENT



POVERTY STATUS IN THE PAST 12 MONTHS OF INDIVIDUALS BY SEX BY EDUCATIONAL ATTAINMENT



Both allow to compare:

-People above or equal to federal poverty level (within last 12 months)

-Below fed poverty level in last 12 months

Can get info either by family structures or by sex (male/female)





SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER

Sex by education (all over 18 but breaks down age groups if we wanted to look at old vs younger etc, but probably age isn’t relevant for just “did they graduate HS”) but allows us to compare male/female education levels





SEX BY SCHOOL ENROLLMENT BY EDUCATIONAL ATTAINMENT BY EMPLOYMENT STATUS 

Allows us to look at sex by employment/school status

Would allow us to see if they graduated HS and are enrolled in school (meaning continued to college) or just in the workforce



TENURE BY EDUCATIONAL ATTAINMENT OF HOUSEHOLDER

Homeownership by education (rent or own a home?)



VETERAN STATUS BY EDUCATIONAL ATTAINMENT FOR THE CIVILIAN POPULATION

Veteran status by education



EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME

Can infer if they are native English speakers and compare education levels (can break down by individual languages or just native English/non)



CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT

Just a count of those older than 18 and what their education level is. Will let us easily get the graduation rates for the entire population.





ALLOCATION OF EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER

This one is just "housekeeping" to see how much missing data was allocated

5.71% responses allocated

for reference:

https://www.census.gov/programs-surveys/acs/methodology/sample-size-and-data-quality/item-allocation-rates-definitions.html
  
