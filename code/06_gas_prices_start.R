library(tidyverse)
library(magrittr) # pipe friendly operations
library(rvest) # scrape data from the web
library(xml2) # parse xml data
url <- "https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emm_epm0u_pte_nus_dpg&f=w"

htmldoc <- read_html(url)
gas_prices_raw <- html_table(htmldoc, fill = T, trim = T) [[5]]

head(gas_prices_raw)

# Your task is to get this data into tidy form. At the end of the exercise,
# your data should look like this:
#
# > gas_prices
# # A tibble: 1,347 x 2
# Date       Value
# <date>     <chr>
#   1 1994-11-28 1.175
# 2 1994-12-05 1.143
# 3 1994-12-12 1.118
# 4 1994-12-19 1.099
# 5 1994-12-26 1.088
# 6 1995-01-02 1.104
# 7 1995-01-09 1.111
# 8 1995-01-16 1.102
# 9 1995-01-23 1.110

# You will need the lubridate package, which has functions like mdy() to
# convert strings to dates.




# If you do this right, you should be able to run this code at the end:
#
# Lets look at our data:
ggplot(gas_prices, aes(x = Date, y = Value)) + geom_line()
