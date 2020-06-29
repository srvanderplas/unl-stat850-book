a <- function(x) {
  b <- function(y) {
    c <- function(z) {
      stop('there was a problem')  # This generates an error
    }
    c()
  }
  b()
}

a()
