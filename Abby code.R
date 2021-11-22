
library(tidyverse)
library(tidycensus)
library(ggridges)
library(dplyr)
options(tigris_use_cache = TRUE)

census_api_key("67cbcd7b6d617916475eb5bd88439380a2511582", install = TRUE)
readRenviron("~/.Renviron")

all_vars_acs5 <- 
  load_variables(year = 2019, dataset = "acs5")


#just testing
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

x
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



##starting to build tables
#B26106 

race_vars <- c(
  White = "B26103H_004",
  Black = "B26103B_004",
  Native = "B26103C_004",
  Asian = "B26103D_004",
  HIPI = "B26103E_004",
  Hispanic = "B26103I_004"
)


#prison pop
adult_correction <- c(
  No_HS = "B26106_017",
  HS = "B26106_018",
  Some_College = "B26106_019",
  Bachelor_or_Higher = "B26106_020")

mi_prison <- get_acs(
  geography = "state",
  state = "MI",
  variables = adult_correction,
  summary_var = "B26106_016"
) 

mi_prison <- mi_prison %>%
  mutate(percent = 100 * (estimate / summary_est)) %>%
  select(NAME, variable, percent)

mi_prison %>%
  ggplot( aes(x=variable, y=percent)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()+
  labs(title = "Percent of MI Prison Population by Educational Attainment", 
     subtitle = "2019 1-year ACS estimates", 
     y = "Percent", 
     x = "Education Level", 
     caption = "Source: ACS Data Table B26106 via the tidycensus R package") 


         

#HS = c("B26106_018","B26106_019","B26106_020"))
groupquarters3 <- get_acs(
  geography = "state",
  state = c("MI", "IL","IN","WI", "OH"),
  variables = adult_correction,
  year = 2019,
  summarize(min = min(estimate, na.rm = TRUE), 
            mean = mean(estimate, na.rm = TRUE), 
            median = median(estimate, na.rm = TRUE), 
            max = max(estimate, na.rm = TRUE))
)

#Illinois, Indiana, Iowa, Kansas, Michigan, Minnesota, Missouri, Nebraska, North Dakota, Ohio, South Dakota, and Wisconsin.

summarize(min = min(estimate, na.rm = TRUE), 
          mean = mean(estimate, na.rm = TRUE), 
          median = median(estimate, na.rm = TRUE), 
          max = max(estimate, na.rm = TRUE))

ggplot(groupquarters3, aes(x = estimate, y = variable)) + 
  geom_density_ridges() + 
  theme_ridges() + 
  labs(x = "Population Count", 
       y = "")
  #scale_x_continuous(labels = scales::count)

#GQ3 <- groupquarters3 %>%
 # select(-moe, -NAME, -GEOID)%>%
  #education = if_else(variables == no_HS, "no_HS", "HS")


