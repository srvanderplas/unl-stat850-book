









# Introduction to Statistical Programming {#intro-prog}


The only way to learn how to program effectively is to take something that works, break it, and then fix it again. There's plenty of theory and you should definitely learn that, but fundamentally, if you are not regularly breaking code, you're probably not programming. 

<div class="figure">
<img src="image/learning_to_code_Orly.jpeg" alt="This is basically the class summarized. " width="50%" />
<p class="caption">(\#fig:unnamed-chunk-2)This is basically the class summarized. </p>
</div>

The goal for this chapter (and several chapters to come) is that you can modify example code and adapt it to the problem at hand. This is the best way to learn how to program, but it means you may break the code and not know how to fix it. If that happens, please try the following steps:

1. Google the error and see if you can understand why it happened.
2. Consult with a classmate to see if they can understand where things broke.
3. Post to the discussion board and see if anyone in the class can understand where things broke.    
(When you do this, post all of the code relevant to the problem, and the error you're getting, so that your classmates can replicate the problem)

If you do not hopelessly break code during this chapter, then please do your best to help others who may not have previously programmed (or previously programmed in these languages). While writing this chapter, I came across about 10 errors in SAS that I'd never encountered before. 

If all else fails, while you're waiting for someone to help you figure out what an error message means... [try this approach](https://xkcd.com/1024/).

## Module Objectives  {- #module-2-objectives}

- Create a program flow map by breaking a problem down into smaller steps
- Write basic scripts to solve mathematical problems with variables, control structures, and scalar/matrix algebra


More informally, the goal is to get familiar with the basics of each programming language, and to show you where to find references for how to use each command -- because (at least) half of programming is knowing where to look something up. 


## Definitions {-}

Many programming resources talk about 3, or 5, or 10 core concepts in any programming language. In this module, we're going to discuss the generic concepts, and then how these concepts are implemented in R and SAS.

Interestingly, the "core concepts" aren't necessarily the same across lists. 
Here is a consensus list of concepts which are generic across languages and usually important

1. **Variables** - a symbolic name or reference to some kind of information. In the expression `a + b > a`, both `a` and `b` are variables. Variables may have a specific type (what data can be stored in the variable), scope (where the variable can be accessed), location (in memory). [Here](https://dev.to/lucpattyn/basic-programming-concepts-for-beginners-2o73) is a nice explanation of the difference between variables in programming and variables in math.

2. **Conditional statements** (if statements) - These statements allow the program to handle information adaptively - if a statement is true, one set of instructions will be used, and if the statement is false, a different set of instructions will be used.

3. **Looping and iteration** - An iteration is any time a sequence of steps is executed. Most languages have several different types of loops or iteration: `for` loops, which allow for the sequence of steps to be executed a specific number of times, `while` loops, which allow for the sequence of steps to be executed while a conditional statement is true, `recursion`, where a block of code calls itself.

4. **Data types and data structures** - these concepts determine what information a variable can hold. Data types are lower-level, simple objects (floating-point numbers, integers, boolean T/F, characters, strings). Data structures may include lists (sequences of many objects) and vectors (sequences of many objects of the same type), dictionaries (a list of key-value pairs), objects (data structures which may hold multiple related pieces of information). 

5. **Functions**, or self-contained modules of code that accomplish a particular task. 

6. **Syntax**, the set of rules that define which combinations of symbols consist of correctly structured and interpretable commands in the language.

7. **Tools**, the set of external programs which may help with development and writing code. Some common tools are IDEs (Integrated Development Environments), which may correct syntax and typos, organize files for you, allow you to keep track of which variables you have defined, and assist you with code organization and navigation. Other tools include compilers (which take human-written code and translate it into efficient machine code), version control systems (which help you track changes to code over time), debuggers, and documentation generators. Not all of these tools are necessary for all languages - scripting languages such as python and R do not require compilers by default, for instance.  

8. **Sequence of commands**: It's important to have the right commands in the right order. Some recipes, like bread dough, are flexible, and you can add the ingredients in almost any order, but in other recipes, the order matters as much as the correct quantity of ingredients (try putting the cheese powder in before the noodles are boiled when making macaroni and cheese. Yuck.). Programming tends to be like these less flexible recipes. 


## Statistical Programming Languages {-}

Having established the generic definitions of the concepts which apply to almost any programming language, we now must examine how R and SAS implement these concepts. R and SAS are both *statistical* programming languages - they are specifically designed to work with data, which means that they make compromises that other languages do not in order to make it easier to write code where the data (rather than the functions, classes, methods, or objects) are the primary concern.

With that said, there are a few notes which are worth mentioning -- 

- <details><summary>Historical view</summary>
Both [R](https://bookdown.org/rdpeng/rprogdatascience/history-and-overview-of-r.html) and [SAS](https://en.wikipedia.org/wiki/SAS_(software)#History) have long histories. SAS in particular dates back to the 1960s, and has syntax which is unique compared to more modern languages such as C, python, Java, and R. R's predecessor, S, dates back to 1976 and was designed for internal use at Bell Labs. The histories of both languages are useful in understanding why they are optimized for their respective tasks, but are not essential for this course (so read them at your leisure).</details>

- <details><summary>Difference between R and SAS</summary><p>
The biggest difference between R and SAS (at a fundamental level) is that R is a [**functional** language](http://adv-r.had.co.nz/Functional-programming.html) - it consists mainly of functions, which can (and do) manipulate objects, including other functions. SAS, on the other hand, is a procedural language - most SAS programs follow a specific series of steps, known as "proc"s. Procs are essentially functions (or compositions of multiple functions), but in SAS, it is simpler to think of an analysis as a series of procedural steps; in R, there are steps, but they may be implemented in a more flexible way (depending on the analysis). </p><p>
Another interesting feature of SAS is that it's really several languages - some commands work in PROC IML (interactive matrix language) but not in a DATA step. When looking for help in SAS, make sure you're referencing the correct part of the language documentation.</p>
</details>

- <details><summary>I'm teaching SAS very differently</summary>
<p>I'm definitely teaching SAS differently than it is normally taught. This is so that we don't have to do half the semester in SAS and half in R - I'd rather teach the concepts and show you how they're implemented than split them up by language. BUT, this means that some of the things we're doing first in SAS are things you wouldn't normally do until you were already proficient in SAS. It also means that SAS is probably going to seem even more oddly organized when taught this way than it actually is (and it is oddly organized, in my opinion).</p><p>
We're going to start with SAS IML (programming concepts) and then talk about the DATA step. We'll use some procedures implicitly along the way, but hopefully that will make sense in context. Then, we'll work on the PROCs (SQL, Transpose, and graphing) - in greater detail. </p>
</details>

- <details><summary>If you've used R or SAS a lot in the past</summary>
<p>Note: If you've programmed before, this chapter is going to seem very ... boring. Sorry, there's no help for that. Some of your classmates haven't ever so much as written "Hello World", and we have to get them up to speed. </p><p>
If you're bored, or feel like you know this material, skim through it anyways just to confirm (and if I'm doing something that's really out there, or there's an easier way to do it, tell me!). Then you can either find something in the references that you don't know already (the book Advanced R is always a great place to start if you want to be quickly confused), or help your classmates that are less experienced. </p>
</details>


::: learn-more
**Basic Syntax and Cheatsheets**

- [SAS Cheatsheet (from another class like this)](https://sites.ualberta.ca/~ahamann/teaching/renr480/SAS-Cheat.pdf)
- [SAS Cheatsheet (by SAS)](https://support.sas.com/content/dam/SAS/support/en/books/data/base-syntax-ref.pdf)
- [R Cheatsheet](https://rstudio.com/wp-content/uploads/2016/10/r-cheat-sheet-3.pdf) - this is a simplified cheat sheet offered by RStudio. 
- [R Cheatsheet (classic)](https://cran.r-project.org/doc/contrib/Short-refcard.pdf)
- [SAS Programming for R Users (free book)](https://support.sas.com/content/dam/SAS/support/en/books/free-books/sas-programming-for-r-users.pdf)

I kept the classic R reference card by my computer for about 5 years, and referenced it at least once or twice a day for that entire period. There will be other cheat sheets and reference cards scattered through this book because if you can't remember something's name, you might be able to remember where it is on the reference card (or at least, that's how I learned R).
:::

## Breaking Problems Down

The most fundamental part of programming that you will need to learn in this class is how to break down a big problem into smaller (hopefully solvable) problems. [This post](https://medium.com/@dannysmith/breaking-down-problems-its-hard-when-you-re-learning-to-code-f10269f4ccd5) is a great example of the process of breaking things down for programming, but the same concept applies outside of programming too!

<details class="ex"><summary>Breaking problems down - remodeling edition</summary>
My spouse and I recently decided to replace our shower curtain with glass doors because the curtain didn't really prevent water from getting all over the floor.

We went to the store and picked out the parts, and the installation instructions broke the steps down like this:

1. Install the base of the track

2. Install the top of the track

3. Hang shower doors

4. Add hardware to shower doors

So we started in on the instructions, only to find out that when our house was built, our shower wasn't leveled properly. The instructions had a solution - we could send off for a $300 custom part that would level our floor, but we'd have to wait at least 4-6 weeks for them to make and ship the part to us. 

We're both programmer-adjacent, so we started thinking through how we could deal with our problem a different way. We considered ignoring the instructions -- our shower was about 1/8" off of level, surely that couldn't be so important, right? My spouse is a bit more ... detail oriented ... than I am, so he wasn't good with that suggestion. 

We considered adding a ton of caulk or plaster to try to level the shower out. But we figured that 1) probably wouldn't work, and 2) would look awful.

Finally, I suggested that my spouse 3D print sections of track-leveler using our 3D printer. Now, this isn't an option for most people, but it is for us - we have a small 3D printer, and spouse knows how to use OpenSCAD to create very accurate, custom dimension 3D printer files. He tested things out a few times, and printed up a series of 12 ~5" sections that when assembled were equivalent to the $300 custom part we could have ordered. Then, he proceeded with the rest of the installation as the instructions listed.

Essentially, because we had a list of subproblems (steps for installation), we could focus our efforts on debugging the one problem we had (not level shower ledge) and we didn't have to get bogged down in "it's impossible to get this job done" - we knew that if we could solve the little problem, we'd be able to get the bigger job done. Programming is just like this - if you can break your problem down into steps (and not steps with code), you can think through how to solve a single step of the problem before you worry about the next step. 
</details>


One tool that is often used to help break a problem down is a [flowchart](https://www.programiz.com/article/flowchart-programming). 

### Try it out {-.tryitout}
The biggest advantage to breaking problems down into smaller steps is that it allows you to focus on solving a small, approachable problem. 

Let's think through an example: suppose I want you to write a program to print out a pyramid of stars, 10 lines high. Yes, I remember, I haven't taught you how to write any code yet. Don't worry about code right now - let's just think about how we might create a pyramid of stars. 

Start by writing some instructions to yourself.

<details><summary>Solution</summary>

First, we have to think about what we would need to make a pyramid of stars. So let's make a miniature one by hand (I'm using - for spaces here to make things visible):
```
---*---
--***--
-*****-
```

To make my miniature star pyramid, I started out by adding space on the first line, then a star, then more space. When I moved to the next line, I added space, but one less space than I'd added before, and then 3 stars, and then more space. So we can break our problem down into two components:

- How much space? (one side)
- How many stars?
- (redundant piece) How much space (the other side).

Thinking my way through how I created my manual pyramid, I realized that I was adding $n$ spaces (where $n$ is the total number of rows) on the first line, and then $n - i$ spaces on subsequent lines, if we start with i=0. But I am an R programmer, so we start with $i=1$, which means I need to have $n - i + 1$ spaces on each row first.

Then, for $i=1$ the first row, we have $2*i - 1$ stars - i = 1, stars = 1, then i = 2, stars = 3, then i = 3, stars = 5....  you can do the regression if you want to, but it's pretty easy to see the relationship.

Finally, we have to (in theory) add the same amount of space on the other side -- strictly speaking, this is optional, but it makes the lines the same length, so it is nice.

So we've thought through the problem step by step, and now we just need to summarize it:

If we want a pyramid that is $n$ rows high, we might think of creating it by using the following line-by-line formula, where $i$ is our current line:

$n - i +1$ spaces, $2i - 1$ stars, $n - i + 1$ spaces

Working this out in a small example helped me come up with that formula; now, I can write a "loop":

- line 1: i = 1, n = 10, 10 spaces, 1 star, 10 spaces
- line 2: i = 2, n = 10, 9 spaces, 3 stars, 9 spaces
- line 3: i = 3, n = 10, 8 spaces, 5 stars, 8 spaces
- line 4: i = 4, n = 10, 7 spaces, 7 stars, 7 spaces
- ...
- line n: i = n, n = 10, 1 space, 19 stars, 1 space

Our program flow map would look something like this:
![Program flow map for stars](image/prog-flow-pyramid-stars.svg)
</details>


## Variable types

Variable types are sufficiently different in R and SAS that we will cover R first, then SAS. For a general overview, though, [this video, titled 'Why TRUE + TRUE = 2'](https://youtu.be/6otW6OXjR8c?list=PL96C35uN7xGLLeET0dOWaKHkAlPsrkcha) is an excellent introduction. 

### R

In R, there are 4 commonly-used types: 

| Type | Description | 
| ---- | ----------- | 
| character | holds text-based information: "abcd" or "3.24a" are examples of values which would be stored as characters in R| 
| logical | holds binary information: 0/1, or FALSE/TRUE. Logical variables are stored as single bit information (e.g. either a 0 or 1), but display as TRUE and FALSE (which are reserved words and constants). | 
| integer | holds (as you might expect) integers. Note that integers are handled differently than doubles (floating point numbers), but in general, R will implicitly convert integers to doubles to avoid common pitfalls with integer divison (which does not allow for decimals). | 
| double | holds floating point numbers. By default, most numeric variables in R are doubles.| 


You can test to see whether a variable holds a value of a specific type using the `is.xxx()` functions, which are demonstrated below. You can convert a variable of one type to another with `as.xxx()` functions. You can test what type a variable is using `typeof()`.

::: note
Note that `<-` is used for assigning a value to a variable. So `x <- "R is awesome"` is read "x gets 'R is awesome'" or "x is assigned the value 'R is awesome'". 
:::

#### Character variables {-}

```r
x <- "R is awesome"
typeof(x)
## [1] "character"
is.character(x)
## [1] TRUE
is.logical(x)
## [1] FALSE
is.integer(x)
## [1] FALSE
is.double(x)
## [1] FALSE
```

#### Logical Variables {-}

```r
x <- FALSE
typeof(x)
## [1] "logical"
is.character(x)
## [1] FALSE
is.logical(x)
## [1] TRUE
is.integer(x)
## [1] FALSE
is.double(x)
## [1] FALSE
```

It is possible to use the shorthand `F` and `T`, but be careful with this, because `F` and `T` are not reserved, and other information can be stored within them. See [this discussion](https://twitter.com/tslumley/status/1279870794730893312) for pros and cons of using `F` and `T` as variables vs. shorthand for true and false. ^[There is also an [R package dedicated to pure evil](https://purrple.cat/blog/2017/05/28/turn-r-users-insane-with-evil/) that will set F and T randomly on startup. Use this information wisely.]

#### Integer Variables {-}

```r
x <- 2
typeof(x)
## [1] "double"
is.character(x)
## [1] FALSE
is.logical(x)
## [1] FALSE
is.integer(x)
## [1] FALSE
is.double(x)
## [1] TRUE
```

Wait, 2 is an integer, right?

2 is an integer, but in R, values are assumed to be doubles unless specified. So if we want R to treat 2 as an integer, we need to specify that it is an integer specifically. 


```r
x <- 2L # The L immediately after the 2 indicates that it is an integer.
typeof(x)
## [1] "integer"
is.character(x)
## [1] FALSE
is.logical(x)
## [1] FALSE
is.integer(x)
## [1] TRUE
is.double(x)
## [1] FALSE
is.numeric(x)
## [1] TRUE
```

#### Double Variables {-}

```r
x <- 2.45
typeof(x)
## [1] "double"
is.character(x)
## [1] FALSE
is.logical(x)
## [1] FALSE
is.integer(x)
## [1] FALSE
is.double(x)
## [1] TRUE
is.numeric(x)
## [1] TRUE
```

#### Numeric Variables {-}
A fifth common "type"^[`numeric` is not really a type, it's a mode. Run `?mode` for more information.], `numeric` is really the union of two types: integer and double, and you may come across it when using `str()` or `mode()`, which are similar to `typeof()` but do not quite do the same thing.

The `numeric` category exists because when doing math, we can add an integer and a double, but adding an integer and a string is ... trickier. Testing for numeric variables guarantees that we'll be able to do math with those variables. `is.numeric()` and `as.numeric()` work as you would expect them to work.

The general case of this property of a language is called **implicit type conversion** - that is, R will implicitly (behind the scenes) convert your integer to a double and then add the other double, so that the result is unambiguously a double. 
</details>

#### Type Conversions {-}
R will generally work hard to seamlessly convert variables to different types. So, for instance, 

```r
TRUE + 2
## [1] 3

2L + 3.1415
## [1] 5.1415

"abcd" + 3
## Error in "abcd" + 3: non-numeric argument to binary operator
```

This conversion doesn't always work - there's no clear way to make "abcd" into a number we could use in addition. So instead, R will issue an error. This error pops up frequently when something went wrong with data import and all of a sudden you just tried to take the mean of a set of string/character variables. Whoops.

When you want to, you can also use `as.xxx()` to make the type conversion **explicit**. So, the analogue of the code above, with explicit conversions would be: 


```r
as.double(TRUE) + 2
## [1] 3

as.double(2L) + 3.1415
## [1] 5.1415

as.numeric("abcd") + 3
## Warning: NAs introduced by coercion
## [1] NA
```

When we make our intent explicit (convert "abcd" to a numeric variable) we get an NA - a missing value. There's still no easy way to figure out where "abcd" is on a number line, but our math will still have a result - `NA + 3` is `NA`.

If you are unsure what the type of a variable is, use the `typeof()` function to find out. 


```r
w <- "a string"
x <- 3L
y <- 3.1415
z <- FALSE

typeof(w)
## [1] "character"
typeof(x)
## [1] "integer"
typeof(y)
## [1] "double"
typeof(z)
## [1] "logical"
```


#### Factors {- #introfactors}

In R, there is one other type of variable to know about, and that is a factor. Factors are basically labeled integers. Instead of storing the data as a string or character, R instead stores the data as a series of integers, and then stores a separate table mapping the integers to labels. This is technically more efficient (which was important when computers had extremely limited memory), but it is also a pain in the rear (that's a technical term). 

Factors are the default way to store characters for most base R functions. Or rather, they were. In R 4.0, the default way to read data in will change from `stringsAsFactors = T` to `stringsAsFactors = F`. You can read about why factors aren't ideal [here](https://developer.r-project.org/Blog/public/2020/02/16/stringsasfactors/index.html), which helps explain why this change was made. 

Depending on what version of R you have installed, you may run into errors related to factors, or not. Because R 4.0 is so new (released in May 2020) <!-- time-specific XXX fix later --> most of the tutorials online will probably have behavior that isn't matched by your R installation. I'm new enough to R 4.0 that I'm not sure when factor related errors will pop up.

Other reasons to learn factors besides for debugging purposes:

- They allow you to control the order of things in graphs, tables, and models
- They allow you to easily change category labels without having to sort through an entire data table
- ... I'm sure there are more, but I'm drawing a blank at the moment


::: note
In this example, we'll use a data.frame, which you can think of as a spreadsheet-type table. We'll work with data frames later in much more detail, but for now, I'm mostly trying to show you a real-life situation that happens ALL the time, with the hopes that you'll recognize the error when/if you encounter it. The data frame isn't the important part.
:::

<details class="ex"><summary>Factors example</summary>
Let's look at the names of the months:

```r
month.name
##  [1] "January"   "February"  "March"     "April"     "May"       "June"     
##  [7] "July"      "August"    "September" "October"   "November"  "December"

df <- data.frame(num = 1:12, name = month.name, stringsAsFactors = T)
# I'm putting the argument in so that this is still relevant when everyone 
# switches to R 4.0. Even with stringsAsFactors = F, factors are still useful 
# and we still need to work with them.
# 
# Any time you create a data frame in base R, you should be watchful for errors
# that are based on strings being converted to factors.

str(df)
## 'data.frame':	12 obs. of  2 variables:
##  $ num : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ name: Factor w/ 12 levels "April","August",..: 5 4 8 1 9 7 6 2 12 11 ...
```

Notice that as soon as we make that data.frame, the months are converted into a factor variable? The other big problem is that the order of the factor levels is ... not what we'd normally want. We don't want alphabetical ordering of month names - they have a different, implicit, and natural order.

We could get this same behavior without the data.frame, but this is where it shows up most often.


```r
month_fct <- factor(month.name) # the order is still not exactly what we'd want it to be
```

To fix this, we can explicitly specify that we're dealing with a factor, and what we want the levels to be. If you specify the levels manually (instead of letting R do the work for you) then you get to determine the order. 

```r
month_fct <- factor(month.name, levels = month.name)
str(month_fct)
##  Factor w/ 12 levels "January","February",..: 1 2 3 4 5 6 7 8 9 10 ...
```

We can even be more explicit: 


```r
month_fct <- factor(month.name, levels = month.name, ordered = T)
str(month_fct)
##  Ord.factor w/ 12 levels "January"<"February"<..: 1 2 3 4 5 6 7 8 9 10 ...
```

Making the factor ordered lets us explicitly say which levels are less than other levels.

Factors are technically integers, with labels that are stored as an attribute. That doesn't mean you can do math with them, though. 

```r
month_fct[1] + month_fct[2]
## Warning in Ops.ordered(month_fct[1], month_fct[2]): '+' is not meaningful for
## ordered factors
## [1] NA
```

Often, years or dates or other numeric-like information will end up as factor variables. When this happens, you need to be a little bit careful. 


```r
# This works pretty naturally for months, right?
as.numeric(month_fct)
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12

yfact <- factor(2000:2020, levels = 2000:2020)
yfact
##  [1] 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014
## [16] 2015 2016 2017 2018 2019 2020
## 21 Levels: 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 ... 2020
# But, this does not...
as.numeric(yfact)
##  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21

as.character(yfact) # gets the labels
##  [1] "2000" "2001" "2002" "2003" "2004" "2005" "2006" "2007" "2008" "2009"
## [11] "2010" "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018" "2019"
## [21] "2020"
as.numeric(as.character(yfact)) # gets the info we want
##  [1] 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014
## [16] 2015 2016 2017 2018 2019 2020
```
When converting factors with numeric labels, you need to first convert the factor to a character, and then to a numeric variable. That will get the information you actually want back out.
</details>


#### Try It Out {- .tryitout}

1. Create variables `string`, `integer`, `decimal`, and `logical`, with types that match the relevant variable names.


```r
string <- 
integer <- 
decimal <- 
logical <- 
```

2. Can you get rid of the error that occurs when this chunk is run?

```r
logical + decimal
integer + decimal
string + integer
```

3. What happens when you add string to string? logical to logical?


<details><summary>Solutions</summary>


```r
string <- "hi, I'm a string"
integer <- 4L
decimal <- 5.412
logical <- TRUE

logical + decimal
## [1] 6.412
integer + decimal
## [1] 9.412
as.numeric(string) + integer
## Warning: NAs introduced by coercion
## [1] NA

"abcd" + "defg"
## Error in "abcd" + "defg": non-numeric argument to binary operator
TRUE + TRUE
## [1] 2
```

In R, adding a string to a string creates an error ("non-numeric argument to binary operator"). Adding a logical to a logical, e.g. TRUE + TRUE, results in 2, which is a numeric value.
</details>

### SAS

In SAS, there are two basic variable types: numeric and character variables. SAS does not differentiate between integers and floats and doubles. Functionally, though, the same basic operations can be performed in SAS. As with R, SAS does attempt to implicitly convert variable types, and will notify you that the conversion has taken place in the log file.

#### Type Conversions {-}
SAS will attempt to implicitly convert variables when:

- a character value is assigned to a previously defined numeric variable
- a character value is used in arithmetic operations
- a character value is compared to a numeric value using a comparison operator (<, >, <=, >=)
- a character value is specified in a function that takes numeric arguments

::: note
Implicit conversion does not occur in WHERE statements. (This will make more sense later, but is here for reference)
:::

<details><summary>Manual type conversions</summary>
If you want to manually convert a value, use the INPUT statement. Unlike in R, the INPUT statement has the ability to read numbers which are formatted differently. For instance


```sas
data set1;
  x = 3;
  y = '3.1415';
  z = x * y;
  put z;
run;
```


```sas
data set2;
  x = 3;
  y = '3.1415';
  z = x * y;
  put z; /* print to log */

  x = '3.14159';
  /* x previously had a number in it, 
     so it will be converted to a number here */
  put x; /* print to log */

  zz = y <= 2;
  /* comparison operator: y will be converted */
  put zz; /* print to log */
  
run;
```



Notice that in SAS, `zz`, which is the result of the logical statement `y<=2`, is a numeric variable. The value 0 signifies that the comparison was false. SAS does not have a logical data type, it uses the numeric variable with 0:=FALSE, 1:=TRUE.

</details>


#### Try it out {- .tryitout}

1. Create variables `string1` and `string2` that each have text/character values. "Bob" and "Jane" might be good options. How does logical operation work with actual character values?

2. What happens if you use `string1` and add 3 to it? 

<details><summary>Solutions</summary>

```sashtmllog
6          data set1;
7            string1 = 'Bob';
8            string2 = 'Jane';
9            x = string1 < string2;
10           put x=; /* This prints the result to the log */
11         run;

x=1
NOTE: The data set WORK.SET1 has 1 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

12         
```

SAS will actually compare strings based on the first letter: Bob comes before Jane, so Bob < Jane. 



```sashtmllog
6          data set2;
7            string1 = 'Bob';
8            y = string1 + 3;
9            put y=;
10         run;

NOTE: Character values have been converted to numeric 
      values at the places given by: (Line):(Column).
      8:7   
NOTE: Invalid numeric data, string1='Bob' , at line 8 column 7.
y=.
string1=Bob y=. _ERROR_=1 _N_=1
NOTE: Missing values were generated as a result of performing an operation 
      on missing values.
      Each place is given by: (Number of times) at (Line):(Column).
      1 at 8:15   
NOTE: The data set WORK.SET2 has 1 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
```


The `.` in SAS is a missing value (like `NA` in R). So SAS is behaving basically like R does: it complains about the fact that you asked it to add a string to a number, and then it stores the result as a missing value. 

</details>

## Data structures

Data **structures** are more complex arrangements of information than single variables. Of primary interest in statistical programming are the following types of structures:

&nbsp;  | Homogeneous | Heterogeneous
-- | :---------- | :------------
1d | vector | list
2d | matrix | data frame (R) or data set (SAS)
nd | array (R) |

In the table above, homogeneous means that all entries in the structure must be of the same type. Heterogeneous means that the entries are allowed to be of different types. 

::: note
Figuring out what to call these types with two languages is hard - in SAS, an array is a group of columns of a data set, but in R, it's a multi-dimensional matrix. In this section, we'll discuss the generic concepts relevant to both languages. The differences between the two languages will be discussed as appropriate. As there are more similarities than differences, it's easier to do this in a single section rather than duplicating half of the content.
:::

### Homogeneous data structures (R and SAS)

R does not have scalar types - even single-value variables are technically vectors of length 1. SAS does have scalar types.

If we try to create a heterogeneous vector in R, using the `concatenate` function, `c()`, which combines scalar entries into a vector, what happens?


```r
c(1, 2, "a", "b", "c")
## [1] "1" "2" "a" "b" "c"
```
Because there were 3 character entries, the entire vector is now a character vector.

<div class="watchout">
R's vector-by-default approach can cause some errors - for instance, R does not read in numeric data formatted with commas as numeric data. You may thus get the result


```r
x <- c(356, 452, "1,325")
mean(x)
## Warning in mean.default(x): argument is not numeric or logical: returning NA
## [1] NA
```

If you are reading in data from a file, this will cause some issues - the whole column of data will be formatted as characters. Keep an eye out for errors of this type. 

One fix for this is to read things in as a character and use the `parse_number` function from the `readr` package -- we'll talk about the `readr` package in [Module 4](#reading-data)
</div>


Jenny Bryan has an excellent set of images to demonstrate [R data types as legos](https://twitter.com/JennyBryan/status/799639755344359426). She's released them under an open license, so I am shamelessly stealing them. 

Logical vector | Factor vector | Integer and Numeric vectors
-------------- | ------------- | --------------
![](https://github.com/jennybc/lego-rstats/blob/master/lego-rstats_016.jpg?raw=true) | ![](https://github.com/jennybc/lego-rstats/raw/master/lego-rstats_017.jpg?raw=true) | ![](https://github.com/jennybc/lego-rstats/raw/master/lego-rstats_018.jpg?raw=true)

These correspond to the 1-dimensional homogeneous data structures. Similarly, models can be made for 2-dimensional and 3-dimensional homogeneous data structures^[While there are both Duplo and Lego in my house, my toddler is a lot more willing to share than my husband, so Duplo will have to do.]:

Vector (1D) | Matrix (2D) | Array (3D)
----------- | ----------- | ----------
![](image/02_green-lego-1d.png) | ![](image/02_green-lego-2d.png) | ![](image/02_green-lego-3d.png)


### Heterogeneous data structures

The heterogeneous data types are not much harder to grasp, as they're mostly different ways to combine various homogeneous data types.

#### Lists 

A **list** is, well, a list - a sequence of potentially different-typed values. Unlike when concatenating values, the `list()` command in R allows each value to keep its natural type. You can access elements of a list using `[]` (this will extract a subset of the list items) or `[[]]`, which will extract a single item from the list. (there will be more on this in the [Indexing section](#indexing) below)

##### Basic List Syntax in R {-}

```r
x <- list("a", "b", "c", 1, 2, 3)

x
## [[1]]
## [1] "a"
## 
## [[2]]
## [1] "b"
## 
## [[3]]
## [1] "c"
## 
## [[4]]
## [1] 1
## 
## [[5]]
## [1] 2
## 
## [[6]]
## [1] 3
x[[3]]
## [1] "c"

x[[4]] + x[[5]]
## [1] 3

x[1:2] # This will work
## [[1]]
## [1] "a"
## 
## [[2]]
## [1] "b"

x[[1:2]] # This won't work
## Error in x[[1:2]]: subscript out of bounds
```


The lego version of a list looks like this: 
<div class="figure">
<img src="https://github.com/jennybc/lego-rstats/raw/master/lego-rstats_019.jpg?raw=TRUE" alt="A list of 4 vectors. Even though the vectors in the list are all the same size in this case, they don't have to be, because they're not organized in any sort of cohesive rectangle shape. A data frame (see below) is essentially a list where all of the components are vectors or lists of the same length. " width="50%" />
<p class="caption">(\#fig:lego-list)A list of 4 vectors. Even though the vectors in the list are all the same size in this case, they don't have to be, because they're not organized in any sort of cohesive rectangle shape. A data frame (see below) is essentially a list where all of the components are vectors or lists of the same length. </p>
</div>

##### Indexing in Lists {-}

Some lists (and data frames) consist of named variables. These list components can be accessed either by index (as above) or by name, using the `$` operator. Names which have spaces or special characters must be enclosed in backticks (next to the 1 on the keyboard). Named components can also be accessed using the `[[ ]]` operator.


```r
dog <- list(name = "Edison Vanderplas", age = 8, 
            breed = "Jack Russell Terrorist", 
            `favorite toy` = "a blue and orange stuffed duck. Or rawhide.",
            `link(video)` = "https://youtu.be/zVeoQTOTIuQ")

dog
## $name
## [1] "Edison Vanderplas"
## 
## $age
## [1] 8
## 
## $breed
## [1] "Jack Russell Terrorist"
## 
## $`favorite toy`
## [1] "a blue and orange stuffed duck. Or rawhide."
## 
## $`link(video)`
## [1] "https://youtu.be/zVeoQTOTIuQ"

dog$name
## [1] "Edison Vanderplas"
dog$breed
## [1] "Jack Russell Terrorist"
dog$`favorite toy`
## [1] "a blue and orange stuffed duck. Or rawhide."
dog[["link(video)"]]
## [1] "https://youtu.be/zVeoQTOTIuQ"
```


You can get a sense of the structure of a list (or any other object) in R using the `str()` command.


```r

str(dog)
## List of 5
##  $ name        : chr "Edison Vanderplas"
##  $ age         : num 8
##  $ breed       : chr "Jack Russell Terrorist"
##  $ favorite toy: chr "a blue and orange stuffed duck. Or rawhide."
##  $ link(video) : chr "https://youtu.be/zVeoQTOTIuQ"
```

##### Recursive lists {-}
Lists can also contain other lists. When accessing a list-within-a-list, just add another index or name reference (see below). 


```r
grocery_list <- list(
  dairy = list("asiago", "fontina", "mozzarella", "blue cheese"),
  baking = list("flour", "yeast", "salt"),
  canned_goods = list("pepperoni", "pizza sauce", "olives"),
  meat = list("bacon", "sausage", "anchovies"),
  veggies = list("bell pepper", "onion", "scallions", "tomatoes", "basil")
)

ick <- c(grocery_list[[4]][2:3], grocery_list$canned_goods[[3]])
ick
## [[1]]
## [1] "sausage"
## 
## [[2]]
## [1] "anchovies"
## 
## [[3]]
## [1] "olives"

crust_ingredients <- c(grocery_list$baking, "water")
crust_ingredients
## [[1]]
## [1] "flour"
## 
## [[2]]
## [1] "yeast"
## 
## [[3]]
## [1] "salt"
## 
## [[4]]
## [1] "water"

essential_toppings <- c(grocery_list$dairy[3], grocery_list$canned_goods[2])
essential_toppings
## [[1]]
## [1] "mozzarella"
## 
## [[2]]
## [1] "pizza sauce"

yummy_toppings <- c(grocery_list$dairy[c(1, 2, 4)], grocery_list$meat[1], grocery_list[[5]][c(3, 5)])
yummy_toppings
## [[1]]
## [1] "asiago"
## 
## [[2]]
## [1] "fontina"
## 
## [[3]]
## [1] "blue cheese"
## 
## [[4]]
## [1] "bacon"
## 
## [[5]]
## [1] "scallions"
## 
## [[6]]
## [1] "basil"
```

##### Basic List Syntax in SAS {-}
There are also [lists in SAS IML](https://documentation.sas.com/?docsetId=imlug&docsetTarget=imlug_langref_sect040.htm&docsetVersion=15.1&locale=en) which function similarly to lists in R. To create a named object in a list, precede the name with `#`. In SAS, the `$` operator can be used to get items from a list, using either name or numeric references. 


```sashtml

proc iml;
  grocery_list = [
    #dairy  = ["asiago", "fontina", "mozzarella", "blue cheese"], 
    #baking = ["flour", "yeast", "salt"], 
    #canned = ["pepperoni", "pizza sauce", "olives"], 
    #meat   = ["bacon", "sausage", "anchovies"], 
    #veggies= ["bell pepper", "onion", "scallions", "tomatoes", "basil"]
  ];

  /* print only works on matrices and vectors */
  /* so we'll cheat and load another library to print lists */
  
  package load ListUtil;
  
  /* run ListPrint(grocery_list); */ 
  /* This would print the thing, but it's long */
  
  ick = [grocery_list$"canned"$3, grocery_list$4$2, grocery_list$4$3];
  crust = grocery_list$"baking";
  call ListAddItem(crust, "water"); /* add an item to a list */
  essential_toppings = [grocery_list$"dairy"$3, grocery_list$"canned"$2];
  yummy_toppings = [grocery_list$"dairy"$1, grocery_list$"dairy"$2, 
    grocery_list$"dairy"$4, grocery_list$"meat"$1, grocery_list$5$3] ;
  /* The || is a concatenation operator, like c(). */
  /* It is inefficient for large data sets */
  
  run ListPrint(ick);
  run ListPrint(crust);
  run ListPrint(yummy_toppings);
quit;

```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: labl">
<colgroup>
<col>
</colgroup>
<tbody>
<tr>
<td class="l data">--------- List = ick---------</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX1"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 1">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 1</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">olives</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX2"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 2">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">sausage</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX3"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 3">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 3</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">anchovies</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX4"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: labl">
<colgroup>
<col>
</colgroup>
<tbody>
<tr>
<td class="l data">--------- List = crust---------</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX5"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 1">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 1</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">flour</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX6"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 2">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">yeast</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX7"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 3">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 3</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">salt</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX8"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 4">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 4</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">water</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX9"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: labl">
<colgroup>
<col>
</colgroup>
<tbody>
<tr>
<td class="l data">--------- List = yummy_toppings---------</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX10"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 1">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 1</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">asiago</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX11"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 2">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">fontina</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX12"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 3">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 3</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">blue cheese</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX13"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 4">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 4</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">bacon</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX14"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: Item 5">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">Item 5</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">scallions</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>



##### Try it out {- .tryitout}
Using the list of pizza toppings above as a starting point, make your own list of pizza toppings organized by grocery store section (approximately). Create your own vectors of yummy, essential, and ick toppings, using R and SAS.


#### Data frames (R only) 

A data frame is a special type of list - one in which each element in the list is a vector of the same length. If you put these vectors side-by-side, you get a table of data that looks like a spreadsheet. 


The lego version of a data frame looks like this: 
<div class="figure">
<img src="https://github.com/jennybc/lego-rstats/raw/master/lego-rstats_020.jpg?raw=TRUE" alt="A data frame with data frame 4 columns. A data frame is essentially a list where all of the components are vectors or lists, and are constrained to have the same length. " width="50%" />
<p class="caption">(\#fig:lego-df)A data frame with data frame 4 columns. A data frame is essentially a list where all of the components are vectors or lists, and are constrained to have the same length. </p>
</div>

##### Basic Data Frame Syntax {-}
When you examine the structure of a data frame, as shown below, you get each column shown in a row, with its type and  the first few values in the column. The `head()` command shows the first 6 rows of a data frame (enough to see what's there, not enough to overflow your screen).


```r
head(mtcars) ## A data frame included in base R
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

str(mtcars)
## 'data.frame':	32 obs. of  11 variables:
##  $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
##  $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
##  $ disp: num  160 160 108 258 360 ...
##  $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
##  $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
##  $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
##  $ qsec: num  16.5 17 18.6 19.4 17 ...
##  $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
##  $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
##  $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
##  $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```

You can change column values or add new columns easily using assignment. It's also easy to access specific columns to perform summary operations.


```r
mtcars$gpm <- 1/mtcars$mpg # gpm is sometimes used to assess efficiency

summary(mtcars$gpm)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 0.02950 0.04386 0.05208 0.05423 0.06483 0.09615
summary(mtcars$mpg)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   10.40   15.43   19.20   20.09   22.80   33.90
```

Often, it is useful to know the dimensions of a data frame. The number of rows can be obtained by using `nrow(df)` and similarly, the columns can be obtained using `ncol(df)` (or, get both with `dim()`). There is also an easy way to get a summary of each column in the data frame, using `summary()`.



```r
summary(mtcars)
##       mpg             cyl             disp             hp       
##  Min.   :10.40   Min.   :4.000   Min.   : 71.1   Min.   : 52.0  
##  1st Qu.:15.43   1st Qu.:4.000   1st Qu.:120.8   1st Qu.: 96.5  
##  Median :19.20   Median :6.000   Median :196.3   Median :123.0  
##  Mean   :20.09   Mean   :6.188   Mean   :230.7   Mean   :146.7  
##  3rd Qu.:22.80   3rd Qu.:8.000   3rd Qu.:326.0   3rd Qu.:180.0  
##  Max.   :33.90   Max.   :8.000   Max.   :472.0   Max.   :335.0  
##       drat             wt             qsec             vs        
##  Min.   :2.760   Min.   :1.513   Min.   :14.50   Min.   :0.0000  
##  1st Qu.:3.080   1st Qu.:2.581   1st Qu.:16.89   1st Qu.:0.0000  
##  Median :3.695   Median :3.325   Median :17.71   Median :0.0000  
##  Mean   :3.597   Mean   :3.217   Mean   :17.85   Mean   :0.4375  
##  3rd Qu.:3.920   3rd Qu.:3.610   3rd Qu.:18.90   3rd Qu.:1.0000  
##  Max.   :4.930   Max.   :5.424   Max.   :22.90   Max.   :1.0000  
##        am              gear            carb            gpm         
##  Min.   :0.0000   Min.   :3.000   Min.   :1.000   Min.   :0.02950  
##  1st Qu.:0.0000   1st Qu.:3.000   1st Qu.:2.000   1st Qu.:0.04386  
##  Median :0.0000   Median :4.000   Median :2.000   Median :0.05208  
##  Mean   :0.4062   Mean   :3.688   Mean   :2.812   Mean   :0.05423  
##  3rd Qu.:1.0000   3rd Qu.:4.000   3rd Qu.:4.000   3rd Qu.:0.06483  
##  Max.   :1.0000   Max.   :5.000   Max.   :8.000   Max.   :0.09615
dim(mtcars)
## [1] 32 12
nrow(mtcars)
## [1] 32
ncol(mtcars)
## [1] 12
```

Missing variables in an R data frame are indicated with NA. 


<details class="ex"><summary>Creating an R data frame</summary>

```r
math_and_lsd <- data.frame(lsd_conc = c(1.17, 2.97, 3.26, 4.69, 5.83, 6.00, 6.41),
                           test_score = c(78.93, 58.20, 67.47, 37.47, 45.65, 32.92, 29.97))
math_and_lsd
##   lsd_conc test_score
## 1     1.17      78.93
## 2     2.97      58.20
## 3     3.26      67.47
## 4     4.69      37.47
## 5     5.83      45.65
## 6     6.00      32.92
## 7     6.41      29.97

# add a column - character vector
math_and_lsd$subjective <- c("finally coming back", "getting better", "it's totally better", "really tripping out", "is it over?", "whoa, man", "I can taste color, but I can't do math")

math_and_lsd
##   lsd_conc test_score                             subjective
## 1     1.17      78.93                    finally coming back
## 2     2.97      58.20                         getting better
## 3     3.26      67.47                    it's totally better
## 4     4.69      37.47                    really tripping out
## 5     5.83      45.65                            is it over?
## 6     6.00      32.92                              whoa, man
## 7     6.41      29.97 I can taste color, but I can't do math
```
</details>

##### Try it out {- .tryitout}

The dataset `state.x77` contains information on US state statistics in the 1970s. By default, it is a matrix, but we can easily convert it to a data frame, as shown below. 


```r
data(state)
state_facts <- data.frame(state.x77)
state_facts <- cbind(state = row.names(state_facts), state_facts, stringsAsFactors = F) 
# State names were stored as row labels
# Store them in a variable instead, and add it to the data frame

row.names(state_facts) <- NULL # get rid of row names

head(state_facts)
##        state Population Income Illiteracy Life.Exp Murder HS.Grad Frost   Area
## 1    Alabama       3615   3624        2.1    69.05   15.1    41.3    20  50708
## 2     Alaska        365   6315        1.5    69.31   11.3    66.7   152 566432
## 3    Arizona       2212   4530        1.8    70.55    7.8    58.1    15 113417
## 4   Arkansas       2110   3378        1.9    70.66   10.1    39.9    65  51945
## 5 California      21198   5114        1.1    71.71   10.3    62.6    20 156361
## 6   Colorado       2541   4884        0.7    72.06    6.8    63.9   166 103766
```

1. How many rows and columns does it have? Can you find at least 3 ways to get that information?

2. The `Illiteracy` column contains the percent of the population of each state that is illiterate. Calculate the number of people in each state who are illiterate, and store that in a new column called `TotalNumIlliterate`. Note: `Population` contains the population in thousands.

3. Calculate the average population density of each state (population per square mile) and store it in a new column `PopDensity`. Using the R reference card, can you find functions that you can combine to get the state with the minimum population density?

<details><summary>Solutions</summary>

```r
# 3 ways to get rows and columns
str(state_facts)
## 'data.frame':	50 obs. of  9 variables:
##  $ state     : chr  "Alabama" "Alaska" "Arizona" "Arkansas" ...
##  $ Population: num  3615 365 2212 2110 21198 ...
##  $ Income    : num  3624 6315 4530 3378 5114 ...
##  $ Illiteracy: num  2.1 1.5 1.8 1.9 1.1 0.7 1.1 0.9 1.3 2 ...
##  $ Life.Exp  : num  69 69.3 70.5 70.7 71.7 ...
##  $ Murder    : num  15.1 11.3 7.8 10.1 10.3 6.8 3.1 6.2 10.7 13.9 ...
##  $ HS.Grad   : num  41.3 66.7 58.1 39.9 62.6 63.9 56 54.6 52.6 40.6 ...
##  $ Frost     : num  20 152 15 65 20 166 139 103 11 60 ...
##  $ Area      : num  50708 566432 113417 51945 156361 ...
dim(state_facts)
## [1] 50  9
nrow(state_facts)
## [1] 50
ncol(state_facts)
## [1] 9

# Illiteracy
state_facts$TotalNumIlliterate <- state_facts$Population * 1e3 * (state_facts$Illiteracy/100) 

# Population Density
state_facts$PopDensity <- state_facts$Population * 1e3/state_facts$Area 
# in people per square mile

# minimum population
state_facts$state[which.min(state_facts$PopDensity)]
## [1] "Alaska"
```
</details>


##### Advanced Data Frames: Tibbles and List-columns {- .learn-more}

If at this point you're bored because you've seen this material before, keep reading to find out about tibbles, list columns and other ways to make data frames even more powerful. 

A tibble is a fancy data frame that is optimized to work with the `tidyverse`, which is a collection of R packages that make data wrangling (getting the data clean and ready for analysis) easier. 

You can read about tibbles [here](https://r4ds.had.co.nz/tibbles.html).

<details>
<summary>You like data frames? Lists? Let's put some lists inside a data frame! (All about list columns)</summary>

Let's start with the lego picture:

![](https://github.com/jennybc/lego-rstats/raw/master/lego-rstats_014.jpg?raw=TRUE)
(The full explanation is available in slide form [here](https://speakerdeck.com/jennybc/data-rectangling?slide=17)). 

A list is just another object that could be stored in a data frame! It is a "generalized vector" in that each entry in a list can be thought of as another list - so a list is really a vector of lists. List-columns make it possible to store e.g. whole data sets in a nested, organized way. Another useful feature is that each entry in a list-column doesn't have to be the same length, which makes it easier to store "ragged" data. 

You can see a couple of examples [here](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html) (but they assume that you know things that you'll only learn in a few modules). 

It is worth coming back to this link later in the book. I will try to remind you.

</details>

#### Data Sets (SAS) {-}

The SAS data set structure is similar to a R data frame.

![This is a schematic of a data set as taken from the SAS documentation](image/02_sas_dataset.png)
<!-- https://documentation.sas.com/api/docsets/basess/9.4/content/images/data-fit.png original source for the image -->

In SAS, missing values are indicated with `.`

SAS datasets also come with a description which is attached to the table. The descriptor portion of the data set records names of variables (and attributes), numbers of observations, and date/time stamps of creation and updates.

<details class="ex"><summary> Creating a SAS data set </summary>
In the next code chunk, we'll create a data set using a SAS Data step. We'll talk more about the anatomy of a SAS command later, but for now, notice that I'm specifying some metadata (the title), telling SAS what the variable names are (Drugs, Score), and then providing some data (indicated by the datalines statement).


```sashtml
data mathLSD;
title 'Average math test scores under the influence of LSD';
input Drugs	Score;
datalines;
1.17 78.93
2.97 58.20
3.26 67.47
4.69 37.47
5.83 45.65
6.00 32.92
6.41 29.97
;

/* Describe the dataset */
proc datasets;
  contents data = mathLSD;
run;

proc print data = mathLSD;
run;
```


<div class="branch">
<a name="IDX15"></a>
<table class="systitleandfootercontainer" style=" border-spacing: 0px;" width="100%" cellspacing="0" cellpadding="1" rules="none" frame="void" border="0" summary="Page Layout">
<tr>
<td class="c systemtitle">Average math test scores under the influence of LSD</td>
</tr>
</table><br>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Datasets: Directory Information">
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="2" scope="colgroup">Directory</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">Libref</th>
<td class="l data">WORK</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Engine</th>
<td class="l data">V9</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Physical Name</th>
<td class="l data">/tmp/SAS_work4B2E00004B80_yeti</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Filename</th>
<td class="l data">/tmp/SAS_work4B2E00004B80_yeti</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Inode Number</th>
<td class="l data">41697413</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Access Permission</th>
<td class="l data">rwx------</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Owner Name</th>
<td class="l data">susan</td>
</tr>
<tr>
<th class="l rowheader" scope="row">File Size</th>
<td class="l data">4KB</td>
</tr>
<tr>
<th class="l rowheader" scope="row">File Size (bytes)</th>
<td class="l data">4096</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX16"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Datasets: Library Members">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r b header" scope="col">#</th>
<th class="l b header" scope="col">Name</th>
<th class="l b header" scope="col">Member Type</th>
<th class="r b header" scope="col">File Size</th>
<th class="l b header" scope="col">Last Modified</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">MATHLSD</td>
<td class="l data">DATA</td>
<td class="r data">128KB</td>
<td class="l data">05/09/2021 10:25:28</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">SASMAC3</td>
<td class="l data">CATALOG</td>
<td class="r data">20KB</td>
<td class="l data">05/09/2021 10:25:28</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">SET1</td>
<td class="l data">DATA</td>
<td class="r data">128KB</td>
<td class="l data">05/09/2021 10:25:28</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">SET2</td>
<td class="l data">DATA</td>
<td class="r data">128KB</td>
<td class="l data">05/09/2021 10:25:28</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX17"></a>
<table class="systitleandfootercontainer" style=" border-spacing: 0px;" width="100%" cellspacing="0" cellpadding="1" rules="none" frame="void" border="0" summary="Page Layout">
<tr>
<td class="c systemtitle">Average math test scores under the influence of LSD</td>
</tr>
</table><br>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Datasets: Attributes">
<colgroup>
<col>
<col>
<col>
<col>
</colgroup>
<tbody>
<tr>
<th class="l rowheader" scope="row">Data Set Name</th>
<td class="l data">WORK.MATHLSD</td>
<th class="l rowheader" scope="row">Observations</th>
<td class="l data">7</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Member Type</th>
<td class="l data">DATA</td>
<th class="l rowheader" scope="row">Variables</th>
<td class="l data">2</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Engine</th>
<td class="l data">V9</td>
<th class="l rowheader" scope="row">Indexes</th>
<td class="l data">0</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Created</th>
<td class="l data">05/09/2021 10:25:28</td>
<th class="l rowheader" scope="row">Observation Length</th>
<td class="l data">16</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Last Modified</th>
<td class="l data">05/09/2021 10:25:28</td>
<th class="l rowheader" scope="row">Deleted Observations</th>
<td class="l data">0</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Protection</th>
<td class="l data"> </td>
<th class="l rowheader" scope="row">Compressed</th>
<td class="l data">NO</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Data Set Type</th>
<td class="l data"> </td>
<th class="l rowheader" scope="row">Sorted</th>
<td class="l data">NO</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Label</th>
<td class="l data"> </td>
<th class="l rowheader" scope="row"> </th>
<td class="l data"> </td>
</tr>
<tr>
<th class="l rowheader" scope="row">Data Representation</th>
<td class="l data">SOLARIS_X86_64, LINUX_X86_64, ALPHA_TRU64, LINUX_IA64</td>
<th class="l rowheader" scope="row"> </th>
<td class="l data"> </td>
</tr>
<tr>
<th class="l rowheader" scope="row">Encoding</th>
<td class="l data">utf-8  Unicode (UTF-8)</td>
<th class="l rowheader" scope="row"> </th>
<td class="l data"> </td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX18"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Datasets: Engine/Host Information">
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="2" scope="colgroup">Engine/Host Dependent Information</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">Data Set Page Size</th>
<td class="l data">65536</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Number of Data Set Pages</th>
<td class="l data">1</td>
</tr>
<tr>
<th class="l rowheader" scope="row">First Data Page</th>
<td class="l data">1</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Max Obs per Page</th>
<td class="l data">4061</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Obs in First Data Page</th>
<td class="l data">7</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Number of Data Set Repairs</th>
<td class="l data">0</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Filename</th>
<td class="l data">/tmp/SAS_work4B2E00004B80_yeti/mathlsd.sas7bdat</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Release Created</th>
<td class="l data">9.0401M6</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Host Created</th>
<td class="l data">Linux</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Inode Number</th>
<td class="l data">41686769</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Access Permission</th>
<td class="l data">rw-rw-r--</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Owner Name</th>
<td class="l data">susan</td>
</tr>
<tr>
<th class="l rowheader" scope="row">File Size</th>
<td class="l data">128KB</td>
</tr>
<tr>
<th class="l rowheader" scope="row">File Size (bytes)</th>
<td class="l data">131072</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX19"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Datasets: Variables">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="4" scope="colgroup">Alphabetic List of Variables and Attributes</th>
</tr>
<tr>
<th class="r b header" scope="col">#</th>
<th class="l b header" scope="col">Variable</th>
<th class="l b header" scope="col">Type</th>
<th class="r b header" scope="col">Len</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">Drugs</td>
<td class="l data">Num</td>
<td class="r data">8</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Score</td>
<td class="l data">Num</td>
<td class="r data">8</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
<div class="branch">
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX20"></a>
<table class="systitleandfootercontainer" style=" border-spacing: 0px;" width="100%" cellspacing="0" cellpadding="1" rules="none" frame="void" border="0" summary="Page Layout">
<tr>
<td class="c systemtitle">Average math test scores under the influence of LSD</td>
</tr>
</table><br>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.MATHLSD">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">Drugs</th>
<th class="r header" scope="col">Score</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">1.17</td>
<td class="r data">78.93</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="r data">2.97</td>
<td class="r data">58.20</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="r data">3.26</td>
<td class="r data">67.47</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="r data">4.69</td>
<td class="r data">37.47</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="r data">5.83</td>
<td class="r data">45.65</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="r data">6.00</td>
<td class="r data">32.92</td>
</tr>
<tr>
<th class="r rowheader" scope="row">7</th>
<td class="r data">6.41</td>
<td class="r data">29.97</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>



The last two blocks are SAS procedures (PROCs). In the first block, I'm asking SAS to describe the contents of the mathMJ dataset. In the second block, I'm telling SAS to print the whole mathMJ dataset out. 
</details>

### Indexing

The 1, 2, and multi-dimensional homogeneous data types should be familiar from e.g. linear algebra and calculus. Single elements of a vector can be extracted using single square brackets, e.g. `x[1]` will get the first element of the vector `x`. In a matrix, elements are indexed as row, column, so to get the (2, 2) entry of a matrix x, you would use `x[2,2]`. This is extended for multi-dimensional arrays in R, with each dimension added, e.g. `x[3,1,2]` or `x[4, 3, 2, 1]`. 

To get a full row or column from a matrix (in both SAS and R) you would use `x[1,]` (get the first row) or `x[,3]` (get the 3rd column). 

To select multiple rows or columns from a matrix, you would use `x[, c(1, 3)]` in R or `x[,{1 3}]` in SAS - both options get the first and third column of the matrix, with all rows of data included.

In both R and SAS, `a:b` where a and b are numbers will form a sequence from `a` to `b` by 1s. So `1:4` is 1, 2, 3, 4. This is often used to get a set of rows or columns: `x[3:4, 1:2]`.

<details class="ex"><summary>R matrix example</summary>

```r
x <- matrix(1:20, nrow = 5, byrow = T) 
# Create a matrix with values 1 to 20, 5 rows, and fill by row

x
##      [,1] [,2] [,3] [,4]
## [1,]    1    2    3    4
## [2,]    5    6    7    8
## [3,]    9   10   11   12
## [4,]   13   14   15   16
## [5,]   17   18   19   20

x[3:4, 1:2]
##      [,1] [,2]
## [1,]    9   10
## [2,]   13   14
# Gets a submatrix 
```
</details>

<details class="ex"><summary>SAS matrix example</summary>
In SAS, the same basic code works (though matrix definition is a bit more manual). 


```sashtml
proc iml; /* Interactive Matrix Language */
  x = {1 2 3 4 5, 6 7 8 9 10, 11 12 13 14 15, 16 17 18 19 20};
  y = x[3:4, 1:2];
  print x; /* Here, print is used instead of put */
  print y;
quit; /* exit proc IML */
```


<div class="branch">
<a name="IDX21"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: x">
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="5" scope="colgroup">x</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">2</td>
<td class="r data">3</td>
<td class="r data">4</td>
<td class="r data">5</td>
</tr>
<tr>
<td class="r data">6</td>
<td class="r data">7</td>
<td class="r data">8</td>
<td class="r data">9</td>
<td class="r data">10</td>
</tr>
<tr>
<td class="r data">11</td>
<td class="r data">12</td>
<td class="r data">13</td>
<td class="r data">14</td>
<td class="r data">15</td>
</tr>
<tr>
<td class="r data">16</td>
<td class="r data">17</td>
<td class="r data">18</td>
<td class="r data">19</td>
<td class="r data">20</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX22"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: y">
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="2" scope="colgroup">y</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">11</td>
<td class="r data">12</td>
</tr>
<tr>
<td class="r data">16</td>
<td class="r data">17</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

Both R and SAS are 1-indexed languages, so the elements of a list or vector are indexed as 1, 2, 3, 4, ...  ^[Most languages are 0-indexed languages: C, C++, python, Java, javascript. Vectors in these languages are indexed as 0, 1, 2, 3.  Other 1-indexed languages include FORTRAN, Matlab, Julia, Mathematica, and Lua, many of which were intended for mathematical processing or data analysis.]

As R has logical vectors, it is possible to index a vector using a logical vector of the same length.

##### Try it out {- .tryitout}
(From project Euler)

If we list all the natural numbers below 10 that are multiples of 3 or 5,
   we get 3, 5, 6 and 9. The sum of these multiples is 23.
Find the sum of all the multiples of 3 or 5 below 1000.


Hint: The modulo operator, `%%`, gives the integer remainder of one number
      divided by another. So `a %% b` gives the integer remainder when
      dividing `a` by `b`. Modular division is often used to find multiples
      of a number.

<details><summary>R solution</summary>

```r

x <- 1:999 # all nums below 1000

m3 <- (x %% 3) == 0 # multiple of 3
m5 <- (x %% 5) == 0 # multiple of 5
m3or5 <- m3 | m5

sum(x[m3or5])
## [1] 233168
```
</details>

<details><summary>SAS solution</summary>

```sashtmllog
6          data tmp;
7            do x = 1 to 999;
8            output;
9            end;
10         run;

NOTE: The data set WORK.TMP has 999 observations and 1 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

11         
12         proc summary data=tmp; /* Summarize data */
13           where (mod(x, 3) = 0) | (mod(x, 5) = 0);
14           /* Keep only obs where x is divisible by 3 or 5 */
15         
16           var x; /* what variable we want the summary for */
17         
18           output out=sum_x sum=; /* output sum_x to a new dataset */
19         run;

NOTE: There were 466 observations read from the data set WORK.TMP.
      WHERE (MOD(x, 3)=0) or (MOD(x, 5)=0);
NOTE: The data set WORK.SUM_X has 1 observations and 3 variables.
NOTE: PROCEDURE SUMMARY used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      

20         
21         proc print data = sum_x; /* print our sum_x dataset */
22         run;

NOTE: There were 1 observations read from the data set WORK.SUM_X.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      
```


<div class="branch">
<a name="IDX23"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.SUM_X">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">_TYPE_</th>
<th class="r header" scope="col">_FREQ_</th>
<th class="r header" scope="col">x</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">0</td>
<td class="r data">466</td>
<td class="r data">233168</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>


Note on the SAS code: where statements allow you to select part of the data for further processing. There was a note earlier about the fact that type conversion doesn't happen in where clauses... this is one of those clauses. We'll get into where clauses in more detail later, in module 5. 
</details>


Most complicated structures in R are actually lists underneath. You should be able to access any of the pieces of a list using a combination of named references and indexing. 

##### {-}
If you have trouble distinguishing between `$`, `[`, and `[[`, you're not alone. The [R for Data Science book has an excellent illustration](https://r4ds.had.co.nz/vectors.html#lists-of-condiments), which I will summarize for you here in abbreviated form (pictures directly lifted from the book). 

<details>
<summary>R4DS indexing illustration</summary>

`x` | `x[1]` | `x[[1]]` | `x[[1]][[1]]`
--- | ------ | -------- | -------------
![](image/02_pepper.jpg) | ![](image/02_pepper-1.jpg) | ![](image/02_pepper-2.jpg) | ![](image/02_pepper-3.jpg)

</details>


## Control structures

### If statements

If statements are just about as simple in programming as they are in real life. 

<div class="figure" style="text-align: center">
<img src="https://imgs.xkcd.com/comics/conditionals.png" alt="[Source](https://xkcd.com/1652/). I've actually met some programmers who talk like this in real life."  />
<p class="caption">(\#fig:unnamed-chunk-5)[Source](https://xkcd.com/1652/). I've actually met some programmers who talk like this in real life.</p>
</div>

<details><summary>General structure of an if statement</summary>
In general, the structure of an if statement is 

````
if (condition) then {
  # do something here
} 
````

If the condition is true, the inner code will be executed. Otherwise, nothing happens.

You can add an else statement that will execute if the condition is not true

````
if (condition) then {
  # do something
} else {
  # do a different thing
}
````

And in some languages, you can even have many sets of if statements: 


```r
if (condition) {
  # do something
} else if (condition 2) {
  # do something else
} else {
  # do a third thing
}
```

Note that this could also be written (perhaps more clearly) as: 

````
if (condition) {
  # do something
} else {
  if (condition 2) {
    # do something else
  } else {
    # do a third thing
  }
}
````

That is, `condition 2` is only checked once it is known that `condition` is false. Often, programmers use logic flow maps, like the one shown below, to map out a logical sequence and ensure that every possible value is handled appropriately.

![If statement flow diagram, from wikimedia commons](https://upload.wikimedia.org/wikipedia/commons/c/c5/If-Then-Else-diagram.svg)
</details>

#### Example: If/then logic in SAS and R {- .ex}
The syntax for conditional statements using if/then logic is shown below using an example where Santa must determine which members of a household will receive a toy for Christmas and which members will receive coal. ^[Traditionally, naughty children get coal, while nice children get toys or candy.]

<details><summary>In R</summary>

```r
tmp <- data.frame(name = c("Alex", "Edison", "Susan", "Ryan"),
                  status = c("naughty", "nice", NA, "neutral"),
                  stringsAsFactors = F)
# Santa's decision process

if (tmp$status == "naughty") {
 tmp$present <- "coal"
} else {
 tmp$present <- "toy"
}
## Warning in if (tmp$status == "naughty") {: the condition has length > 1 and only
## the first element will be used

tmp
##     name  status present
## 1   Alex naughty    coal
## 2 Edison    nice    coal
## 3  Susan    <NA>    coal
## 4   Ryan neutral    coal
```

What happened? 

When evaluating if statements, R does not evaluate each entry in the vector `tmp$status` separately. Instead, it takes the first value and issues a warning message. One option would be to use a loop, and examine each row in the data set separately. We'll talk about loops in the next subsection. Another option is to use the `ifelse()` function, which is `ifelse(condition, thing to do if condition is true, thing to do if condition is false)`


```r
tmp$present <- ifelse(tmp$status == "naughty", "coal", "toy")

tmp
##     name  status present
## 1   Alex naughty    coal
## 2 Edison    nice     toy
## 3  Susan    <NA>    <NA>
## 4   Ryan neutral     toy
```

When R evaluates a missing value, (so ? NA == "naughty"), the result is `NA`. This is fine for us - if we don't have data on whether someone is naughty or nice, maybe we don't need to give them a present at all. But "neutral" is evaluated as getting a toy. Do we want that to happen? Maybe not. We might have to nest ifelse statements to solve this issue...


```r
tmp$present <- ifelse(tmp$status == "naughty", 
                      "coal", 
                      ifelse(tmp$status == "nice", "toy", NA))

tmp
##     name  status present
## 1   Alex naughty    coal
## 2 Edison    nice     toy
## 3  Susan    <NA>    <NA>
## 4   Ryan neutral    <NA>
```
</details>

<details><summary>In SAS</summary>
In a data step:

```sashtml
data santa;
  input name $ status $;
  datalines;
  Edison nice
  Alex naughty
  Susan .
  Ryan neutral
;

/* Modify santa_list and make a new dataset, present_list */
data presents;
  set santa;
  if status = "naughty" then present = "coal";
  else present = "toy";
run; /* must end with run if no datalines option */

proc print data=presents;
run;
```


<div class="branch">
<a name="IDX24"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.PRESENTS">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">name</th>
<th class="l header" scope="col">status</th>
<th class="l header" scope="col">present</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">Edison</td>
<td class="l data">nice</td>
<td class="l data">toy</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Alex</td>
<td class="l data">naughty</td>
<td class="l data">coal</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">Susan</td>
<td class="l data"> </td>
<td class="l data">toy</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">Ryan</td>
<td class="l data">neutral</td>
<td class="l data">toy</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

Note that `.`, or missing data is handled the same as 'nice'. That might not be what we wanted... this is the natural thing to do, right?


```sashtml
6          data santa;
7            input name $ status $;
8            datalines;

NOTE: The data set WORK.SANTA has 4 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

13         ;
14         
15         /* Modify santa_list and make a new dataset, present_list */
16         data presents;
17           set santa;
18           if status = "naughty" then present = "coal";
19           else (if status = "nice" then present = "toy" else present =
                      ______
                      22
19       ! .);
ERROR: Undeclared array referenced: else.
19           else (if status = "nice" then present = "toy" else present =
                                      ____
                                      388
19       ! .);
ERROR 22-322: Syntax error, expecting one of the following: !, !!, &, (, 
              *, **, +, ',', -, /, <, <=, <>, =, >, ><, >=, AND, EQ, GE, 
              GT, IN, LE, LT, MAX, MIN, NE, NG, NL, NOTIN, OR, [, ^=, {, 
              |, ||, ~=.  

ERROR 388-185: Expecting an arithmetic operator.

19           else (if status = "nice" then present = "toy" else present =
                                      ____
                                      202
19       ! .);
ERROR 202-322: The option or parameter is not recognized and will be 
               ignored.

19           else (if status = "nice" then present = "toy" else present =
                                                           ____
                                                           388
19       ! .);
ERROR 388-185: Expecting an arithmetic operator.

19           else (if status = "nice" then present = "toy" else present =
                                                           ____
                                                           202
19       ! .);
ERROR 202-322: The option or parameter is not recognized and will be 
               ignored.

19           else (if status = "nice" then present = "toy" else present =
19       ! .);
             _
             22
ERROR 22-322: Syntax error, expecting one of the following: +, =.  

19           else (if status = "nice" then present = "toy" else present =
19       ! .);
             _
             76
ERROR 76-322: Syntax error, statement will be ignored.

20         run;

NOTE: Character values have been converted to numeric 
      values at the places given by: (Line):(Column).
      19:54   
NOTE: The SAS System stopped processing this step because of errors.
NOTE: Due to ERROR(s) above, SAS set option OBS=0, enabling syntax check 
      mode. 
      This prevents execution of subsequent data modification statements.
WARNING: The data set WORK.PRESENTS may be incomplete.  When this step was 
         stopped there were 0 observations and 4 variables.
WARNING: Data set WORK.PRESENTS was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


20       !      /* must end with run if no datalines option */
21         
22         proc print data=presents;
23         run;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 4.
```



SAS doesn't handle nested if statements very well - they can be ambiguous. Instead, [SAS documentation suggests using `do;` and `end;` to denote the start and end points of each if statement](https://documentation.sas.com/?docsetId=basess&docsetTarget=p0pcj5ajwyngron1wlsq0tet0hce.htm&docsetVersion=9.4&locale=en) (like the `{}` in R). 


```sashtml
data santa;
  input name $ status $;
  datalines;
  Edison nice
  Alex naughty
  Susan .
  Ryan neutral
;
  
data presents;
  set santa;
  if status = "naughty" then 
    do;
      present = "coal";
    end;
  else if status = "nice" then
    do;
      present = "toy";
    end;
  else 
    do;
      present = .;
    end;
run;
          
proc print data=presents;
run;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.PRESENTS">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">name</th>
<th class="l header" scope="col">status</th>
<th class="l header" scope="col">present</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">Edison</td>
<td class="l data">nice</td>
<td class="l data">toy</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Alex</td>
<td class="l data">naughty</td>
<td class="l data">coal</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">Susan</td>
<td class="l data"> </td>
<td class="l data">.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">Ryan</td>
<td class="l data">neutral</td>
<td class="l data">.</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>



Interestingly, if you set a character variable to be missing, SAS converts it to '.'. So, if we actually want to have the value be missing, we can set it to an empty string.


```sashtml
data santa;
  input name $ status $;
  datalines;
  Edison nice
  Alex naughty
  Susan .
  Ryan neutral
;
data presents; 
  set santa;
  if status = "naughty" then 
    do;
      present = "coal";
    end;
  else if status = "nice" then
    do;
      present = "toy";
    end;
  else 
    do;
      present = '';
    end;
run;
          
proc print data=presents;
run;
```


<div class="branch">
<a name="IDX1"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.PRESENTS">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">name</th>
<th class="l header" scope="col">status</th>
<th class="l header" scope="col">present</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">Edison</td>
<td class="l data">nice</td>
<td class="l data">toy</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Alex</td>
<td class="l data">naughty</td>
<td class="l data">coal</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">Susan</td>
<td class="l data"> </td>
<td class="l data"> </td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">Ryan</td>
<td class="l data">neutral</td>
<td class="l data"> </td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>


Now things work the way we expected them to work.
</details>

#### {-}

There are more complicated if-statement like control structures, such as switch statements, which can save time and typing. In the interests of simplicity, we will skip these for now, as any conditional can be implemented with sequences of if statements in the proper order. If you would like to read about switch statements, here are links to [SAS case statement documentation](https://documentation.sas.com/?docsetId=sqlproc&docsetTarget=n0a85s0ijz65irn1h3jtariooea5.htm&docsetVersion=9.4&locale=en) and [base R switch statement explanation](https://www.tutorialgateway.org/r-switch-statement/) and [documentation](https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/switch).

#### Try it out {- .tryitout}
The `sample()` function selects a random sample of entries from a vector. Suppose we sample a random vector $x$ with 10 entries. Write one or more if statements to fulfill the following conditions

- if $x$ is divisible by 2, $y$ should be positive; otherwise, it should be negative.
- if $x$ is divisible by 3, $y$ should have a magnitude of 2; otherwise, it should have a magnitude of 1.

It may be helpful to define separate variables `y_mag` and `y_sign` and then multiply them afterwards. Once you have found the value of $y$ compute $\text{sum}(x * y)$.

You may use the following R and SAS code skeletons to set the problem up.

```r
set.seed(342502837)
x <- sample(1:50, size = 20, replace = F)

# Conditional statements go here

sum(x * y)
## [1] 1567.609
```

````
proc iml;
  call randseed(342502837);
  x = sample(1:50, 20)`;
  create sampledata from x [colname = "x"];
  append from x;
  close;
quit;

data xy;
  set sampledata;


  /* Conditional statements go here */
  
  
  /* Leave this so that the code below works */
  res = x * y;
run;

proc summary data=xy; /* Summarize data */
  var res; /* what variable we want the summary for */
  
  output out=tmpsum sum=; /* output tmpsum to a new dataset */
run;

proc print data = xy; /* print our original dataset to check result */
  var x y res;
  sum res;
run;

proc print data = tmpsum; /* print our tmpsum dataset */
run;
````

<details><summary>R Solution</summary>

```r
set.seed(342502837)
x <- sample(1:50, size = 20, replace = F)

y_sign <- ifelse(x %% 2 == 0, 1, -1)
y_mag <- ifelse(x %% 3 == 0, 2, 1)
y <- y_sign * y_mag

sum(x * y)
## [1] 157
```
</details>
<details><summary>SAS Solution</summary>


```sashtmllog
6          proc iml;
NOTE: IML Ready
7            call randseed(342502837);
8            x = sample(1:50, 20)`;
9            create sampledata from x [colname = "x"];
10           append from x;
11           close;
NOTE: Closing WORK.SAMPLEDATA
NOTE: The data set WORK.SAMPLEDATA has 20 observations and 1 variables.
12         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.01 seconds
      cpu time            0.00 seconds
      

13         
14         data xy;
15           set sampledata;
16         
17           y_sign = 0 * x;
18           y_mag = 0 * x;
19         
20           /* Conditional statements go here */
21           if MOD(x, 2) = 0 then y_sign = 1;
22             else y_sign = -1;
23           if MOD(x, 3) = 0 then y_mag = 2;
24             else y_mag = 1;
25         
26           y = y_sign * y_mag;
27           res = x * y;
28         run;

NOTE: There were 20 observations read from the data set WORK.SAMPLEDATA.
NOTE: The data set WORK.XY has 20 observations and 5 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

29         
30         proc summary data=xy; /* Summarize data */
31           var res; /* what variable we want the summary for */
32         
33           output out=tmpsum sum=; /* output tmpsum to a new dataset */
34         run;

NOTE: There were 20 observations read from the data set WORK.XY.
NOTE: The data set WORK.TMPSUM has 1 observations and 3 variables.
NOTE: PROCEDURE SUMMARY used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      

35         
36         
37         proc print data = xy; /* print our original dataset to check
37       ! result */
38           var x y res;
39           sum res;
40         run;

NOTE: There were 20 observations read from the data set WORK.XY.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      

41         
42         proc print data = tmpsum; /* print our tmpsum dataset */
43         run;

NOTE: There were 1 observations read from the data set WORK.TMPSUM.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      
```


<div class="branch">
<a name="IDX2"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.XY">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">x</th>
<th class="r header" scope="col">y</th>
<th class="r header" scope="col">res</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">44</td>
<td class="r data">1</td>
<td class="r data">44</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="r data">42</td>
<td class="r data">2</td>
<td class="r data">84</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="r data">1</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="r data">7</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-7</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="r data">42</td>
<td class="r data">2</td>
<td class="r data">84</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="r data">13</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-13</td>
</tr>
<tr>
<th class="r rowheader" scope="row">7</th>
<td class="r data">27</td>
<td class="r data" nowrap>-2</td>
<td class="r data" nowrap>-54</td>
</tr>
<tr>
<th class="r rowheader" scope="row">8</th>
<td class="r data">19</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-19</td>
</tr>
<tr>
<th class="r rowheader" scope="row">9</th>
<td class="r data">41</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-41</td>
</tr>
<tr>
<th class="r rowheader" scope="row">10</th>
<td class="r data">16</td>
<td class="r data">1</td>
<td class="r data">16</td>
</tr>
<tr>
<th class="r rowheader" scope="row">11</th>
<td class="r data">6</td>
<td class="r data">2</td>
<td class="r data">12</td>
</tr>
<tr>
<th class="r rowheader" scope="row">12</th>
<td class="r data">44</td>
<td class="r data">1</td>
<td class="r data">44</td>
</tr>
<tr>
<th class="r rowheader" scope="row">13</th>
<td class="r data">26</td>
<td class="r data">1</td>
<td class="r data">26</td>
</tr>
<tr>
<th class="r rowheader" scope="row">14</th>
<td class="r data">48</td>
<td class="r data">2</td>
<td class="r data">96</td>
</tr>
<tr>
<th class="r rowheader" scope="row">15</th>
<td class="r data">22</td>
<td class="r data">1</td>
<td class="r data">22</td>
</tr>
<tr>
<th class="r rowheader" scope="row">16</th>
<td class="r data">15</td>
<td class="r data" nowrap>-2</td>
<td class="r data" nowrap>-30</td>
</tr>
<tr>
<th class="r rowheader" scope="row">17</th>
<td class="r data">40</td>
<td class="r data">1</td>
<td class="r data">40</td>
</tr>
<tr>
<th class="r rowheader" scope="row">18</th>
<td class="r data">1</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">19</th>
<td class="r data">27</td>
<td class="r data" nowrap>-2</td>
<td class="r data" nowrap>-54</td>
</tr>
<tr>
<th class="r rowheader" scope="row">20</th>
<td class="r data">13</td>
<td class="r data" nowrap>-1</td>
<td class="r data" nowrap>-13</td>
</tr>
<tr>
<th class="r header" scope="col"> </th>
<th class="r header" scope="col"> </th>
<th class="r header" scope="col"> </th>
<th class="r header" scope="col">235</th>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
<div class="branch">
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX3"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.TMPSUM">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">_TYPE_</th>
<th class="r header" scope="col">_FREQ_</th>
<th class="r header" scope="col">res</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">0</td>
<td class="r data">20</td>
<td class="r data">235</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

See [this](https://www.oreilly.com/library/view/sas-certification-prep/9781607649243/p12osnn9d1s4hgn12yf8ffocxhw7.htm) to understand how the print statement works and how to add column summary values. 
</details>

### Loops
Often, we need to do a single task many times - for instance, we may need to calculate the average data value for each week, using daily data. Rather than typing out 52 different iterations of the same code, it is likely easier to type out one single block of code which contains the steps necessary to complete one instance of the task, and then leverage variables to ensure that each task is completed the correct number of times, using the correct inputs.

Let us start with the most generic loop written in pseudocode (code that won't work, but provides the general idea of the steps which are taken)

````
loop_invocation(iteration variable, exit condition) {
  # Steps to repeat
}
````

We use the `loop_invocation` function to indicate what type of loop we use. We have at least one `iteration variable` that indicates where in the looping process we currently are. This may be an index (if we want to do something 500 times, it would take values from 1 to 500), or it may take a more complicated sequence of values (for instance, if we are testing convergence, we might put some sort of delta variable as the iteration variable). Most loops also have an explicit exit condition that is part of the loop invocation; more rarely, a loop may depend on `break` statements that cause the control flow of the code to exit. Without some sort of exit condition, our program would run forever, which is... not optimal.


#### Count controlled loops (FOR loops)

In a for loop, the steps in the loop body repeat a specified number of times. That is, *for* each value in a sequence, the steps within the loop are repeated. 


Another explanation of for loops is available at 
[Khan Academy](https://www.khanacademy.org/computing/ap-computer-science-principles/programming-101/repetition-with-loops/a/repetition-with-for-loops?modal=1).


##### Example: Santa and if/else + loops in R (plus some debugging strategies) {- .ex}
For instance, suppose we want to revisit our R Santa example from the previous section. The original if/else code we wrote in R didn't work, because R evaluates if statements using a single (scalar or vector of length 1) condition. If we add a loop around that code, we can evaluate only one row at a time. We need to check every row, so we'll iterate over `1:nrow(tmp)` - it's better to get the upper bound from the data frame, rather than just using 4 - if we add another entry, the code will still work if we're using `nrow(tmp)` to define how many iterations we need.

We start by defining our data frame:

```r
tmp <- data.frame(name = c("Alex", "Edison", "Susan", "Ryan"),
                  status = c("naughty", "nice", NA, "neutral"),
                  stringsAsFactors = F)
```

And then we add the basic loop syntax:

```r
for (i in 1:nrow(tmp)) {
  
}
```

For some reason, `i` is often used as the iteration variable (with `j` and `k` for nested loops). 

What this loop says is that `i` will first take on the value 1, then 2, then 3, then 4. On each iteration, `i` will advance to the next value in the vector of options we have provided. 

Now we need to add the middle part by adapting the conditional statement we used before so that it looks at only the `i`th row. I've also added the catch-all else condition that assigns NA for any value that isn't "naughty" or "nice". 

It's good practice to initialize your variable (create a column for it) ahead of time and set the variable to a default value.


```r

tmp$present <- NA # Initialize column and set to NA by default

for (i in 1:nrow(tmp)) {
  # Santa's decision process
  if (tmp$status[i] == "naughty") {
   tmp$present[i] <- "coal"
  } else if (tmp$status[i] == "nice") {
   tmp$present[i] <- "toy"
  } else {
    tmp$present[i] <- NA_character_ 
    # use a special NA value that has 
    # character type to avoid any issues
  }
}
## Error in if (tmp$status[i] == "naughty") {: missing value where TRUE/FALSE needed
```

Well, that didn't work! We can see that the loop stopped at `i = 3` by printing out the value of `i` - because the loop failed, `i` will still contain the value which caused the loop to stop. 


```r
i
## [1] 3
tmp[i,] # print tmp at that point
##    name status present
## 3 Susan   <NA>    <NA>
```


Combining this information with the error above, we can guess that R stopped evaluating the loop because the if statement returned NA (missing) instead of TRUE or FALSE. 

if/else statements in R can't evaluate to `NA`, so we need to restructure our conditional statement - first, we'll test for `NA` values, then, we can test for naughty and nice, and we'll keep the catch-all statement at the bottom. We'll test for an `NA` value using the function `is.na()`.


```r

tmp$present <- NA # Initialize column and set to NA by default

for (i in 1:nrow(tmp)) {
  # Santa's decision process
  if (is.na(tmp$status[i])) {
    tmp$present[i] <- NA_character_
  } else if (tmp$status[i] == "naughty") {
   tmp$present[i] <- "coal"
  } else if (tmp$status[i] == "nice") {
   tmp$present[i] <- "toy"
  } else {
    tmp$present[i] <- NA_character_ 
  }
}

tmp
##     name  status present
## 1   Alex naughty    coal
## 2 Edison    nice     toy
## 3  Susan    <NA>    <NA>
## 4   Ryan neutral    <NA>
```

Now the if/else logic works exactly as intended. This is longer than the version using `ifelse()`, but it is perhaps more readable. 

##### {-}

In most cases in R and SAS, it is possible to write code without needing loops at all, because both languages are vector-based - they will often use **vectorized** functions which implicitly loop over each row without having to write a loop to do so. `ifelse()` is a vectorized version of `if() {} else {}`. 

Here is an example of the most basic for loop logic - printing the numbers 1 through 10 - in both R and SAS. SAS code is provided for both PROC IML and DATA steps.

<details class="ex"><summary>For loops in R</summary>

```r
# R Example loop
for (i in 1:10) {
  print(i)
}
## [1] 1
## [1] 2
## [1] 3
## [1] 4
## [1] 5
## [1] 6
## [1] 7
## [1] 8
## [1] 9
## [1] 10
```
</details>

<details class="ex"><summary>"For loops" in SAS IML (using `do`)</summary>

```sashtmllog
6          /* SAS IML example loop */
7          proc iml;
NOTE: IML Ready
8            do i = 1 to 10;
9              print i;
10           end;
10       !        /* This ends the loop definition */
11         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.02 seconds
      cpu time            0.02 seconds
      
```


<div class="branch">
<a name="IDX4"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX5"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">2</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX6"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">3</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX7"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">4</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX8"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">5</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX9"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">6</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX10"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">7</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX11"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">8</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX12"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">9</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX13"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">10</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

<details class="ex"><summary>"For loops" in a SAS DATA step</summary>

```sashtmllog
6          data A;
7            do i = 1 to 10;
8              put i=;
9            end; /* This ends the loop definition */
10         run;

i=1
i=2
i=3
i=4
i=5
i=6
i=7
i=8
i=9
i=10
NOTE: The data set WORK.A has 1 observations and 1 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
```

</details>


While the most straighforward (and common) case of for-loop use in practice is to count from 1 to N, both R and SAS allow for loops to use other sequence structures.

<details><summary>Other sequences in loops in R</summary>

R allows loops to occur over any vector... even randomly generated numbers, or nonnumeric vectors (say, a character vector of URLs).

```r
x <- rnorm(5) # Generate 5 normal (0,1) samples

for (i in x) {
  print(i^2)
}
## [1] 4.500349
## [1] 3.820737
## [1] 2.656216
## [1] 1.120775
## [1] 2.10086
```

We can also iterate by non-integer values using `seq(from = , to = , by = )`

```r
# This loop counts down in 1/2 units from 5 to 0
for (i in seq(5, 0, -.5)) {
  # do nothing
}
```
</details>

<details><summary>Other sequence structures in SAS for loops</summary>
We can iterate by non-integer values:

```sashtmllog
6          data A;
7          y = 0;
8          do i = 5 to 0 by -0.5;
9              put i=;
10           end;
11         run;

i=5
i=4.5
i=4
i=3.5
i=3
i=2.5
i=2
i=1.5
i=1
i=0.5
i=0
NOTE: The data set WORK.A has 1 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
```

We can even add additional conditions:


```sashtmllog
6          data A;
7          y = 0;
8          do i = 5 to 0 by -0.5 while (i**2 > 1);
9              put i=;
10           end;
11         run;

i=5
i=4.5
i=4
i=3.5
i=3
i=2.5
i=2
i=1.5
NOTE: The data set WORK.A has 1 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      
```
</details>


##### Try it out (in R) {- .tryitout}

The `beepr` package plays sounds in R to alert you when your code has finished running (or just to annoy your friends and classmates). ([Documentation](https://www.r-project.org/nosvn/pandoc/beepr.html)) 

::: note
We'll learn more about packages in the next chapter, but for now, just go with it. 
:::

You can install the package using the following command:

```r
install.packages("beepr")
```

(if you are using Linux you will also need to make sure one of `paplay`, `aplay`, or `vlc` is installed)

Load the library and write a `for` loop which plays the 10 different sounds corresponding to integers 1 through 10. 


```r
library(beepr) # load the beepr library

beep(sound = 1) # sound is any integer between 1 and 10.
```

It may be helpful to add the command `Sys.sleep(5)` into your loop to space out the noises so that they can be heard individually.

<details><summary>Solution</summary>

```r
library(beepr)

for (i in 1:10) {
  beep(sound = i)
  Sys.sleep(5)
}

```
</details>

##### Try it out (in SAS) {- .tryitout}

Write a for loop which will output the first 30 [fibbonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number). You can use the following code as a starting point:


```sashtmllog
6          /* SAS IML example loop */
7          proc iml;
NOTE: IML Ready
8            current = 1;
9            prev = 0;
10         
11         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

12         
```

<details><summary>Solution</summary>


```sashtmllog
6          /* SAS IML example loop */
7          proc iml;
NOTE: IML Ready
8            current = 1;
9            prev = 0;
10         
11           do i = 1 to 30;
12             new = current + prev;
13             prev = current;
14             current = new;
15             print current;
16           end;
16       !        /* This ends the loop definition */
17         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.03 seconds
      cpu time            0.04 seconds
      

18         
```


<div class="branch">
<a name="IDX14"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX15"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">2</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX16"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">3</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX17"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">5</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX18"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">8</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX19"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">13</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX20"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">21</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX21"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">34</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX22"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">55</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX23"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">89</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX24"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">144</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX25"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">233</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX26"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">377</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX27"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">610</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX28"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">987</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX29"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1597</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX30"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">2584</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX31"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">4181</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX32"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">6765</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX33"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">10946</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX34"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">17711</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX35"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">28657</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX36"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">46368</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX37"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">75025</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX38"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">121393</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX39"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">196418</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX40"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">317811</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX41"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">514229</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX42"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">832040</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX43"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: current">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">current</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1346269</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

#### Condition-controlled loops (WHILE, DO WHILE)

Frequently, we do not know how many times a loop will need to execute a priori. We might be converging on a value, and want to repeat the calculation until the new value is within an acceptably epsilon of the previous iteration. In these cases, it can be helpful to use a [WHILE loop](https://en.wikipedia.org/wiki/While_loop), which loops while the condition is true (another variant, the do-while loop, is similar, except that a do-while loop will always execute once, and checks the condition at the end of the iteration). 

If a WHILE loop condition is never falsified, the loop will continue forever. Thus, it is usually wise to include a loop counter as well, and a condition to terminate the loop if the counter value is greater than a certain threshold.

Another explanation of while loops is available at [Khan Academy](https://www.khanacademy.org/computing/ap-computer-science-principles/programming-101/repetition-with-loops/a/conditional-repetition-of-instructions?modal=1).

##### Example: The Basel Problem {- .ex}
Let's solve the [Basel problem](https://en.wikipedia.org/wiki/Basel_problem) in R and SAS using WHILE loops - we'll repeat the calculation until the value changes by less than 0.000001. The Basel problem is the problem of calculating the precise infinite summation $$\sum_{n=1}^\infty \frac{1}{n^2}$$

We'll stick to calculating it computationally.

<details><summary>In R</summary>


```r
# Start out by defining your starting values outside of the loop
i <- 1
basel_value <- 0 # initial guess
prev_basel_value <- -Inf # previous value 
while (abs(basel_value - prev_basel_value) > 0.000001) {
  prev_basel_value <- basel_value # update condition
  basel_value <- basel_value + 1/i^2
  i <- i + 1
  
  # Prevent infinite loops
  if (i > 1e6) {
    break
  }
  
  # Monitor the loop to know that it's behaving
  if (i %% 200 == 0) {
    print(c('i = ' = i, 'prev' = prev_basel_value, 'current' = basel_value, diff = basel_value - prev_basel_value))
  }
}
##         i =          prev      current         diff 
## 2.000000e+02 1.639896e+00 1.639922e+00 2.525189e-05 
##         i =          prev      current         diff 
## 4.000000e+02 1.642425e+00 1.642431e+00 6.281368e-06 
##         i =          prev      current         diff 
## 6.000000e+02 1.643263e+00 1.643266e+00 2.787060e-06 
##         i =          prev      current         diff 
## 8.000000e+02 1.643682e+00 1.643683e+00 1.566414e-06 
##         i =          prev      current         diff 
## 1.000000e+03 1.643933e+00 1.643934e+00 1.002003e-06

i
## [1] 1001
basel_value
## [1] 1.643935
prev_basel_value
## [1] 1.643934
```
</details>

<details><summary>In SAS</summary>

```sashtmllog
6          proc iml;
NOTE: IML Ready
7            i = 1;
8            basel = 0;
9            prev = -1;
10           do while((basel - prev) > 1e-6);
11             prev = basel;
12             basel = basel + 1/i**2;
12       !                             /* ** is the exponent operator */
13             i = i + 1;
14         
15             if i > 1e6 then
16               do;
17                 leave;
18             end;
19         
20             if MOD(i, 200) = 0 then
21               do;
22                 print i, prev, basel;
23             end;
24           end;
25         
26           print i, basel;
27         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.02 seconds
      cpu time            0.03 seconds
      

28         
```


<div class="branch">
<a name="IDX44"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">200</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX45"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: prev">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">prev</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6398963</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX46"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6399215</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX47"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">400</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX48"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: prev">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">prev</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6424247</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX49"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6424309</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX50"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">600</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX51"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: prev">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">prev</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6432632</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX52"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.643266</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX53"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">800</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX54"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: prev">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">prev</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6436817</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX55"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6436833</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX56"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1000</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX57"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: prev">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">prev</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6439326</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX58"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6439336</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX59"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: i">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">i</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1001</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX60"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: basel">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">basel</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1.6439346</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

</details>


##### Try it out {- .tryitout}

Write a while loop in R and in SAS to calculate $\displaystyle \lim_{x \rightarrow 4} \frac{2 - \sqrt{x}}{4-x}$ by starting at 3 and halving the distance to 4 with each iteration. Exit the loop when you are within 1e-6 of the value computed on the previous iteration, or when you are within 1e-6 from 4. Which exit condition did you hit first? How do you know?

<details><summary>Solutions</summary>

```r
x <- 3
dist <- 4 - x
current_value <- 0
prev_value <- -Inf
while (abs(current_value - prev_value) > 1e-6 & dist > 1e-6) {
  prev_value <- current_value
  dist <- dist/2
  x <- 4 - dist
  current_value <- (2 - sqrt(x))/(4-x)
}

c(x = x, dist = dist, current_value = current_value, d_value = abs(current_value - prev_value))
##             x          dist current_value       d_value 
##  3.999939e+00  6.103516e-05  2.500010e-01  9.536961e-07
```
Before $x$ got to 4 - 1e-6, the change in f(x) became less than 1e-6. 


```sashtmllog
6          proc iml;
NOTE: IML Ready
7            x = 3;
8            dist = 4 - x;
9            fx = 0;
10           prev_fx = 1;
11           dfx = abs(fx - prev_fx);
12           do while(dfx > 1e-6 & dist > 1e-6);
13             prev_fx = fx;
14             dist = dist/2;
15             x = 4 - dist;
16             fx = (2 - sqrt(x))/(4 - x);
17             dfx = abs(fx - prev_fx);
18           end;
19         
20           print x, dist, fx, dfx;
21         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      

22         
```


<div class="branch">
<a name="IDX61"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: x">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">x</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">3.999939</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX62"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: dist">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">dist</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">0.000061</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX63"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: fx">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">fx</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">0.250001</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX64"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: dfx">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">dfx</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data" nowrap>9.537E-7</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

#### Other Loops and Interative Structures

There are many different ways to implement iteration in any language, including very low-level controls like `repeat` (in R). Higher level iteration may include a FOREACH loop, where a series of commands is applied to a list or vector (the `*apply` commands in R are examples of this). An additional method of iteration that requires functions is the recursion (where a function calls itself). In every case, these alternative loop structures can be translated to for or while loops. 


## Overgrown Calculators

While R and SAS are both extremely powerful statistical programming languages, the core of both languages is the ability to do basic calculations and matrix arithmetic. As almost every dataset is stored as a matrix-like structure (data sets and data frames both allow for multiple types, which isn't quite compatible with more canonical matrices), it is useful to know how to do matrix-level calculations in R and SAS. 

In this section, we will essentially be using both R and SAS as overgrown calculators.

| Operation | R | SAS | 
| :--------- | :- | :--- |
| Addition | + | + |
| Subtraction | - | - |
| Elementwise Multiplication | \* | \# |
| Matrix/Vector Multiplication | %\*% | \* |
| Division | \ | \ |
| Elementwise Exponentiation | ^ | \#\# | 
| Matrix Exponentiation | ^ | \*\* |
| Matrix Transpose | `t(A)` | `A\\`` |

<details class="ex"><summary>R basic mathematical operators</summary>

```r
# transpose these to make row vectors to match SAS
x <- t(1:10)
y <- t(seq(3, 30, by = 3))

x + y
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]    4    8   12   16   20   24   28   32   36    40
x - y
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]   -2   -4   -6   -8  -10  -12  -14  -16  -18   -20
x * y
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]    3   12   27   48   75  108  147  192  243   300
x / y
##           [,1]      [,2]      [,3]      [,4]      [,5]      [,6]      [,7]
## [1,] 0.3333333 0.3333333 0.3333333 0.3333333 0.3333333 0.3333333 0.3333333
##           [,8]      [,9]     [,10]
## [1,] 0.3333333 0.3333333 0.3333333
x^2
##      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
## [1,]    1    4    9   16   25   36   49   64   81   100
t(x) %*% y
##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
##  [1,]    3    6    9   12   15   18   21   24   27    30
##  [2,]    6   12   18   24   30   36   42   48   54    60
##  [3,]    9   18   27   36   45   54   63   72   81    90
##  [4,]   12   24   36   48   60   72   84   96  108   120
##  [5,]   15   30   45   60   75   90  105  120  135   150
##  [6,]   18   36   54   72   90  108  126  144  162   180
##  [7,]   21   42   63   84  105  126  147  168  189   210
##  [8,]   24   48   72   96  120  144  168  192  216   240
##  [9,]   27   54   81  108  135  162  189  216  243   270
## [10,]   30   60   90  120  150  180  210  240  270   300
```
</details>

<details class="ex"><summary>SAS basic mathematical operators</summary>
By default, SAS creates row vectors with `do(a, b, by = c)` syntax. The transpose operator (a single backtick) can be used to transform `A` into `A`\`. 

```sashtmllog
6          proc iml;
NOTE: IML Ready
7            x = do(1, 10, 1);
8            y = do(3, 30, 3);
9          
10           z = x + y;
11           z2 = x - y;
12           z3 = x # y;
13           z4 = x/y;
14           z5 = x##2;
15           z6 = x` * y;
16           print z, z2, z3, z4, z5, z6;
17         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.07 seconds
      cpu time            0.07 seconds
      
```


<div class="branch">
<a name="IDX65"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data">4</td>
<td class="r data">8</td>
<td class="r data">12</td>
<td class="r data">16</td>
<td class="r data">20</td>
<td class="r data">24</td>
<td class="r data">28</td>
<td class="r data">32</td>
<td class="r data">36</td>
<td class="r data">40</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX66"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z2">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z2</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data" nowrap>-2</td>
<td class="r data" nowrap>-4</td>
<td class="r data" nowrap>-6</td>
<td class="r data" nowrap>-8</td>
<td class="r data" nowrap>-10</td>
<td class="r data" nowrap>-12</td>
<td class="r data" nowrap>-14</td>
<td class="r data" nowrap>-16</td>
<td class="r data" nowrap>-18</td>
<td class="r data" nowrap>-20</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX67"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z3">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z3</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data">3</td>
<td class="r data">12</td>
<td class="r data">27</td>
<td class="r data">48</td>
<td class="r data">75</td>
<td class="r data">108</td>
<td class="r data">147</td>
<td class="r data">192</td>
<td class="r data">243</td>
<td class="r data">300</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX68"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z4">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z4</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
<td class="r data">0.3333333</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX69"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z5">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z5</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data">1</td>
<td class="r data">4</td>
<td class="r data">9</td>
<td class="r data">16</td>
<td class="r data">25</td>
<td class="r data">36</td>
<td class="r data">49</td>
<td class="r data">64</td>
<td class="r data">81</td>
<td class="r data">100</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX70"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: z6">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="11" scope="colgroup">z6</th>
</tr>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">COL1</th>
<th class="r b header" scope="col">COL2</th>
<th class="r b header" scope="col">COL3</th>
<th class="r b header" scope="col">COL4</th>
<th class="r b header" scope="col">COL5</th>
<th class="r b header" scope="col">COL6</th>
<th class="r b header" scope="col">COL7</th>
<th class="r b header" scope="col">COL8</th>
<th class="r b header" scope="col">COL9</th>
<th class="r b header" scope="col">COL10</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">ROW1</th>
<td class="r data">3</td>
<td class="r data">6</td>
<td class="r data">9</td>
<td class="r data">12</td>
<td class="r data">15</td>
<td class="r data">18</td>
<td class="r data">21</td>
<td class="r data">24</td>
<td class="r data">27</td>
<td class="r data">30</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW2</th>
<td class="r data">6</td>
<td class="r data">12</td>
<td class="r data">18</td>
<td class="r data">24</td>
<td class="r data">30</td>
<td class="r data">36</td>
<td class="r data">42</td>
<td class="r data">48</td>
<td class="r data">54</td>
<td class="r data">60</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW3</th>
<td class="r data">9</td>
<td class="r data">18</td>
<td class="r data">27</td>
<td class="r data">36</td>
<td class="r data">45</td>
<td class="r data">54</td>
<td class="r data">63</td>
<td class="r data">72</td>
<td class="r data">81</td>
<td class="r data">90</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW4</th>
<td class="r data">12</td>
<td class="r data">24</td>
<td class="r data">36</td>
<td class="r data">48</td>
<td class="r data">60</td>
<td class="r data">72</td>
<td class="r data">84</td>
<td class="r data">96</td>
<td class="r data">108</td>
<td class="r data">120</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW5</th>
<td class="r data">15</td>
<td class="r data">30</td>
<td class="r data">45</td>
<td class="r data">60</td>
<td class="r data">75</td>
<td class="r data">90</td>
<td class="r data">105</td>
<td class="r data">120</td>
<td class="r data">135</td>
<td class="r data">150</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW6</th>
<td class="r data">18</td>
<td class="r data">36</td>
<td class="r data">54</td>
<td class="r data">72</td>
<td class="r data">90</td>
<td class="r data">108</td>
<td class="r data">126</td>
<td class="r data">144</td>
<td class="r data">162</td>
<td class="r data">180</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW7</th>
<td class="r data">21</td>
<td class="r data">42</td>
<td class="r data">63</td>
<td class="r data">84</td>
<td class="r data">105</td>
<td class="r data">126</td>
<td class="r data">147</td>
<td class="r data">168</td>
<td class="r data">189</td>
<td class="r data">210</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW8</th>
<td class="r data">24</td>
<td class="r data">48</td>
<td class="r data">72</td>
<td class="r data">96</td>
<td class="r data">120</td>
<td class="r data">144</td>
<td class="r data">168</td>
<td class="r data">192</td>
<td class="r data">216</td>
<td class="r data">240</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW9</th>
<td class="r data">27</td>
<td class="r data">54</td>
<td class="r data">81</td>
<td class="r data">108</td>
<td class="r data">135</td>
<td class="r data">162</td>
<td class="r data">189</td>
<td class="r data">216</td>
<td class="r data">243</td>
<td class="r data">270</td>
</tr>
<tr>
<th class="l rowheader" scope="row">ROW10</th>
<td class="r data">30</td>
<td class="r data">60</td>
<td class="r data">90</td>
<td class="r data">120</td>
<td class="r data">150</td>
<td class="r data">180</td>
<td class="r data">210</td>
<td class="r data">240</td>
<td class="r data">270</td>
<td class="r data">300</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

</details>

Other matrix operations, such as determinants and extraction of the matrix diagonal, are similarly easy:

<details class="ex"><summary>R matrix operations</summary>

```r
mat <- matrix(c(1, 2, 3, 6, 4, 5, 7, 8, 9), nrow = 3, byrow = T)
t(mat) # transpose
##      [,1] [,2] [,3]
## [1,]    1    6    7
## [2,]    2    4    8
## [3,]    3    5    9
det(mat) # get the determinant
## [1] 18
diag(mat) # get the diagonal
## [1] 1 4 9
diag(diag(mat)) # get a square matrix with off-diag 0s
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    4    0
## [3,]    0    0    9
diag(1:3) # diag() also will create a diagonal matrix if given a vector
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    2    0
## [3,]    0    0    3
```
</details>
<details class="ex"><summary>SAS matrix operations</summary>

```sashtmllog
6          proc iml;
NOTE: IML Ready
7            mat = {1 2 3, 6 4 5, 7 8 9};
8            tmat = mat`;
8        !                /* transpose */
9            determinant = det(mat);
9        !                           /* get the determinant */
10           diagonal_vector = vecdiag(mat);
10       !                                   /* get the diagonal as a
10       ! vector */
11           diagonal_mat = diag(mat);
11       !                             /* get the diagonal as a square
11       ! matrix */
12                                     /* with 0 on off-diagonal entries */
13         
14           dm = diag({1 2 3});
14       !                       /* make a square matrix with vector as the
14       !  diagonal */
15         
16           print tmat, determinant, diagonal_vector, diagonal_mat, dm;
17         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      
```


<div class="branch">
<a name="IDX71"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: tmat">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">tmat</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">6</td>
<td class="r data">7</td>
</tr>
<tr>
<td class="r data">2</td>
<td class="r data">4</td>
<td class="r data">8</td>
</tr>
<tr>
<td class="r data">3</td>
<td class="r data">5</td>
<td class="r data">9</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX72"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: determinant">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">determinant</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">18</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX73"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: diagonal_vector">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">diagonal_vector</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
</tr>
<tr>
<td class="r data">4</td>
</tr>
<tr>
<td class="r data">9</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX74"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: diagonal_mat">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">diagonal_mat</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">0</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">4</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">9</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX75"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: dm">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">dm</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data">0</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">2</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">3</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

The other important matrix-related function is the inverse. In R, `A^-1` will get you the elementwise reciprocal of the matrix. Not exactly what we'd like to see... Instead, in both languages, we use the `solve()` function. The inverse is defined as the matrix B such that `AB = I` where `I` is the identity matrix (1's on diagonal, 0's off-diagonal). So if we `solve(A)` (in R) or `solve(A, diag(n))` in SAS (where n is a vector of 1s the size of A), we will get the inverse matrix.

<details class="ex"><summary>Invert a matrix in R</summary>

```r
mat <- matrix(c(1, 2, 3, 6, 4, 5, 7, 8, 9), nrow = 3, byrow = T)

minv <- solve(mat) # get the inverse

minv
##            [,1]       [,2]       [,3]
## [1,] -0.2222222  0.3333333 -0.1111111
## [2,] -1.0555556 -0.6666667  0.7222222
## [3,]  1.1111111  0.3333333 -0.4444444
mat %*% minv 
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    1    0
## [3,]    0    0    1
```
</details>

<details class="ex"><summary>Invert a matrix in SAS</summary>
[Documentation](https://documentation.sas.com/?docsetId=imlug&docsetTarget=imlug_langref_sect208.htm&docsetVersion=14.2&locale=en)

```sashtmllog
6          proc iml;
NOTE: IML Ready
7            mat = {1 2 3, 6 4 5, 7 8 9};
8          
9            mat_inv = solve(mat, diag({1 1 1}));
9        !                                        /* get the inverse */
10           mat_inv2 = inv(mat);
10       !                        /* less efficient and less accurate */
11           print mat_inv, mat_inv2;
12         
13           id = mat * mat_inv;
14           id2 = mat * mat_inv2;
15           print id, id2;
16         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.02 seconds
      cpu time            0.02 seconds
      
```


<div class="branch">
<a name="IDX76"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: mat_inv">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">mat_inv</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data" nowrap>-0.222222</td>
<td class="r data">0.3333333</td>
<td class="r data" nowrap>-0.111111</td>
</tr>
<tr>
<td class="r data" nowrap>-1.055556</td>
<td class="r data" nowrap>-0.666667</td>
<td class="r data">0.7222222</td>
</tr>
<tr>
<td class="r data">1.1111111</td>
<td class="r data">0.3333333</td>
<td class="r data" nowrap>-0.444444</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX77"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: mat_inv2">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">mat_inv2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data" nowrap>-0.222222</td>
<td class="r data">0.3333333</td>
<td class="r data" nowrap>-0.111111</td>
</tr>
<tr>
<td class="r data" nowrap>-1.055556</td>
<td class="r data" nowrap>-0.666667</td>
<td class="r data">0.7222222</td>
</tr>
<tr>
<td class="r data">1.1111111</td>
<td class="r data">0.3333333</td>
<td class="r data" nowrap>-0.444444</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX78"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: id">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">id</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data" nowrap>-2.22E-16</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data" nowrap>-8.88E-16</td>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX79"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure IML: id2">
<colgroup>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" colspan="3" scope="colgroup">id2</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">1</td>
<td class="r data" nowrap>-2.22E-16</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">0</td>
</tr>
<tr>
<td class="r data">0</td>
<td class="r data" nowrap>-8.88E-16</td>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>


## References and Links {- .learn-more}
Non-exhaustive list of general R and SAS references used in this chapter:

- [SAS Matrix reference](http://www.math.wpi.edu/saspdf/iml/chap4.pdf)
- [SAS Data set documentation](https://documentation.sas.com/?docsetId=basess&docsetTarget=p1f5xhmkdfhyjcn1n6k9wdcacba0.htm&docsetVersion=9.4&locale=en)
- [Creating SAS Data Sets from IML](https://support.sas.com/content/dam/SAS/support/en/books/simulating-data-with-sas/65378_Appendix_A_A_SAS_IML_Primer.pdf) (also [this](https://education.illinois.edu/docs/default-source/carolyn-anderson/edpsy584/SAS_iml.pdf) friendly guide and [this](https://blogs.sas.com/content/iml/2019/07/17/write-numeric-character-matrices-data-set.html) blog post)
- [SAS Data Step options](https://libguides.library.kent.edu/SAS/DataStep)
- [SAS Mathematical Operators](https://www.tutorialspoint.com/sas/sas_operators.htm)
- [Lists and Data Structures in SAS](https://documentation.sas.com/?docsetId=imlug&docsetTarget=imlug_lists_gettingstarted03.htm&docsetVersion=14.3&locale=en)
- [Loops in SAS](https://blogs.sas.com/content/iml/2011/09/07/loops-in-sas.html) and [SAS documentation for DO WHILE](https://support.sas.com/documentation/cdl/en/lestmtsref/63323/HTML/default/viewer.htm#p1awxgleif5wlen1pja0nrn6yi6i.htm) loops
- [Random number generation in SAS](https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2018/1810-2018.pdf)

- [SAS and R compared (by SAS)](https://blogs.sas.com/content/sgf/2020/03/19/free-e-book-sas-programming-for-r-users/)
- [Repeatable random number generation in R](http://www.cookbook-r.com/Numbers/Generating_repeatable_sequences_of_random_numbers/)
- [Data structures in Advanced R](http://adv-r.had.co.nz/Data-structures.html)

### Cheat Sheets and Reference Cards

- [SAS Cheatsheet (from another class like this)](https://sites.ualberta.ca/~ahamann/teaching/renr480/SAS-Cheat.pdf)
- [SAS Cheatsheet (by SAS)](https://support.sas.com/content/dam/SAS/support/en/books/data/base-syntax-ref.pdf)
- [R Cheatsheet](https://rstudio.com/wp-content/uploads/2016/10/r-cheat-sheet-3.pdf) - this is a simplified cheat sheet offered by RStudio. 
- [R Cheatsheet (classic)](https://cran.r-project.org/doc/contrib/Short-refcard.pdf)
- [SAS Programming for R Users (free book)](https://support.sas.com/content/dam/SAS/support/en/books/free-books/sas-programming-for-r-users.pdf) and [github site with training materials](https://github.com/sassoftware/sas-prog-for-r-users)
- [R programming for SAS users](http://r4stats.com/books/free-version/) - site for the book, plus link to a free early version of the book (the book is now published)

### SAS (as taught in other places)
- [Introduction to SAS](https://online.stat.psu.edu/statprogram/stat480) - Undergraduate course at Penn State
- [Intermediate SAS](https://online.stat.psu.edu/statprogram/stat481) - Undergraduate course at Penn State
- [Advanced SAS](https://online.stat.psu.edu/statprogram/stat482) - Undergraduate course at Penn State

### R courses (as taught elsewhere) and Textbooks
- [Stat 579 at Iowa State](https://stat579-at-isu.github.io/schedule.html) (as taught by Heike Hofmann)
- [Stat 545 at Univ. British Columbia](https://stat545.com/) (developed by Jenny Bryan)
- [R for Data Science](https://r4ds.had.co.nz/) - R textbook (free) by Hadley Wickham and Garret Grolemund
- [Advanced R](http://adv-r.had.co.nz/Introduction.html) by Hadley Wickham

### Combination of R and SAS courses
- [Stat 850](https://www.chrisbilder.com/stat850/) as taught by Chris Bilder at UNL


### Non-Exhaustive List of Sources used to aggregate "core programming concepts": 

- https://blog.upperlinecode.com/computer-language-fundamentals-five-core-concepts-1aa43e929f40
- https://howtoprogramwithjava.com/programming-101-the-5-basic-concepts-of-any-programming-language/
- https://dev.to/lucpattyn/basic-programming-concepts-for-beginners-2o73
- http://livecode.byu.edu/programmingconcepts/ControlStruct.php
- http://holowczak.com/programming-concepts-tutorial-programmers/