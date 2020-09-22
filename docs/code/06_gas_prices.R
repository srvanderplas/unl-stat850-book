library(tidyverse)
library(magrittr) # pipe friendly operations
library(rvest) # scrape data from the web
library(xml2) # parse xml data
url <- "https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emm_epm0u_pte_nus_dpg&f=w"

htmldoc <- read_html(url)
gas_prices_raw <- html_table(htmldoc, fill = T, trim = T) [[5]]

# Function to clean up column names
# Written as an extra function because it makes the code a lot cleaner
fix_gas_names <- function(x) {
  # Add extra header row information
  paste(x, c("", rep(c("Date", "Value"), times = 5))) %>%
    # trim leading/trailing spaces
    str_trim() %>%
    # replace characters in names that aren't ok for variables in R
    make.names()
}

# Clean up the table a bit
gas_prices_raw <- gas_prices_raw %>%
  set_names(fix_gas_names(names(.))) %>%
  # remove first row that is really an extra header row
  filter(Year.Month != "Year-Month") %>%
  # get rid of empty rows
  filter(Year.Month != "")

# Now, we have to decide how best to handle our data. Lets start with Year.Month
# It contains two different values, and we really would like to have two different
# columns, one for year, and one for month.
gas_prices_raw <- gas_prices_raw %>%
  separate(Year.Month, into = c("year", "month"), sep = "-")

# Next, lets tackle the fact that this is in wide format and we'd like long format.
# But we have two different variables, right? Date, and Value.
# So our first step is to go with extra-long form
gas_prices_long <- pivot_longer(gas_prices_raw, -c(year, month),
                                names_to = "variable", values_to = "value")

# > gas_prices_long
# # A tibble: 3,768 x 4
# year  month variable     value
# <chr> <chr> <chr>        <chr>
#   1 1994  Nov   Week.1.Date  ""
# 2 1994  Nov   Week.1.Value ""
# 3 1994  Nov   Week.2.Date  ""
# 4 1994  Nov   Week.2.Value ""
# 5 1994  Nov   Week.3.Date  ""
# 6 1994  Nov   Week.3.Value ""
# 7 1994  Nov   Week.4.Date  "11/28"
# 8 1994  Nov   Week.4.Value "1.175"

# This form is just a stepping stone between what we have and what we actually want
# Our next step is to pivot this into a wider format so that date and value have their own columns.
# To do that, we need to separate our variable name into week and variable type

gas_prices_long <- gas_prices_long %>%
  # First, take "Week." off of the front
  mutate(variable = str_remove(variable, "Week\\.")) %>%
  # Then separate the two values
  separate(variable, into = c("week", "variable"), sep = "\\.")

# Now we're ready to move back into wide-er form
gas_prices <- gas_prices_long %>%
  # filter out empty values
  filter(value != "") %>%
  pivot_wider(
    names_from = variable,
    values_from = value
  )


# Ok, now we're close. Lets just get date into a nice form
# We could do this in two different ways:
# first, we could get the month-day Date and split it into month and day
#        and then use a date function to recombine them
# or, we could paste the year on the end and use the mdy() function from
#        lubridate to read the whole string in as a date.
#        That option seems easier.

library(lubridate)
gas_prices <- gas_prices %>%
  mutate(Date = paste(Date, year, sep = "/")) %>%
  mutate(Date = mdy(Date))

# And now we can get rid of redundant columns
gas_prices <- gas_prices %>%
  select(Date, Value)

# Finally, our value variable is a character variable, so lets fix that quick
gas_prices <- gas_prices %>%
  mutate(Value = as.numeric(Value))

# Lets look at our data:
ggplot(gas_prices, aes(x = Date, y = Value)) + geom_line()
