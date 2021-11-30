---
title: "Abby Code2"
author: "Abby"
date: "11/28/2021"
output:
  html_document: default
  pdf_document: default
---

```{r, Libraries, message = FALSE}
library(tidyverse)
library(tidycensus)
library(ggridges)
library(dplyr)
library(tigris)
options(tigris_use_cache = TRUE)
library(leaflet)
library(sf)
library(packcircles)
library(ggplot2)
library(viridis)
library(ggiraph)
library(ggbeeswarm)
```

```{r, load_variables}
#census_api_key("67cbcd7b6d617916475eb5bd88439380a2511582", install = TRUE)
#readRenviron("~/.Renviron")

all_vars_acs5 <- 
  load_variables(year = 2019, dataset = "acs5")
```


```{r, group_quarters3_define_variables_B26201}
adult_prison_total <- ("B26106_016")
ap_noHS <- ("B26106_017")
ap_HS <- c("B26106_018", "B26106_019", "B26106_020")
```

```{r, prison_plots_bar_chart}
#state_ap_estimates <- get_acs(
#  geography = "state",
#  state =  "MI",
#  variables = c(ap_noHS, ap_HS),
#  survey = "acs5",
#  year = 2019,
#  output = "wide",
#  geometry = FALSE
#)

#ap_summary <- state_ap_estimates %>%
 # rowwise() %>%
#  mutate(ap_noHS = B26106_017E,
 #        ap_HS = sum(B26106_020E,B26106_019E,B26106_018E),
  #      ) %>%
 # select(NAME,ap_HS,ap_noHS ) %>%
#  arrange(NAME) %>%
#  ungroup()

mi_prison <- get_acs(
  geography = "state",
  state = "MI",
  variables = c(ap_noHS, ap_HS),
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
  scale_x_discrete(labels = c('No High School','High School Graduate','Some College', 'Bachelors or Higher'))+
  labs(title = "Percent of MI Prison Population by Educational Attainment", 
     subtitle = "2019 5-year ACS estimates", 
     y = "Percent", 
     x = "Education Level", 
     caption = "Source: ACS Data Table B26106 via the tidycensus R package") 
```

```{r, define_variables_jobs}

#enrolled in school
FnoHS_employed <- ("B14005_027")
FnoHS_unemployed <- ("B14005_028")
FnoHS_notinlaborforce <- ("B14005_029")
FHS_employed <- ("B14005_023")
FHS_unemployed <- ("B14005_024")
FHS_notinlaborforce <-("B14005_025")
MnoHS_employed <- ("B14005_013")
MnoHS_unemployed <- ("B14005_014")
MnoHS_notinlaborforce <-("B14005_015")
MHS_employed <- ("B14005_009")
MHS_unemployed <- ("B14005_010")
MHS_notinlaborforce <- ("B14005_011")

employed <- c(Male_No_HS = "B14005_013", 
              Male_HS = "B14005_009", 
              Female_No_HS = "B14005_027", 
              Female_HS = "B14005_023")
unemployed <- c(Male_No_HS = "B14005_014", 
              Male_HS = "B14005_010", 
              Female_No_HS = "B14005_028", 
              Female_HS = "B14005_024")
nilf <- c(Male_No_HS = "B14005_014", 
              Male_HS = "B14005_011", 
              Female_No_HS = "B14005_029", 
              Female_HS = "B14005_025")

```

```{r, labor_force_plots_employed}

#Kent county, employed
kent_tracts <- get_acs(geography = "tract", variables = employed, 
                        state = "MI", county = "Kent County", geometry = TRUE,
                        summary_var = "B14005_001") 

kent_tracts <- kent_tracts %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()

#wayne county, employed
wayne_tracts <- get_acs(geography = "tract", variables = employed, 
                        state = "MI", county = "Wayne County", geometry = TRUE,
                        summary_var = "B14005_001") 

wayne_tracts <- wayne_tracts %>% 
  mutate(pct = 100 * estimate / summary_est)

wayne_tracts %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()
```

```{r, labor_force_plots_unemployed}}
#Kent county, unemployed
kent_tracts2 <- get_acs(geography = "tract", variables = unemployed, 
                        state = "MI", county = "Kent County", geometry = TRUE,
                        summary_var = "B14005_001") 

kent_tracts2 <- kent_tracts2 %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts2 %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()

#wayne county, unemployed
wayne_tracts2 <- get_acs(geography = "tract", variables = unemployed, 
                        state = "MI", county = "Wayne County", geometry = TRUE,
                        summary_var = "B14005_001") 

wayne_tracts2 <- wayne_tracts2 %>% 
  mutate(pct = 100 * estimate / summary_est)

wayne_tracts2 %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()
```


```{r, not_in_labor_force}

#Kent county, employed
kent_tracts3 <- get_acs(geography = "tract", variables = nilf, 
                        state = "MI", county = "Kent County", geometry = TRUE,
                        summary_var = "B14005_001") 

kent_tracts3 <- kent_tracts3 %>% 
  mutate(pct = 100 * estimate / summary_est)

kent_tracts3 %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()

#wayne county, employed
wayne_tracts3 <- get_acs(geography = "tract", variables = nilf, 
                        state = "MI", county = "Wayne County", geometry = TRUE,
                        summary_var = "B14005_001") 

wayne_tracts3 <- wayne_tracts3 %>% 
  mutate(pct = 100 * estimate / summary_est)

wayne_tracts3 %>% 
  ggplot(aes(fill = pct)) +
    geom_sf(color = NA) +
    facet_wrap(~variable) +
    scale_fill_viridis_c()
```


```{r, leaflet_MI}

mi1 <- get_acs(geography = "county", 
               variables = c(Male_HS_employed = "B14005_023"), 
               state = "MI", 
               geometry = TRUE) %>%
  st_transform(4326)

mi2 <- get_acs(geography = "tract", 
               variables = c(Male_HS_employed = "B14005_023"), 
               state = "MI", 
               geometry = TRUE) %>%
  st_transform(4326)

bins <- c(0, 10, 20,30,40,50,60,70,80,90,100)

pala <- colorBin("viridis", mi1$estimate, bins = bins)

leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(data = mi1, stroke = FALSE, smoothFactor = 0.2, 
              color = ~pala(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Counties") %>%
  addPolygons(data = mi2, stroke = FALSE, smoothFactor = 0.2, 
              color = ~pala(estimate), 
              label = ~as.character(estimate), 
              fillOpacity = 0.8, 
              group = "Tracts") %>%
  addLegend(pal = pala, values = mi1$estimate, 
            title = "Population Males Employed with HS Diploma") %>%
  addLayersControl(overlayGroups = c("Tracts", "Counties")) %>%
  hideGroup("Tracts")
```

