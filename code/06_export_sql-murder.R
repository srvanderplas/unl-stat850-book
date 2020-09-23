library(RSQLite)
library(tidyverse)
library(sas7bdat)


con <- dbConnect(RSQLite::SQLite(), "data/sql-murder-mystery.db")

dir.create("data/sql-murder")
purrr::walk(dbListTables(con), function(x) dbReadTable(con, x) %>%
              mutate(across(where(is.character), ~str_remove(., "\n"))) %>%
              write_csv(path = paste0("data/sql-murder/", x, ".csv")))



