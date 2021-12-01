# project418-518

Welcome to our STA 418/518 project GitHub!

Members: Abby Simons-Scalise, Alex Gichuki, and Meghan Nash

---------------------------------------------------------------------------

Overview:

We hope to investigate and analyze graduation rates for Michigan high school students. We plan to use logistic regression (unless the data does not fit the necessary assumptions) to identify if certain characteristics have an effect on whether a student graduates high school or not. We will be using US Census data and creating visuals for possible factors that may affect graduation rate.

---------------------------------------------------------------------------

The variables/characteristics we are looking at are:
- GROUP QUARTERS TYPE (5 TYPES) BY EDUCATIONAL ATTAINMENT - Abby, table B26201. This is a count of people in a correctional facility and their educational attainment (shows crime rates according to education level).
- SEX BY SCHOOL ENROLLMENT BY EDUCATIONAL ATTAINMENT BY EMPLOYMENT STATUS - Abby, table B14005. This compares sex by employment and school status. It allows us to see if people graduated high school and are enrolled in school (meaning continued to college) or are in the workforce.
- POVERTY STATUS IN THE PAST 12 MONTHS OF FAMILIES BY HOUSEHOLD TYPE BY EDUCATIONAL ATTAINMENT - Alex, table B17018. This compares people below or equal to federal poverty level (within last 12 months) by family structures and education level reached.
- POVERTY STATUS IN THE PAST 12 MONTHS OF INDIVIDUALS BY SEX BY EDUCATIONAL ATTAINMENT - Alex, table B17003. This compares people below or equal to federal poverty level (within last 12 months) by sex (male/female).
- SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER - Alex, table B15001. This compares sex (male/female) by education level achieved, broken down by age groups.
- MEDIAN EARNINGS IN THE PAST 12 MONTHS (IN 2019 INFLATION-ADJUSTED DOLLARS) BY SEX BY EDUCATIONAL ATTAINMENT - Meghan, table B20004. This compares education by income and sex (male/female).
- EDUCATIONAL ATTAINMENT AND EMPLOYMENT STATUS BY LANGUAGE SPOKEN AT HOME - Meghan, table B16010. This compares if people are native English speakers (do they speak a different language at home) and compare education levels.
- CITIZEN, VOTING-AGE POPULATION BY EDUCATIONAL ATTAINMENT - Meghan, table B29002. This is a count of those older than 18 and what their education level is. This lets us easily get the graduation rates for the entire population.

---------------------------------------------------------------------------

Here are some useful links:

Documentation:
https://rstudio-pubs-static.s3.amazonaws.com/541247_e7b707cd2f71405bb5624517877785ff.html
https://www.census.gov/programs-surveys/acs/guidance/handbooks/general.html

ACS package:
https://cran.r-project.org/web/packages/acs/readme/README.html

Tidycensus package:
https://github.com/walkerke/umich-workshop

https://dcl-wrangle.stanford.edu/census.html#census-bureau-basics

https://walker-data.com/isds-webinar/#34

https://walker-data.com/tidycensus/articles/spatial-data.html

https://walker-data.com/tidycensus/articles/basic-usage.html#geography-in-tidycensus

https://walker-data.com/census-r/wrangling-census-data-with-tidyverse-tools.html
