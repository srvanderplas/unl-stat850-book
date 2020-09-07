# Step 1: Get the data

brewing_materials <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewing_materials.csv')
beer_taxed <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_taxed.csv')
brewer_size <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewer_size.csv')
beer_states <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/beer_states.csv')

# Beer states table
head(beer_states)

table(beer_states$type)

# install.packages("skimr")
library(skimr)

skim(beer_states)

# install.packages("ggplot2")
library(ggplot2)

beer_states %>%
  ggplot(aes(x = year, y = barrels, group = state)) +
  geom_line() +
  facet_wrap(~type, scales = "free_y")

beer_states[which.max(beer_states$barrels),]


beer_states[beer_states$state != "total", ] %>%
  ggplot(aes(x = year, y = barrels, group = state)) +
  geom_line() +
  facet_wrap(~type, scales = "free_y") +
  scale_y_log10()

tmp <- beer_states[beer_states$type == "Bottles and Cans",]
tmp <- tmp[tmp$year == 2019,]
tmp[which.min(tmp$barrels),]


