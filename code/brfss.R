# Format BRFSS Data
library(tidyverse)

library(rvest)
library(xml2)

# Codebook: https://www.cdc.gov/brfss/annual_data/2018/pdf/codebook18_llcp-v2-508.pdf
# Orig data: https://www.cdc.gov/brfss/annual_data/2018/files/LLCP2018ASC.zip

variables <- read_html("https://www.cdc.gov/brfss/annual_data/2018/llcp_varlayout_18_onecolumn.html") %>%
  html_table() %>%
  `[[`(1)

variables <- variables %>%
  mutate(varname = `Variable Name` %>% str_remove("^[[:punct:]]"))


brfss <- read_fwf("data/BRFSS_2018_full.txt",
                  col_positions = fwf_positions(variables$`Starting Column`,
                                                variables$`Starting Column` + variables$`Field Length` - 1),
                  guess_max = 437436)
brfss <- set_names(brfss, variables$varname)

ne_brfss <- filter(brfss, STATE == "31")


brfss_subset <- select(brfss, STATE, SEX1, HEIGHT3, WEIGHT2,
                       SMOKER3, ALCDAY5, AVEDRNK2, DRNK3GE5, MAXDRNKS, RFBING5, RFDRHV6,
                       FLUSHOT6, SEATBELT, PREDIAB1,
                       PRACE1, MRACE1, IMPRACE,
                       MENT14D, PHYS14D, AGEG5YR, EDUCAG, INCOMG)

brfss1 <- brfss_subset %>%
  select(STATE, SEX1, SMOKER3, RFBING5, RFDRHV6, IMPRACE, AGEG5YR, EDUCAG, INCOMG)

write_csv(brfss1, "data/06_brfss_factors.csv", na = '.')


library(maps)
library(mapproj)
us_states <- map_data("state")
fips_map <- state.fips %>%
  mutate(polyname = str_remove(polyname, ":main") %>% str_remove(., ":north"))
us_states <- us_states %>%
  left_join(select(fips_map, STATE = fips, region = polyname))


ggplot(data = us_states, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") + coord_map()

ggplot(data = us_states, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = STATE), colour = "black") + coord_map()

ggplot(data = us_states, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = factor(STATE)), colour = "black") + coord_map()
