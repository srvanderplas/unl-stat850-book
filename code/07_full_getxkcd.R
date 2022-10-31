library(png)
library(xml2)

# get the most current xkcd or the specified number
get_xkcd <- function(id = NULL) {
  if (is.null(id)) {
    # Have to get the location of the image ourselves
    url <- "http://xkcd.com"
  } else if (is.numeric(id)) {
    url <- paste0("http://xkcd.com/", id, "/")
  } else {
    # only allow numeric or null input
    stop("To get current xkcd, pass in NULL, otherwise, pass in a valid comic number")
  }

  page <- read_html(url)
  # Find the comic
  image <- xml_find_first(page, "//div[@id='comic']/img") %>%
    # pull the address out of the tag
    xml_attr("src")
  # Clean up the address
  image <- substr(image, 3, nchar(image)) # cut the first 2 characters off

  # make temp file
  location <- tempfile(fileext = "png")
  download.file(image, destfile = location, quiet = T)

  if (file.exists(location)) {
    readPNG(source = location)
  } else {
    stop(paste("Something went wrong saving the image at ", image, " to ", location))
  }
}
