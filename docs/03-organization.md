









# Organization: Packages, Functions, Scripts, and Documents {#organization}

## Module Objectives{- #module-3-objectives}

- Compose markdown documents with code and text
- Write functions and scripts in R and SAS to solve basic problems 
- Analyze additional software available from package and software repositories to determine whether it is suitable for the problem

## Reproducibility and Markdown

<!-- Why reproducibility is important in science and statistics -->
The concepts of **replication** and **reproducibility** are central to science - we do not trust studies whose results cannot be replicated by additional repetitions of the experiment, and we do not trust statistical analyses whose results are not backed up by valid methods that can be re-run to verify the reported results. While replication covers the lab methods, experimental design, and data collection procedures, reproducibility is concerned with the code and the data from an experiment which has already been run. Specifically, the idea is that the research paper is basically an advertisement - by exposing the code and data used in the analysis, readers can engage with the core of the analysis methods, leading to better peer feedback as well as easier adoption of the research for future work.

Reproducibility has several advantages:

1. **It allows you to show the correctness of your results**    
Trying to reproduce an analysis from the data and the description in the journal article is... challenging, if not impossible. By providing the raw data and code to take the data from raw form to analysis results, readers can verify the legitimacy of each step in the analysis. This allows researchers to review each others' methods, finding mistakes due to [bugs in the software used](https://www.sciencemag.org/news/2016/08/one-five-genetics-papers-contains-errors-thanks-microsoft-excel) or due to implementation errors. In one particularly prominent failure of reproducibility, a study used to support macroeconomic theories that shaped the response to the 2008-2009 recession [negatively correlating national debt with gdp growth](https://theconversation.com/the-reinhart-rogoff-error-or-how-not-to-excel-at-economics-13646) was found to be flawed due to an excel indexing mistake. Use of GUI-based (graphical user interface) statistical analysis software may make it harder to identify these mistakes, because the formulas and code are not visually displayed. 

2. **It allows others to use your results more easily**    
By sharing your code and raw data, you provide the wider scientific community with the ability to use your results to build new scientific studies. This increases the relevance of your work, the number of citations your papers get, and you also benefit from the community adopting a culture of openness and reproducibility.

3. **It allows you to use your results and code more easily**    
In 2 years, when you need to find the code you used for that analysis in XXX paper, you'll be able to find the code (and the data) to see how it worked and what you did. The code may or may not run as-is (depending on software versioning, package updates, etc.), but you will have the methods clearly documented along with the data (so it's easy to replicate the data format needed, etc.)

There are other advantages (personal and public) described in an issue of [Biostatistics](https://academic.oup.com/biostatistics/issue/11/3) dedicated to reproducibility. [David Donoho's response is particularly useful.](https://doi.org/10.1093/biostatistics/kxq028) 

As you might expect, there are [many different](https://academic.oup.com/biostatistics/article/10/3/405/293660) [types of reproducibility](https://ropensci.github.io/reproducibility-guide/sections/introduction/). 

- **Code reproducibility** - allows replication of the computing aspects of the study. Includes code, software, hardware, and implementation details.
- **Data reproducibility** - allows replication of the non-computational parts of the study (e.g. experiment and data collection). This may include making protocols and data available.
- **Statistical reproducibility** - allows replication of the statistical methods. Includes details about model parameters, thresholds, etc. and may also include study pre-registration to prevent p-hacking.

There are also many levels of reproducibility. Much of the computer code written in the 1960s is no longer runnable today, because the computer architecture it was written for is not available anymore. Code which depends on URLs is vulnerable to website rearrangements or the content no longer being hosted. Archiving projects on GitHub is nice, but what happens if GitHub goes down? Even small package version updates can break code so that it no longer runs as it once did. It's important to decide what type of reproducibility is important for a particular project, and then design the project's workflow around that process.

<div class="my-opinion">
For most of my projects, I don't worry about software versioning too much ^[I may archive my sessionInfo() so that package versions are documented]. As much as possible, I keep the **code and the data (if it's small) on GitHub** in a public repository for people to access, along with any manuscripts or presentations related to the project. Manuscripts are written in knitr or Rmarkdown, so that the code is documented by the context of the project, and every image in the article generated by R has corresponding code available. This ensures that 

1. my code (and data) is stored somewhere off-site (backed up in the cloud)
2. my code is available if others want to use it 
3. I can track my contributions to a project relative to any collaborators
4. I can undo changes that I make if something in the code breaks. 
5. I can undo changes my collaborators inadvertently make because all changes are recorded.
6. I can reuse blocks of code easily (and find them easily on GitHub)


In situations where I run experiments, I also make sure that **any experimental stimuli** or other code that would contribute to the execution and data collection part of the experiment are also included in the repository. This may involve archiving intermediate results that would not normally be archived so that exact stimuli can be regenerated "just in case". 
</div>

<!-- Why reproducibility is convenient -->

The github reproducibility work flow is convenient - it allows for me to easily collaborate with others, without emailing versions of code and documents back and forth or dealing with Dropbox version conflicts. I can revert changes that are made that had unintentional effects fairly easily. I can sync my files across multiple machines effortlessly. And if necessary, I can look back at the changes I've made and see why I made them, or what I've already tried.

### Reproducibility References and Reading {- .learn-more}

I highly recommend scanning these resources to get a good sense of the different ways the word "reproducibility" is used in the literature.

- [Advanced R's reproducibility guide](http://adv-r.had.co.nz/Reproducibility.html)
- [A reproducible R workflow](https://timogrossenbacher.ch/2017/07/a-truly-reproducible-r-workflow/)
- [ROpenSci's guide to reproducibility](https://ropensci.github.io/reproducibility-guide/sections/introduction/)
- [Roger Peng's Biostatistics editorial on reproducibility](https://doi.org/10.1093/biostatistics/kxp014)
- [The Biostatistics reproducibility issue w/ responses to the editorial and associated commentary](https://academic.oup.com/biostatistics/issue/11/3)


### Markdown and R {#rmarkdown}

![Rmarkdown is magic. (image by Allison Horst)](https://github.com/allisonhorst/stats-illustrations/raw/master/rstats-artwork/rmarkdown_wizards.png)

In this class, we're primarily going to use Rmarkdown to create dynamic documents. 

Markdown itself (without the R) is a special style of text that is intended to allow you to do basic formatting without having to pause to actually click the buttons (if you were writing in word). Some versions of markdown integrate equation functionality (so you can type mathematical equations using LaTeX syntax) and also allows for the use of templates (so you can write whole journal articles in a text editor). Markdown is also program agnostic - it will allow you to compile your work into HTML, word, or PDF form. 

Markdown documents must be *compiled* - a computer program runs and transforms the text file into a full document. RStudio has markdown functionality built-in, and also supports `Rmarkdown`, which is a markdown variant designed to make it easy to integrate R code and generated pictures with your text (this is called "literate programming"). There are other markdown packages in R which extend markdown's functionality so that you can write a book (like this one), create presentations or posters, or [maintain a blog](http://srvanderplas.netlify.app) using primarily Rmarkdown.

Rmarkdown, despite the name, also allows you to integrate the results from code in other languages. As you saw in [the last chapter](#intro-prog), SAS code can be integrated into markdown as well. Other languages commonly used include python, julia, SQL, Bash, C++, and Stan.

::: learn-more
There is a full set of [Rmarkdown tutorials](https://rmarkdown.rstudio.com/lesson-1.html) from RStudio. There is also a handy [cheatsheet](https://rmarkdown.rstudio.com/lesson-15.html). If you run into trouble or want to do something more complicated, [there is an Rmarkdown cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/) which contains a number of useful tricks.
:::

<details><summary>Quick Anatomy of Rmarkdown documents</summary>
![Explanation of Rmarkdown markup](image/Rmarkdown_doc_anatomy.png)
</details>

::: tryitout
Or, you can take the "jump right in" approach - open RStudio, File -> New -> Rmarkdown document. To compile it, click the knit button in the bar at the top of the text editor window. Make changes to the text and the R code, compile it, and see what happens. Voila! You're a markdow expert!
:::

Rmarkdown documents may contain code used to support an analysis, but they are usually not the best way to develop an analysis method - they are better for documentation, writing tutorials, and other scenarios where you need both text explanations and code/analysis/results. There are other "containers" for code, though, including functions, scripts, and packages. Each has their own advantages and disadvantages, and most of them can be used together. 

### Rmarkdown with... SAS? 

You may have noticed that I've been including SAS chunks throughout this book, and even in your homework assignments. 

::: learn-more
Here's how that's set up.
[SAS in Rmarkdown -- guide](http://ritsokiguess.site/docs/2018/08/20/sas-in-r-markdown/).
:::

It's really fairly easy (on Linux) and not too bad on Windows, which surprised me -- I was expecting it to be a lot more involved to set SASmarkdown up. Of course, I don't have a Mac, so I was surprised to learn that it is a pain in the ... to get SASmarkdown working on Macs because of the way SAS runs. 

SASmarkdown works with the following setup(s):

- Windows + SAS (not Community Edition) + R 
- Mac + Parallels + SAS + R (with SAS and RStudio both installed in parallels)
- Linux + SAS + R

If you're using SAS Community Edition, you cannot use SASMarkdown. Instead, you'll have to submit SAS files separately from your Rmarkdown code, or use the server set up by HCC that has the correct configuration.

If you are using SAS Community Edition, you are still expected to ensure your code is fully reproducible on other computers.

## Functions and Modules

A function (or a module, in SAS) is a block of code which is only run when it is called. It takes arguments (known as parameters) and returns data or some other value. 

You should write a function if you're written similar code more than 2x - this will reduce the amount of code you have to wade through, and will make changing your code easier. 

::: learn-more
There is some extensive material on this subject in [R for Data Science on functions](https://r4ds.had.co.nz/functions.html). If you aren't familiar with functions, you should read that material before proceeding.
:::

Let's look at the structure of a generic function in pseudocode (code that isn't really part of any language, but describes the steps of a program):

````
my_function_name = function(param1, param2 = 3) {
  step1 // do something
  
  step2 // do something else 
  
  return step_1/step2
}

````

1. The first part of a function declaration (storing information in a named object) is the function's intended name, `my_function_name`. 
2. Then, we indicate that we are defining a function (with `= function()`), and what **parameters** our function requires. 
    - For `param1`, we do not provide a default value, but for `param2`, we indicate that the **default value** is 3.     
    If we call the function (tell the program to run this function with certain arguments and provide the result), we could either say `my_function_name(param1 = value1, param2 = value2)` or `my_function_name(param1 = value1)` (which is equivalent to `my_function_name(param1 = value1, param2 = 3)`).     
    In R, you can even say `my_function_name(value1, value2)` and the assumption is that you've supplied the parameters in the correct order.^[It's a good idea to specify your parameter names when you're using functions you're unfamiliar with, which at this point, is probably all of them.] 
    
3. Inside the function block (indicated by `{}` here, but some languages may use `do ... end;`), we perform whatever steps we've decided to include in the function
4. At the end of the function, we **return** a value - the function exits, and leaves behind some information.

Inside the function, we refer to the values passed in using their function names - in this case, `param1` and `param2`. Outside the function, these values probably are assigned to variables with other names -- but inside the function, they have an alias that is only valid while we're working within the function.


In R, functions look like this: 

> `function_name <- function( arglist ) {`    
> `   expr`    
> `return(value)`    
> `}`

and we would call our function by writing the code `function_name(args)`. 

In SAS, functions are called modules and look like this:

> `START function_name arglist GLOBAL arglist2;`     
> `   expr`    
> `FINISH function_name;`

and we would call the function using `RUN function_name args;`

<details><summary>Module documentation</summary>
````
Statements That Define and Execute Modules
Modules are used to create a user-defined subroutine or function. 

A module definition begins with a START statement, which has the following general form:
START <name> <( arguments )> <GLOBAL( arguments )>;

A module definition ends with a FINISH statement, which has the following general form:
FINISH <name>;

To execute a module, you can use either a RUN statement or a CALL statement. 
The general forms of these statements are as follows:
`RUN <name> <( arguments)>;
`CALL <name> <( arguments)>;`
The only difference between the RUN and CALL statements is the order of resolution.
````

[Source: SAS function reference](https://support.sas.com/rnd/app/iml/programming.html)
</details>


Let's try functions out by writing a simple function that takes two numbers as arguments and adds them together.


```r
adder <- function(a, b) {
  return(a + b)
}

adder(3, 4)
## [1] 7
```


```sashtmllog
6          proc IML;
NOTE: IML Ready
7          
8            start adder(a, b);
9              return(a + b);
10           finish;
NOTE: Module ADDER defined.
11         
12           /* In IML, you can use the function like this as well */
13           c = adder(3, 4);
14           print '3 + 4 = ' c;
15         
16         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure IML: c">
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c headerempty" scope="col"> </th>
<th class="r b header" scope="col">c</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data">3 + 4 =</td>
<td class="r data">7</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>


Of course, it's not just important to be able to write your own functions. It's also helpful to be able to see how functions are written, both to explore how a method is implemented and for debugging purposes. In SAS, this is generally not an option, because SAS is closed source, but in R, you can see the code behind any function which is implemented in R (it is harder to see functions implemented in C or C++, but not impossible) by typing the function name (no parentheses) into the command prompt.

<details><summary>Let's examine how the colSums() function is implemented</summary>

```r
colSums
## function (x, na.rm = FALSE, dims = 1L) 
## {
##     if (is.data.frame(x)) 
##         x <- as.matrix(x)
##     if (!is.array(x) || length(dn <- dim(x)) < 2L) 
##         stop("'x' must be an array of at least two dimensions")
##     if (dims < 1L || dims > length(dn) - 1L) 
##         stop("invalid 'dims'")
##     n <- prod(dn[id <- seq_len(dims)])
##     dn <- dn[-id]
##     z <- if (is.complex(x)) 
##         .Internal(colSums(Re(x), n, prod(dn), na.rm)) + (0+1i) * 
##             .Internal(colSums(Im(x), n, prod(dn), na.rm))
##     else .Internal(colSums(x, n, prod(dn), na.rm))
##     if (length(dn) > 1L) {
##         dim(z) <- dn
##         dimnames(z) <- dimnames(x)[-id]
##     }
##     else names(z) <- dimnames(x)[[dims + 1L]]
##     z
## }
## <bytecode: 0x55d952ef4c88>
## <environment: namespace:base>
```

You can see that the first 3 steps in the function are if statements to test whether the inputs are acceptable - x must be a data frame, a matrix, or an array (with 2+ dimensions). 

The next couple of lines test to see whether there are additional "column" dimensions (don't worry if you don't understand what's going on in this code - it's highly optimized and a bit arcane). 

Then, the function checks to see if x is real-valued or complex, and if it's complex, computes the real and imaginary sums separately. 

The `.Internal(colSums(x...))` part is calling a C function - basically, functions written in C are faster than R because they're compiled, so this speeds basic operations up in R. 

Then there are statements that transfer dimension names over to the summed object. At the end of the function, the last value computed is returned automatically (in this case, z). 
</details>

<div class="tryitout">
### Try it out {-}
Write a function named `circle_area` which computes the area of a circle given the radius. Make sure to use reasonable parameter names! (Note: in R, pi is conveniently stored in the variable of the same name - it can be overwritten if you want to do so, but why would you want to do that? In SAS, you can get the value of pi using `constant("pi")`)

<details><summary>Solution</summary>

```r
circle_area <- function(r) {
  r^2*pi # automatically returned as the last computed value
}

circle_area(5)
## [1] 78.53982
```

A more complete and robust answer might include a test for numeric `r`:

```r
circle_area <- function(r) {
  if (!is.numeric(r)) {
    stop("Supplied radius must be numeric") # This issues an error
  }
  r^2*pi # automatically returned as the last computed value
}
circle_area(5)
## [1] 78.53982
```



```sashtmllog
6          proc IML;
NOTE: IML Ready
7          
8            start circle_area(r);
9              pi = constant("pi");
10             return(pi*r**2);
11           finish;
NOTE: Module CIRCLE_AREA defined.
12         
13           c = circle_area(5);
14           print c;
15         
16         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

17         
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure IML: c">
<colgroup>
<col>
</colgroup>
<thead>
<tr>
<th class="c b header" scope="col">c</th>
</tr>
</thead>
<tbody>
<tr>
<td class="r data">78.539816</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>
</div>

One last trick to note: functions generally can only return one object. If you need to return more than one thing, put the objects into a list or another data structure, and return that - then you can take the list/structure apart outside the function to use the returned values separately. 

### Scope

The scope of a variable is the space in the program where a variable is defined and can be accessed. A **local** variable is one which can only be accessed within a function or block of code - it does not exist outside of that code. A **global** variable is one which is available to the entire program. 


In R, every function is defined in a certain environment, and once it is defined, executed in a specific environment. Think of an environment as a space full of available variables, functions, and objects. Any defined object or variable that a function has access to is **in scope**. When you are inside of a function block, you have access to values defined within the function, plus any other values outside the function. When there are two variables with the same name, the object in the environment which is "closest" is used.

<details><summary>Demonstration of scoping in R</summary>


```r

a <- 3

myfun <- function(a, b) {
  a + b + 2
}

myfun(5, 6) # a is 5 inside the function, so that overrides the 
## [1] 13
            # a defined outside the function

myfun(a, 3) # this references the a outside the function
## [1] 8
```

![Scope diagram. When myfun() is called, the calling environment contains the two parameters a and b.](image/03_myfun_scope.png)


```r
a <- 3

myfun2 <- function(d) {
  myfun(a, d)
}

myfun2(3) # the only a in scope inside fun2 is the a defined at the top of the chunk
## [1] 8
```


![Scope diagram. When myfun2() is called, the calling environment contains only a parameter $d$. $a$ is pulled from the global environment, as there is no parameter $a$ in the myfun2 calling environment.](image/03_myfun2_scope.png)


```r
a <- 3

myfun3 <- function(a, d) {
  b <- a; # make a copy of the value
  a <- 250;
  myfun(b, d)
}

a
## [1] 3

myfun3(5, 3) # now, a is defined inside fun3 as a = 5, so there is an a in 
## [1] 10
             # fun3's scope that isn't in the global environment.

a # value of a hasn't changed
## [1] 3
```

![Scope diagram. When myfun3() is called, the calling environment contains parameters a and d, which are then copied into the calling environment of myfun as $a$ and $b$. The variable $a$ in the global environment is ignored.](image/03_myfun3_scope.png)

</details>

If you want to avoid too many issues with scoping (because scoping rules are complicated), the simplest way is to not reuse variable names inside of a function if you've already used those names outside the function (this holds for all languages, really).

R does have global variables and a global assignment operator, `<<-`, but the use of global variables is strongly discouraged, and global variables are not permitted in e.g. CRAN packages. 

In SAS, scoping rules are more like those in other programming languages - you have to keep track of how arguments are made available to the function. 

<details><summary>Demonstration of scoping in SAS. Environments do not inherit variables from the calling environment.</summary>


```saslog
2          PROC IML;
NOTE: IML Ready
3          a = 3;
4          
5          start myfun(a, b);
6            return a + b + 2;
7          finish;
NOTE: Module MYFUN defined.
8          
9          r1 = myfun(5, 6);
10         /* a is 5 inside the function, so that overrides the
11            a defined outside the function */
12         
13         r2 = myfun(a, 3);
14         /* this references the a outside the function */
15         
16         print r1 r2;
17         quit;
NOTE: Exiting IML.
NOTE: The PROCEDURE IML printed page 3.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

18         
##                               The SAS System                              1
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                              c
## 
##                             3 + 4 =          7
##                               The SAS System                              2
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                      c
## 
##                                  78.539816
##  
##                                                                            
##  
##                                    r1        r2
## 
##                                    13         8
```

In SAS, the equivalent version of the program used to demonstrate lexical scoping in R produces an error. In SAS, you cannot assume the function has access to values defined outside of that function that are not passed into the function as arguments.


```saslog
2          PROC IML;
NOTE: IML Ready
3          a = 3;
4          
5          start myfun(a, b);
6            return a + b + 2;
7          finish;
NOTE: Module MYFUN defined.
8          
9          start myfun2(d);
10           return myfun(a, d);
10       !                       /* SAS complains because a is not defined
10       ! */
11         finish;
NOTE: Module MYFUN2 defined.
12         
13         r1 = myfun2(3);
ERROR: (execution) Matrix has not been set to a value.

 operation : + at line 6 column 12
 operands  : a, b

a      0 row       0 col     (type ?, size 0)


b      1 row       1 col     (numeric)

         3

 statement : RETURN at line 6 column 3
 traceback : module MYFUN at line 6 column 3
             module MYFUN2 at line 10 column 3

NOTE: Paused in module MYFUN.
14         
15         print r1;
ERROR: Matrix r1 has not been set to a value.

 statement : PRINT at line 15 column 1
16         quit;
NOTE: Exiting IML.
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 2.
##                               The SAS System                              1
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                              c
## 
##                             3 + 4 =          7
##                               The SAS System                              2
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                      c
## 
##                                  78.539816
##                               The SAS System                              3
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                    r1        r2
## 
##                                    13         8
```
</details>


First, let's consider the similarities: like R, functions have a local scope, and changing a similarly named value inside the function doesn't change the value outside the function. 

```saslog


2          PROC IML;
NOTE: IML Ready
3          start myfun(x);
4            y = 2 * x;
5            print y[label="y inside function (local)"];
6            return 1;
7          finish;
NOTE: Module MYFUN defined.
8          
9          y = 0;
10         x = 1:5;
11         res = myfun(x);
12         print y[label="y outside function"];
13         
14         quit;
NOTE: Exiting IML.
NOTE: The PROCEDURE IML printed page 4.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.02 seconds
      

15         

ERROR: Errors printed on page 2.
##                               The SAS System                              1
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                              c
## 
##                             3 + 4 =          7
##                               The SAS System                              2
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                      c
## 
##                                  78.539816
##                               The SAS System                              3
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                                    r1        r2
## 
##                                    13         8
##  
##                                                                            
##  
##                          y inside function (local)
## 
##                      2         4         6         8        10
## 
## 
##                             y outside function
## 
##                                              0
```

However, R's environment feature and lexical scoping is not common to many other programming languages. 
When values are passed into the function as arguments, the behavior in SAS deviates from the equivalent behavior in R. In SAS, arguments to functions are passed by **reference**. 

An argument that is passed **by value** makes a copy of the value (to a new memory location) for the local function scope (this is what R does). 

When an argument is passed **by reference**, the *address* of the argument is passed in instead^[if you're familiar with C, the argument passed in is just a pointer to the original memory]. 
This is faster and more efficient (because you aren't making a new copy of the data), but it does mean that changes inside the function persist outside that function. [This can cause problems when reusing modules](https://blogs.sas.com/content/iml/2011/02/07/passing-arguments-by-reference-an-efficient-choice.html). 

<details><summary>Argument passing in SAS</summary>
If we make a slight modification to `myfun(a, b)`, though, we see some interesting behavior in SAS that we wouldn't see in the equivalent R program.

```saslog
2          PROC IML;
NOTE: IML Ready
3          a = 3;
4          
5          start myfun(a, b);
6            a = a + 2;
7            return a + b;
8          finish;
NOTE: Module MYFUN defined.
9          
10         b = a;
11         
12         r1 = myfun(5, 6);
13         
14         c = a;
15         
16         r2 = myfun(a, 3);
17         
18         d = a;
19         
20         print b[label="a before r1"] r1 c[label="a after r1"] r2
20       ! d[label="a after r2"];
21         quit;
NOTE: Exiting IML.
NOTE: The PROCEDURE IML printed page 1.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.03 seconds
      cpu time            0.03 seconds
      
##            a before r1        r1 a after r1        r2 a after r2
## 
##                      3        13          3         8          5
```


::: note
In SAS, be sure that if you are using a logical operator AND, `&`, you put spaces around it (e.g. ` & `) - `&var2` is a way to specify that you are passing an argument (`var2`) by reference, and SAS can get confused and issue weird warnings if you actually intended this to be a logical statement of `var1 &var2`. 

I ran across this once and it thoroughly confused me until I remembered that &var can mean "pass by reference" in some languages. 
:::

<details><summary>Another example of SAS passing arguments by reference (and the unexpected effects that can have on a program's state)</summary>


```saslog
2          PROC IML;
NOTE: IML Ready
3          start myfun(x);
4            call sort(x, 1);
4        !                    /* sort the values */
5            return (cusum(x));
5        !                      /* cusum() = cumulative sum */
6          finish;
NOTE: Module MYFUN defined.
7          
8          y = {3, 1, 4, 1, 5, 9, 2, 6, 5, 4};
9          z = y;
10         
11         print y[label="y before function is called"];
12         
13         cs = myfun(y);
14         
15         print z[label="original y"]
16               y[label="y after function is called"]
17               cs[label="cumulative sum of sorted y"];
18         
19         quit;
NOTE: Exiting IML.
NOTE: The PROCEDURE IML printed page 2.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

20         
##                               The SAS System                              1
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##            a before r1        r1 a after r1        r2 a after r2
## 
##                      3        13          3         8          5
##  
##                                                                            
##  
##                         y before function is called
## 
##                                                   3
##                                                   1
##                                                   4
##                                                   1
##                                                   5
##                                                   9
##                                                   2
##                                                   6
##                                                   5
##                                                   4
## 
## 
##      original y y after function is called cumulative sum of sorted y
## 
##               3                          1                          1
##               1                          1                          2
##               4                          2                          4
##               1                          3                          7
##               5                          4                         11
##               9                          4                         15
##               2                          5                         20
##               6                          5                         25
##               5                          6                         31
##               4                          9                         40
```

Because arguments in SAS are passed by reference, you can "trick" a function into returning multiple values by passing the variables in as arguments to the function, changing their values in the function, and returning. This is not necessarily a good practice - it can make code very difficult to debug, and may lead to non-obvious dependencies - but for short, simple programs, you can probably get away with it.


```saslog
2          PROC IML;
NOTE: IML Ready
3            start getDescriptive(Mean, SD, /* output args */
4                                   x /* input arg */);
5              Mean = x[:];
5        !                  /* this is shorthand for compute the mean of
5        ! the column */
6              SD = sqrt( ssq(x - Mean)/(nrow(x) - 1));
7            finish;
NOTE: Module GETDESCRIPTIVE defined.
8          
9          m = 0;
10         s = 0;
11         y = {3, 1, 4, 1, 5, 9, 2, 6, 5, 4};
12         
13         run GetDescriptive(m, s, y);
14         print m s;
15         
16         
17         quit;
NOTE: Exiting IML.
NOTE: The PROCEDURE IML printed page 3.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

18         
##                               The SAS System                              1
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##            a before r1        r1 a after r1        r2 a after r2
## 
##                      3        13          3         8          5
##                               The SAS System                              2
##                                            Sunday, May  9, 2021 10:29:00 AM
## 
##                         y before function is called
## 
##                                                   3
##                                                   1
##                                                   4
##                                                   1
##                                                   5
##                                                   9
##                                                   2
##                                                   6
##                                                   5
##                                                   4
## 
## 
##      original y y after function is called cumulative sum of sorted y
## 
##               3                          1                          1
##               1                          1                          2
##               4                          2                          4
##               1                          3                          7
##               5                          4                         11
##               9                          4                         15
##               2                          5                         20
##               6                          5                         25
##               5                          6                         31
##               4                          9                         40
##  
##                                                                            
##  
##                                     m         s
## 
##                                     4 2.4494897
```

If you want to avoid any of these side-effects of SAS's pass-by-reference behavior, you can very easily do so: just don't write any modules that modify input arguments. Always modify a copy of the variable instead. 
</details>

</details>


<details><summary>Argument passing in R</summary>
In R, variables inside a function don't modify variables which are outside a function (generally speaking). In SAS, this is not necessarily the case. In the first call to myfun(), we pass in two numerical arguments, and we see that even though the value of a changes inside the function, that change doesn't affect the variable defined outside of the function. In the second call to myfun(), we pass a variable in as an argument, and we see that the variable changes after the function's execution! In the R chunk (below), you can see that the behavior of what is essentially the same code is different.

```r

a <- 3

myfun <- function(a, b) {
  a <- a + 2
  a + b
}

a
## [1] 3

myfun(5, 6)
## [1] 13

a
## [1] 3

myfun(a, 3) 
## [1] 8

a
## [1] 3
```
</details>


<div class="tryitout">
#### Try it out {-}

Can you predict what the output of this chunk will be?

```
f <- function(x) {
  f <- function(x) {
    f <- function(x) {
      x ^ 2
    }
    f(x) + 1
  }
  f(x) * 2
}
f(10)
```

Run it - were you right?

What happens when you run a similar program in SAS? (I only nested two functions this time, but you get the idea)

```
proc IML;
  start f(x);

    start f(x);
      return x**x;
    finish;

    return f(x)+1;
  finish;
quit;
```

<details><summary>Solution</summary>

Working through the R program: This gets much less confusing if you rename the functions following R's scoping rules.

```
f <- function(x) {
  f1 <- function(x) { # because inside of f(), the new definition will dominate 
    f2 <- function(x) { # because inside of f1(), the new definition will dominate
      x ^ 2
    }
    f2(x) + 1
  }
  f1(x) * 2
}
f(10)
```

Once this has been renamed, it is relatively easy to write out as a series of mathematical substitutions:

$$f(10) = f1(10) * 2 = (f2(10) + 1) * 2 = (10^2 + 1)*2 = 202$$

Running the similar program in SAS results in SAS complaining about a recursive function definition. 

</details>


What will this SAS program output?


```sashtmllog
6          proc IML;
NOTE: IML Ready
7          
8          start funwithSAS(x, y);
9            a = x;
10           x = x + 3;
11           return x*y;
12         finish;
NOTE: Module FUNWITHSAS defined.
13         
14         a = 0;
15         res1 = funwithSAS(a, 5);
16         a1 = a;
17         
18         x = 3;
19         res2 = funwithSAS(x, 5);
20         a2 = a;
21         x2 = x;
22         
23         y = 3;
24         res3 = funwithSAS(x, y);
25         
26         /* print res1 a1 res2 a2 x2 res3 a x y; */ /* uncomment this
26       ! when you're ready */
27         
28         quit;
NOTE: Exiting IML.
NOTE: PROCEDURE IML used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

29         
```

<details><summary>Solution</summary>
This is easiest if we step through the program and list what is passed around inside and outside of the function evaluation.

    a = 0
    res1 = ...? 
    (inside funwithsas res1) x = (location of a), y = 5
    (inside funwithsas res1) a = x = (location of a), x = (location of a) + 3 = 3, so (location of a) = 3 and x = 3.
    res1 returns x = 3 * y = 5 = 15
    
    a1 = 3
    res2 = ...?
    (inside funwithsas res2) x = (location of x), y = 5
    (inside funwithsas res2) a = (location of x), x = (location of x) + 3 = 6 (a outside the function is unaffected because a is not a parameter)
    res2 returns x = 6 * y = 5 = 30
    
    a2 = 3
    x2 = 6
    
    y = 3
    res3 = ...?
    (inside funwithsas res3) x = (location of x), y = (location of y)
    (inside funwithsas res3) a = (location of x), x = (location of x) + 3 = 9 (a outside the function is unaffected; y is unchanged)
    res3 returns x = 9 * y = 3 = 27
    
    at this point, x = 9 and y = 3.
    
    So the output is res1 = 15 a1 = 3 res2 = 30 a2 = 3 x2 = 6 res3 = 27 a = 3 x = 9 y = 3
    
The trick to this problem is to realize that inside of the function, when a variable is passed in (by reference) the thing that is assigned is the pointer to the value in memory where the original variable lives. So when a is passed in as x, x is assigned (location of a), which is then assigned to the local copy of a. So both variables now point at the outside (a), and any changes to x also affect both a and the local copy of a. 
</details>
</div>

### The Pipe


::: note
You do not need to understand the collapsed section below. If you're feeling comfortable with the material, go ahead and read it now. I've left it in the functions section, because it's a topic relating to functions, but it's not essential to understand to use R (even at an advanced level)^[I had been using R for ~8 years before I ever heard the term "infix operator" - and I'd been using infix operators for a long time at that point, just without thinking about what they were.]. 
:::

<details>
<summary>Infix operators</summary>
Most functions take arguments written after the function name. Can you think of any functions which work differently?

**Infix** functions are functions that take arguments on both sides of the function name. Say, a + b: technically, a and b are arguments to the function +, so we could think of this as +(a, b). 

R has a number of infix functions, but you can also create your own. User-defined infix functions start and end with %. So %>%, %in%, %dosomething% would all be valid infix operators. To define one, you need to enclose the name in back-ticks (\`). 


```r
`%dosomething%` <- function(a, b) {
  a^b - a + b
}

3 %dosomething% 4
## [1] 82
```

You can also call default infix operators using this syntax: \`+\`(3, 4) = 7

One of the most useful infix operators is the pipe, `%>%`, which is a part of the `magrittr` library and is commonly included in other packages, such as `dplyr`, and `tidyr` (we will talk about packages later in this chapter, but pipes are useful to discuss now, so roll with it for a few minutes). 
</details>

The one part of this section that is important to at least be able to use is the pipe: `%>%`. 

<div class="learn-more">
There is an [entire chapter dedicated to discussing the pipe in R4DS](https://r4ds.had.co.nz/pipes.html), including a discussion of when not to use the pipe. 
</div>


```r
library(magrittr)

3 %>% exp()
## [1] 20.08554
exp(3)
## [1] 20.08554
```
The pipe takes the left hand side and a function, and puts the left hand side as an argument to the function on the right hand side. It doesn't sound very impressive, but it allows you to do a very cool thing: "chain" operations.

Consider 3 functions:

```r
f1 <- function(x, y = 3) {
  x * y
}

f2 <- function(z) {
  z^2
}

f3 <- function(z2) {
  log10(z2)
}
```

Normally, you'd write `f3(f2(f1(4)))`, which you have to read from the inside to the outside if you want to describe what this function call is doing. With pipes, you can write the same operation as:

```r
4 %>% f1() %>% f2() %>% f3()
## [1] 2.158362
```

This is much simpler to read - it's like a recipe. "Take 4, do f1, then f2, then f3". 

You don't need to know how to define your own infix operators, but you will want to become familiar with the pipe. It's a central component of writing "tidy" R code. Incidentally, SAS also has a use for the pipe: [leveraging the operating system to work with files](https://blogs.sas.com/content/sgf/2016/03/11/using-a-pipe-to-return-the-output-of-an-operating-system-command-to-sas-software/). In SAS, you just use the keyword `pipe`, which is hopefully pretty obvious. 



## Procs  and Data steps
In R, the primary unit of code is a function, and nearly every operation in R is a function call, but the functions themselves are malleable and can be easily re-written. SAS is not that flexible - its procedures have been checked and double-checked and maintained for 30 years (in many cases). That level of validation explains its popularity in e.g. the pharmaceutical industry or government, but it does lead to a certain rigidity in the "flow" of a SAS data analysis. Personally, I find that using SAS generally doesn't require much thought, but I quickly get frustrated when it's not possible to do the exact thing I want to do in a direct or relatively easy way. 

The primary units of code in SAS are "steps", and come in two main flavors: data steps, and proc steps. Data steps are written by the user and customized extensively to the dataset you're creating or reading in. Proc steps, on the other hand, execute mainly pre-defined procedures that are built into SAS. Thus far, you've seen DATA steps and PROC PRINT and IML. In the next module, you'll see PROC IMPORT, PROC MEANS, PROC CORR, PROC SUMMARY, PROC FREQ, and PROC UNIVARIATE. 

There is a handy [overview of the SAS language](https://stats.idre.ucla.edu/sas/library/sas-libraryoverview-of-the-sas-language/) that may be useful in understanding the code that you've only been reading and copying up to this point. 

The bare SAS procedure with no options looks like this:
```
PROC MEANS;
RUN;
```
By default, SAS will use the last dataset created to run this procedure. 

<details><summary>SAS procedures can also be run with options that modify the statement. </summary>

```sashtmllog
6          PROC PRINT DATA=SASHELP.CARS (obs=10);
7          RUN;

NOTE: There were 10 observations read from the data set SASHELP.CARS.
NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.02 seconds
      cpu time            0.02 seconds
      

8          
9          PROC MEANS DATA=SASHELP.CARS;
10         RUN;

NOTE: There were 428 observations read from the data set SASHELP.CARS.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.02 seconds
      cpu time            0.03 seconds
      
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Print: Data Set SASHELP.CARS">
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
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">Make</th>
<th class="l header" scope="col">Model</th>
<th class="l header" scope="col">Type</th>
<th class="l header" scope="col">Origin</th>
<th class="l header" scope="col">DriveTrain</th>
<th class="r header" scope="col">MSRP</th>
<th class="r header" scope="col">Invoice</th>
<th class="r header" scope="col">EngineSize</th>
<th class="r header" scope="col">Cylinders</th>
<th class="r header" scope="col">Horsepower</th>
<th class="r header" scope="col">MPG_City</th>
<th class="r header" scope="col">MPG_Highway</th>
<th class="r header" scope="col">Weight</th>
<th class="r header" scope="col">Wheelbase</th>
<th class="r header" scope="col">Length</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">Acura</td>
<td class="l data">MDX</td>
<td class="l data">SUV</td>
<td class="l data">Asia</td>
<td class="l data">All</td>
<td class="r data">$36,945</td>
<td class="r data">$33,337</td>
<td class="r data">3.5</td>
<td class="r data">6</td>
<td class="r data">265</td>
<td class="r data">17</td>
<td class="r data">23</td>
<td class="r data">4451</td>
<td class="r data">106</td>
<td class="r data">189</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Acura</td>
<td class="l data">RSX Type S 2dr</td>
<td class="l data">Sedan</td>
<td class="l data">Asia</td>
<td class="l data">Front</td>
<td class="r data">$23,820</td>
<td class="r data">$21,761</td>
<td class="r data">2.0</td>
<td class="r data">4</td>
<td class="r data">200</td>
<td class="r data">24</td>
<td class="r data">31</td>
<td class="r data">2778</td>
<td class="r data">101</td>
<td class="r data">172</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">Acura</td>
<td class="l data">TSX 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Asia</td>
<td class="l data">Front</td>
<td class="r data">$26,990</td>
<td class="r data">$24,647</td>
<td class="r data">2.4</td>
<td class="r data">4</td>
<td class="r data">200</td>
<td class="r data">22</td>
<td class="r data">29</td>
<td class="r data">3230</td>
<td class="r data">105</td>
<td class="r data">183</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">Acura</td>
<td class="l data">TL 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Asia</td>
<td class="l data">Front</td>
<td class="r data">$33,195</td>
<td class="r data">$30,299</td>
<td class="r data">3.2</td>
<td class="r data">6</td>
<td class="r data">270</td>
<td class="r data">20</td>
<td class="r data">28</td>
<td class="r data">3575</td>
<td class="r data">108</td>
<td class="r data">186</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="l data">Acura</td>
<td class="l data">3.5 RL 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Asia</td>
<td class="l data">Front</td>
<td class="r data">$43,755</td>
<td class="r data">$39,014</td>
<td class="r data">3.5</td>
<td class="r data">6</td>
<td class="r data">225</td>
<td class="r data">18</td>
<td class="r data">24</td>
<td class="r data">3880</td>
<td class="r data">115</td>
<td class="r data">197</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="l data">Acura</td>
<td class="l data">3.5 RL w/Navigation 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Asia</td>
<td class="l data">Front</td>
<td class="r data">$46,100</td>
<td class="r data">$41,100</td>
<td class="r data">3.5</td>
<td class="r data">6</td>
<td class="r data">225</td>
<td class="r data">18</td>
<td class="r data">24</td>
<td class="r data">3893</td>
<td class="r data">115</td>
<td class="r data">197</td>
</tr>
<tr>
<th class="r rowheader" scope="row">7</th>
<td class="l data">Acura</td>
<td class="l data">NSX coupe 2dr manual S</td>
<td class="l data">Sports</td>
<td class="l data">Asia</td>
<td class="l data">Rear</td>
<td class="r data">$89,765</td>
<td class="r data">$79,978</td>
<td class="r data">3.2</td>
<td class="r data">6</td>
<td class="r data">290</td>
<td class="r data">17</td>
<td class="r data">24</td>
<td class="r data">3153</td>
<td class="r data">100</td>
<td class="r data">174</td>
</tr>
<tr>
<th class="r rowheader" scope="row">8</th>
<td class="l data">Audi</td>
<td class="l data">A4 1.8T 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Europe</td>
<td class="l data">Front</td>
<td class="r data">$25,940</td>
<td class="r data">$23,508</td>
<td class="r data">1.8</td>
<td class="r data">4</td>
<td class="r data">170</td>
<td class="r data">22</td>
<td class="r data">31</td>
<td class="r data">3252</td>
<td class="r data">104</td>
<td class="r data">179</td>
</tr>
<tr>
<th class="r rowheader" scope="row">9</th>
<td class="l data">Audi</td>
<td class="l data">A41.8T convertible 2dr</td>
<td class="l data">Sedan</td>
<td class="l data">Europe</td>
<td class="l data">Front</td>
<td class="r data">$35,940</td>
<td class="r data">$32,506</td>
<td class="r data">1.8</td>
<td class="r data">4</td>
<td class="r data">170</td>
<td class="r data">23</td>
<td class="r data">30</td>
<td class="r data">3638</td>
<td class="r data">105</td>
<td class="r data">180</td>
</tr>
<tr>
<th class="r rowheader" scope="row">10</th>
<td class="l data">Audi</td>
<td class="l data">A4 3.0 4dr</td>
<td class="l data">Sedan</td>
<td class="l data">Europe</td>
<td class="l data">Front</td>
<td class="r data">$31,840</td>
<td class="r data">$28,846</td>
<td class="r data">3.0</td>
<td class="r data">6</td>
<td class="r data">220</td>
<td class="r data">20</td>
<td class="r data">28</td>
<td class="r data">3462</td>
<td class="r data">104</td>
<td class="r data">179</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
<div class="branch">
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX1"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Means: Summary statistics">
<colgroup>
<col>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="l b header" scope="col">Variable</th>
<th class="l b header" scope="col">Label</th>
<th class="r b header" scope="col">N</th>
<th class="r b header" scope="col">Mean</th>
<th class="r b header" scope="col">Std Dev</th>
<th class="r b header" scope="col">Minimum</th>
<th class="r b header" scope="col">Maximum</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Invoice</th>
</tr>
<tr>
<th class="l data middle_stacked_value">EngineSize</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Cylinders</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Horsepower</th>
</tr>
<tr>
<th class="l data middle_stacked_value">MPG_City</th>
</tr>
<tr>
<th class="l data middle_stacked_value">MPG_Highway</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Weight</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Wheelbase</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Length</th>
</tr>
</table></th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value"> </th>
</tr>
<tr>
<th class="l data middle_stacked_value"> </th>
</tr>
<tr>
<th class="l data middle_stacked_value">Engine Size (L)</th>
</tr>
<tr>
<th class="l data middle_stacked_value"> </th>
</tr>
<tr>
<th class="l data middle_stacked_value"> </th>
</tr>
<tr>
<th class="l data middle_stacked_value">MPG (City)</th>
</tr>
<tr>
<th class="l data middle_stacked_value">MPG (Highway)</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Weight (LBS)</th>
</tr>
<tr>
<th class="l data middle_stacked_value">Wheelbase (IN)</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Length (IN)</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">426</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data middle_stacked_value">428</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">428</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">32774.86</td>
</tr>
<tr>
<td class="r data middle_stacked_value">30014.70</td>
</tr>
<tr>
<td class="r data middle_stacked_value">3.1967290</td>
</tr>
<tr>
<td class="r data middle_stacked_value">5.8075117</td>
</tr>
<tr>
<td class="r data middle_stacked_value">215.8855140</td>
</tr>
<tr>
<td class="r data middle_stacked_value">20.0607477</td>
</tr>
<tr>
<td class="r data middle_stacked_value">26.8434579</td>
</tr>
<tr>
<td class="r data middle_stacked_value">3577.95</td>
</tr>
<tr>
<td class="r data middle_stacked_value">108.1542056</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">186.3621495</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">19431.72</td>
</tr>
<tr>
<td class="r data middle_stacked_value">17642.12</td>
</tr>
<tr>
<td class="r data middle_stacked_value">1.1085947</td>
</tr>
<tr>
<td class="r data middle_stacked_value">1.5584426</td>
</tr>
<tr>
<td class="r data middle_stacked_value">71.8360316</td>
</tr>
<tr>
<td class="r data middle_stacked_value">5.2382176</td>
</tr>
<tr>
<td class="r data middle_stacked_value">5.7412007</td>
</tr>
<tr>
<td class="r data middle_stacked_value">758.9832146</td>
</tr>
<tr>
<td class="r data middle_stacked_value">8.3118130</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">14.3579913</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">10280.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">9875.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">1.3000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">3.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">73.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">10.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">12.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">1850.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">89.0000000</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">143.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">192465.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">173560.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">8.3000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">12.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">500.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">60.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">66.0000000</td>
</tr>
<tr>
<td class="r data middle_stacked_value">7190.00</td>
</tr>
<tr>
<td class="r data middle_stacked_value">144.0000000</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">238.0000000</td>
</tr>
</table></td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
In the code above, both `DATA=SASHELP.CARS` and `(obs=10)` are options that modify their respective statements. 
</details>
<details><summary>
Some procs also support additional statements: for instance, we can use the VAR statement to tell SAS which variables we want to work with. </summary>

```sashtmllog
6          PROC MEANS DATA=SASHELP.CARS;
7            VAR msrp cylinders;
8          RUN;

NOTE: There were 428 observations read from the data set SASHELP.CARS.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Means: Summary statistics">
<colgroup>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="l b header" scope="col">Variable</th>
<th class="r b header" scope="col">N</th>
<th class="r b header" scope="col">Mean</th>
<th class="r b header" scope="col">Std Dev</th>
<th class="r b header" scope="col">Minimum</th>
<th class="r b header" scope="col">Maximum</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">428</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">426</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">32774.86</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">5.8075117</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">19431.72</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.5584426</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">10280.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">3.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">192465.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">12.0000000</td>
</tr>
</table></td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>
<details><summary>Another statement, CLASS, tells SAS to run the procedure for each level of a named categorical variable. </summary>

```sashtmllog
6          PROC MEANS DATA=SASHELP.CARS;
7            CLASS type;
8            VAR msrp cylinders;
9          RUN;

NOTE: There were 428 observations read from the data set SASHELP.CARS.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.01 seconds
      cpu time            0.03 seconds
      
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" summary="Procedure Means: Summary statistics">
<colgroup>
<col>
<col>
<col>
</colgroup>
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="l b header" scope="col">Type</th>
<th class="r b header" scope="col">N Obs</th>
<th class="l b header" scope="col">Variable</th>
<th class="r b header" scope="col">N</th>
<th class="r b header" scope="col">Mean</th>
<th class="r b header" scope="col">Std Dev</th>
<th class="r b header" scope="col">Minimum</th>
<th class="r b header" scope="col">Maximum</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l t data">Hybrid</th>
<th class="r t data">3</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">3</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">3</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">19920.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">3.6666667</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">725.4653679</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">0.5773503</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">19110.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">3.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">20510.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
</tr>
<tr>
<th class="l t data">SUV</th>
<th class="r t data">60</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">60</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">60</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">34790.25</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">6.5666667</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">13598.63</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.3822932</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">17163.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">76870.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">10.0000000</td>
</tr>
</table></td>
</tr>
<tr>
<th class="l t data">Sedan</th>
<th class="r t data">262</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">262</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">262</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">29773.62</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">5.5801527</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">15584.59</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.4749723</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">10280.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">128420.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">12.0000000</td>
</tr>
</table></td>
</tr>
<tr>
<th class="l t data">Sports</th>
<th class="r t data">49</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">49</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">47</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">53387.06</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">6.3404255</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">33779.63</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.7849199</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">18345.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">192465.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">12.0000000</td>
</tr>
</table></td>
</tr>
<tr>
<th class="l t data">Truck</th>
<th class="r t data">24</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">24</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">24</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">24941.38</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">6.2500000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">9871.97</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.5948286</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">12800.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">52975.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">8.0000000</td>
</tr>
</table></td>
</tr>
<tr>
<th class="l t data">Wagon</th>
<th class="r t data">30</th>
<th class="l stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<th class="l data top_stacked_value">MSRP</th>
</tr>
<tr>
<th class="l data bottom_stacked_value">Cylinders</th>
</tr>
</table></th>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">30</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">30</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">28840.53</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">5.3000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">11834.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">1.4178663</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">11905.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">4.0000000</td>
</tr>
</table></td>
<td class="r stacked_cell data"><table width="100%" border="0" cellpadding="7" cellspacing="0">
<tr>
<td class="r data top_stacked_value">60670.00</td>
</tr>
<tr>
<td class="r data bottom_stacked_value">8.0000000</td>
</tr>
</table></td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>
Some statements may have additional options that further modify the statement. 

The SAS documentation contains full lists of all statements (and all options for those statements). 

<div class="tryitout">
### Try It Out {-}
Take a look at the [Dictionary of SAS DATA step statements](https://documentation.sas.com/?docsetId=lestmtsref&docsetTarget=p0gct6ariiecuhn15jkq8pzfzgef.htm&docsetVersion=9.4&locale=en). Find the RENAME statement and read up on its syntax. Can you rename the variable msrp in the SASHELP.CARS dataset?
```
DATA tmp; /* Create a temporary dataset */
  SET SASHELP.CARS; /* use the CARS data */
  
  /* Your RENAME statement goes here */

RUN;
```
</div>

There is an overview of many common SAS procedures [here](https://stats.idre.ucla.edu/sas/library/sas-libraryoverview-of-sas-procedures/). 

## Scripts

Up until this point, you may have been writing code in an R Studio or SAS text editor window, or, you may have been typing commands into the command line without preserving them in a separate file. You might even have been working in R markdown documents, where you had code and non-code chunks of the file.

A **script** is a file which contains only code and comments. It is intended to run from start to finish, and usually completes one or more tasks - for instance, cleaning your data, or loading a series of custom functions into your R environment. Scripts are useful because they preserve code so that it can be re-run... and in some cases, they can even be re-run autonomously - I have several scripts which automatically run at specific times every day to complete various tasks (scraping data off the internet, mostly). 

I find that when doing data analysis, it is often easier to write a script as opposed to working in R markdown or typing commands into the console. Scripts are a record of what I've done, and ensure that commands are executed in the right order. As with any tool, it is important to know where to use the tool and where the tool is usually not the best option. 

You can source (run) an R script using the `source()` command with the file path of the script as the argument. 

Scripts in R end in `.r` or `.R`, while scripts in SAS end in `.sas`. 

Scripts can be run in one of (at least) two modes: batch mode, or interactive mode. In batch mode, the entire script is run without human intervention or monitoring. This is useful for repetitive jobs -- for instance, to record the weather at 6h intervals throughout the day. In interactive mode, scripts may be run line-by-line or block-wise, with small tweaks made to the code as you proceed through the file. I find that in some cases, what starts out as an interactive mode script can become a batch script as I work the kinks out.

If you ever need to use the high-performance computing resources on campus, you will need to write code to run in batch mode, because these jobs are generally not friendly to interactive programming. 

### Try it out {- .tryitout}

I maintain a list of packages that I find to be useful so that when I install R on a new machine (or update R), I don't have to spend 3 weeks realizing that I need to install X package. Instead of many repeated 5 minute pauses for package installation, I can just let this script run once and walk away.

I've pared down my list of packages a bit for this class (you don't need the packages for analysis of 3D bullet scan data, for instance), but this step should help populate your R installation with a few new packages.

Read the script (located [here](code/03_setup.R)) and try to understand what it is doing. Once you think you understand what it is doing, run the following command to run the script and install the packages on your machine. Were you right?


```r
url <- "https://raw.githubusercontent.com/srvanderplas/unl-stat850/master/code/03_setup.R"
source(url)
```

### Try it out (SAS) {- .tryitout}

Use [this blog post](https://blogs.sas.com/content/iml/2016/12/12/koch-snowflake.html) to create a SAS script that draws a Koch Snowflake in SAS. Save it as "Snowflake.SAS" and open the file in SAS to run it.

<details><summary>Snowflake.SAS</summary>

```sashtml
PROC IML;
  start KochDivide(A, E);                    /* (x,y) coords of endpoints */
     segs = j(5, 2, .);                      /* matrix to hold 4 shorter segs */
     v = (E-A) / 3;                          /* vector 1/3 as long as orig */
     segs[{1 2 4 5}, ] = A + v @ T(0:3);     /* endpoints of new segs */
     /* Now compute middle point. Use ATAN2 to find direction angle. */
     theta = -constant("pi")/3 + atan2(v[2], v[1]); /* change angle by pi/3 */
     w = cos(theta) || sin(theta);           /* vector to middle point */
     segs[3,] = segs[2,] + norm(v)*w;
     return segs;
  finish;
 

  /* create Koch Snowflake from an equilateral triangle */
  start KochPoly(P0, iters=5);    
    P = P0;
    do j=1 to iters;
       N = nrow(P) - 1;             /* old number of segments */
       newP = j(4*N+1, 2);          /* new number of segments + 1 */
       do i=1 to N;                 /* for each segment... */
          idx = (4*i-3):(4*i+1);                    /* rows for 4 new segments */
          newP[idx, ] = KochDivide(P[i,], P[i+1,]); /* generate new segments */
       end;
       P = newP;                    /* update polygon and iterate */
    end;
    return P;
  finish;

  /* create equilateral triangle as base for snowflake */
  pi = constant("pi");
  angles = -pi/6 // pi/2 // 7*pi/6;  /* angles for equilateral triangle */
  P = cos(angles) || sin(angles);    /* vertices of equilateral triangle */
  P = P // P[1,];                    /* append first vertex to close triangle */
  K = KochPoly(P);                   /* create the Koch snowflake */
    
  S = j(nrow(K), 3, 1);      /* add ID variable with constant value 1 */
  S[ ,1:2] = K;
  create Koch from S[colname={X Y ID}];  
  append from S;  
  close;


  /* test KochDivide on line segment from (0,0) to (1,0) */
  s = KochDivide({0 0}, {1 0});
  title  "Fundamental Step in the Koch Snowflake Construction";
  ods graphics / width=600  height=300; 
  call series(s[,1], s[,2]) procopt="aspect=0.333";

QUIT;
 
ods graphics / width=400px height=400px;
footnote justify=Center "Koch Snowflake";
proc sgplot data=Koch;
   styleattrs wallcolor=CXD6EAF8;               /* light blue */
   polygon x=x y=y ID=ID / outline fill fillattrs=(color=white);
   xaxis display=none;
   yaxis display=none;
run;
```


<div class="branch">
<div class="branch">
<a name="IDX"></a>
<div>
<div  class="c">
<img alt="The SGPlot Procedure" src=" image/sas-snowflake-tryitout.png" style=" height: 300px; width: 600px;" border="0" class="c">
</div>
</div>
<br>
</div>
</div>
<div class="branch">
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX1"></a>
<div>
<div  class="c">
<img alt="The SGPlot Procedure" src=" image/sas-snowflake-tryitout1.png" style=" height: 400px; width: 400px;" border="0" class="c">
</div>
</div>
<br>
</div>


</details>

## Packages

Both SAS and R have systems for extending the base system/language with additional functionality. In R, these extensions are called packages. In SAS, language extensions are called modules (for things sold by SAS), macros (for functions distributed by users), and in packages (which exist but are rarely used).^[Note that the various components of SAS can be *extremely* confusing to separate. I found [this](https://www.lexjansen.com/mwsug/2017/RF/MWSUG-2017-RF01.pdf) guide to be somewhat helpful.]

<details><summary>SAS packages</summary>
In SAS, there are packages of code that encapsulate scripts. However, unlike R (and many other languages), there is no centralized repository for SAS packages. Papers may include SAS packages to demonstrate new methods, and other packages may be found on GitHub or various SAS forums.

A more common way of distributing code in SAS seems to be through the use of single-file macros. (Even longtime SAS users don't necessarily know about the package system). These macros often need to be slightly customized to your environment (or you need to customize your environment to match the assumptions made in the macro, which can be harder). 
</details>

<details><summary>R packages</summary>
In R, there are two main sources for packages: CRAN (the Comprehensive R Archive Network) (and related archives, such as MRAN, which is Microsoft's version of CRAN) and github. R packages published on CRAN go through a basic verification process that makes sure that the package meets certain [standards](https://cran.r-project.org/) (for instance, packages must have proper dependencies specified, cannot conflict with previous package names, must have a software license, and cannot contain malicious code). Note that CRAN does not check the packages for statistical correctness!

On github, packages go through less verification. Many packages use a system where the version in development is on github and available for installation, but the version on CRAN is considered "stable". Sometimes, packages are never put on CRAN: I contribute to several packages which are too large for CRAN, and it's not worth the hassle to get an exception or figure out a workaround.



Currently, the CRAN package repository features 1.7548\times 10^{4} available packages. How do you navigate them to find the one you need? Sometimes, the [CRAN Task Views](https://cran.r-project.org/web/views/) may be helpful - for instance, if you want to see all of the packages which are useful for Meta-Analysis, Finance, Bayesian statistics, etc. Other times, it's useful to let Google help you navigate: searching for "R CRAN" + "what you want the package to do" can often narrow things down (I recommend adding CRAN in because Google results for "R" are not particularly useful.)

Once you find and install a package (`install.packages()` for CRAN packages, `devtools::install_github()` for GitHub packages), you have to figure out how to use it. Many R packages come with **vignettes**, which are short articles that demonstrate how a package is used. 
You can browse the available vignettes using `browseVignettes()` (if you provide a package name as an argument, you will get only vignettes from that package). 

Another way to get help on a package is to use `?<package name>`, e.g. `?ggplot2`. That will take you to the main package description page, and there are often links to documentation. At the bottom of the description page, you can click on a link to get to the Index, which is a list of all functions that are provided in that package. From there, you can find the documentation for each function in the package. 
</details>

### Try it out {- .tryitout}

Install the R package `tibble` if it is not already installed. Pull up the vignettes for the `tibble` package, and read about tibbles. What is the equivalent base R object? How do tibbles differ from that object?

Get to the package index for the `tibble` package, either by navigating through the Packages tab in RStudio, or using `?tibble`. Access the documentation for the `tribble` function, and try loading the package and creating your own tibble using `tribble`. 

<details><summary>Solution</summary>

```r
## install.packages("tibble")
library(tibble)
## ?tibble
## ?tribble
tribble(~var1, ~var2,
        1, 2, 
        3, 4,
        5, 6)
## # A tibble: 3 x 2
##    var1  var2
##   <dbl> <dbl>
## 1     1     2
## 2     3     4
## 3     5     6
```
</details>

## References and Links {.learn-more -}

- A more advanced take on functions in R can be found [here](http://adv-r.had.co.nz/Functions.html) (Advanced R chapter)
- There is also a handy cheat sheet style summary of PROC IML in SAS [here](https://www.iuj.ac.jp/faculty/kucc625/sas/sas_iml.html) and some useful demonstrations of simple tasks in IML [here](https://faculty.tarleton.edu/crawford/documents/Math5364/ProcIMLandMacros.txt). 
- A helpful blog post for scoping in SAS is [here](https://blogs.sas.com/content/iml/2013/04/29/understanding-local-and-global-variables-in-the-sasiml-language.html)
- [Here is another explanation of pass-by-value vs. pass-by-reference](https://www.educative.io/edpresso/pass-by-value-vs-pass-by-reference) (intended for C programming)
- [A comparison of R, SAS, and python](https://scholar.smu.edu/cgi/viewcontent.cgi?article=1021&context=datasciencereview) - source of information about the SAS package distribution system. 
- [Another explanation of pipes](https://psyteachr.github.io/msc-data-skills/tidyr.html#pipes) (lots of examples)