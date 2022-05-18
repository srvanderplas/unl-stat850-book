# This script collects all R packages used in the bookdown document for installation
dep_list <- c("here", "purrr", "stringr", "dplyr")
install.packages(setdiff(dep_list, installed.packages()))

library(here)
library(purrr)
library(stringr)
library(dplyr)

rmd_files <- list.files(here::here(), ".[qR]md$", recursive = T, full.names = T)
r_files <- list.files(here::here(), ".R$", recursive = T, full.names = T)

all_files <- c(rmd_files, r_files)

all_lines <- purrr::map(all_files, readLines) %>% unlist() %>% str_trim()
pattern <- "library\\(([A-z0-9]{1,})\\)(.*)$"
pattern2 <- "([A-z0-9]{1,})::"
pkgs <- str_detect(all_lines, pattern)
pkgs <- all_lines[pkgs] %>% str_replace(pattern, "\\1") %>% str_remove("^# ") %>% unique()

pkgs2 <- str_detect(all_lines, pattern2)
pkgs2 <- all_lines[pkgs2] %>% str_extract(pattern2) %>% str_remove_all("[`[:punct:]]") %>% unique()

all_pkgs <- c(pkgs, pkgs2) %>% unique()

writeLines(all_pkgs, "data/packages")


install.packages(setdiff(all_pkgs, installed.packages()))
devtools::install_github(c("heike/classdata", "hadley/emo", "mine-cetinkaya-rundel/nycsquirrels18", "gadenbuie/tweetrmd"))
