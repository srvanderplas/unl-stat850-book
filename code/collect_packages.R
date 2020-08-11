# This script collects all R packages used in the bookdown document for installation
library(tidyverse)
rmd_files <- list.files(here::here(), ".Rmd$", recursive = T, full.names = T)
r_files <- list.files(here::here(), ".R$", recursive = T, full.names = T)

all_files <- c(rmd_files, r_files)

all_lines <- purrr::map(all_files, readLines) %>% unlist() %>% str_trim()
pattern <- "library\\(([A-z0-9]{1,})\\)(.*)$"
pkgs <- str_detect(all_lines, pattern)
pkgs <- all_lines[pkgs] %>% str_replace(pattern, "\\1") %>% str_remove("^# ") %>% unique()

writeLines(pkgs, "data/packages")
