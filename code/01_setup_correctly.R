# This file is intended to test whether you have the necessary software installed on your computer
# You may modify these paths if you know them
# If you are on Windows, you must escape the \ with another \,
# so C:\\folder\\file is the equivalent of C:\folder\file

git_location <- NULL
sas_location <- NULL
tex_location <- NULL


OS <- Sys.info()$sysname

if(OS %in% c("Darwin", "Linux")) {
  git_location <- system("which git", intern = T)
  sas_location <-
} else { # Windows
  git_location <- system("where git", intern = T)
}

if (is.null(git_location) | is.na(git_location)) {
  warning("Git is not found. Install it or ensure that the path is set in the script above.")
}
