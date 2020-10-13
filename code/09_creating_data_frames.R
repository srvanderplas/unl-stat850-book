# Create data by columns
tibble(
  int = 1:10,
  letters = letters[1:10]
)

# Create data by rows
tribble(
  ~suit, ~value, ~points,
  "clubs", 2, 0,
  "hearts", 2, 1,
  "diamonds", 2, 0,
  "spades", 2, 0
)

# Create data by structure/relationships

suits <- c("hearts", "diamonds", "clubs", "spades")
values <- factor(1:13, labels = c(2:10, "Jack", "Queen", "King", "Ace"))
crossing(suits, values) # every combination of suit and value
# there is also a nesting function that you can use to create similar data frames
