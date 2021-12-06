################### Use this R File ##########################################

# Load in needed packages
library(tidycensus)
library(tidyverse)
options(tigris_use_cache = TRUE)
library(ggbeeswarm)
library(ggridges)
library(dplyr)
library(leaflet)
library(sf)
library(packcircles)
library(ggplot2)
library(viridis)
library(ggiraph)

# Load in census api key - need to access census data
census_api_key("e9df2097261bae1ad446e25f6d7a62746f68e2a4", install = TRUE)

# Doing only one year to avoid errors
all_vars_acs5 <-
  load_variables(year = 2019, dataset = "acs5")


################### Loading in Variables ####################################

## MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)
## BY SEX BY EDUCATIONAL ATTAINMENT
## B20004
# total - no sex division
median_earn_total <- ("B20004_001")
median_earn_less_hs <- ("B20004_002")
median_earn_hs <- ("B20004_003")
median_earn_college <- ("B20004_004")
median_earn_bach_deg <- ("B20004_005")
median_earn_grad_deg <- ("B20004_006")
# male
median_earn_male <- ("B20004_007")
median_earn_male_less_hs <- ("B20004_008")
median_earn_male_hs <- ("B20004_009")
median_earn_male_college <- ("B20004_010")
median_earn_male_bach_deg <- ("B20004_011")
median_earn_male_grad_deg <- ("B20004_012")
# female
median_earn_fem <- ("B20004_013")
median_earn_fem_less_hs <- ("B20004_014")
median_earn_fem_hs <- ("B20004_015")
median_earn_fem_college <- ("B20004_016")
median_earn_fem_bach_deg <- ("B20004_017")
median_earn_fem_grad_deg <- ("B20004_018")


## EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME
## B16010
edu_emp_lang_total <- ("B16010_001")
# less than high school
edu_emp_lang_less_hs <- ("B16010_002")
edu_emp_lang_less_hs_work <- ("B16010_003")
edu_emp_lang_less_hs_work_eng <- ("B16010_004")
edu_emp_lang_less_hs_work_spanish <- ("B16010_005")
edu_emp_lang_less_hs_work_indoEurop <- ("B16010_006")
edu_emp_lang_less_hs_work_asian <- ("B16010_007")
edu_emp_lang_less_hs_work_other <- ("B16010_008")
edu_emp_lang_less_hs_NOTwork <- ("B16010_009")
edu_emp_lang_less_hs_NOTwork_eng <- ("B16010_010")
edu_emp_lang_less_hs_NOTwork_spanish <- ("B16010_011")
edu_emp_lang_less_hs_NOTwork_indoEurop <- ("B16010_012")
edu_emp_lang_less_hs_NOTwork_asian <- ("B16010_013")
edu_emp_lang_less_hs_NOTwork_other <- ("B16010_014")

# high school graduate
edu_emp_lang_hs <- ("B16010_015")
edu_emp_lang_hs_work <- ("B16010_016")
edu_emp_lang_hs_work_eng <- ("B16010_017")
edu_emp_lang_hs_work_spanish <- ("B16010_018")
edu_emp_lang_hs_work_indoEurop <- ("B16010_019")
edu_emp_lang_hs_work_asian <- ("B16010_020")
edu_emp_lang_hs_work_other <- ("B16010_021")
edu_emp_lang_hs_NOTwork <- ("B16010_022")
edu_emp_lang_hs_NOTwork_eng <- ("B16010_023")
edu_emp_lang_hs_NOTwork_spanish <- ("B16010_024")
edu_emp_lang_hs_NOTwork_indoEurop <- ("B16010_025")
edu_emp_lang_hs_NOTwork_asian <- ("B16010_026")
edu_emp_lang_hs_NOTwork_other <- ("B16010_027")

# some college
edu_emp_lang_college <- ("B16010_028")
edu_emp_lang_college_work <- ("B16010_029")
edu_emp_lang_college_work_eng <- ("B16010_030")
edu_emp_lang_college_work_spanish <- ("B16010_031")
edu_emp_lang_college_work_indoEurop <- ("B16010_032")
edu_emp_lang_college_work_asian <- ("B16010_033")
edu_emp_lang_college_work_other <- ("B16010_034")
edu_emp_lang_college_NOTwork <- ("B16010_035")
edu_emp_lang_college_NOTwork_eng <- ("B16010_036")
edu_emp_lang_college_NOTwork_spanish <- ("B16010_037")
edu_emp_lang_college_NOTwork_indoEurop <- ("B16010_038")
edu_emp_lang_college_NOTwork_asian <- ("B16010_039")
edu_emp_lang_college_NOTwork_other <- ("B16010_040")

# bachelors degree or higher
edu_emp_lang_bach_deg <- ("B16010_041")
edu_emp_lang_bach_deg_work <- ("B16010_042")
edu_emp_lang_bach_deg_work_eng <- ("B16010_043")
edu_emp_lang_bach_deg_work_spanish <- ("B16010_044")
edu_emp_lang_bach_deg_work_indoEurop <- ("B16010_045")
edu_emp_lang_bach_deg_work_asian <- ("B16010_046")
edu_emp_lang_bach_deg_work_other <- ("B16010_047")
edu_emp_lang_bach_deg_NOTwork <- ("B16010_048")
edu_emp_lang_bach_deg_NOTwork_eng <- ("B16010_049")
edu_emp_lang_bach_deg_NOTwork_spanish <- ("B16010_050")
edu_emp_lang_bach_deg_NOTwork_indoEurop <- ("B16010_051")
edu_emp_lang_bach_deg_NOTwork_asian <- ("B16010_052")
edu_emp_lang_bach_deg_NOTwork_other <- ("B16010_053")


## CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT
## B29002
voting_age_total <- ("B29002_001")
# voting_age_below_9th <- ("B29002_002")
voting_age_hs <- ("B29002_003")
voting_age_hs_grad <- ("B29002_004")
voting_age_college <- ("B29002_005")
voting_age_assoc <- ("B29002_006")
voting_age_bach <- ("B29002_007")
voting_age_grad <- ("B29002_008")


################### Making the datasets ####################################

## MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)
## BY SEX BY EDUCATIONAL ATTAINMENT
# total - no sex division
med_earn_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(median_earn_total, median_earn_less_hs, median_earn_hs, 
                median_earn_college, median_earn_bach_deg,
                median_earn_grad_deg),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# male
med_earn_male_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(median_earn_male, median_earn_male_less_hs, median_earn_male_hs, 
                median_earn_male_college, median_earn_male_bach_deg, 
                median_earn_male_grad_deg),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# female
med_earn_fem_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(median_earn_fem, median_earn_fem_less_hs, median_earn_fem_hs, 
                median_earn_fem_college, median_earn_fem_bach_deg, 
                median_earn_fem_grad_deg),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)


## EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME
# total - no divisions
edu_emp_lang_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_total),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# less than high school
edu_emp_lang_less_hs_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_less_hs, edu_emp_lang_less_hs_work,
                edu_emp_lang_less_hs_work_eng,
                edu_emp_lang_less_hs_work_spanish,
                edu_emp_lang_less_hs_work_indoEurop,
                edu_emp_lang_less_hs_work_asian,
                edu_emp_lang_less_hs_work_other,
                edu_emp_lang_less_hs_NOTwork,
                edu_emp_lang_less_hs_NOTwork_eng,
                edu_emp_lang_less_hs_NOTwork_spanish,
                edu_emp_lang_less_hs_NOTwork_indoEurop,
                edu_emp_lang_less_hs_NOTwork_asian,
                edu_emp_lang_less_hs_NOTwork_other),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# high school
edu_emp_lang_hs_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_hs, edu_emp_lang_hs_work, 
                edu_emp_lang_hs_work_eng,
                edu_emp_lang_hs_work_spanish,
                edu_emp_lang_hs_work_indoEurop,
                edu_emp_lang_hs_work_asian,
                edu_emp_lang_hs_work_other,
                edu_emp_lang_hs_NOTwork,
                edu_emp_lang_hs_NOTwork_eng,
                edu_emp_lang_hs_NOTwork_spanish,
                edu_emp_lang_hs_NOTwork_indoEurop,
                edu_emp_lang_hs_NOTwork_asian,
                edu_emp_lang_hs_NOTwork_other),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# some college
edu_emp_lang_college_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_college, edu_emp_lang_college_work,
                edu_emp_lang_college_work_eng,
                edu_emp_lang_college_work_spanish,
                edu_emp_lang_college_work_indoEurop,
                edu_emp_lang_college_work_asian,
                edu_emp_lang_college_work_other,
                edu_emp_lang_college_NOTwork,
                edu_emp_lang_college_NOTwork_eng,
                edu_emp_lang_college_NOTwork_spanish,
                edu_emp_lang_college_NOTwork_indoEurop,
                edu_emp_lang_college_NOTwork_asian,
                edu_emp_lang_college_NOTwork_other),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)
# bachelor's degree or higher
edu_emp_lang_bach_deg_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_bach_deg, edu_emp_lang_bach_deg_work_eng,
                edu_emp_lang_bach_deg_work_spanish,
                edu_emp_lang_bach_deg_work_indoEurop,
                edu_emp_lang_bach_deg_work_asian,
                edu_emp_lang_bach_deg_work_other,
                edu_emp_lang_bach_deg_NOTwork,
                edu_emp_lang_bach_deg_NOTwork_eng,
                edu_emp_lang_bach_deg_NOTwork_spanish,
                edu_emp_lang_bach_deg_NOTwork_indoEurop,
                edu_emp_lang_bach_deg_NOTwork_asian,
                edu_emp_lang_bach_deg_NOTwork_other),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)


## CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT
voting_age_ds <- get_acs(
  geography = "state",
  state =  "MI",
  # county = "Kent",
  variables = c(voting_age_hs, voting_age_hs_grad, 
                voting_age_college, voting_age_assoc, voting_age_bach,
                voting_age_grad),
  survey = "acs5",
  year = 2019,
  # output = "wide",
  summary_var=voting_age_total,
  geometry = FALSE
)


################### Combining Variables #######################################

## EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME
# combining high school graduate, some college, and bachelors or higher
edu_emp_lang_grad <- c("B16010_015", "B16010_028", "B16010_041")
edu_emp_lang_grad_work <- c("B16010_016", "B16010_029", "B16010_042")
edu_emp_lang_grad_work_eng <- c("B16010_017", "B16010_030", "B16010_043")
edu_emp_lang_grad_work_spanish <- c("B16010_018", "B16010_031", "B16010_044")
edu_emp_lang_grad_work_indoEurop <- c("B16010_019", "B16010_031", "B16010_045")
edu_emp_lang_grad_work_asian <- c("B16010_020", "B16010_033", "B16010_046")
edu_emp_lang_grad_work_other <- c("B16010_021", "B16010_034", "B16010_047")
edu_emp_lang_grad_NOTwork <- c("B16010_022", "B16010_035", "B16010_048")
edu_emp_lang_grad_NOTwork_eng <- c("B16010_023", "B16010_036", "B16010_049")
edu_emp_lang_grad_NOTwork_spanish <- c("B16010_024", "B16010_037", "B16010_050")
edu_emp_lang_grad_NOTwork_indoEurop <- c("B16010_025", "B16010_038", "B16010_051")
edu_emp_lang_grad_NOTwork_asian <- c("B16010_026", "B16010_039", "B16010_052")
edu_emp_lang_grad_NOTwork_other <- c("B16010_027", "B16010_040", "B16010_053")

## MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)
## BY SEX BY EDUCATIONAL ATTAINMENT
# combining earnings
total_earn <- c(total = "B20004_001",
                male = "B20004_007",
                female = "B20004_013")
less_hs_earn <- c(total = "B20004_002",
                male = "B20004_008",
                female = "B20004_014")
hs_earn <- c(total = "B20004_003",
                  male = "B20004_009",
                  female = "B20004_015")
college_earn <- c(total = "B20004_004",
             male = "B20004_010",
             female = "B20004_016")
bach_earn <- c(total = "B20004_005",
                  male = "B20004_011",
                  female = "B20004_017")
grad_earn <- c(total = "B20004_006",
                  male = "B20004_012",
                  female = "B20004_018")

edu_emp_lang_less_hs <- ("B16010_002")
edu_emp_lang_less_hs_work <- ("B16010_003")
edu_emp_lang_less_hs_work_eng <- ("B16010_004")
edu_emp_lang_less_hs_work_spanish <- ("B16010_005")
edu_emp_lang_less_hs_work_indoEurop <- ("B16010_006")
edu_emp_lang_less_hs_work_asian <- ("B16010_007")
edu_emp_lang_less_hs_work_other <- ("B16010_008")
edu_emp_lang_less_hs_NOTwork <- ("B16010_009")
edu_emp_lang_less_hs_NOTwork_eng <- ("B16010_010")
edu_emp_lang_less_hs_NOTwork_spanish <- ("B16010_011")
edu_emp_lang_less_hs_NOTwork_indoEurop <- ("B16010_012")
edu_emp_lang_less_hs_NOTwork_asian <- ("B16010_013")
edu_emp_lang_less_hs_NOTwork_other <- ("B16010_014")

## EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME
# combining languages 
employed_lessHS <- c(lessHS_eng = "B16010_004", 
                     lessHS_spanish = "B16010_005", 
                     lessHS_indoEurop = "B16010_006", 
                     lessHS_asian = "B16010_007",
                     lessHS_other = "B16010_008")

UNemployed_lessHS <- c(lessHS_eng = "B16010_010", 
                       lessHS_spanish = "B16010_011", 
                       lessHS_indoEurop = "B16010_012", 
                       lessHS_asian = "B16010_013",
                       lessHS_other = "B16010_014")

################### New Dataset with Combined Vars ############################

## Making the new education, employment, and language dataset
edu_emp_lang_comb_ds <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(edu_emp_lang_grad, edu_emp_lang_grad_work,
                edu_emp_lang_grad_work_eng, 
                edu_emp_lang_grad_work_spanish, 
                edu_emp_lang_grad_work_indoEurop, 
                edu_emp_lang_grad_work_asian, 
                edu_emp_lang_grad_work_other, 
                edu_emp_lang_grad_NOTwork, 
                edu_emp_lang_grad_NOTwork_eng, 
                edu_emp_lang_grad_NOTwork_spanish, 
                edu_emp_lang_grad_NOTwork_indoEurop, 
                edu_emp_lang_grad_NOTwork_asian, 
                edu_emp_lang_grad_NOTwork_other),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)


# making rowwise summaries for the edu/emp/lang dataset
edu_emp_lang_comb_summary <- edu_emp_lang_comb_ds %>%
  rowwise() %>%
  mutate(
    edu_emp_lang_grad = sum(B16010_015E, B16010_028E, B16010_041E), 
    edu_emp_lang_grad_work = sum(B16010_016E, B16010_029E, B16010_042E),
    edu_emp_lang_grad_work_eng = sum(B16010_017E, B16010_030E, B16010_043E),
    edu_emp_lang_grad_work_spanish = sum(B16010_018E, B16010_031E, B16010_044E),
    edu_emp_lang_grad_work_indoEurop = sum(B16010_019E, B16010_031E, B16010_045E),
    edu_emp_lang_grad_work_asian = sum(B16010_020E, B16010_033E, B16010_046E),
    edu_emp_lang_grad_work_other = sum(B16010_021E, B16010_034E, B16010_047E),
    edu_emp_lang_grad_NOTwork = sum(B16010_022E, B16010_035E, B16010_048E),
    edu_emp_lang_grad_NOTwork_eng = sum(B16010_023E, B16010_036E, B16010_049E),
    edu_emp_lang_grad_NOTwork_spanish = sum(B16010_024E, B16010_037E, B16010_050E),
    edu_emp_lang_grad_NOTwork_indoEurop = sum(B16010_025E, B16010_038E, B16010_051E),
    edu_emp_lang_grad_NOTwork_asian = sum(B16010_026E, B16010_039E, B16010_052E),
    edu_emp_lang_grad_NOTwork_other = sum(B16010_027E, B16010_040E, B16010_053E)
  ) %>%
  select(NAME, edu_emp_lang_grad, edu_emp_lang_grad_work, edu_emp_lang_grad_work_eng, 
         edu_emp_lang_grad_work_spanish, edu_emp_lang_grad_work_indoEurop, 
         edu_emp_lang_grad_work_asian, edu_emp_lang_grad_work_other, 
         edu_emp_lang_grad_NOTwork, edu_emp_lang_grad_NOTwork_eng, 
         edu_emp_lang_grad_NOTwork_spanish, edu_emp_lang_grad_NOTwork_indoEurop, 
         edu_emp_lang_grad_NOTwork_asian, edu_emp_lang_grad_NOTwork_other) %>%
  arrange(NAME) %>%
  ungroup()

employed_HS <- c(HS_eng = edu_emp_lang_grad_work_eng, 
                 HS_spanish = edu_emp_lang_grad_work_spanish, 
                 HS_indoEurop = edu_emp_lang_grad_work_indoEurop, 
                 HS_asian = edu_emp_lang_grad_work_asian,
                 HS_other = edu_emp_lang_grad_work_other)

UNemployed_HS <- c(HS_eng = edu_emp_lang_grad_NOTwork_eng, 
                   HS_spanish = edu_emp_lang_grad_NOTwork_spanish, 
                   HS_indoEurop = edu_emp_lang_grad_work_indoEurop, 
                   HS_asian = edu_emp_lang_grad_work_asian,
                   HS_other = edu_emp_lang_grad_work_other)

################### Getting Percents for Pie Chart ############################

voting_age_perc <- voting_age_ds %>%
  mutate(percent = 100 * (estimate / summary_est)) %>%
  select(NAME, variable, percent)


################### Graphs #############################################

## MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS)
## BY SEX BY EDUCATIONAL ATTAINMENT
## interactive leaflet plot

# Male High School Earn
m_hs_county <- get_acs(geography = "county", 
               variables = c(median_earn_male_hs = "B20004_009"), 
               state = "MI", 
               geometry = TRUE) %>%
  st_transform(4326)

m_hs_tract <- get_acs(geography = "tract", 
               variables = c(median_earn_male_hs = "B20004_009"), 
               state = "MI", 
               geometry = TRUE) %>%
  st_transform(4326)

bins <- c(10000, 15000, 20000, 25000, 30000, 35000, 40000, 45000, 
          50000, 55000, 60000, 65000, 70000, 75000, 80000, 85000, 
          90000, 95000, 100000)
################################################# ERROR need to figure out bins
#can do 10000-55000 for county
#need up to 100000 for tract

pala <- colorBin("viridis", m_hs_county$estimate, bins = bins)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = m_hs_county, stroke = FALSE, smoothFactor = 0.2, 
              color = ~pala(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Counties") %>%
  addPolygons(data = m_hs_tract, stroke = FALSE, smoothFactor = 0.2, 
              color = ~pala(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Tracts") %>%
  addLegend(pal = pala, values = m_hs_county$estimate, 
            title = "Male Earnings with HS Diploma") %>%
  addLayersControl(overlayGroups = c("Tracts", "Counties")) %>%
  hideGroup("Tracts")

# Female High School Earn
f_hs_county <- get_acs(geography = "county", 
                       variables = c(median_earn_fem_hs = "B20004_015"), 
                       state = "MI", 
                       geometry = TRUE) %>%
  st_transform(4326)

f_hs_tract <- get_acs(geography = "tract", 
                      variables = c(median_earn_fem_hs = "B20004_015"), 
                      state = "MI", 
                      geometry = TRUE) %>%
  st_transform(4326)

binsC <- c(15000, 20000, 25000, 30000)
binsT <- c(15000, 20000, 25000, 30000, 35000, 40000, 45000)
################################################# ERROR need to figure out bins
# county - only need 15000 - 30000
# need more for tracts

palaC <- colorBin("viridis", f_hs_county$estimate, bins = binsC)
palaT <- colorBin("viridis", f_hs_county$estimate, bins = binsT)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = f_hs_county, stroke = FALSE, smoothFactor = 0.2, 
              color = ~palaC(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Counties") %>%
  addPolygons(data = f_hs_tract, stroke = FALSE, smoothFactor = 0.2, 
              color = ~palaT(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Tracts") %>%
  addLegend(pal = palaC, values = f_hs_county$estimate, 
            title = "Female Earnings with HS Diploma") %>%
  addLegend(pal = palaT, values = f_hs_tract$estimate, 
            title = "Female Earnings with HS Diploma") %>%
  addLayersControl(overlayGroups = c("Tracts", "Counties")) %>%
  hideGroup("Tracts")

## EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME
## facet plots
# employed, less than HS
kent_tracts <- get_acs(geography = "tract",
                       variables = employed_lessHS, 
                       state = "MI",
                       county = "Kent County",
                       geometry = TRUE,
                       summary_var = "B20004_001") 

kent_tracts <- kent_tracts %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts %>% 
  ggplot(aes(fill = pct)) +
  geom_sf(color = NA) +
  facet_wrap(~variable) +
  scale_fill_viridis_c()

# unemployed, less than hs
kent_tracts <- get_acs(geography = "tract",
                       variables = UNemployed_lessHS, 
                       state = "MI",
                       county = "Kent County",
                       geometry = TRUE,
                       summary_var = "B20004_001") 

kent_tracts <- kent_tracts %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts %>% 
  ggplot(aes(fill = pct)) +
  geom_sf(color = NA) +
  facet_wrap(~variable) +
  scale_fill_viridis_c()

# employed, hs or higher
########################################### ERROR did not combine var correctly
kent_tracts_HS <- get_acs(geography = "tract",
                       variables = employed_HS, 
                       state = "MI",
                       county = "Kent County",
                       geometry = TRUE,
                       summary_var = "B20004_001") 

kent_tracts_HS <- kent_tracts_HS %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts_HS %>% 
  ggplot(aes(fill = pct)) +
  geom_sf(color = NA) +
  facet_wrap(~variable) +
  scale_fill_viridis_c()

# employed, hs or higher
########################################## ERROR did not combine var correctly
kent_tracts_HS <- get_acs(geography = "tract",
                       variables = UNemployed_HS, 
                       state = "MI",
                       county = "Kent County",
                       geometry = TRUE,
                       summary_var = "B20004_001") 

kent_tracts_HS <- kent_tracts_HS %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts_HS %>% 
  ggplot(aes(fill = pct)) +
  geom_sf(color = NA) +
  facet_wrap(~variable) +
  scale_fill_viridis_c()


## CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT
## Do pie chart (with percents)
################################################ ERROR position of the labels
voting_age_label <- voting_age_perc %>% 
  arrange(desc(variable)) %>%
  mutate(prop = percent / sum(voting_age_perc$percent) *100) %>%
  mutate(ypos = cumsum(percent)- 0.5*percent)
# pie chart
ggplot(voting_age_perc, aes(x="", y=variable, fill=percent)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void() + # remove background, grid, numeric labels
  theme(legend.position="none") + #remove legend
  geom_text(aes(label = percent), color = "white", size=6) #add labels


# classic bar chart
voting_age_perc %>%
  ggplot( aes(x=variable, y=percent)) +
  geom_bar(stat="identity", fill="#f68060", alpha=.6, width=.4) +
  coord_flip() +
  xlab("") +
  theme_bw()+
  scale_x_discrete(labels = c('High School, No Diploma','High School Graduate', 
                              'Some College, No Degree', 'Associates Degree', 
                              'Bachelors Degree', 'Graduate Degree or Higher'))+
  labs(title = "Percent of MI Voting-Age Population by Educational Attainment", 
       subtitle = "2019 5-year ACS estimates", 
       y = "Percent", 
       x = "Education Level", 
       caption = "Source: ACS Data Table B29002 via the tidycensus R package") 

