
census_api_key("55c2d218ad663e521c268658bf0c9c5c301fef30", install = TRUE, overwrite = TRUE)
readRenviron("~/.Renviron")


#load_variables
all_vars_acs5 <- 
  load_variables(year = 2019, dataset = "acs5")



#packages
library(tidycensus)
library(tidyverse)
library(ggbeeswarm)


#POVERTY STATUS IN THE PAST 12 MONTHS OF INDIVIDUALS BY SEX BY EDUCATIONAL ATTAINMENT
#Table b17003


#define poverty variables,
poorMales_noHSdiploma <- c("B17003_004")
poorMales_HSdiploma <- c("B17003_005","B17003_006","B17003_007")
poorFemales_noHSdiploma <- c("B17003_009")
poorFemales_HSdiploma <- c("B17003_010","B17003_011","B17003_012")
NotPoorMales_noHSdiploma <- c("B17003_015")
NotPoorMales_HSdiploma <- c("B17003_016","B17003_017","B17003_018")
NotPoorFemales_noHSdiploma <- c("B17003_020")
NotPoorFemales_HSdiploma <- c("B17003_021","B17003_022","B17003_023")




#dataset with the new poverty variables
state_poverty_estimate <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(poorMales_noHSdiploma, poorMales_HSdiploma, poorFemales_noHSdiploma,
                poorFemales_HSdiploma, NotPoorMales_noHSdiploma, NotPoorMales_HSdiploma,
                NotPoorFemales_noHSdiploma, NotPoorFemales_HSdiploma),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)



#rowise summary for poverty dataset
state_poverty_summary <- state_poverty_estimate %>%
  rowwise() %>%
  mutate(poorMales_noHSdip = B17003_004E,
         poorMales_HSdip = sum(B17003_005E,B17003_006E,B17003_007E),
         poorFemales_noHSdip = B17003_009E,
         poorFemales_HSdip = sum(B17003_010E,B17003_011E,B17003_012E),
         NotPoorMales_noHSdip = B17003_015E,
         NotPoorMales_HSdip = sum(B17003_016E,B17003_017E,B17003_018E),
         NotPoorFemales_noHSdip = B17003_020E,
         NotPoorFemales_HSdip = sum(B17003_021E,B17003_022E,B17003_023E)
  ) %>%
  select(NAME, poorMales_noHSdip, poorMales_HSdip, poorFemales_noHSdip,
         poorFemales_HSdip, NotPoorMales_noHSdip, NotPoorMales_HSdip,
         NotPoorFemales_noHSdip, NotPoorFemales_HSdip) %>%
  arrange(NAME) %>%
  ungroup()


#separating county name and state name
state_poverty_summary <- separate(
  state_poverty_summary,
  NAME,
  into = c("county", "state"),
  sep = ", "
)


# Deleting column with repeated state name
MI_poverty_by_edu <- state_poverty_summary %>% 
  select(-state)


#poverty dataset with totals
county_poverty_totals <- MI_poverty_by_edu %>%
  rowwise() %>%
  mutate(TOTAL = sum(c(poorMales_noHSdip, poorMales_HSdip, poorFemales_noHSdip,
                       poorFemales_HSdip, NotPoorMales_noHSdip, NotPoorMales_HSdip,
                       NotPoorFemales_noHSdip, NotPoorFemales_HSdip)))


#comparing poverty status by sex by educational attainment
MI_poverty <- county_totals %>%
  pivot_longer(!c(county, TOTAL), names_to = "variables", values_to = "count") %>%
  relocate(TOTAL, .after = count)


#poverty by sex by educational attainment group percentages per county
MI_poverty_percentage <- MI_age %>%
  mutate(percent = 100 * (count/TOTAL)) %>%
  select(county, variables, percent)


#Group wise poverty by gender by education (PGE)analysis
largest_PGE_group <- MI_poverty_percentage %>%
  group_by(county) %>%
  filter(percent == max(percent))


smallest_PGE_group <- MI_poverty_percentage %>%
  group_by(county) %>%
  filter(percent == min(percent))


#poverty plot
ggplot(MI_poverty_percentage, aes(x = variables, y = percent, color= percent)) +
  geom_quasirandom(alpha = 0.5) +
  coord_flip() +
  scale_color_viridis_c(guide = "none") +
  labs(title = "Michigan Counties Poverty Status by Sex by Educational Attainment",
       caption = "Data Source: 2015-2019 ACS\n")


#Table B15001 
#SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER 


#age by sex by education
agebyEdu <- get_acs(
  geography = "county",
  table = "B15001",
  state =  "MI",
  year = 2019
)


#define age variables}
#defining age variables by aggregating them by age, gender, and high school completion
male18to24noHSdiploma <- c("B15001_004","B15001_005")
male18to24HSdiploma <- c("B15001_006","B15001_007","B15001_008","B15001_009","B15001_010")
male25to34noHSdiploma <- c("B15001_012","B15001_013")
male25to34HSdiploma <- c("B15001_014","B15001_015","B15001_016","B15001_017","B15001_018")
male35to44noHSdiploma <- c("B15001_020","B15001_021")
male35to44HSdiploma <- c("B15001_022","B15001_023","B15001_024","B15001_025","B15001_026")
male45to64noHSdiploma <- c("B15001_028","B15001_029")
male45to64HSdiploma <- c("B15001_030","B15001_031","B15001_032","B15001_033","B15001_034")
maleAbove65noHSdiploma <- c("B15001_036","B15001_037")
maleAbove65HSdiploma <- c("B15001_038","B15001_039","B15001_040","B15001_041","B15001_042")
female18to24noHSdiploma <- c("B15001_045","B15001_046")
female18to24HSdiploma <- c("B15001_047","B15001_048","B15001_049","B15001_050","B15001_051")
female25to34noHSdiploma <- c("B15001_053","B15001_054")
female25to34HSdiploma <- c("B15001_055","B15001_056","B15001_057","B15001_058","B15001_059")
female35to44noHSdiploma <- c("B15001_061","B15001_062")
female35to44HSdiploma <- c("B15001_063","B15001_064","B15001_065","B15001_066","B15001_067")
female45to64noHSdiploma <- c("B15001_069","B15001_070")
female45to64HSdiploma <- c("B15001_071","B15001_072","B15001_073","B15001_074","B15001_075")
femaleAbove65noHSdiploma <- c("B15001_077","B15001_078")
femaleAbove65HSdiploma <- c("B15001_079","B15001_080","B15001_081","B15001_082","B15001_083")



#r dataset with new age variables

state_age_estimate <- get_acs(
  geography = "county",
  state =  "MI",
  variables = c(male18to24noHSdiploma, male18to24HSdiploma, male25to34noHSdiploma, male25to34HSdiploma,
                male35to44noHSdiploma, male35to44HSdiploma, male45to64noHSdiploma, male45to64HSdiploma,
                maleAbove65noHSdiploma, maleAbove65HSdiploma, female18to24noHSdiploma,
                female18to24HSdiploma, female25to34noHSdiploma, female25to34HSdiploma,
                female35to44noHSdiploma, female35to44HSdiploma, female45to64noHSdiploma,
                female45to64HSdiploma, femaleAbove65noHSdiploma, femaleAbove65HSdiploma),
  survey = "acs5",
  year = 2019,
  output = "wide",
  geometry = FALSE
)


#rowwise summaries for age dataset
state_age_summary <- state_age_estimate %>%
  rowwise() %>%
  mutate(
    male18to24noHSdip = sum(B15001_004E,B15001_005E),
    male18to24HSdip = sum(B15001_006E,B15001_007E,B15001_008E,B15001_009E,B15001_010E),
    male25to34noHSdip = sum(B15001_012E,B15001_013E),
    male25to34HSdip = sum(B15001_014E,B15001_015E,B15001_016E,B15001_017E,B15001_018E),
    male35to44noHSdip = sum(B15001_020E,B15001_021E),
    male35to44HSdip = sum(B15001_022E,B15001_023E,B15001_024E,B15001_025E,B15001_026E),
    male45to64noHSdip = sum(B15001_028E,B15001_029E),
    male45to64HSdip = sum(B15001_030E,B15001_031E,B15001_032E,B15001_033E,B15001_034E),
    maleAbove65noHSdip = sum(B15001_036E,B15001_037E),
    maleAbove65HSdip = sum(B15001_038E,B15001_039E,B15001_040E,B15001_041E,B15001_042E),
    female18to24noHSdip = sum(B15001_045E,B15001_046E),
    female18to24HSdip = sum(B15001_047E,B15001_048E,B15001_049E,B15001_050E,B15001_051E),
    female25to34noHSdip = sum(B15001_053E,B15001_054E),
    female25to34HSdip = sum(B15001_055E,B15001_056E,B15001_057E,B15001_058E,B15001_059E),
    female35to44noHSdip = sum(B15001_061E,B15001_062E),
    female35to44HSdip = sum(B15001_063E,B15001_064E,B15001_065E,B15001_066E,B15001_067E),
    female45to64noHSdip = sum(B15001_069E,B15001_070E),
    female45to64HSdip = sum(B15001_071E,B15001_072E,B15001_073E,B15001_074E,B15001_075E),
    femaleAbove65noHSdip = sum(B15001_077E,B15001_078E),
    femaleAbove65HSdip = sum(B15001_079E,B15001_080E,B15001_081E,B15001_082E,B15001_083E)
  ) %>%
  select(NAME, male18to24noHSdip, male18to24HSdip, male25to34noHSdip, male25to34HSdip,
         male35to44noHSdip, male35to44HSdip, male45to64noHSdip, male45to64HSdip, maleAbove65noHSdip,
         maleAbove65HSdip, female18to24noHSdip, female18to24HSdip, female25to34noHSdip, female25to34HSdip,
         female35to44noHSdip, female35to44HSdip, female45to64noHSdip, female45to64HSdip, 
         femaleAbove65noHSdip, femaleAbove65HSdip) %>%
  arrange(NAME) %>%
  ungroup()



#separating NAME for age data}


state_age_summary <- separate(
  state_age_summary,
  NAME,
  into = c("county", "state"),
  sep = ", "
)


#tidy age dataset
MI_age_by_edu <- state_age_summary %>% 
  select(-state)


#age data set with totals
county_totals <- MI_age_by_edu %>%
  rowwise() %>%
  mutate(TOTAL = sum(c(male18to24noHSdip, male18to24HSdip, male25to34noHSdip,
                       male25to34HSdip, male35to44noHSdip, male35to44HSdip,
                       male45to64noHSdip, male45to64HSdip, maleAbove65noHSdip,
                       maleAbove65HSdip, female18to24noHSdip, female18to24HSdip,
                       female25to34noHSdip, female25to34HSdip, female35to44noHSdip,
                       female35to44HSdip, female45to64noHSdip, female45to64HSdip,
                       femaleAbove65noHSdip, femaleAbove65HSdip)))



#Comparing age by gender by educational attainment in MI.
MI_age <- county_totals  %>%
  pivot_longer(!c(county,TOTAL), names_to = "variables", values_to = "count") %>%
  relocate(TOTAL, .after = count)

#age by gender by education for all counties 
MI_age_percent <- MI_age %>%
  mutate(percent = 100 * (count / TOTAL)) %>%
  select(county, variables, percent)


#Group-wise age by gender by educational (AGE) analysis
largest_AGE_group <- MI_age_percent %>%
  group_by(county) %>%
  filter(percent == max(percent))
  
least_AGE_group <- MI_age_percent %>%
  group_by(county) %>%
  filter(percent == min(percent))


ggplot(MI_age_percent, aes(x = variables, y = percent, color= percent)) +
  geom_quasirandom(alpha = 0.5) +
  coord_flip() +
  scale_color_viridis_c(guide = "none") +
  labs(title = "Michigan Counties Sex by Age by Educational Attainment for the Population 18 and Over.",
       caption = "Data Source: 2015-2019 ACS\n")

  
