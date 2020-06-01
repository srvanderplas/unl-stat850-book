# Stat 850 Installation script

user_name <- readline(prompt = "Your full name: ")
user_email <- readline(prompt = "The email address associated with your github account: ")
# github_name <- readline(prompt = "Your github username: ")

# To start with...
install.packages(c("devtools", "dplyr", "ggplot2", "tidyr", "purrr", "stringr",
                   "readxl", "tibble", "tinytex", "rmarkdown", "knitr", "git2r",
                   "usethis", "SASmarkdown"))
# Explanations:
# devtools - tools for R development, including functions that allow you to install a package from github easily
# dplyr, tidyr, purrr - tools for manipulating and transforming data
# stringr - tools for manipulating strings
# readxl - read Excel files
# tibble - easier ways to handle spreadsheet-like data
# tinytex - install LaTeX from R
# rmarkdown, knitr, SASmarkdown - create documents with R
# git2r - work with git in R
# usethis - handy functions for R setup


library(usethis)
use_git_config(user.name = user_name, user.email = user_email, scope = "user")
git_vaccinate() # Tell git to ignore all files that are OS-dependent and don't have useful data.
# git2r::cred_ssh_key(publickey=git2r::ssh_path("id_rsa.pub"), privatekey = git2r::ssh_path("id_rsa"))

library(tinytex)
tinytex::install_tinytex() # Install LaTeX on your system
