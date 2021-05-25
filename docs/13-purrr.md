









# Lists, Nested Lists, and Functional Programming


## Module Objectives  {- #module13-objectives}

- Use functional programming techniques to create code which is well organized and easier to understand and maintain


## Review: Lists and Vectors

A **vector** is a 1-dimensional R data structure that contains items of the same simple ('atomic') type (character, logical, integer, factor). 


```r
(logical_vec <- c(T, F, T, T))
[1]  TRUE FALSE  TRUE  TRUE
(numeric_vec <- c(3, 1, 4, 5))
[1] 3 1 4 5
(char_vec <- c("A", "AB", "ABC", "ABCD"))
[1] "A"    "AB"   "ABC"  "ABCD"
```

You **index** a vector using brackets: to get the 3rd element of the vector `x`, you would use `x[3]`.

```r
logical_vec[3]
[1] TRUE
numeric_vec[3]
[1] 4
char_vec[3]
[1] "ABC"
```

You can also index a vector using a logical vector:

```r
numeric_vec[logical_vec]
[1] 3 4 5
char_vec[logical_vec]
[1] "A"    "ABC"  "ABCD"
logical_vec[logical_vec]
[1] TRUE TRUE TRUE
```


A **list** is a 1-dimensional R data structure that has no restrictions on what type of content is stored within it. 


```r
(mylist <- list(logical_vec, numeric_vec, third_thing = char_vec[1:2]))
[[1]]
[1]  TRUE FALSE  TRUE  TRUE

[[2]]
[1] 3 1 4 5

$third_thing
[1] "A"  "AB"
```

A list is a vector, but it is not an atomic vector - that is, it does not necessarily contain things that are all the same type. List components may have names (or not), be homogeneous (or not), have the same length (or not). 

There are 3 ways to index a list:

- With single square brackets, just like we index atomic vectors. In this case, the return value is always a list.


```r
mylist[1]
[[1]]
[1]  TRUE FALSE  TRUE  TRUE

mylist[2]
[[1]]
[1] 3 1 4 5

mylist[c(T, F, T)]
[[1]]
[1]  TRUE FALSE  TRUE  TRUE

$third_thing
[1] "A"  "AB"
```
- With double square brackets. In this case, the return value is the thing inside the specified position in the list, but you also can only get one entry in the main list at a time. You can also get things by name.


```r
mylist[[1]]
[1]  TRUE FALSE  TRUE  TRUE

mylist[["third_thing"]]
[1] "A"  "AB"
```
- Using `x$name`. This is equivalent to using `x[["name"]]`. Note that this does not work on unnamed entries in the list.


```r
mylist$third_thing
[1] "A"  "AB"
```

::: learn-more
You can get a more thorough review of vectors and lists [from Jenny Bryan's purrr tutorial](https://jennybc.github.io/purrr-tutorial/bk00_vectors-and-lists.html).
:::

Operations in R are **vectorized** - that is, by default, they operate on vectors. This is primarily a feature that applies to atomic vectors (and we don't even think about it): 


```r
(rnorm(10) + rnorm(10, mean = 3))
 [1] 1.1336777 1.7114025 0.6687748 6.3158537 1.2916852 4.3396155 1.8819082
 [8] 3.1377086 1.8833287 4.9366963
```

We didn't have to use a for loop to add these two vectors with 10 entries each together. In python (and SAS, and other languages), this might instead look like:


```r
a <- rnorm(10)
b <- rnorm(10, mean = 3)
result <- rep(0, 10)
for(i in 1:10) {
  result[i] <- a[i] + b[i]
}
result
 [1] 5.088881 3.594083 2.975052 2.035523 4.754911 2.662893 3.433084 3.733120
 [9] 3.719182 3.373924
```

That is, we would apply or map the + function to each entry of a and b. For atomic vectors, it's easy to do this by default; with a list, however, we need to be a bit more explicit (because everything that's passed into the function may not be the same type). 

This logic is the basis behind the purrr package (and similar base functions `apply`, `lapply`, `sapply`, `tapply`, and `mapply` - I find the purrr package easier to work with, but you may use the base package versions if you want, and you can find a [side-by-side comparison in the purrr tutorial](https://jennybc.github.io/purrr-tutorial/bk01_base-functions.html)). 


## Introduction to `map`


```r
library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
✓ ggplot2 3.3.3.9000     ✓ purrr   0.3.4     
✓ tibble  3.1.1          ✓ dplyr   1.0.5     
✓ tidyr   1.1.3          ✓ stringr 1.4.0     
✓ readr   1.4.0          ✓ forcats 0.5.1     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
x tidyr::extract()   masks magrittr::extract()
x dplyr::filter()    masks stats::filter()
x dplyr::lag()       masks stats::lag()
x purrr::set_names() masks magrittr::set_names()
library(purrr) # list functions
library(repurrrsive) # examples
```

We'll use one of the datasets in `repurrsive`, `got_chars`, to start playing with the `map_` series of functions.

```r
data(got_chars)
length(got_chars)
[1] 30
got_chars[[1]]
$url
[1] "https://www.anapioficeandfire.com/api/characters/1022"

$id
[1] 1022

$name
[1] "Theon Greyjoy"

$gender
[1] "Male"

$culture
[1] "Ironborn"

$born
[1] "In 278 AC or 279 AC, at Pyke"

$died
[1] ""

$alive
[1] TRUE

$titles
[1] "Prince of Winterfell"                                
[2] "Captain of Sea Bitch"                                
[3] "Lord of the Iron Islands (by law of the green lands)"

$aliases
[1] "Prince of Fools" "Theon Turncloak" "Reek"            "Theon Kinslayer"

$father
[1] ""

$mother
[1] ""

$spouse
[1] ""

$allegiances
[1] "House Greyjoy of Pyke"

$books
[1] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"

$povBooks
[1] "A Clash of Kings"     "A Dance with Dragons"

$tvSeries
[1] "Season 1" "Season 2" "Season 3" "Season 4" "Season 5" "Season 6"

$playedBy
[1] "Alfie Allen"
```

It appears that each entry in this 30-item list is a character from Game of Thrones, and there are several sub-fields for each character.

What characters do we have?

We can use `purrr::map(x, "name")` to get a list of all characters' names. Since they are all the same type, we could also use an extension of `map`, `map_chr`, which will coerce the returned list into a character vector (which may be simpler to operate on). 

::: note
There are several packages with map() functions including functions that are meant to actually plot maps; it generally saves time and effort to just type the function name with the package you want; you don't *have* to do so, but if you have a lot of other (non tidyverse, in particular) packages loaded, it will save you a lot of grief.
:::


```r
purrr::map(got_chars, "name")
[[1]]
[1] "Theon Greyjoy"

[[2]]
[1] "Tyrion Lannister"

[[3]]
[1] "Victarion Greyjoy"

[[4]]
[1] "Will"

[[5]]
[1] "Areo Hotah"

[[6]]
[1] "Chett"

[[7]]
[1] "Cressen"

[[8]]
[1] "Arianne Martell"

[[9]]
[1] "Daenerys Targaryen"

[[10]]
[1] "Davos Seaworth"

[[11]]
[1] "Arya Stark"

[[12]]
[1] "Arys Oakheart"

[[13]]
[1] "Asha Greyjoy"

[[14]]
[1] "Barristan Selmy"

[[15]]
[1] "Varamyr"

[[16]]
[1] "Brandon Stark"

[[17]]
[1] "Brienne of Tarth"

[[18]]
[1] "Catelyn Stark"

[[19]]
[1] "Cersei Lannister"

[[20]]
[1] "Eddard Stark"

[[21]]
[1] "Jaime Lannister"

[[22]]
[1] "Jon Connington"

[[23]]
[1] "Jon Snow"

[[24]]
[1] "Aeron Greyjoy"

[[25]]
[1] "Kevan Lannister"

[[26]]
[1] "Melisandre"

[[27]]
[1] "Merrett Frey"

[[28]]
[1] "Quentyn Martell"

[[29]]
[1] "Samwell Tarly"

[[30]]
[1] "Sansa Stark"
purrr::map_chr(got_chars, "name")
 [1] "Theon Greyjoy"      "Tyrion Lannister"   "Victarion Greyjoy" 
 [4] "Will"               "Areo Hotah"         "Chett"             
 [7] "Cressen"            "Arianne Martell"    "Daenerys Targaryen"
[10] "Davos Seaworth"     "Arya Stark"         "Arys Oakheart"     
[13] "Asha Greyjoy"       "Barristan Selmy"    "Varamyr"           
[16] "Brandon Stark"      "Brienne of Tarth"   "Catelyn Stark"     
[19] "Cersei Lannister"   "Eddard Stark"       "Jaime Lannister"   
[22] "Jon Connington"     "Jon Snow"           "Aeron Greyjoy"     
[25] "Kevan Lannister"    "Melisandre"         "Merrett Frey"      
[28] "Quentyn Martell"    "Samwell Tarly"      "Sansa Stark"       
```

Similar shortcuts work to get the nth item in each sub list:

```r
purrr::map_chr(got_chars, 4)
 [1] "Male"   "Male"   "Male"   "Male"   "Male"   "Male"   "Male"   "Female"
 [9] "Female" "Male"   "Female" "Male"   "Female" "Male"   "Male"   "Male"  
[17] "Female" "Female" "Female" "Male"   "Male"   "Male"   "Male"   "Male"  
[25] "Male"   "Female" "Male"   "Male"   "Male"   "Female"
```
Specifying the output type using e.g. `map_chr` works if each item in the list is an atomic vector of length 1. If the list is more complicated, though, these shortcuts will issue an error:


```r
purrr::map(got_chars, "books")
[[1]]
[1] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"

[[2]]
[1] "A Feast for Crows"         "The World of Ice and Fire"

[[3]]
[1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"

[[4]]
[1] "A Clash of Kings"

[[5]]
[1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"

[[6]]
[1] "A Game of Thrones" "A Clash of Kings" 

[[7]]
[1] "A Storm of Swords" "A Feast for Crows"

[[8]]
[1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
[4] "A Dance with Dragons"

[[9]]
[1] "A Feast for Crows"

[[10]]
[1] "A Feast for Crows"

[[11]]
NULL

[[12]]
[1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
[4] "A Dance with Dragons"

[[13]]
[1] "A Game of Thrones" "A Clash of Kings" 

[[14]]
[1] "A Game of Thrones"         "A Clash of Kings"         
[3] "A Storm of Swords"         "A Feast for Crows"        
[5] "The World of Ice and Fire"

[[15]]
[1] "A Storm of Swords"

[[16]]
[1] "A Feast for Crows"

[[17]]
[1] "A Clash of Kings"     "A Storm of Swords"    "A Dance with Dragons"

[[18]]
[1] "A Feast for Crows"    "A Dance with Dragons"

[[19]]
[1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"

[[20]]
[1] "A Clash of Kings"          "A Storm of Swords"        
[3] "A Feast for Crows"         "A Dance with Dragons"     
[5] "The World of Ice and Fire"

[[21]]
[1] "A Game of Thrones" "A Clash of Kings" 

[[22]]
[1] "A Storm of Swords"         "A Feast for Crows"        
[3] "The World of Ice and Fire"

[[23]]
[1] "A Feast for Crows"

[[24]]
[1] "A Game of Thrones"    "A Clash of Kings"     "A Storm of Swords"   
[4] "A Dance with Dragons"

[[25]]
[1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
[4] "A Feast for Crows"

[[26]]
[1] "A Clash of Kings"  "A Storm of Swords" "A Feast for Crows"

[[27]]
[1] "A Game of Thrones"    "A Clash of Kings"     "A Feast for Crows"   
[4] "A Dance with Dragons"

[[28]]
[1] "A Game of Thrones" "A Clash of Kings"  "A Storm of Swords"
[4] "A Feast for Crows"

[[29]]
[1] "A Game of Thrones"    "A Clash of Kings"     "A Dance with Dragons"

[[30]]
[1] "A Dance with Dragons"
purrr::map_chr(got_chars, "books")
Error: Result 1 must be a single string, not a character vector of length 3
```

What if we want to extract several things? This trick works off of the idea that `[` is a function: that is, the single brackets we used before are actually a special type of function. In R functions, there is often the argument `...`, which is a convention that allows us to pass arguments to other functions that are called within the main function we are using (you'll see ... used in plotting and regression functions frequently as well). 

Here, we use `...` to pass in our list of 3 things we want to pull from each item in the list.


```r
purrr::map(got_chars, `[`, c("name", "gender", "born"))
[[1]]
[[1]]$name
[1] "Theon Greyjoy"

[[1]]$gender
[1] "Male"

[[1]]$born
[1] "In 278 AC or 279 AC, at Pyke"


[[2]]
[[2]]$name
[1] "Tyrion Lannister"

[[2]]$gender
[1] "Male"

[[2]]$born
[1] "In 273 AC, at Casterly Rock"


[[3]]
[[3]]$name
[1] "Victarion Greyjoy"

[[3]]$gender
[1] "Male"

[[3]]$born
[1] "In 268 AC or before, at Pyke"


[[4]]
[[4]]$name
[1] "Will"

[[4]]$gender
[1] "Male"

[[4]]$born
[1] ""


[[5]]
[[5]]$name
[1] "Areo Hotah"

[[5]]$gender
[1] "Male"

[[5]]$born
[1] "In 257 AC or before, at Norvos"


[[6]]
[[6]]$name
[1] "Chett"

[[6]]$gender
[1] "Male"

[[6]]$born
[1] "At Hag's Mire"


[[7]]
[[7]]$name
[1] "Cressen"

[[7]]$gender
[1] "Male"

[[7]]$born
[1] "In 219 AC or 220 AC"


[[8]]
[[8]]$name
[1] "Arianne Martell"

[[8]]$gender
[1] "Female"

[[8]]$born
[1] "In 276 AC, at Sunspear"


[[9]]
[[9]]$name
[1] "Daenerys Targaryen"

[[9]]$gender
[1] "Female"

[[9]]$born
[1] "In 284 AC, at Dragonstone"


[[10]]
[[10]]$name
[1] "Davos Seaworth"

[[10]]$gender
[1] "Male"

[[10]]$born
[1] "In 260 AC or before, at King's Landing"


[[11]]
[[11]]$name
[1] "Arya Stark"

[[11]]$gender
[1] "Female"

[[11]]$born
[1] "In 289 AC, at Winterfell"


[[12]]
[[12]]$name
[1] "Arys Oakheart"

[[12]]$gender
[1] "Male"

[[12]]$born
[1] "At Old Oak"


[[13]]
[[13]]$name
[1] "Asha Greyjoy"

[[13]]$gender
[1] "Female"

[[13]]$born
[1] "In 275 AC or 276 AC, at Pyke"


[[14]]
[[14]]$name
[1] "Barristan Selmy"

[[14]]$gender
[1] "Male"

[[14]]$born
[1] "In 237 AC"


[[15]]
[[15]]$name
[1] "Varamyr"

[[15]]$gender
[1] "Male"

[[15]]$born
[1] "At a village Beyond the Wall"


[[16]]
[[16]]$name
[1] "Brandon Stark"

[[16]]$gender
[1] "Male"

[[16]]$born
[1] "In 290 AC, at Winterfell"


[[17]]
[[17]]$name
[1] "Brienne of Tarth"

[[17]]$gender
[1] "Female"

[[17]]$born
[1] "In 280 AC"


[[18]]
[[18]]$name
[1] "Catelyn Stark"

[[18]]$gender
[1] "Female"

[[18]]$born
[1] "In 264 AC, at Riverrun"


[[19]]
[[19]]$name
[1] "Cersei Lannister"

[[19]]$gender
[1] "Female"

[[19]]$born
[1] "In 266 AC, at Casterly Rock"


[[20]]
[[20]]$name
[1] "Eddard Stark"

[[20]]$gender
[1] "Male"

[[20]]$born
[1] "In 263 AC, at Winterfell"


[[21]]
[[21]]$name
[1] "Jaime Lannister"

[[21]]$gender
[1] "Male"

[[21]]$born
[1] "In 266 AC, at Casterly Rock"


[[22]]
[[22]]$name
[1] "Jon Connington"

[[22]]$gender
[1] "Male"

[[22]]$born
[1] "In or between 263 AC and 265 AC"


[[23]]
[[23]]$name
[1] "Jon Snow"

[[23]]$gender
[1] "Male"

[[23]]$born
[1] "In 283 AC"


[[24]]
[[24]]$name
[1] "Aeron Greyjoy"

[[24]]$gender
[1] "Male"

[[24]]$born
[1] "In or between 269 AC and 273 AC, at Pyke"


[[25]]
[[25]]$name
[1] "Kevan Lannister"

[[25]]$gender
[1] "Male"

[[25]]$born
[1] "In 244 AC"


[[26]]
[[26]]$name
[1] "Melisandre"

[[26]]$gender
[1] "Female"

[[26]]$born
[1] "At Unknown"


[[27]]
[[27]]$name
[1] "Merrett Frey"

[[27]]$gender
[1] "Male"

[[27]]$born
[1] "In 262 AC"


[[28]]
[[28]]$name
[1] "Quentyn Martell"

[[28]]$gender
[1] "Male"

[[28]]$born
[1] "In 281 AC, at Sunspear, Dorne"


[[29]]
[[29]]$name
[1] "Samwell Tarly"

[[29]]$gender
[1] "Male"

[[29]]$born
[1] "In 283 AC, at Horn Hill"


[[30]]
[[30]]$name
[1] "Sansa Stark"

[[30]]$gender
[1] "Female"

[[30]]$born
[1] "In 286 AC, at Winterfell"
```

If this is ugly syntax to you, that's fine - the `magrittr` package also includes an `extract` function that works the same way.


```r
purrr::map(got_chars, magrittr::extract, c("name", "gender", "born"))
[[1]]
[[1]]$name
[1] "Theon Greyjoy"

[[1]]$gender
[1] "Male"

[[1]]$born
[1] "In 278 AC or 279 AC, at Pyke"


[[2]]
[[2]]$name
[1] "Tyrion Lannister"

[[2]]$gender
[1] "Male"

[[2]]$born
[1] "In 273 AC, at Casterly Rock"


[[3]]
[[3]]$name
[1] "Victarion Greyjoy"

[[3]]$gender
[1] "Male"

[[3]]$born
[1] "In 268 AC or before, at Pyke"


[[4]]
[[4]]$name
[1] "Will"

[[4]]$gender
[1] "Male"

[[4]]$born
[1] ""


[[5]]
[[5]]$name
[1] "Areo Hotah"

[[5]]$gender
[1] "Male"

[[5]]$born
[1] "In 257 AC or before, at Norvos"


[[6]]
[[6]]$name
[1] "Chett"

[[6]]$gender
[1] "Male"

[[6]]$born
[1] "At Hag's Mire"


[[7]]
[[7]]$name
[1] "Cressen"

[[7]]$gender
[1] "Male"

[[7]]$born
[1] "In 219 AC or 220 AC"


[[8]]
[[8]]$name
[1] "Arianne Martell"

[[8]]$gender
[1] "Female"

[[8]]$born
[1] "In 276 AC, at Sunspear"


[[9]]
[[9]]$name
[1] "Daenerys Targaryen"

[[9]]$gender
[1] "Female"

[[9]]$born
[1] "In 284 AC, at Dragonstone"


[[10]]
[[10]]$name
[1] "Davos Seaworth"

[[10]]$gender
[1] "Male"

[[10]]$born
[1] "In 260 AC or before, at King's Landing"


[[11]]
[[11]]$name
[1] "Arya Stark"

[[11]]$gender
[1] "Female"

[[11]]$born
[1] "In 289 AC, at Winterfell"


[[12]]
[[12]]$name
[1] "Arys Oakheart"

[[12]]$gender
[1] "Male"

[[12]]$born
[1] "At Old Oak"


[[13]]
[[13]]$name
[1] "Asha Greyjoy"

[[13]]$gender
[1] "Female"

[[13]]$born
[1] "In 275 AC or 276 AC, at Pyke"


[[14]]
[[14]]$name
[1] "Barristan Selmy"

[[14]]$gender
[1] "Male"

[[14]]$born
[1] "In 237 AC"


[[15]]
[[15]]$name
[1] "Varamyr"

[[15]]$gender
[1] "Male"

[[15]]$born
[1] "At a village Beyond the Wall"


[[16]]
[[16]]$name
[1] "Brandon Stark"

[[16]]$gender
[1] "Male"

[[16]]$born
[1] "In 290 AC, at Winterfell"


[[17]]
[[17]]$name
[1] "Brienne of Tarth"

[[17]]$gender
[1] "Female"

[[17]]$born
[1] "In 280 AC"


[[18]]
[[18]]$name
[1] "Catelyn Stark"

[[18]]$gender
[1] "Female"

[[18]]$born
[1] "In 264 AC, at Riverrun"


[[19]]
[[19]]$name
[1] "Cersei Lannister"

[[19]]$gender
[1] "Female"

[[19]]$born
[1] "In 266 AC, at Casterly Rock"


[[20]]
[[20]]$name
[1] "Eddard Stark"

[[20]]$gender
[1] "Male"

[[20]]$born
[1] "In 263 AC, at Winterfell"


[[21]]
[[21]]$name
[1] "Jaime Lannister"

[[21]]$gender
[1] "Male"

[[21]]$born
[1] "In 266 AC, at Casterly Rock"


[[22]]
[[22]]$name
[1] "Jon Connington"

[[22]]$gender
[1] "Male"

[[22]]$born
[1] "In or between 263 AC and 265 AC"


[[23]]
[[23]]$name
[1] "Jon Snow"

[[23]]$gender
[1] "Male"

[[23]]$born
[1] "In 283 AC"


[[24]]
[[24]]$name
[1] "Aeron Greyjoy"

[[24]]$gender
[1] "Male"

[[24]]$born
[1] "In or between 269 AC and 273 AC, at Pyke"


[[25]]
[[25]]$name
[1] "Kevan Lannister"

[[25]]$gender
[1] "Male"

[[25]]$born
[1] "In 244 AC"


[[26]]
[[26]]$name
[1] "Melisandre"

[[26]]$gender
[1] "Female"

[[26]]$born
[1] "At Unknown"


[[27]]
[[27]]$name
[1] "Merrett Frey"

[[27]]$gender
[1] "Male"

[[27]]$born
[1] "In 262 AC"


[[28]]
[[28]]$name
[1] "Quentyn Martell"

[[28]]$gender
[1] "Male"

[[28]]$born
[1] "In 281 AC, at Sunspear, Dorne"


[[29]]
[[29]]$name
[1] "Samwell Tarly"

[[29]]$gender
[1] "Male"

[[29]]$born
[1] "In 283 AC, at Horn Hill"


[[30]]
[[30]]$name
[1] "Sansa Stark"

[[30]]$gender
[1] "Female"

[[30]]$born
[1] "In 286 AC, at Winterfell"
```

What if we want this to be a data frame instead? We can use `map_dfr` to get a data frame that is formed by row-binding each element in the list. 


```r
purrr::map_dfr(got_chars, `[`, c("name", "gender", "born")) 
# A tibble: 30 x 3
   name               gender born                                    
   <chr>              <chr>  <chr>                                   
 1 Theon Greyjoy      Male   "In 278 AC or 279 AC, at Pyke"          
 2 Tyrion Lannister   Male   "In 273 AC, at Casterly Rock"           
 3 Victarion Greyjoy  Male   "In 268 AC or before, at Pyke"          
 4 Will               Male   ""                                      
 5 Areo Hotah         Male   "In 257 AC or before, at Norvos"        
 6 Chett              Male   "At Hag's Mire"                         
 7 Cressen            Male   "In 219 AC or 220 AC"                   
 8 Arianne Martell    Female "In 276 AC, at Sunspear"                
 9 Daenerys Targaryen Female "In 284 AC, at Dragonstone"             
10 Davos Seaworth     Male   "In 260 AC or before, at King's Landing"
# … with 20 more rows

# Equivalent to
purrr::map(got_chars, `[`, c("name", "gender", "born")) %>%
  dplyr::bind_rows()
# A tibble: 30 x 3
   name               gender born                                    
   <chr>              <chr>  <chr>                                   
 1 Theon Greyjoy      Male   "In 278 AC or 279 AC, at Pyke"          
 2 Tyrion Lannister   Male   "In 273 AC, at Casterly Rock"           
 3 Victarion Greyjoy  Male   "In 268 AC or before, at Pyke"          
 4 Will               Male   ""                                      
 5 Areo Hotah         Male   "In 257 AC or before, at Norvos"        
 6 Chett              Male   "At Hag's Mire"                         
 7 Cressen            Male   "In 219 AC or 220 AC"                   
 8 Arianne Martell    Female "In 276 AC, at Sunspear"                
 9 Daenerys Targaryen Female "In 284 AC, at Dragonstone"             
10 Davos Seaworth     Male   "In 260 AC or before, at King's Landing"
# … with 20 more rows
```




## Creating (and Using) List-columns

Data structures in R are typically list-based in one way or another. Sometimes, more complicated data structures are actually lists of lists, or tibbles with a list-column, or other variations on "list within a ____". In combination with `purrr`, this is an *incredibly* powerful setup that can make working with simulations and data very easy.

Suppose, for instance, I want to simulate some data for modeling purposes, where I can control the number of outliers in the dataset:


```r
data_sim <- function(n_outliers = 0) {
  tmp <- tibble(x = seq(-10, 10, .1),
                y = rnorm(length(x), mean = x, sd = 1))
  
  
  outlier_sample <- c(NULL, sample(tmp$x, n_outliers))
  
  # Create outliers
  tmp %>% 
    mutate(
      is_outlier = x %in% outlier_sample,
      y = y + is_outlier * sample(c(-1, 1), n(), replace = T) * runif(n(), 5, 10)
    )
}
data_sim()
# A tibble: 201 x 3
       x      y is_outlier
   <dbl>  <dbl> <lgl>     
 1 -10    -9.93 FALSE     
 2  -9.9  -9.80 FALSE     
 3  -9.8  -8.03 FALSE     
 4  -9.7  -8.60 FALSE     
 5  -9.6  -9.54 FALSE     
 6  -9.5  -9.64 FALSE     
 7  -9.4  -8.76 FALSE     
 8  -9.3  -9.36 FALSE     
 9  -9.2  -9.42 FALSE     
10  -9.1 -10.8  FALSE     
# … with 191 more rows
```
Now, lets suppose that I want 100 replicates of each of 0, 5, 10, and 20 outliers. 


```r
sim <- crossing(rep = 1:100, n_outliers = c(0, 5, 10, 20)) %>%
  mutate(sim_data = purrr::map(n_outliers, data_sim))
```

I could use `unnest(sim_data)` if I wanted to expand my data a bit to see what I have, but in this case, it's more useful to leave it in its current, compact form. Instead, suppose I fit a linear regression to each of the simulated data sets, and store the fitted linear regression object in a new list-column?


```r
sim <- sim %>%
  mutate(reg = purrr::map(sim_data, ~lm(data = ., y ~ x)))
```
Here, we use an **anonymous** function in purrr: by using `~{expression}`, we have defined a function that takes the argument `.` (which is just a placeholder). So in our case, we're saying "use the data that I pass in to fit a linear regression of `y` using `x` as a predictor". 

Let's play around a bit with this: We might want to look at our regression coefficients or standard errors to see how much the additional outliers affect us. We could use a fancy package for tidy modeling, such as `broom`, but for now, lets do something a bit simpler and apply the purrr name extraction functions we used earlier.

It can be helpful to examine one of the objects just to see what you're dealing with:


```r
str(sim$reg[[1]])
List of 12
 $ coefficients : Named num [1:2] 0.207 1.008
  ..- attr(*, "names")= chr [1:2] "(Intercept)" "x"
 $ residuals    : Named num [1:201] 0.6461 -1.4697 -1.245 0.3034 0.0164 ...
  ..- attr(*, "names")= chr [1:201] "1" "2" "3" "4" ...
 $ effects      : Named num [1:201] -2.935 82.928 -1.136 0.41 0.122 ...
  ..- attr(*, "names")= chr [1:201] "(Intercept)" "x" "" "" ...
 $ rank         : int 2
 $ fitted.values: Named num [1:201] -9.87 -9.77 -9.67 -9.57 -9.47 ...
  ..- attr(*, "names")= chr [1:201] "1" "2" "3" "4" ...
 $ assign       : int [1:2] 0 1
 $ qr           :List of 5
  ..$ qr   : num [1:201, 1:2] -14.1774 0.0705 0.0705 0.0705 0.0705 ...
  .. ..- attr(*, "dimnames")=List of 2
  .. .. ..$ : chr [1:201] "1" "2" "3" "4" ...
  .. .. ..$ : chr [1:2] "(Intercept)" "x"
  .. ..- attr(*, "assign")= int [1:2] 0 1
  ..$ qraux: num [1:2] 1.07 1.11
  ..$ pivot: int [1:2] 1 2
  ..$ tol  : num 1e-07
  ..$ rank : int 2
  ..- attr(*, "class")= chr "qr"
 $ df.residual  : int 199
 $ xlevels      : Named list()
 $ call         : language lm(formula = y ~ x, data = .)
 $ terms        :Classes 'terms', 'formula'  language y ~ x
  .. ..- attr(*, "variables")= language list(y, x)
  .. ..- attr(*, "factors")= int [1:2, 1] 0 1
  .. .. ..- attr(*, "dimnames")=List of 2
  .. .. .. ..$ : chr [1:2] "y" "x"
  .. .. .. ..$ : chr "x"
  .. ..- attr(*, "term.labels")= chr "x"
  .. ..- attr(*, "order")= int 1
  .. ..- attr(*, "intercept")= int 1
  .. ..- attr(*, "response")= int 1
  .. ..- attr(*, ".Environment")=<environment: 0x563b54e74aa0> 
  .. ..- attr(*, "predvars")= language list(y, x)
  .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
  .. .. ..- attr(*, "names")= chr [1:2] "y" "x"
 $ model        :'data.frame':	201 obs. of  2 variables:
  ..$ y: num [1:201] -9.23 -11.24 -10.92 -9.27 -9.45 ...
  ..$ x: num [1:201] -10 -9.9 -9.8 -9.7 -9.6 -9.5 -9.4 -9.3 -9.2 -9.1 ...
  ..- attr(*, "terms")=Classes 'terms', 'formula'  language y ~ x
  .. .. ..- attr(*, "variables")= language list(y, x)
  .. .. ..- attr(*, "factors")= int [1:2, 1] 0 1
  .. .. .. ..- attr(*, "dimnames")=List of 2
  .. .. .. .. ..$ : chr [1:2] "y" "x"
  .. .. .. .. ..$ : chr "x"
  .. .. ..- attr(*, "term.labels")= chr "x"
  .. .. ..- attr(*, "order")= int 1
  .. .. ..- attr(*, "intercept")= int 1
  .. .. ..- attr(*, "response")= int 1
  .. .. ..- attr(*, ".Environment")=<environment: 0x563b54e74aa0> 
  .. .. ..- attr(*, "predvars")= language list(y, x)
  .. .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
  .. .. .. ..- attr(*, "names")= chr [1:2] "y" "x"
 - attr(*, "class")= chr "lm"
```

If we pull out the coefficients by name we get a vector of length two. So before we unnest, we need to change that so that R formats it as a row of a data frame.


```r
sim$reg[[1]]$coefficients %>% as_tibble_row()
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1         0.207  1.01
```

This will make our formatting a lot easier and prevent any duplication that might occur if we unnest a vector that has length > 1. 


```r
sim <- sim %>%
  mutate(coefs = purrr::map(reg, "coefficients") %>%
           purrr::map(as_tibble_row))

sim$coefs[1:5]
[[1]]
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1         0.207  1.01

[[2]]
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1        0.0669 0.972

[[3]]
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1        0.0531 0.959

[[4]]
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1         0.121  1.03

[[5]]
# A tibble: 1 x 2
  `(Intercept)`     x
          <dbl> <dbl>
1       -0.0219 0.999
```

Then, we can plot our results:


```r
sim %>%
  unnest(coefs) %>%
  select(rep, n_outliers, `(Intercept)`, x) %>%
  pivot_longer(-c(rep, n_outliers), names_to = "coef", values_to = "value") %>%
  ggplot(aes(x = value, color = factor(n_outliers))) + geom_density() + 
  facet_wrap(~coef, scales = "free_x")
```

<img src="image/list-cols7-1.png" width="2100" />

So as there are more and more outliers, the coefficient estimates get a wider distribution, but remain (relatively) centered on the "true" values of 0 and 1, respectively. 

Notice that we keep our data in list column form right up until it is time to actually unnest it - which means that we have at the ready the simulated data, the simulated model, and the conditions under which it was simulated, all in the same data structure. It's a really nice, organized system.

## Ways to use `map`

There are 3 main use cases for `map` (and its cousins `pmap`, `map2`, etc.):

1. Use with an existing function
2. Use with an anonymous function, defined on the fly
3. Use with a formula (which is just a concise way to define an anonymous function)

I'll use a trivial example to show the difference between these options:


```r
# An existing function
res <- tibble(x = 1:10, y1 = map_dbl(x, log10))

# An anonymous function
res <- res %>% mutate(y2 = map_dbl(x, function(z) z^2/10))

# A formula equivalent to function(z) z^5/(z + 10)
# the . is the variable you're manipulating
res <- res %>% mutate(y3 = map_dbl(x, ~.^5/(.+10)))
```

It can be a bit tricky to differentiate between options 2 and 3 in practice - the biggest difference is that you're not using the keyword `function` and your variable is the default placeholder variable `.` used in the tidyverse. 

```r
.reset()

library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
✓ ggplot2 3.3.3.9000     ✓ purrr   0.3.4     
✓ tibble  3.1.1          ✓ dplyr   1.0.5     
✓ tidyr   1.1.3          ✓ stringr 1.4.0     
✓ readr   1.4.0          ✓ forcats 0.5.1     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
x tidyr::extract()   masks magrittr::extract()
x dplyr::filter()    masks stats::filter()
x dplyr::lag()       masks stats::lag()
x purrr::set_names() masks magrittr::set_names()
library(repurrrsive)
```

### Try it out {- .tryitout}

Use each of the 3 options for defining a method in purrr to pull out a single string of all of the books each character was in. To do this, you'll need to collapse the list of books for each character into a single string, which you can do with the `paste` function and the `collapse` argument.


```r
letters[1:10] %>% paste(collapse = "|")
[1] "a|b|c|d|e|f|g|h|i|j"
```
Start with this data frame of character names and book list-columns:


```r
data(got_chars)

got_df <- tibble(name = map_chr(got_chars, "name"),
                 id = map_int(got_chars, "id"),
                 books = map(got_chars, "books"))
```

<details><summary>Solution</summary>

```r
# Define a function


my_collapse <- function(x) paste(x, collapse = " | ")

data(got_chars)

got_df <- tibble(name = map_chr(got_chars, "name"),
                 id = map_int(got_chars, "id"),
                 books = map(got_chars, "books"))

got_df <- got_df %>%
  mutate(
    fun_def_res = map_chr(books, my_collapse),
    # Here, I don't have to define a function, I just pass my additional 
    # argument in after the fact...
    fun_base_res = map_chr(books, paste, collapse = " | "),
    
    # Here, I can just define a new function without a name and apply it to 
    # each entry
    fun_anon_res = map_chr(books, function(x) paste(x, collapse = " | ")),
    
    # And here, I don't even bother to specifically say that I'm defining a 
    # function, I just apply a formula to each entry
    fun_formula_res = map_chr(books, ~paste(., collapse = " | "))
  ) 

head(got_df)
# A tibble: 6 x 7
  name      id books  fun_def_res   fun_base_res  fun_anon_res  fun_formula_res 
  <chr>  <int> <list> <chr>         <chr>         <chr>         <chr>           
1 Theon…  1022 <chr … A Game of Th… A Game of Th… A Game of Th… A Game of Thron…
2 Tyrio…  1052 <chr … A Feast for … A Feast for … A Feast for … A Feast for Cro…
3 Victa…  1074 <chr … A Game of Th… A Game of Th… A Game of Th… A Game of Thron…
4 Will    1109 <chr … A Clash of K… A Clash of K… A Clash of K… A Clash of Kings
5 Areo …  1166 <chr … A Game of Th… A Game of Th… A Game of Th… A Game of Thron…
6 Chett   1267 <chr … A Game of Th… A Game of Th… A Game of Th… A Game of Thron…
```
</details>


<!-- ## Other Purrr functions -->
## Beyond `map`: Functions with multiple inputs

Sometimes, you might need to map a function over two vectors/lists in parallel. `purrr` has you covered with the `map2` function. As with `map`, the syntax is `map2(thing1, thing2, function, other.args)`; the big difference is that `function` takes two arguments.

Let's create a simple times-table:

```r
crossing(x = 1:10, y = 1:10) %>%
  mutate(times = map2_int(x, y, `*`)) %>%
  pivot_wider(names_from = y, names_prefix = 'y=', values_from = times)
# A tibble: 10 x 11
       x `y=1` `y=2` `y=3` `y=4` `y=5` `y=6` `y=7` `y=8` `y=9` `y=10`
   <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>  <int>
 1     1     1     2     3     4     5     6     7     8     9     10
 2     2     2     4     6     8    10    12    14    16    18     20
 3     3     3     6     9    12    15    18    21    24    27     30
 4     4     4     8    12    16    20    24    28    32    36     40
 5     5     5    10    15    20    25    30    35    40    45     50
 6     6     6    12    18    24    30    36    42    48    54     60
 7     7     7    14    21    28    35    42    49    56    63     70
 8     8     8    16    24    32    40    48    56    64    72     80
 9     9     9    18    27    36    45    54    63    72    81     90
10    10    10    20    30    40    50    60    70    80    90    100
# we could use `multiply_by` instead of `*` if we wanted to
```

If you are using formula notation to define functions with `map2`, you will need to refer to your two arguments as `.x` and `.y`. You can determine this from the Usage section when you run `map2`, which shows you `map2(.x, .y, .f, ...)` - that is, the first argument is .x, the second is .y, and the third is the function. 

### Try it out {- .tryitout}

Use `map2` to determine if each Game of Thrones character has more titles than aliases. Start with this code:


```r
library(repurrrsive)
library(tidyverse)

data(got_chars)
got_names <- tibble(name = purrr::map_chr(got_chars, "name"),
                    titles = purrr::map(got_chars, "titles"),
                    aliases = purrr::map(got_chars, "aliases"))
```

<details><summary>Solution</summary>

```r
got_names %>%
  mutate(more_titles = map2_lgl(titles, aliases, ~length(.x) > length(.y)))
# A tibble: 30 x 4
   name               titles    aliases    more_titles
   <chr>              <list>    <list>     <lgl>      
 1 Theon Greyjoy      <chr [3]> <chr [4]>  FALSE      
 2 Tyrion Lannister   <chr [2]> <chr [11]> FALSE      
 3 Victarion Greyjoy  <chr [2]> <chr [1]>  TRUE       
 4 Will               <chr [1]> <chr [1]>  FALSE      
 5 Areo Hotah         <chr [1]> <chr [1]>  FALSE      
 6 Chett              <chr [1]> <chr [1]>  FALSE      
 7 Cressen            <chr [1]> <chr [1]>  FALSE      
 8 Arianne Martell    <chr [1]> <chr [1]>  FALSE      
 9 Daenerys Targaryen <chr [5]> <chr [11]> FALSE      
10 Davos Seaworth     <chr [4]> <chr [5]>  FALSE      
# … with 20 more rows
```
</details>

Like `map`, you can specify the type of the output response using `map2`. This makes it very easy to format the output appropriately for your application.

You can use functions with many arguments with `map` by using the `pmap` variant; here, you pass in a list of functions, which are identified by position (`..1, ..2, ..3,` etc). Note the `..` - you are referencing the list first, and the index within the list argument 2nd. 


## Purrr References {- .learn-more}

- The Joy of Functional Programming (for Data Science): Hadley Wickham's talk on purrr and functional programming. [~1h video](https://learning.acm.org/techtalks/functionalprogramming) and [slides](https://learning.acm.org/binaries/content/assets/leaning-center/webinar-slides/2019/hadleywickham_techtalkslides.pdf).     
(The Joy of Cooking meets Data Science, with illustrations by Allison Horst)

- [Pirating Web Content Responsibly with R and purrr](https://rud.is/b/2017/09/19/pirating-web-content-responsibly-with-r/) (a blog post in honor of international talk like a pirate day)

- [Happy R Development with purrr](https://colinfay.me/happy-dev-purrr/)

- [Web mining with purrr](https://colinfay.me/purrr-web-mining/)

- [Text Wrangling with purrr](https://colinfay.me/purrr-text-wrangling/)

- [Setting NAs with purrr](https://colinfay.me/purrr-set-na/) (uses the `naniar` package)

- [Mappers with purrr](https://colinfay.me/purrr-mappers/) - handy ways to make your code simpler if you're reusing functions a lot. 

- [Function factories - code optimization with purrr](https://colinfay.me/purrr-code-optim/)

- [Stats and Machine Learning examples with purrr](https://colinfay.me/purrr-statistics/)
