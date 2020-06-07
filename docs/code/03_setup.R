# Read in package list
# This is my list of essential packages. I probably don't update it enough... :(
pkgs <- read.csv(
  "https://raw.githubusercontent.com/srvanderplas/unl-stat850/master/code/03_initial_packages.csv",
  stringsAsFactors = F, comment.char = "#")

# Don't reinstall packages that are already installed
# First, list all packages that are currently installed
installed.pkgs <- installed.packages()
# Then, remove any installed packages from the list of packages to install
pkgs <- pkgs[!pkgs$Name %in% installed.pkgs,]

# Separate out github packages
gh <- subset(pkgs, Location == "github")
cran <- subset(pkgs, Location == "CRAN")

# Install cran packages (if any are not already installed)
if (nrow(cran) > 0) {
  install.packages(cran$Name, Ncpus = availableCores(),
                   dependencies = c('Suggests', 'Depends', 'Imports', 'Enhances'))
}

# Install github packages
if (nrow(gh) > 0) {

  # devtools is a package that makes it easy to install packages from github
  if (!"devtools" %in% installed.packages()) {
    install.packages("devtools")
  }

  library(devtools)

  # github packages have to be installed individually (no vector based installation)
  for (i in paste(gh$Author, gh$Name, sep = "/")) {
    try(install_github(i, dependencies = c('Suggests', 'Depends', 'Imports', 'Enhances')))
  }

}
