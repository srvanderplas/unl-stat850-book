








# Transforming Data {#transforming-data}

## Module Objectives  {- #module7-objectives}

- Implement variable and dataset transformations to support visualization and data analysis.



> Happy families are all alike; every unhappy family is unhappy in its own way. - Leo Tolstoy

> Tidy datasets are all alike, but every messy dataset is messy in its own way. - Hadley Wickham


Most of the time, data does not come in a format suitable for analysis. Spreadsheets are generally optimized for data *viewing*, rather than for statistical analysis - they may be laid out so that there are multiple observations in a single row (e.g., commonly a year's worth of data, with monthly observations in each column). 

Unfortunately, this type of data structure is not usually useful to us when we analyze or visualize the data. 

::: note
This section is going to seem like it drags on forever. It covers a lot of material, and a few different concepts. I highly recommend separating it out into 3-4 different "sessions" - Tidy data, Strings, Pivot operations, and Table Joins. 

For now, you need to know this material well enough to 1) identify what operation needs to happen, and 2) know where to find the sample code for that operation. It will get easier to remember the specific syntax with practice. 
:::

<details><summary>Load initial packages</summary>

```r
library(dplyr) # Data wrangling
library(tidyr) # Data rearranging
library(tibble) # data table
```
</details>

## Identifying the problem: Messy data

These datasets all display the same data: TB cases documented by the WHO in Afghanistan, Brazil, and China, between 1999 and 2000. There are 4 variables: country, year, cases, and population, but each table has a different layout.


Table: (\#tab:tidy1)Table 1

|country     | year|  cases| population|
|:-----------|----:|------:|----------:|
|Afghanistan | 1999|    745|   19987071|
|Afghanistan | 2000|   2666|   20595360|
|Brazil      | 1999|  37737|  172006362|
|Brazil      | 2000|  80488|  174504898|
|China       | 1999| 212258| 1272915272|
|China       | 2000| 213766| 1280428583|

Here, each observation is a single row, each variable is a column, and everything is nicely arranged for e.g. regression or statistical analysis. We can easily compute another measure, such as cases per 100,000 population, by taking cases/population * 100000 (this would define a new column). 



Table: (\#tab:tidy2)Table 2

|country     | year|type       |      count|
|:-----------|----:|:----------|----------:|
|Afghanistan | 1999|cases      |        745|
|Afghanistan | 1999|population |   19987071|
|Afghanistan | 2000|cases      |       2666|
|Afghanistan | 2000|population |   20595360|
|Brazil      | 1999|cases      |      37737|
|Brazil      | 1999|population |  172006362|
|Brazil      | 2000|cases      |      80488|
|Brazil      | 2000|population |  174504898|
|China       | 1999|cases      |     212258|
|China       | 1999|population | 1272915272|
|China       | 2000|cases      |     213766|
|China       | 2000|population | 1280428583|

Here, we have 4 columns again, but we now have 12 rows: one of the columns is an indicator of which of two numerical observations is recorded in that row; a second column stores the value. This form of the data is more easily plotted in e.g. ggplot2, if we want to show lines for both cases and population, but computing per capita cases would be much more difficult in this form than in the arrangement in table 1. 



Table: (\#tab:tidy3)Table 3

|country     | year|rate              |
|:-----------|----:|:-----------------|
|Afghanistan | 1999|745/19987071      |
|Afghanistan | 2000|2666/20595360     |
|Brazil      | 1999|37737/172006362   |
|Brazil      | 2000|80488/174504898   |
|China       | 1999|212258/1272915272 |
|China       | 2000|213766/1280428583 |

This form has only 3 columns, because the rate variable (which is a character) stores both the case count and the population. We can't do *anything* with this format as it stands, because we can't do math on data stored as characters. However, this form might be easier to read and record for a human being. 



Table: (\#tab:tidy4)Table 4a

|country     |   1999|   2000|
|:-----------|------:|------:|
|Afghanistan |    745|   2666|
|Brazil      |  37737|  80488|
|China       | 212258| 213766|



Table: (\#tab:tidy4)Table 4b

|country     |       1999|       2000|
|:-----------|----------:|----------:|
|Afghanistan |   19987071|   20595360|
|Brazil      |  172006362|  174504898|
|China       | 1272915272| 1280428583|

In this form, we have two tables - one for population, and one for cases. Each year's observations are in a separate column. This format is often found in separate sheets of an excel workbook. To work with this data, we'll need to transform each table so that there is a column indicating which year an observation is from, and then merge the two tables together by country and year. 



Table: (\#tab:tidy5)Table 5

|country     |century |year |rate              |
|:-----------|:-------|:----|:-----------------|
|Afghanistan |19      |99   |745/19987071      |
|Afghanistan |20      |00   |2666/20595360     |
|Brazil      |19      |99   |37737/172006362   |
|Brazil      |20      |00   |80488/174504898   |
|China       |19      |99   |212258/1272915272 |
|China       |20      |00   |213766/1280428583 |

Table 5 is very similar to table 3, but the year has been separated into two columns - century, and year. This is more common with year, month, and day in separate columns  (or date and time in separate columns), often to deal with the fact that spreadsheets don't always handle dates the way you'd hope they would. 


These variations highlight the principles which can be said to define a tidy dataset:
1. Each variable must have its own column
2. Each observation must have its own row
3. Each value must have its own cell

<div class="tryitout">
### Try it out {-}
Go back through the 5 tables and determine whether each table is tidy, and if it is not, which rule or rules it violates. Figure out what you would have to do in order to compute a standardized TB infection rate per 100,000 people. 
<details><summary>Solution</summary>

1. table1 - this is tidy data. Computing a standardized infection rate is as simple as creating the variable rate = cases/population*100,000.

2. table2 - each variable does not have its own column (so a single year's observation of one country actually has 2 rows). Computing a standardized infection rate requires moving cases and population so that each variable has its own column, and then you can proceed using the process in 1.

3. table3 - each value does not have its own cell (and each variable does not have its own column). In Table 3, you'd have to separate the numerator and denominator of each cell, convert each to a numeric variable, and then you could proceed as in 1. 

4. table4a and table 4b - there are multiple observations in each row because there is not a column for year. To compute the rate, you'd need to "stack" the two columns in each table into a single column, add a year column that is 1999, 1999, 1999, 2000, 2000, 2000, and then merge the two tables. Then you could proceed as in 1. 

5. table 5 - each variable does not have its own column (there are two columns for year, in addition to the issues noted in table3). Computing the rate would be similar to table 3; the year issues aren't actually a huge deal unless you plot them, at which point 99 will seem to be bigger than 00 (so you'd need to combine the two year columns together first). 
</details>
</div>

It is actually impossible to have a table that violates only one of the rules of tidy data - you have to violate at least two. So a simpler way to state the rules might be: 

1. Each dataset goes into its own table (or tibble, if you are using R)
2. Each variable gets its own column

By the end of this module, you should have the skills to "tidy" each of these tables. 

## String operations: Creating new variables and separating multi-variable columns

Nearly always, when multiple variables are stored in a single column, they are stored as character variables. There are many different "levels" of working with strings in programming, from simple find-and-replaced of fixed (constant) strings to regular expressions, which are extremely powerful (and extremely complicated). 

> Some people, when confronted with a problem, think “I know, I’ll use regular expressions.” Now they have two problems. - Jamie Zawinski

![Alternately, the xkcd version of the above quote](https://imgs.xkcd.com/comics/perl_problems.png)

The tidyverse package to deal with strings is [`stringr`](https://stringr.tidyverse.org/). The functions in stringr take the form of `str_XXX` where XXX is a verb. So `str_split()`, `str_replace()`, `str_remove()`, `str_to_lower()` all should make some sense.



For this example, we'll use a subset of the US Department of Education College Scorecard data. [Documentation](https://collegescorecard.ed.gov/data/documentation/), [Data](https://collegescorecard.ed.gov/data/). I've selected a few columns from the institution-level data available on the College Scorecard site. 

<details><summary>Let's take a look (Read in the data)</summary>


```r
college <- read_csv("data/College_Data_Abbrev.csv", guess_max = 5000, na = '.')
Error in read_csv("data/College_Data_Abbrev.csv", guess_max = 5000, na = "."): could not find function "read_csv"
str(college)
Error in str(college): object 'college' not found
```



```sashtml
libname classdat "sas/";

filename fileloc 'data/College_Data_Abbrev.csv';
PROC IMPORT  datafile = fileloc out=classdat.college REPLACE
DBMS = csv; /* comma delimited file */
GUESSINGROWS=500;
GETNAMES = YES;
RUN;

PROC PRINT DATA = classdat.college (obs = 5);
RUN;
```


<div class="branch">
<a name="IDX"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set CLASSDAT.COLLEGE">
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
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">UNITID</th>
<th class="l header" scope="col">INSTNM</th>
<th class="l header" scope="col">CITY</th>
<th class="l header" scope="col">STABBR</th>
<th class="l header" scope="col">ZIP</th>
<th class="l header" scope="col">ACCREDAGENCY</th>
<th class="l header" scope="col">INSTURL</th>
<th class="l header" scope="col">PREDDEG</th>
<th class="l header" scope="col">MAIN</th>
<th class="r header" scope="col">NUMBRANCH</th>
<th class="l header" scope="col">HIGHDEG</th>
<th class="l header" scope="col">CONTROL</th>
<th class="r header" scope="col">ST_FIPS</th>
<th class="r header" scope="col">LOCALE</th>
<th class="r header" scope="col">LATITUDE</th>
<th class="r header" scope="col">LONGITUDE</th>
<th class="l header" scope="col">State</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">100654</td>
<td class="l data">Alabama A &amp; M University</td>
<td class="l data">Normal</td>
<td class="l data">AL</td>
<td class="l data">35762</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.aamu.edu/</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">34.783368</td>
<td class="r data" nowrap>-86.568502</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="r data">100663</td>
<td class="l data">University of Alabama at Birmingham</td>
<td class="l data">Birmingham</td>
<td class="l data">AL</td>
<td class="l data">35294-0110</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">https://www.uab.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">33.505697</td>
<td class="r data" nowrap>-86.799345</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="r data">100690</td>
<td class="l data">Amridge University</td>
<td class="l data">Montgomery</td>
<td class="l data">AL</td>
<td class="l data">36117-3553</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.amridgeuniversity.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Private Non Profit</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">32.362609</td>
<td class="r data" nowrap>-86.17401</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="r data">100706</td>
<td class="l data">University of Alabama in Huntsville</td>
<td class="l data">Huntsville</td>
<td class="l data">AL</td>
<td class="l data">35899</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.uah.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">34.724557</td>
<td class="r data" nowrap>-86.640449</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="r data">100724</td>
<td class="l data">Alabama State University</td>
<td class="l data">Montgomery</td>
<td class="l data">AL</td>
<td class="l data">36104-0271</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.alasu.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">32.364317</td>
<td class="r data" nowrap>-86.295677</td>
<td class="l data">Alabama</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

### Basic String Operations

<details><summary>What proportion of the schools operating in each state have the state's name in the school name?</summary>

We'll use `str_detect()` to look for the state name in the college name. 

```r
library(stringr) # string processing

# Outside the pipe
str_detect(college$INSTNM, pattern = college$State)
Error in type(pattern): object 'college' not found

# Using the pipe and mutate:
college <- college %>%
  mutate(uses_st_name = str_detect(INSTNM, State))
Error in mutate(., uses_st_name = str_detect(INSTNM, State)): object 'college' not found

library(ggplot2) # graphs and charts
# By state - percentage of institution names
college %>%
  group_by(State) %>%
  summarize(pct_uses_st_name = mean(uses_st_name), n = n()) %>%
  filter(n > 5) %>% # only states/territories with at least 5 schools
  # Reorder state factor level by percentage that uses state name
  mutate(State = reorder(State, -pct_uses_st_name)) %>%
  ggplot(data = ., aes(x = State, y = pct_uses_st_name)) + 
  geom_col() + coord_flip() + 
  geom_text(aes(y = 1, label = paste("Total Schools:", n)), hjust = 1)
Error in group_by(., State): object 'college' not found
```

In SAS, we use `find(x, pattern, 't')` to find the location of the pattern, which is 0 if the pattern is not found. To get something equivalent to `str_detect`, we just test whether this quantity is greater than 0. (The R equivalent of `find` is `str_locate()`). 

Note that SAS pads character fields with spaces so that they are all the same length. So if we want to test for "Alabama    " we could omit the 't' option in the command, but since we usually don't want that, we need to tell SAS to trim the fields before searching for the pattern. 


```sashtml
libname classdat "sas/";

DATA collegetmp;
set classdat.college;
uses_st_name = find(INSTNM, State, 't') GT 0;
RUN;


PROC PRINT DATA = collegetmp (obs = 5);
RUN;
```


<div class="branch">
<a name="IDX1"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.COLLEGETMP">
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
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="r header" scope="col">UNITID</th>
<th class="l header" scope="col">INSTNM</th>
<th class="l header" scope="col">CITY</th>
<th class="l header" scope="col">STABBR</th>
<th class="l header" scope="col">ZIP</th>
<th class="l header" scope="col">ACCREDAGENCY</th>
<th class="l header" scope="col">INSTURL</th>
<th class="l header" scope="col">PREDDEG</th>
<th class="l header" scope="col">MAIN</th>
<th class="r header" scope="col">NUMBRANCH</th>
<th class="l header" scope="col">HIGHDEG</th>
<th class="l header" scope="col">CONTROL</th>
<th class="r header" scope="col">ST_FIPS</th>
<th class="r header" scope="col">LOCALE</th>
<th class="r header" scope="col">LATITUDE</th>
<th class="r header" scope="col">LONGITUDE</th>
<th class="l header" scope="col">State</th>
<th class="r header" scope="col">uses_st_name</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">100654</td>
<td class="l data">Alabama A &amp; M University</td>
<td class="l data">Normal</td>
<td class="l data">AL</td>
<td class="l data">35762</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.aamu.edu/</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">34.783368</td>
<td class="r data" nowrap>-86.568502</td>
<td class="l data">Alabama</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="r data">100663</td>
<td class="l data">University of Alabama at Birmingham</td>
<td class="l data">Birmingham</td>
<td class="l data">AL</td>
<td class="l data">35294-0110</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">https://www.uab.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">33.505697</td>
<td class="r data" nowrap>-86.799345</td>
<td class="l data">Alabama</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="r data">100690</td>
<td class="l data">Amridge University</td>
<td class="l data">Montgomery</td>
<td class="l data">AL</td>
<td class="l data">36117-3553</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.amridgeuniversity.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Private Non Profit</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">32.362609</td>
<td class="r data" nowrap>-86.17401</td>
<td class="l data">Alabama</td>
<td class="r data">0</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="r data">100706</td>
<td class="l data">University of Alabama in Huntsville</td>
<td class="l data">Huntsville</td>
<td class="l data">AL</td>
<td class="l data">35899</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.uah.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">34.724557</td>
<td class="r data" nowrap>-86.640449</td>
<td class="l data">Alabama</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="r data">100724</td>
<td class="l data">Alabama State University</td>
<td class="l data">Montgomery</td>
<td class="l data">AL</td>
<td class="l data">36104-0271</td>
<td class="l data">Southern Association of Colleges and Schools Commission on Colleges</td>
<td class="l data">www.alasu.edu</td>
<td class="l data">Predominantly bachelor&#39;s-degree granting</td>
<td class="l data">main campus</td>
<td class="r data">1</td>
<td class="l data">Graduate</td>
<td class="l data">Public</td>
<td class="r data">1</td>
<td class="r data">12</td>
<td class="r data">32.364317</td>
<td class="r data" nowrap>-86.295677</td>
<td class="l data">Alabama</td>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

<details><summary>What are some common substrings in a set of text?</summary>
For this, we'll start with working with the single column `INSTNM`. 


```r
head(college$INSTNM) %>% str_split(., " ") # Split on every space
Error in head(college$INSTNM): object 'college' not found

# We may need to fix certain things that should stay together
# But doing too much of that gets tedious...
str_replace(college$INSTNM, "A & M", "A&M") %>%
  head() %>% 
  str_split(., "[ -]") # This pattern says "either ' ' or '-'" 
Error in stri_replace_first_regex(string, pattern, fix_replacement(replacement), : object 'college' not found
                       # (but the - has to be at the start or the end)
```

So we could take the time to clean up everything, making sure that e.g. San Diego is treated as a single word, but that's a pain in the rear. Instead, let's just see what happens if we brute-force it. 

```r
tmp <- college %>%
  select(INSTNM, State) %>% 
  mutate(name_words = str_split(INSTNM, '[ -]')) # This is a list-column
Error in select(., INSTNM, State): object 'college' not found
tmp
Error in eval(expr, envir, enclos): object 'tmp' not found
unnest(tmp) # Unnest duplicates rows so that the expanded data frame has the 
Error in unnest(tmp): object 'tmp' not found
            # same structure as the original data
```

List columns are one way to maintain tidy data. They allow you to have several "sub-observations" for each observation and are useful for precisely cases like this, where there are uneven numbers of words in each university's name. We're not going to focus on list columns, but if you're interested, check out `purrr` and this [excellent tutorial](https://jennybc.github.io/purrr-tutorial/). 


```r
library(purrr) # List columns

Attaching package: 'purrr'
The following object is masked from 'package:magrittr':

    set_names

unnest(tmp) %>% 
  pull(name_words) %>% # this pulls out a single column
  table() %>% 
  sort(decreasing = T) %>% 
  head(50)
Error in unnest(tmp): object 'tmp' not found
```

In SAS, this is a bit more tricky. Most people I know that use both SAS and R will do the data cleaning in R once things get complicated, and then read the clean data in to SAS. That's a valid approach, but it's worth seeing what has to be done in SAS this once. As we get further into this class, I'll probably be more willing to say "we're just going to use R for this" for two reasons - 1. I know R better, and 2. R is generally better at handling the weird stuff; SAS is built to quickly handle things that are already formatted in a reasonable way. SAS seems to be highly preferred for e.g. fitting mixed/linear models, but it isn't the easiest tool to use for data cleaning. 

But, in this particular case, there is [documentation about how to break a sentence into words](https://blogs.sas.com/content/iml/2016/07/11/break-sentence-into-words-sas.html) in SAS. 


```sashtml
libname classdat "sas/";
DATA collegename;
SET classdat.college;
numWords = countw(INSTNM, " ");
DO i = 1 TO numWords;
  word = scan(INSTNM, i, " ");
  OUTPUT;
END;
KEEP word numWords;
;

PROC PRINT DATA=collegename (obs = 30);
run;

PROC FREQ DATA=collegename ORDER=FREQ;
TABLES word / MAXLEVELS=30;
RUN;
```


<div class="branch">
<a name="IDX2"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.COLLEGENAME">
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
<th class="r header" scope="col">numWords</th>
<th class="l header" scope="col">word</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="r data">5</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="r data">5</td>
<td class="l data">A</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="r data">5</td>
<td class="l data">&amp;</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="r data">5</td>
<td class="l data">M</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="r data">5</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="r data">5</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">7</th>
<td class="r data">5</td>
<td class="l data">of</td>
</tr>
<tr>
<th class="r rowheader" scope="row">8</th>
<td class="r data">5</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">9</th>
<td class="r data">5</td>
<td class="l data">at</td>
</tr>
<tr>
<th class="r rowheader" scope="row">10</th>
<td class="r data">5</td>
<td class="l data">Birmingham</td>
</tr>
<tr>
<th class="r rowheader" scope="row">11</th>
<td class="r data">2</td>
<td class="l data">Amridge</td>
</tr>
<tr>
<th class="r rowheader" scope="row">12</th>
<td class="r data">2</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">13</th>
<td class="r data">5</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">14</th>
<td class="r data">5</td>
<td class="l data">of</td>
</tr>
<tr>
<th class="r rowheader" scope="row">15</th>
<td class="r data">5</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">16</th>
<td class="r data">5</td>
<td class="l data">in</td>
</tr>
<tr>
<th class="r rowheader" scope="row">17</th>
<td class="r data">5</td>
<td class="l data">Huntsville</td>
</tr>
<tr>
<th class="r rowheader" scope="row">18</th>
<td class="r data">3</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">19</th>
<td class="r data">3</td>
<td class="l data">State</td>
</tr>
<tr>
<th class="r rowheader" scope="row">20</th>
<td class="r data">3</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">21</th>
<td class="r data">4</td>
<td class="l data">The</td>
</tr>
<tr>
<th class="r rowheader" scope="row">22</th>
<td class="r data">4</td>
<td class="l data">University</td>
</tr>
<tr>
<th class="r rowheader" scope="row">23</th>
<td class="r data">4</td>
<td class="l data">of</td>
</tr>
<tr>
<th class="r rowheader" scope="row">24</th>
<td class="r data">4</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">25</th>
<td class="r data">4</td>
<td class="l data">Central</td>
</tr>
<tr>
<th class="r rowheader" scope="row">26</th>
<td class="r data">4</td>
<td class="l data">Alabama</td>
</tr>
<tr>
<th class="r rowheader" scope="row">27</th>
<td class="r data">4</td>
<td class="l data">Community</td>
</tr>
<tr>
<th class="r rowheader" scope="row">28</th>
<td class="r data">4</td>
<td class="l data">College</td>
</tr>
<tr>
<th class="r rowheader" scope="row">29</th>
<td class="r data">3</td>
<td class="l data">Athens</td>
</tr>
<tr>
<th class="r rowheader" scope="row">30</th>
<td class="r data">3</td>
<td class="l data">State</td>
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
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Freq: One-Way Frequencies">
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
<th class="l b header" scope="col">word</th>
<th class="r b header" scope="col">Frequency</th>
<th class="r b header" scope="col"> Percent</th>
<th class="r b header" scope="col">Cumulative<br/> Frequency</th>
<th class="r b header" scope="col">Cumulative<br/>  Percent</th>
</tr>
</thead>
<tbody>
<tr>
<th class="l rowheader" scope="row">College</th>
<td class="r data">2324</td>
<td class="r data">8.86</td>
<td class="r data">2324</td>
<td class="r data">8.86</td>
</tr>
<tr>
<th class="l rowheader" scope="row">of</th>
<td class="r data">1731</td>
<td class="r data">6.60</td>
<td class="r data">4055</td>
<td class="r data">15.47</td>
</tr>
<tr>
<th class="l rowheader" scope="row">University</th>
<td class="r data">1314</td>
<td class="r data">5.01</td>
<td class="r data">5369</td>
<td class="r data">20.48</td>
</tr>
<tr>
<th class="l rowheader" scope="row">School</th>
<td class="r data">604</td>
<td class="r data">2.30</td>
<td class="r data">5973</td>
<td class="r data">22.78</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Community</th>
<td class="r data">553</td>
<td class="r data">2.11</td>
<td class="r data">6526</td>
<td class="r data">24.89</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Institute</th>
<td class="r data">506</td>
<td class="r data">1.93</td>
<td class="r data">7032</td>
<td class="r data">26.82</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Beauty</th>
<td class="r data">433</td>
<td class="r data">1.65</td>
<td class="r data">7465</td>
<td class="r data">28.47</td>
</tr>
<tr>
<th class="l rowheader" scope="row">State</th>
<td class="r data">381</td>
<td class="r data">1.45</td>
<td class="r data">7846</td>
<td class="r data">29.92</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Technical</th>
<td class="r data">359</td>
<td class="r data">1.37</td>
<td class="r data">8205</td>
<td class="r data">31.29</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Academy</th>
<td class="r data">311</td>
<td class="r data">1.19</td>
<td class="r data">8516</td>
<td class="r data">32.48</td>
</tr>
<tr>
<th class="l rowheader" scope="row">and</th>
<td class="r data">293</td>
<td class="r data">1.12</td>
<td class="r data">8809</td>
<td class="r data">33.60</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Career</th>
<td class="r data">219</td>
<td class="r data">0.84</td>
<td class="r data">9028</td>
<td class="r data">34.43</td>
</tr>
<tr>
<th class="l rowheader" scope="row">-</th>
<td class="r data">211</td>
<td class="r data">0.80</td>
<td class="r data">9239</td>
<td class="r data">35.24</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Campus</th>
<td class="r data">206</td>
<td class="r data">0.79</td>
<td class="r data">9445</td>
<td class="r data">36.02</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Center</th>
<td class="r data">198</td>
<td class="r data">0.76</td>
<td class="r data">9643</td>
<td class="r data">36.78</td>
</tr>
<tr>
<th class="l rowheader" scope="row">&amp;</th>
<td class="r data">186</td>
<td class="r data">0.71</td>
<td class="r data">9829</td>
<td class="r data">37.49</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Technology</th>
<td class="r data">175</td>
<td class="r data">0.67</td>
<td class="r data">10004</td>
<td class="r data">38.15</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Cosmetology</th>
<td class="r data">162</td>
<td class="r data">0.62</td>
<td class="r data">10166</td>
<td class="r data">38.77</td>
</tr>
<tr>
<th class="l rowheader" scope="row">the</th>
<td class="r data">159</td>
<td class="r data">0.61</td>
<td class="r data">10325</td>
<td class="r data">39.38</td>
</tr>
<tr>
<th class="l rowheader" scope="row">The</th>
<td class="r data">139</td>
<td class="r data">0.53</td>
<td class="r data">10464</td>
<td class="r data">39.91</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Hair</th>
<td class="r data">132</td>
<td class="r data">0.50</td>
<td class="r data">10596</td>
<td class="r data">40.41</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Medical</th>
<td class="r data">132</td>
<td class="r data">0.50</td>
<td class="r data">10728</td>
<td class="r data">40.92</td>
</tr>
<tr>
<th class="l rowheader" scope="row">County</th>
<td class="r data">130</td>
<td class="r data">0.50</td>
<td class="r data">10858</td>
<td class="r data">41.41</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Nursing</th>
<td class="r data">121</td>
<td class="r data">0.46</td>
<td class="r data">10979</td>
<td class="r data">41.87</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Seminary</th>
<td class="r data">117</td>
<td class="r data">0.45</td>
<td class="r data">11096</td>
<td class="r data">42.32</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Health</th>
<td class="r data">112</td>
<td class="r data">0.43</td>
<td class="r data">11208</td>
<td class="r data">42.75</td>
</tr>
<tr>
<th class="l rowheader" scope="row">New</th>
<td class="r data">112</td>
<td class="r data">0.43</td>
<td class="r data">11320</td>
<td class="r data">43.17</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Education</th>
<td class="r data">109</td>
<td class="r data">0.42</td>
<td class="r data">11429</td>
<td class="r data">43.59</td>
</tr>
<tr>
<th class="l rowheader" scope="row">American</th>
<td class="r data">108</td>
<td class="r data">0.41</td>
<td class="r data">11537</td>
<td class="r data">44.00</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Paul</th>
<td class="r data">104</td>
<td class="r data">0.40</td>
<td class="r data">11641</td>
<td class="r data">44.40</td>
</tr>
</tbody>
<tfoot>
<tr>
<th class="c b footer" colspan="5">The first 30 levels are displayed.</th>
</tr>
</tfoot>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>

### Regular Expressions
Matching exact strings is easy - it's just like using find and replace.


```r
human_talk <- "blah, blah, blah. Do you want to go for a walk?"
dog_hears <- str_extract(human_talk, "walk")
dog_hears
[1] "walk"
```

But, if you can master even a small amount of regular expression notation, you'll have exponentially more power to do good (or evil) when working with strings. You can get by without regular expressions if you're creative, but often they're much simpler. 

You may find it helpful to follow along with this section using this [web  app](https://spannbaueradam.shinyapps.io/r_regex_tester/) built to test R regular expressions for R. A similar application for Perl compatible regular expressions (used by SAS) can be found [here](https://regex101.com/). The subset of regular expression syntax we're going to cover here is fairly limited (and common to both SAS and R, with a few adjustments), but [you can find regular expressions to do just about anything string-related](https://stackoverflow.com/questions/tagged/regex?tab=Votes). As with any tool, there are situations where it's useful, and situations where you should not use a regular expression, no matter how much you want to. 


<details><summary>Short Regular Expression Primer (with R examples)</summary>

- `[]` enclose sets of characters    
Ex: `[abc]` will match any single character `a`, `b`, `c`
  - `-` specifies a range of characters (`A-z` matches all upper and lower case letters)
  - to match `-` exactly, precede with a backslash (outside of `[]`) or put the `-` last (inside `[]`)
- `.` matches any character (except a newline)
- To match special characters, escape them using `\` (in most languages) or `\\` (in R). So `\\.` will match a literal `.`, `\\$` will match a literal `$`. 


```r
num_string <- "phone: 123-456-7890, nuid: 12345678, ssn: 123-45-6789"

ssn <- str_extract(num_string, "[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]")
ssn
[1] "123-45-6789"
```

Listing out all of those numbers can get repetitive, though. How do we specify repetition?

- `*` means repeat between 0 and inf times
- `+` means 1 or more times
- `?` means 0 or 1 times -- most useful when you're looking for something optional
- `{a, b}` means repeat between `a` and `b` times, where `a` and `b` are integers. `b` can be blank. So `[abc]{3,}` will match `abc`, `aaaa`, `cbbaa`, but not `ab`, `bb`, or `a`. For a single number of repeated characters, you can use `{a}`. So `{3, }` means "3 or more times" and `{3}` means "exactly 3 times"


```r
str_extract("banana", "[a-z]{1,}") # match any sequence of lowercase characters
[1] "banana"
str_extract("banana", "[ab]{1,}") # Match any sequence of a and b characters
[1] "ba"
str_extract_all("banana", "(..)") # Match any two characters
[[1]]
[1] "ba" "na" "na"
str_extract("banana", "(..)\\1") # Match a repeated thing
[1] "anan"
```


```r
num_string <- "phone: 123-456-7890, nuid: 12345678, ssn: 123-45-6789, bank account balance: $50,000,000.23"

ssn <- str_extract(num_string, "[0-9]{3}-[0-9]{2}-[0-9]{4}")
ssn
[1] "123-45-6789"
phone <- str_extract(num_string, "[0-9]{3}.[0-9]{3}.[0-9]{4}")
phone
[1] "123-456-7890"
nuid <- str_extract(num_string, "[0-9]{8}")
nuid
[1] "12345678"
bank_balance <- str_extract(num_string, "\\$[0-9,]+\\.[0-9]{2}")
bank_balance
[1] "$50,000,000.23"
```

There are also ways to "anchor" a pattern to a part of the string (e.g. the beginning or the end)

- `^` has multiple meanings:
  - if it's the first character in a pattern, `^` matches the beginning of a string
  - if it follows `[`, e.g. `[^abc]`, `^` means "not" - for instance, "the collection of all characters that aren't a, b, or c". 
- `$` means the end of a string

Combined with pre and post-processing, these let you make sense out of semi-structured string data, such as addresses

```r
address <- "1600 Pennsylvania Ave NW, Washington D.C., 20500"

house_num <- str_extract(address, "^[0-9]{1,}")

 # Match everything alphanumeric up to the comma
street <- str_extract(address, "[A-z0-9 ]{1,}")
street <- str_remove(street, house_num) %>% str_trim() # remove house number

city <- str_extract(address, ",.*,") %>% str_remove_all(",") %>% str_trim()

zip <- str_extract(address, "[0-9-]{5,10}$") # match 5 and 9 digit zip codes
```


- `()` are used to capture information. So `([0-9]{4})` captures any 4-digit number
- `a|b` will select a or b. 

If you've captured information using (), you can reference that information using backreferences. In most languages, those look like this: `\1` for the first reference, `\9` for the ninth. In R, though, the `\` character is special, so you have to escape it. So in R, `\\1` is the first reference, and `\\2` is the second, and so on. 


```r
phone_num_variants <- c("(123) 456-7980", "123.456.7890", "+1 123-456-7890")
phone_regex <- "\\(?([0-9]{3})?\\)?.?([0-9]{3}).?([0-9]{4})"
# \\( and \\) match literal parentheses if they exist
# ([0-9]{3})? captures the area code, if it exists
# .? matches any character
# ([0-9]{3}) captures the exchange code
# ([0-9]{4}) captures the 4-digit individual code

str_extract(phone_num_variants, phone_regex)
[1] "(123) 456-7980" "123.456.7890"   "123-456-7890"  
str_replace(phone_num_variants, phone_regex, "\\1\\2\\3")
[1] "1234567980"    "1234567890"    "+1 1234567890"
# We didn't capture the country code, so it remained in the string

human_talk <- "blah, blah, blah. Do you want to go for a walk? I think I'm going to treat myself to some ice cream for working so hard. "
dog_hears <- str_extract_all(human_talk, "walk|treat")
dog_hears
[[1]]
[1] "walk"  "treat"
```
</details>

In SAS, much the same information is true, though you do not have to double-escape special characters. SAS uses PERL-compatible regular expressions (PCRE for short) (these can also be enabled in base-R string functions). 

In PCRE regular expressions, '/' are used as delimiters. SAS assigns each sequential regular expression a number (so that you can reference them if necessary).

<details><summary>PRXMATCH returns the first position of a string where a match is found (0 otherwise)</summary>

In this example, however, lets just test to see whether PRXMATCH finds a match or not


```sashtml
DATA strings;
  INFILE DATALINES DSD; /* This allows quoted strings */
  INPUT string ~ $150.; /* ~ says deal with quoted strings */
  DATALINES;
"abcdefghijklmnopqrstuvwxyzABAB"
"banana orange strawberry apple"
"ana went to montana to eat a banana"
"call me at 432-394-2873. Do you want to go for a walk? I'm going to treat myself to some ice cream for working so hard."
"phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23"
"1600 Pennsylvania Ave NW, Washington D.C., 20500"
RUN;

DATA info;
set strings;
  IF PRXMATCH("/\(?([0-9]{3})?\)?.?([0-9]{3}).([0-9]{4})/", string) GT 0 THEN phone = 1;
    ELSE phone = 0;
  IF PRXMATCH("/(walk|treat)/", string) GT 0 THEN dog = 1;
    ELSE dog = 0;
  IF PRXMATCH("/([0-9]*) ([A-z0-9 ]{3,}), ([A-z\. ]{3,}), ([0-9]{5})/", string) GT 0 THEN addr = 1;
    ELSE addr = 0; /* Changed to require at least 3 characters in street and city names */
  IF PRXMATCH("/(..)\1/", string) GT 0 THEN abab = 1;
    ELSE abab = 0;
;

PROC PRINT DATA=info;
RUN;
```


<div class="branch">
<a name="IDX4"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.INFO">
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
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">string</th>
<th class="r header" scope="col">phone</th>
<th class="r header" scope="col">dog</th>
<th class="r header" scope="col">addr</th>
<th class="r header" scope="col">abab</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">&quot;abcdefghijklmnopqrstuvwxyzABAB&quot;</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">&quot;banana orange strawberry apple&quot;</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">&quot;ana went to montana to eat a banana&quot;</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">&quot;call me at 432-394-2873. Do you want to go for a walk? I&#39;m going to treat myself to some ice cream for working so hard.&quot;</td>
<td class="r data">1</td>
<td class="r data">1</td>
<td class="r data">0</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="l data">&quot;phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23&quot;</td>
<td class="r data">1</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">1</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="l data">&quot;1600 Pennsylvania Ave NW, Washington D.C., 20500&quot;</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">1</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

Note that the equivalent syntax in R would be:

```r
strings <- c("abcdefghijklmnopqrstuvwxyzABAB",
"banana orange strawberry apple",
"ana went to montana to eat a banana",
"call me at 432-394-2873. Do you want to go for a walk? I'm going to treat myself to some ice cream for working so hard.",
"phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23",
"1600 Pennsylvania Ave NW, Washington D.C., 20500")

phone_regex <- "\\(?([0-9]{3})?\\)?.?([0-9]{3}).([0-9]{4})"
dog_regex <- "(walk|treat)"
addr_regex <- "([0-9]*) ([A-z0-9 ]{3,}), ([A-z\\. ]{3,}), ([0-9]{5})"
abab_regex <- "(..)\\1"

tibble(
  text = strings,
  phone = str_detect(strings, phone_regex),
  dog = str_detect(strings, dog_regex),
  addr = str_detect(strings, addr_regex),
  abab = str_detect(strings, abab_regex))
# A tibble: 6 x 5
  text                                                   phone dog   addr  abab 
  <chr>                                                  <lgl> <lgl> <lgl> <lgl>
1 abcdefghijklmnopqrstuvwxyzABAB                         FALSE FALSE FALSE TRUE 
2 banana orange strawberry apple                         FALSE FALSE FALSE TRUE 
3 ana went to montana to eat a banana                    FALSE FALSE FALSE TRUE 
4 call me at 432-394-2873. Do you want to go for a walk… TRUE  TRUE  FALSE FALSE
5 phone: (123) 456-7890, nuid: 12345678, bank account b… TRUE  FALSE FALSE FALSE
6 1600 Pennsylvania Ave NW, Washington D.C., 20500       FALSE FALSE TRUE  FALSE
```
</details>

When doing various operations with regular expressions, it can be useful to save the regular expression for later use. 

- PRXPARSE saves a regex for use later
- PRXSUBSTR saves the starting location and length of a string match
- SUBSTR extracts the string given the starting location and length

<details><summary>PRXPARSE, PRXSUBSTR, SUBSTR</summary>

```sashtml
DATA strings;
  INFILE DATALINES DSD; /* This allows quoted strings */
  INPUT string ~ $150.; /* ~ says deal with quoted strings */
  DATALINES;
"abcdefghijklmnopqrstuvwxyzABAB"
"banana orange strawberry apple"
"ana went to montana to eat a banana"
"call me at 432-394-2873. Do you want to go for a walk? I'm going to treat myself to some ice cream for working so hard."
"phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23"
"1600 Pennsylvania Ave NW, Washington D.C., 20500"
RUN;

DATA info;
  SET strings;
  /* This says use these variables for all rows */
  RETAIN REphone REdog REaddr REabab; 
  
  /* This block defined our variables */
  IF _N_ = 1 THEN DO;
    REphone = PRXPARSE("/\(?([0-9]{3})?\)?.?([0-9]{3}).([0-9]{4})/");
    REdog = PRXPARSE("/(walk|treat)/");
    REaddr = PRXPARSE("/([0-9]*) ([A-z0-9 ]{3,}), ([A-z\. ]{3,}), ([0-9]{5})/");
    REabab = PRXPARSE("/(..)\1/");
  END;
  
  /* This block identifies string start and length for matches */
  /* Note that phonestart, phonelength, dogstart, doglength, ... 
     are all defined implicitly in this block */
  CALL PRXSUBSTR(REphone, string, phonestart, phonelength);
  CALL PRXSUBSTR(REdog, string, dogstart, doglength);
  CALL PRXSUBSTR(REaddr, string, addrstart, addrlength);
  CALL PRXSUBSTR(REabab, string, ababstart, abablength);

  /* This block extracts all of the matches */
  IF phonestart GT 0 THEN DO;
    phonenumber = SUBSTR(string, phonestart, phonelength);
  END;
  IF dogstart GT 0 THEN DO;
    dogword = SUBSTR(string, dogstart, doglength);
  END;
  IF addrstart GT 0 THEN DO;
    addr = SUBSTR(string, addrstart, addrlength);
  END;
  IF ababstart GT 0 THEN DO;
    abab = SUBSTR(string, ababstart, abablength);
  END;


  /* This block keeps only rows with a phone number, dog keyword, or address */
  IF (phonestart GT 0) OR (dogstart GT 0) OR (addrstart GT 0) OR (ababstart GT 0) THEN DO;
    OUTPUT;
  END;

  /* This keeps only the variables we care about */
  KEEP string phonenumber dogword addr abab;
;

PROC PRINT DATA=info;
RUN;
```


<div class="branch">
<a name="IDX5"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.INFO">
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
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">string</th>
<th class="l header" scope="col">phonenumber</th>
<th class="l header" scope="col">dogword</th>
<th class="l header" scope="col">addr</th>
<th class="l header" scope="col">abab</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">&quot;abcdefghijklmnopqrstuvwxyzABAB&quot;</td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data">ABAB</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">&quot;banana orange strawberry apple&quot;</td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data">anan</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">&quot;ana went to montana to eat a banana&quot;</td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data">anan</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">&quot;call me at 432-394-2873. Do you want to go for a walk? I&#39;m going to treat myself to some ice cream for working so hard.&quot;</td>
<td class="l data" nowrap>432-394-2873</td>
<td class="l data">walk</td>
<td class="l data"> </td>
<td class="l data"> </td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="l data">&quot;phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23&quot;</td>
<td class="l data" nowrap>(123) 456-7890</td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data"> </td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="l data">&quot;1600 Pennsylvania Ave NW, Washington D.C., 20500&quot;</td>
<td class="l data"> </td>
<td class="l data"> </td>
<td class="l data">1600 Pennsylvania Ave NW, Washington D.C., 20500</td>
<td class="l data"> </td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

Note that the equivalent syntax in R would be:

```r
strings <- c("abcdefghijklmnopqrstuvwxyzABAB",
"banana orange strawberry apple",
"ana went to montana to eat a banana",
"call me at 432-394-2873. Do you want to go for a walk? I'm going to treat myself to some ice cream for working so hard.",
"phone: (123) 456-7890, nuid: 12345678, bank account balance: $50,000,000.23",
"1600 Pennsylvania Ave NW, Washington D.C., 20500")

phone_regex <- "\\(?([0-9]{3})?\\)?.?([0-9]{3}).([0-9]{4})"
dog_regex <- "(walk|treat)"
addr_regex <- "([0-9]*) ([A-z0-9 ]{3,}), ([A-z\\. ]{3,}), ([0-9]{5})"
abab_regex <- "(..)\\1"

tibble(
  text = strings,
  phone = str_extract(strings, phone_regex),
  dog = str_extract(strings, dog_regex),
  addr = str_extract(strings, addr_regex),
  abab = str_extract(strings, abab_regex))
# A tibble: 6 x 5
  text                               phone     dog   addr                  abab 
  <chr>                              <chr>     <chr> <chr>                 <chr>
1 abcdefghijklmnopqrstuvwxyzABAB     <NA>      <NA>  <NA>                  ABAB 
2 banana orange strawberry apple     <NA>      <NA>  <NA>                  anan 
3 ana went to montana to eat a bana… <NA>      <NA>  <NA>                  anan 
4 call me at 432-394-2873. Do you w… 432-394-… walk  <NA>                  <NA> 
5 phone: (123) 456-7890, nuid: 1234… (123) 45… <NA>  <NA>                  <NA> 
6 1600 Pennsylvania Ave NW, Washing… <NA>      <NA>  1600 Pennsylvania Av… <NA> 
```
</details>

<details><summary>Find and Replace with PRXCHANGE</summary>
The next major task is find and replace, where we get to see another feature of perl-style regular expressions. 's/xxx/yyy/' is the general form of a find-and-replace regular expression. Think "substitue yyy for xxx". 


```sashtml
DATA ducks;
INFILE DATALINES DSD;
INPUT line ~ $50.;
DATALINES;
"Five little ducks went out one day,"
"Over the hills and far away."
"Mother duck said, quack quack quack quack,"
"But only four little ducks came back."
RUN;

DATA cats;
SET ducks;
/* define lengths of output strings */
LENGTH new_text $ 50 new_text2 $ 50;

IF _N_ = 1 THEN DO;
  REanimal = PRXPARSE("s/duck/cat/");
  REnoise = PRXPARSE("s/quack/meow/");
END;
RETAIN REanimal REnoise;

/* First, replace duck with cat */
CALL PRXCHANGE(REanimal, -1, line, new_text, r_length, trunc, n_of_changes);

/* Then, fix noises */
CALL PRXCHANGE(REnoise, -1, new_text, new_text2, r_length2, trunc2, n_of_changes2);

/* Warnings if anything was truncated */
IF trunc THEN PUT "Note: new_text was truncated";
IF trunc2 THEN PUT "Note: new_text2 was truncated";
RUN;

PROC PRINT DATA=cats;
RUN;
```


<div class="branch">
<a name="IDX6"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Print: Data Set WORK.CATS">
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
</colgroup>
<thead>
<tr>
<th class="r header" scope="col">Obs</th>
<th class="l header" scope="col">line</th>
<th class="l header" scope="col">new_text</th>
<th class="l header" scope="col">new_text2</th>
<th class="r header" scope="col">REanimal</th>
<th class="r header" scope="col">REnoise</th>
<th class="r header" scope="col">r_length</th>
<th class="r header" scope="col">trunc</th>
<th class="r header" scope="col">n_of_changes</th>
<th class="r header" scope="col">r_length2</th>
<th class="r header" scope="col">trunc2</th>
<th class="r header" scope="col">n_of_changes2</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">&quot;Five little ducks went out one day,&quot;</td>
<td class="l data">&quot;Five little cats went out one day,&quot;</td>
<td class="l data">&quot;Five little cats went out one day,&quot;</td>
<td class="r data">1</td>
<td class="r data">2</td>
<td class="r data">49</td>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">50</td>
<td class="r data">0</td>
<td class="r data">0</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">&quot;Over the hills and far away.&quot;</td>
<td class="l data">&quot;Over the hills and far away.&quot;</td>
<td class="l data">&quot;Over the hills and far away.&quot;</td>
<td class="r data">1</td>
<td class="r data">2</td>
<td class="r data">50</td>
<td class="r data">0</td>
<td class="r data">0</td>
<td class="r data">50</td>
<td class="r data">0</td>
<td class="r data">0</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">&quot;Mother duck said, quack quack quack quack,&quot;</td>
<td class="l data">&quot;Mother cat said, quack quack quack quack,&quot;</td>
<td class="l data">&quot;Mother cat said, meow meow meow meow,&quot;</td>
<td class="r data">1</td>
<td class="r data">2</td>
<td class="r data">49</td>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">46</td>
<td class="r data">0</td>
<td class="r data">4</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">&quot;But only four little ducks came back.&quot;</td>
<td class="l data">&quot;But only four little cats came back.&quot;</td>
<td class="l data">&quot;But only four little cats came back.&quot;</td>
<td class="r data">1</td>
<td class="r data">2</td>
<td class="r data">49</td>
<td class="r data">0</td>
<td class="r data">1</td>
<td class="r data">50</td>
<td class="r data">0</td>
<td class="r data">0</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>

The equivalent R code:

```r
line <- c(
"Five little ducks went out one day,",
"Over the hills and far away.",
"Mother duck said, quack quack quack quack,",
"But only four little ducks came back."
)

str_replace_all(line, "duck", "cat") %>%
  str_replace_all("quack", "meow")
[1] "Five little cats went out one day,"   
[2] "Over the hills and far away."         
[3] "Mother cat said, meow meow meow meow,"
[4] "But only four little cats came back." 

# Or, in one line... 
str_replace_all(line, c("duck" = "cat", "quack" = "meow"))
[1] "Five little cats went out one day,"   
[2] "Over the hills and far away."         
[3] "Mother cat said, meow meow meow meow,"
[4] "But only four little cats came back." 
```


In PCRE, a backreference in the same expression would be `\1`, `\2`, etc., but if you are in the replace block of the regex, you would use `$1`, `$2`, .... 
</details>

::: note
Don't expect too much out of yourself as far as regular expressions go. I used them for almost a decade before I (mostly) quit googling "regex for ..." to find somewhere to start. 

Another thing to realize - regular expressions are 100% a language you write, but don't ever expect to read. So leave yourself lots of comments. 
:::


#### Try it out - Squirrel Census {- .tryitout}

The Squirrel Census (https://www.thesquirrelcensus.com/) is a multimedia science, design, and storytelling project focusing on the Eastern gray (Sciurus carolinensis) in NYC's Central Park. They count squirrels and present their findings to the public. This table contains squirrel data for each of the 3,023 sightings, including location coordinates, age, primary and secondary fur color, elevation, activities, communications, and interactions between squirrels and with humans.


<details><summary>Task 1: Fix the date!</summary>
In both SAS and R, read in the data ([link](data/2018_Central_Park_Squirrel_Census_-_Squirrel_Data.csv)) and format the date correctly. You can do this by carefully specifying how the date is read in (?read_csv in R, [informat](https://documentation.sas.com/?docsetId=etsug&docsetTarget=etsug_intervals_sect009.htm&docsetVersion=15.1&locale=en) in SAS)

<details><summary>R solution</summary>

```r
library(readr)
library(lubridate)

Attaching package: 'lubridate'
The following objects are masked from 'package:base':

    date, intersect, setdiff, union

squirrels <- read_csv("data/2018_Central_Park_Squirrel_Census_-_Squirrel_Data.csv") %>%
  mutate(Date = as.character(Date) %>% mdy())

── Column specification ────────────────────────────────────────────────────────
cols(
  .default = col_character(),
  X = col_double(),
  Y = col_double(),
  Date = col_double(),
  `Hectare Squirrel Number` = col_double(),
  Running = col_logical(),
  Chasing = col_logical(),
  Climbing = col_logical(),
  Eating = col_logical(),
  Foraging = col_logical(),
  Kuks = col_logical(),
  Quaas = col_logical(),
  Moans = col_logical(),
  `Tail flags` = col_logical(),
  `Tail twitches` = col_logical(),
  Approaches = col_logical(),
  Indifferent = col_logical(),
  `Runs from` = col_logical(),
  `Zip Codes` = col_double(),
  `Community Districts` = col_double(),
  `Borough Boundaries` = col_double()
  # ... with 2 more columns
)
ℹ Use `spec()` for the full column specifications.
```
</details>

<details><summary>SAS solution</summary>

```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          filename fileloc
8        ! 'data/2018_Central_Park_Squirrel_Census_-_Squirrel_Data.csv';
9          PROC IMPORT  datafile = fileloc out=classdat.squirrel REPLACE
10         DBMS = csv;
10       !             /* comma delimited file */
11         GUESSINGROWS=500;
12         GETNAMES = YES;
13         RUN;

Name Combination of Primary and Highlight Color truncated to 
Combination_of_Primary_and_Highl.
Problems were detected with provided names.  See LOG. 
14          /**************************************************************
14       ! ********
15          *   PRODUCT:   SAS
16          *   VERSION:   9.4
17          *   CREATOR:   External File Interface
18          *   DATE:      06MAY21
19          *   DESC:      Generated SAS Datastep Code
20          *   TEMPLATE SOURCE:  (None Specified.)
21          ***************************************************************
21       ! ********/
22             data CLASSDAT.SQUIRREL    ;
23             %let _EFIERR_ = 0; /* set the ERROR detection macro variable
23       !  */
24             infile FILELOC delimiter = ',' MISSOVER DSD  firstobs=2 ;
25                informat X best32. ;
26                informat Y best32. ;
27                informat Unique_Squirrel_ID $14. ;
28                informat Hectare $3. ;
29                informat Shift $2. ;
30                informat Date best32. ;
31                informat Hectare_Squirrel_Number best32. ;
32                informat Age $8. ;
33                informat Primary_Fur_Color $8. ;
34                informat Highlight_Fur_Color $24. ;
35                informat Combination_of_Primary_and_Highl $29. ;
36                informat Color_notes $110. ;
37                informat Location $12. ;
38                informat Above_Ground_Sighter_Measurement $5. ;
39                informat Specific_Location $58. ;
40                informat Running $5. ;
41                informat Chasing $5. ;
42                informat Climbing $5. ;
43                informat Eating $5. ;
44                informat Foraging $5. ;
45                informat Other_Activities $134. ;
46                informat Kuks $5. ;
47                informat Quaas $5. ;
48                informat Moans $5. ;
49                informat Tail_flags $5. ;
50                informat Tail_twitches $5. ;
51                informat Approaches $5. ;
52                informat Indifferent $5. ;
53                informat Runs_from $5. ;
54                informat Other_Interactions $70. ;
55                informat Lat_Long $45. ;
56                informat Zip_Codes $1. ;
57                informat Community_Districts best32. ;
58                informat Borough_Boundaries best32. ;
59                informat City_Council_Districts best32. ;
60                informat Police_Precincts best32. ;
61                format X best12. ;
62                format Y best12. ;
63                format Unique_Squirrel_ID $14. ;
64                format Hectare $3. ;
65                format Shift $2. ;
66                format Date best12. ;
67                format Hectare_Squirrel_Number best12. ;
68                format Age $8. ;
69                format Primary_Fur_Color $8. ;
70                format Highlight_Fur_Color $24. ;
71                format Combination_of_Primary_and_Highl $29. ;
72                format Color_notes $110. ;
73                format Location $12. ;
74                format Above_Ground_Sighter_Measurement $5. ;
75                format Specific_Location $58. ;
76                format Running $5. ;
77                format Chasing $5. ;
78                format Climbing $5. ;
79                format Eating $5. ;
80                format Foraging $5. ;
81                format Other_Activities $134. ;
82                format Kuks $5. ;
83                format Quaas $5. ;
84                format Moans $5. ;
85                format Tail_flags $5. ;
86                format Tail_twitches $5. ;
87                format Approaches $5. ;
88                format Indifferent $5. ;
89                format Runs_from $5. ;
90                format Other_Interactions $70. ;
91                format Lat_Long $45. ;
92                format Zip_Codes $1. ;
93                format Community_Districts best12. ;
94                format Borough_Boundaries best12. ;
95                format City_Council_Districts best12. ;
96                format Police_Precincts best12. ;
97             input
98                         X
99                         Y
100                        Unique_Squirrel_ID  $
101                        Hectare  $
102                        Shift  $
103                        Date
104                        Hectare_Squirrel_Number
105                        Age  $
106                        Primary_Fur_Color  $
107                        Highlight_Fur_Color  $
108                        Combination_of_Primary_and_Highl  $
109                        Color_notes  $
110                        Location  $
111                        Above_Ground_Sighter_Measurement  $
112                        Specific_Location  $
113                        Running  $
114                        Chasing  $
115                        Climbing  $
116                        Eating  $
117                        Foraging  $
118                        Other_Activities  $
119                        Kuks  $
120                        Quaas  $
121                        Moans  $
122                        Tail_flags  $
123                        Tail_twitches  $
124                        Approaches  $
125                        Indifferent  $
126                        Runs_from  $
127                        Other_Interactions  $
128                        Lat_Long  $
129                        Zip_Codes  $
130                        Community_Districts
131                        Borough_Boundaries
132                        City_Council_Districts
133                        Police_Precincts
134            ;
135            if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR
135      ! detection macro variable */
136            run;

NOTE: The infile FILELOC is:
      
      Filename=/home/susan/Projects/Class/unl-stat850/stat850-textbook/data
      /2018_Central_Park_Squirrel_Census_-_Squirrel_Data.csv,
      Owner Name=susan,Group Name=susan,
      Access Permission=-rw-rw-r--,
      Last Modified=23Jun2020:09:12:28,
      File Size (bytes)=784170

NOTE: 3023 records were read from the infile FILELOC.
      The minimum record length was 210.
      The maximum record length was 433.
NOTE: The data set CLASSDAT.SQUIRREL has 3023 observations and 36 
      variables.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      

3023 rows created in CLASSDAT.SQUIRREL from FILELOC.
  
  
  
NOTE: CLASSDAT.SQUIRREL data set was successfully created.
NOTE: The data set CLASSDAT.SQUIRREL has 3023 observations and 36 
      variables.
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.28 seconds
      cpu time            0.29 seconds
      

137        
138        PROC CONTENTS DATA=classdat.squirrel;
139        RUN;

NOTE: PROCEDURE CONTENTS used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      

140        
141        DATA classdat.cleanSquirrel;
142        SET classdat.squirrel;
143        month = FLOOR(date/1000000);
144        day = MOD(FLOOR(date/10000), 100);
145        year = MOD(date, 10000);
146        date = MDY(month, day, year);
147        format date MMDDYY10.;
148        RUN;

NOTE: Data file CLASSDAT.CLEANSQUIRREL.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
ERROR: Some character data was lost during transcoding in the dataset 
       CLASSDAT.CLEANSQUIRREL. Either the data contains characters that 
       are not representable in the new encoding or truncation occurred 
       during transcoding.
NOTE: The DATA step has been abnormally terminated.
NOTE: The SAS System stopped processing this step because of errors.
NOTE: Due to ERROR(s) above, SAS set option OBS=0, enabling syntax check 
      mode. 
      This prevents execution of subsequent data modification statements.
NOTE: There were 1180 observations read from the data set 
      CLASSDAT.SQUIRREL.
WARNING: The data set CLASSDAT.CLEANSQUIRREL may be incomplete.  When this 
         step was stopped there were 1179 observations and 39 variables.
WARNING: Data set CLASSDAT.CLEANSQUIRREL was not replaced because this 
         step was stopped.
NOTE: DATA statement used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      

ERROR: Errors printed on page 6.
```


<div class="branch">
<a name="IDX7"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Contents: Attributes">
<colgroup>
<col>
<col>
<col>
<col>
</colgroup>
<tbody>
<tr>
<th class="l rowheader" scope="row">Data Set Name</th>
<td class="l data">CLASSDAT.SQUIRREL</td>
<th class="l rowheader" scope="row">Observations</th>
<td class="l data">3023</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Member Type</th>
<td class="l data">DATA</td>
<th class="l rowheader" scope="row">Variables</th>
<td class="l data">36</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Engine</th>
<td class="l data">V9</td>
<th class="l rowheader" scope="row">Indexes</th>
<td class="l data">0</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Created</th>
<td class="l data">05/06/2021 12:25:59</td>
<th class="l rowheader" scope="row">Observation Length</th>
<td class="l data">656</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Last Modified</th>
<td class="l data">05/06/2021 12:25:59</td>
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
<a name="IDX8"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Contents: Engine/Host Information">
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
<td class="l data">31</td>
</tr>
<tr>
<th class="l rowheader" scope="row">First Data Page</th>
<td class="l data">1</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Max Obs per Page</th>
<td class="l data">99</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Obs in First Data Page</th>
<td class="l data">89</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Number of Data Set Repairs</th>
<td class="l data">0</td>
</tr>
<tr>
<th class="l rowheader" scope="row">Filename</th>
<td class="l data">/home/susan/Projects/Class/unl-stat850/stat850-textbook/sas/squirrel.sas7bdat</td>
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
<td class="l data">39064960</td>
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
<td class="l data">2MB</td>
</tr>
<tr>
<th class="l rowheader" scope="row">File Size (bytes)</th>
<td class="l data">2097152</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
<a name="IDX9"></a>
<div>
<div align="center">
<!--BEGINTABLE--><table class="table" style=" border-left-width: 0px; border-right-width: 0px;" cellspacing="0" cellpadding="7" rules="groups" frame="hsides" bordercolor="#C1C1C1" summary="Procedure Contents: Variables">
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
<th class="c b header" colspan="6" scope="colgroup">Alphabetic List of Variables and Attributes</th>
</tr>
<tr>
<th class="r b header" scope="col">#</th>
<th class="l b header" scope="col">Variable</th>
<th class="l b header" scope="col">Type</th>
<th class="r b header" scope="col">Len</th>
<th class="l b header" scope="col">Format</th>
<th class="l b header" scope="col">Informat</th>
</tr>
</thead>
<tbody>
<tr>
<th class="r rowheader" scope="row">14</th>
<td class="l data">Above_Ground_Sighter_Measurement</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">8</th>
<td class="l data">Age</td>
<td class="l data">Char</td>
<td class="r data">8</td>
<td class="l data">$8.</td>
<td class="l data">$8.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">27</th>
<td class="l data">Approaches</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">34</th>
<td class="l data">Borough_Boundaries</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">17</th>
<td class="l data">Chasing</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">35</th>
<td class="l data">City_Council_Districts</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">18</th>
<td class="l data">Climbing</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">12</th>
<td class="l data">Color_notes</td>
<td class="l data">Char</td>
<td class="r data">110</td>
<td class="l data">$110.</td>
<td class="l data">$110.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">11</th>
<td class="l data">Combination_of_Primary_and_Highl</td>
<td class="l data">Char</td>
<td class="r data">29</td>
<td class="l data">$29.</td>
<td class="l data">$29.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">33</th>
<td class="l data">Community_Districts</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">6</th>
<td class="l data">Date</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">19</th>
<td class="l data">Eating</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">20</th>
<td class="l data">Foraging</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">4</th>
<td class="l data">Hectare</td>
<td class="l data">Char</td>
<td class="r data">3</td>
<td class="l data">$3.</td>
<td class="l data">$3.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">7</th>
<td class="l data">Hectare_Squirrel_Number</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">10</th>
<td class="l data">Highlight_Fur_Color</td>
<td class="l data">Char</td>
<td class="r data">24</td>
<td class="l data">$24.</td>
<td class="l data">$24.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">28</th>
<td class="l data">Indifferent</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">22</th>
<td class="l data">Kuks</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">31</th>
<td class="l data">Lat_Long</td>
<td class="l data">Char</td>
<td class="r data">45</td>
<td class="l data">$45.</td>
<td class="l data">$45.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">13</th>
<td class="l data">Location</td>
<td class="l data">Char</td>
<td class="r data">12</td>
<td class="l data">$12.</td>
<td class="l data">$12.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">24</th>
<td class="l data">Moans</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">21</th>
<td class="l data">Other_Activities</td>
<td class="l data">Char</td>
<td class="r data">134</td>
<td class="l data">$134.</td>
<td class="l data">$134.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">30</th>
<td class="l data">Other_Interactions</td>
<td class="l data">Char</td>
<td class="r data">70</td>
<td class="l data">$70.</td>
<td class="l data">$70.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">36</th>
<td class="l data">Police_Precincts</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">9</th>
<td class="l data">Primary_Fur_Color</td>
<td class="l data">Char</td>
<td class="r data">8</td>
<td class="l data">$8.</td>
<td class="l data">$8.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">23</th>
<td class="l data">Quaas</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">16</th>
<td class="l data">Running</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">29</th>
<td class="l data">Runs_from</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">5</th>
<td class="l data">Shift</td>
<td class="l data">Char</td>
<td class="r data">2</td>
<td class="l data">$2.</td>
<td class="l data">$2.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">15</th>
<td class="l data">Specific_Location</td>
<td class="l data">Char</td>
<td class="r data">58</td>
<td class="l data">$58.</td>
<td class="l data">$58.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">25</th>
<td class="l data">Tail_flags</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">26</th>
<td class="l data">Tail_twitches</td>
<td class="l data">Char</td>
<td class="r data">5</td>
<td class="l data">$5.</td>
<td class="l data">$5.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">3</th>
<td class="l data">Unique_Squirrel_ID</td>
<td class="l data">Char</td>
<td class="r data">14</td>
<td class="l data">$14.</td>
<td class="l data">$14.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">1</th>
<td class="l data">X</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">2</th>
<td class="l data">Y</td>
<td class="l data">Num</td>
<td class="r data">8</td>
<td class="l data">BEST12.</td>
<td class="l data">BEST32.</td>
</tr>
<tr>
<th class="r rowheader" scope="row">32</th>
<td class="l data">Zip_Codes</td>
<td class="l data">Char</td>
<td class="r data">1</td>
<td class="l data">$1.</td>
<td class="l data">$1.</td>
</tr>
</tbody>
</table>
<!--ENDTABLE--></div>
</div>
<br>
</div>
</details>
</details>

<details><summary>Task 2: Clean up the Combination of primary and highlight fur color column</summary>
A. Get rid of leading and trailing `+` characters
B. Where two highlight colors exist, add the primary color to both of them (so `Gray+Cinnamon, White` becomes `Gray+Cinnamon, Gray+White`)

You can do this by working with the original values or the combination values; whatever is easiest. 

<details><summary>R solution</summary>

```r
squirrels_colorfix <- squirrels %>%
  # Make it easier to join things back together...
  mutate(id = 1:n()) %>% 
  # keep the stuff we need for this
  select(id, 
         primary = `Primary Fur Color`, 
         highlight = `Highlight Fur Color`, 
         combo = `Combination of Primary and Highlight Color`) %>%
  
  # Remove all single character strings. 
  # ^ means "front of string", $ means "end of string", and . is a wildcard
  mutate(combo = str_remove(combo, "^.$")) %>%
  
  # Remove trailing + signs
  mutate(combo = str_remove(combo, "\\+$")) %>%
  
  # This allows only two highlight colors
  mutate(combo = str_replace(
    combo, 
    "^(Black|Cinnamon|Gray)\\+(Black|Cinnamon|Gray|White), (Black|Cinnamon|Gray|White)$", 
    "\\1+\\2, \\1+\\3")) %>%
  
  # This allows three highlight colors
  mutate(combo = str_replace(
    combo, 
    "^(Black|Cinnamon|Gray)\\+(Black|Cinnamon|Gray|White), (Black|Cinnamon|Gray|White), (Black|Cinnamon|Gray|White)$", 
    "\\1+\\2, \\1+\\3, \\1+\\4"))

table(squirrels_colorfix$combo)

                                                                      Black 
                                   55                                    74 
                       Black+Cinnamon           Black+Cinnamon, Black+White 
                                   15                                     3 
                           Black+Gray               Black+Gray, Black+White 
                                    8                                     1 
                          Black+White                              Cinnamon 
                                    2                                    62 
                       Cinnamon+Black        Cinnamon+Black, Cinnamon+White 
                                   10                                     3 
                        Cinnamon+Gray         Cinnamon+Gray, Cinnamon+Black 
                                  162                                     3 
        Cinnamon+Gray, Cinnamon+White                        Cinnamon+White 
                                   58                                    94 
                                 Gray                            Gray+Black 
                                  895                                    24 
            Gray+Black, Gray+Cinnamon Gray+Black, Gray+Cinnamon, Gray+White 
                                    9                                    32 
               Gray+Black, Gray+White                         Gray+Cinnamon 
                                    7                                   752 
            Gray+Cinnamon, Gray+White                            Gray+White 
                                  265                                   489 
```
</details>

<details><summary>SAS solution</summary>

```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          DATA squirrelcolor;
9          SET classdat.cleanSquirrel;
NOTE: Data file CLASSDAT.CLEANSQUIRREL.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
10         
11         LENGTH orig  $50 new_text1 $ 50 new_text2 $ 50 new_text3 $ 50;
12         orig = Combination_of_Primary_and_Highl;
13         
14         IF _N_ = 1 THEN DO;
15           REthree =
15       ! PRXPARSE("s/^(Gray|Cinnamon|Black)\+(Black|Cinnamon|Gray|White),
15       !  (Black|Cinnamon|Gray|White),
15       ! (Black|Cinnamon|Gray|White)$/$1+$2, $1+$3, $1+$4/");
16           REtwo =
16       ! PRXPARSE("s/^(Gray|Cinnamon|Black)\+(Black|Cinnamon|Gray|White),
16       !  (Black|Cinnamon|Gray|White)$/$1+$2, $1+$3/");
17           REplus = PRXPARSE("s/[^A-z]$//");
18         END;
19         RETAIN REplus REtwo REthree;
20         
21         CALL PRXCHANGE(REplus, -1, trim(orig), new_text1);
22         CALL PRXCHANGE(REthree, -1, trim(new_text1), new_text2);
23         CALL PRXCHANGE(REtwo, -1, trim(new_text2), new_text3);
24         
25         keep orig new_text1 new_text2 new_text3;
26         RUN;

NOTE: The data set WORK.SQUIRRELCOLOR has 0 observations and 4 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

27         
28         /* print all combinations that occur w/ new value */
29         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
30         SELECT DISTINCT orig, new_text3 FROM squirrelcolor;
NOTE: Statement not executed due to NOEXEC option.
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 9.
```
</details>
</details>

### Joining and Splitting Variables

There's another string-related task that is fairly commonly encountered: separating variables into two different columns (as in Table 3 above).
<div class="figure">
<img src="image/tidyr_separate.png" alt="A visual representation of what separating variables means for data set operations." width="50%" />
<p class="caption">(\#fig:tidy-separate-pic)A visual representation of what separating variables means for data set operations.</p>
</div>
<details><summary>Separating Variables</summary>
We can use `str_extract()` if we want, but it's actually faster to use `separate()`, which is part of the `tidyr` package. There is also `extract()`, which is another `tidyr` function that uses regular expressions and capture groups to split variables up. 


```r
table3 %>%
  separate(col = rate, into = c("cases", "population"), sep = "/", remove = F)
# A tibble: 6 x 5
  country      year rate              cases  population
  <chr>       <int> <chr>             <chr>  <chr>     
1 Afghanistan  1999 745/19987071      745    19987071  
2 Afghanistan  2000 2666/20595360     2666   20595360  
3 Brazil       1999 37737/172006362   37737  172006362 
4 Brazil       2000 80488/174504898   80488  174504898 
5 China        1999 212258/1272915272 212258 1272915272
6 China        2000 213766/1280428583 213766 1280428583
```

I've left the rate column in the original data frame just to make it easy to compare and verify that yes, it worked. 

`separate()` will also take a full on regular expression if you want to capture only parts of a string to put into new columns. 

[The `scan()` function in SAS can be used similarly](https://communities.sas.com/t5/SAS-Procedures/Splitting-a-delimited-column-into-multiple-columns/td-p/351130), though it doesn't have quite the simplicity and convenience of `separate`.

```sashtml
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      


6          data table3;
7          length country $12 rate $20;
8          input country $ year rate $;
9          datalines;

NOTE: The data set WORK.TABLE3 has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

16         ;
17         data table3split;
18         set table3;
19         length var1-var2 $10.;
20         array var(2) $;
NOTE: The array var has the same name as a SAS-supplied or user-defined 
      function.  Parentheses following this name are treated as array 
      references and not function references.
21         do i = 1 to dim(var);
22           var[i]=scan(rate, i, '/', 'M');
23         end;
24         count = var1;
25         population = var2;
26         run;

NOTE: The data set WORK.TABLE3SPLIT has 0 observations and 8 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 9.
```
</details>

And, of course, there is a complementary operation, which is when it's necessary to join two columns to get a useable data value. 
<div class="figure">
<img src="image/tidyr_unite.png" alt="A visual representation of what uniting variables means for data set operations." width="50%" />
<p class="caption">(\#fig:tidyr-unite-pic)A visual representation of what uniting variables means for data set operations.</p>
</div>

<details><summary>Joining Variables</summary>
`separate()` has a complement, `unite()`, which is useful for handling situations like in table5:

```r
table5 %>%
  unite(col = "year", century:year, sep = '') %>%
  separate(col = rate, into = c("cases", "population"), sep = "/")
# A tibble: 6 x 4
  country     year  cases  population
  <chr>       <chr> <chr>  <chr>     
1 Afghanistan 1999  745    19987071  
2 Afghanistan 2000  2666   20595360  
3 Brazil      1999  37737  172006362 
4 Brazil      2000  80488  174504898 
5 China       1999  212258 1272915272
6 China       2000  213766 1280428583
```

Note that separate and unite both work with character variables - it's not necessarily true that you'll always be working with character formats when you need to do these operations. For instance, it's relatively common to need to separate dates into year, month, and day as separate columns (or to join them together). 

Of course, it's much easier just to do a similar two-step operation (we have to convert to numeric variables to do math)

```r
table5 %>%
  mutate(year = as.numeric(century)*100 + as.numeric(year)) %>% 
  select(-century)
# A tibble: 6 x 3
  country      year rate             
  <chr>       <dbl> <chr>            
1 Afghanistan  1999 745/19987071     
2 Afghanistan  2000 2666/20595360    
3 Brazil       1999 37737/172006362  
4 Brazil       2000 80488/174504898  
5 China        1999 212258/1272915272
6 China        2000 213766/1280428583
```

(Handy shortcut functions in `dplyr` don't completely remove the need to think).

Similarly, it is possible to do this operation in SAS as well (by string concatenation or using the numeric approach), as shown below:


```sashtml
6          /* read in the data */
7          DATA table5;
8          LENGTH country $12 century year rate $20;
9          INPUT country $ century year rate $;
10         DATALINES;

NOTE: The data set WORK.TABLE5 has 0 observations and 4 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

17         ;
18         
19         /* Format the data */
20         DATA table5split;
21           SET table5;
22           LENGTH v1-v2 $10. yyc $3. centc $3. yyyyc $4.;
23           ARRAY v(2) $;
24           DO i = 1 TO dim(v);
25             v[i]=scan(rate, i, '/', 'M');
26           END;
27           count = v1;
28           population = v2;
29           /* Numeric version */
30           year = century*100 + year;
31           /* Character version */
32           yyc = PUT(year, 2.); /* convert to character */
33           centc = PUT(century, 2.); /* convert to character */
34           yyyyc = CATT('', centc, yearc); /* catt is truncate, then
34       ! concatenate */
35         RUN;

NOTE: Character values have been converted to numeric 
      values at the places given by: (Line):(Column).
      30:10   30:24   
NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      30:22   
NOTE: The data set WORK.TABLE5SPLIT has 0 observations and 13 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

36         
37         /* Print the data */
38         PROC PRINT DATA=table5split;
39           VAR country year yyyyc count population rate centc century yyc
39       ! ;
40         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 9.
```
</details>


## Pivot operations

It's fairly common for data to come in forms which are convenient for either human viewing or data entry. Unfortunately, these forms aren't necessarily the most friendly for analysis. 

![](https://raw.githubusercontent.com/kelseygonzalez/tidyexplain/master/images/static/png/original-dfs-tidy.png)

The two operations we'll learn here are wide -> long and long -> wide. 

![](https://raw.githubusercontent.com/kelseygonzalez/tidyexplain/wider_longer/images/tidyr-pivot_wider_longer.gif)

This animation uses the R functions pivot_wider() and pivot_longer() [Animation source](https://github.com/kelseygonzalez/tidyexplain/tree/wider_longer), but the concept is the same in both R and SAS. 

### Longer

In many cases, the data come in what we might call "wide" form - some of the column names are not names of variables, but instead, are themselves values of another variable. 

Tables 4a and 4b are good examples of data which is in "wide" form and should be in long(er) form: the years, which are variables, are column names, and the values are cases and population respectively.  

```r
table4a
# A tibble: 3 x 3
  country     `1999` `2000`
* <chr>        <int>  <int>
1 Afghanistan    745   2666
2 Brazil       37737  80488
3 China       212258 213766
table4b
# A tibble: 3 x 3
  country         `1999`     `2000`
* <chr>            <int>      <int>
1 Afghanistan   19987071   20595360
2 Brazil       172006362  174504898
3 China       1272915272 1280428583
```

The solution to this is to rearrange the data into "long form": to take the columns which contain values and "stack" them, adding a variable to indicate which column each value came from. To do this, we have to duplicate the values in any column which isn't being stacked (e.g. country, in both the example above and the image below). 

<div class="figure">
<img src="image/tidyr_pivot_longer.png" alt="A visual representation of what the pivot_longer operation looks like in practice." width="50%" />
<p class="caption">(\#fig:tidyr-pivot-longer-pic)A visual representation of what the pivot_longer operation looks like in practice.</p>
</div>

Once our data are in long form, we can (if necessary) separate values that once served as column labels into actual variables, and we'll have tidy(er) data. 

<details><summary>In R, wide-to-long conversions are performed using `pivot_longer()`</summary>

```r
tba <- table4a %>% 
  pivot_longer(-country, names_to = "year", values_to = "cases")
tbb <- table4b %>% 
  pivot_longer(-country, names_to = "year", values_to = "population")

# To get the tidy data, we join the two together (see Table joins below)
left_join(tba, tbb, by = c("country", "year")) %>%
  # make year numeric b/c it's dumb not to
  mutate(year = as.numeric(year))
# A tibble: 6 x 4
  country      year  cases population
  <chr>       <dbl>  <int>      <int>
1 Afghanistan  1999    745   19987071
2 Afghanistan  2000   2666   20595360
3 Brazil       1999  37737  172006362
4 Brazil       2000  80488  174504898
5 China        1999 212258 1272915272
6 China        2000 213766 1280428583
```

The columns are moved to a variable with the name passed to the argument "names_to" (hopefully, that is easy to remember), and the values are moved to a variable with the name passed to the argument "values_to" (again, hopefully easy to remember). 

We identify ID variables (variables which we don't want to pivot) by not including them in the pivot statement. We can do this in one of two ways:

- select only variables we want to pivot: `pivot_longer(table4a, cols = `1999`:`2000`, names_to = "year", values_to = "cases")`
- select variables we don't want to pivot, using `-` to remove them. (see above, where `-country` excludes country from the pivot operation)

Which option is easier depends how many things you're pivoting (and how the columns are structured). 

If we wanted to avoid the table join, we could do this process another way: first, we would add a column to each tibble called id with values "cases" and "population" respectively. Then, we could bind the two tables together by row (so stack them on top of each other). We could then do a wide-to-long pivot, followed by a long-to-wide pivot to get our data into tidy form. 


```r
# Create ID columns
table4a.x <- table4a %>% mutate(id = "cases")
table4b.x <- table4b %>% mutate(id = "population")
# Create one table
table4 <- bind_rows(table4a.x, table4b.x)

table4_long <- table4 %>%
  # rearrange columns
  select(country, id, `1999`, `2000`) %>%
  # Don't pivot country or id
  pivot_longer(-c(country:id), names_to = "year", values_to = "count")

# Intermediate fully-long form
table4_long
# A tibble: 12 x 4
   country     id         year       count
   <chr>       <chr>      <chr>      <int>
 1 Afghanistan cases      1999         745
 2 Afghanistan cases      2000        2666
 3 Brazil      cases      1999       37737
 4 Brazil      cases      2000       80488
 5 China       cases      1999      212258
 6 China       cases      2000      213766
 7 Afghanistan population 1999    19987071
 8 Afghanistan population 2000    20595360
 9 Brazil      population 1999   172006362
10 Brazil      population 2000   174504898
11 China       population 1999  1272915272
12 China       population 2000  1280428583

# make wider, with case and population columns
table4_tidy <- table4_long %>%
  pivot_wider(names_from = id, values_from = count)

table4_tidy
# A tibble: 6 x 4
  country     year   cases population
  <chr>       <chr>  <int>      <int>
1 Afghanistan 1999     745   19987071
2 Afghanistan 2000    2666   20595360
3 Brazil      1999   37737  172006362
4 Brazil      2000   80488  174504898
5 China       1999  212258 1272915272
6 China       2000  213766 1280428583
```
</details>

::: note
SAS will let you do a single transpose operation, where tidyr requires two separate pivots -- this is because tidyr is trying to make the steps readable, even though it means writing more code. 
:::

<details><summary>In SAS, we use PROC TRANSPOSE to perform wide-to-long pivot operations</summary>

[[Friendly guide to PROC TRANSPOSE](https://libguides.library.kent.edu/SAS/TransposeData)]{.learn-more}


```sashtml
6          DATA table4a;
7          input country $12. _1999 _2000;
8          datalines;

NOTE: The data set WORK.TABLE4A has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

12         ;
13         
14         PROC TRANSPOSE DATA=table4a out=table4atmp
15           (rename=(COL1 = cases)) /* rename output variable
15       ! ('values_to') */
16           NAME = year /* where column names go ('names_to') */
17         ;
18         BY country;  /* The combination of BY variables defines a row */
19         VAR _1999 _2000; /* Specify variables to pivot */
20         RUN;

WARNING: The variable COL1 in the DROP, KEEP, or RENAME list has never 
         been referenced.
NOTE: There were 0 observations read from the data set WORK.TABLE4A.
NOTE: The data set WORK.TABLE4ATMP has 2 observations and 2 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

21         
22         DATA table4b;
23         input country $12. _1999 _2000;
24         datalines;

NOTE: The data set WORK.TABLE4B has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

28         ;
29         
30         PROC TRANSPOSE DATA=table4b out=table4btmp
31           (rename=(COL1 = population)) /* rename output variable
31       ! ('values_to') */
32           NAME = year /* where the column names go ('names_to') */
33         ;
34         BY country;  /* The combination of BY variables defines a row */
35         VAR _1999 _2000; /* Specify variables to pivot */
36         RUN;

WARNING: The variable COL1 in the DROP, KEEP, or RENAME list has never 
         been referenced.
NOTE: There were 0 observations read from the data set WORK.TABLE4B.
NOTE: The data set WORK.TABLE4BTMP has 2 observations and 2 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

37         
38         DATA table4clean;
39         /* merge the two tables together */
40         /* (country and year selected automatically as merge vars) */
41         MERGE table4atmp table4btmp;
42         /* Remove the first character of year, which is _ */
43         /* Then convert to a numeric variable */
44         year = input(SUBSTR(year, 2, 5), 4.);
45         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      44:8   
NOTE: The data set WORK.TABLE4CLEAN has 0 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

46         
47         PROC PRINT DATA=table4clean;
48         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on page 9.
```
In the above code, we let SAS name our output variable COL1, and then renamed it at the end by modifying the output statement. Another option would be to create an ID variable when inputting each data set, and use the ID statement to indicate that variable. 



```sashtml
6          DATA table4a;
7          input country $12. _1999 _2000;
8          id = "cases";
9          datalines;

NOTE: The data set WORK.TABLE4A has 0 observations and 4 variables.
WARNING: Data set WORK.TABLE4A was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

13         ;
14         
15         PROC TRANSPOSE DATA=table4a out=table4atmp
16           NAME = year /* where column names go ('names_to') */
17         ;
18         BY country;  /* The combination of BY variables defines a row */
19         VAR _1999 _2000; /* Specify variables to pivot */
20         ID id; /* This variable holds the output variable name
20       ! ('values_to') */
ERROR: Variable ID not found.
21         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.TABLE4ATMP may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
WARNING: Data set WORK.TABLE4ATMP was not replaced because this step was 
         stopped.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
22         


23         DATA table4b;
24         input country $12. _1999 _2000;
25         id = "population";
26         datalines;

NOTE: The data set WORK.TABLE4B has 0 observations and 4 variables.
WARNING: Data set WORK.TABLE4B was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

30         ;
31         
32         PROC TRANSPOSE DATA=table4b out=table4btmp
33           NAME = year /* where the column names go ('names_to') */
34         ;
35         BY country;  /* The combination of BY variables defines a row */
36         VAR _1999 _2000; /* Specify variables to pivot */
37         ID id; /* This variable holds the output variable name
37       ! ('values_to') */
ERROR: Variable ID not found.
38         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.TABLE4BTMP may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
WARNING: Data set WORK.TABLE4BTMP was not replaced because this step was 
         stopped.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
39         


40         DATA table4clean;
41         /* merge the two tables together */
42         /* (country and year selected automatically as merge vars) */
43         MERGE table4atmp table4btmp;
44         /* Remove the first character of year, which is _ */
45         /* Then convert to a numeric variable */
46         year = input(SUBSTR(year, 2, 5), 4.);
47         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      46:8   
NOTE: The data set WORK.TABLE4CLEAN has 0 observations and 2 variables.
WARNING: Data set WORK.TABLE4CLEAN was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

48         
49         PROC PRINT DATA=table4clean;
50         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11.
```

This seems a bit odd, as we're defining constant variables, but it works -- and provides some insight into how the reverse operation (long to wide) might work (e.g. nonconstant variables). 
Imagine instead of transposing each dataset and then merging them, we just stack the two wide-format datasets on top of each other. Then we can do the same transpose operation, but we'll end up with two columns: cases, and population. 


```sashtml
6          DATA table4a;
7          input country $12. _1999 _2000;
8          id = "cases";
9          datalines;

NOTE: The data set WORK.TABLE4A has 0 observations and 4 variables.
WARNING: Data set WORK.TABLE4A was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

13         ;
14         
15         DATA table4b;
16         input country $12. _1999 _2000;
17         id = "population";
18         datalines;

NOTE: The data set WORK.TABLE4B has 0 observations and 4 variables.
WARNING: Data set WORK.TABLE4B was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

22         ;
23         
24         DATA table4;
25         /* stack the two datasets on top of each other */
26           SET table4b table4a;
27         /* sort by country */
28           BY country;
29         RUN;

NOTE: The data set WORK.TABLE4 has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

30         
31         PROC TRANSPOSE DATA=table4 out=table4tmp NAME = year;
32         BY country;
33         VAR _1999 _2000;
34         ID id; /* This variable holds the output variable names
34       ! ('values_to') */
ERROR: Variable ID not found.
35         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.TABLE4TMP may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
36         


37         DATA table4tmp;
38           SET table4tmp;
39         /* Remove the first character of year, which is _ */
40         /* Then convert to a numeric variable */
41         year = input(SUBSTR(year, 2, 5), 4.);
42         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      41:21   
NOTE: The data set WORK.TABLE4TMP has 0 observations and 1 variables.
WARNING: Data set WORK.TABLE4TMP was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

43         
44         PROC PRINT DATA=table4tmp;
45         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12.
```
</details>

It's not too complicated -- and it definitely beats doing that operation by hand, even for short, simple tables. You can imagine how messy the cut/copy/paste job would be in Excel. 

It takes some getting used to, but once you get a feel for how to do these transpose operations, you'll be able to handle messy data reproducibly - instead of describing how you did XYZ operations in Excel, you can provide a script that will take the original data as input and spit out clean, analysis-ready data as output. 

::: warning
Because wide-to-long transformations end up combining values from several columns into a single column, you can run into issues with type conversions that happen implicitly. If you try to `pivot_longer()` using a character column mixed in with numeric columns, your "value" column will be converted to a character automatically. 
:::

Now, let's look at a "real data" example using HIV case data from the World Health Organization.  ([download page here](https://apps.who.int/gho/data/view.main.22500A?lang=en)).
<details><summary>WHO HIV data set up</summary>

```r
url <- "https://apps.who.int/gho/athena/data/xmart.csv?target=GHO/HIV_0000000026,SDGHIV&profile=crosstable&filter=COUNTRY:*;REGION:*;AGEGROUP:-&x-sideaxis=COUNTRY&x-topaxis=GHO;YEAR;SEX&x-collapse=true"

# create colnames in shorter form
hiv <- read_csv(url, na = "No data", ) %>%
  select(-2) # get rid of only column that has raw totals

── Column specification ────────────────────────────────────────────────────────
cols(
  .default = col_character()
)
ℹ Use `spec()` for the full column specifications.

# work with the names to make them shorter and more readable
# otherwise, they're too long for SAS
newnames <- names(hiv)  %>%
  str_remove("New HIV infections \\(per 1000 uninfected population\\); ") %>%
  str_replace_all("(\\d{4}); (Male|Female|Both)( sexes)?", "Rate_\\1_\\2")
hiv <- set_names(hiv, newnames) %>%
  # transliterate - get rid of non-ascii characters, replace w/ closest equiv
  mutate(Country = iconv(Country, to="ASCII//TRANSLIT"))

write_csv(hiv, path = "data/who_hiv.csv", na = '.') # make it easy for SAS
Warning: The `path` argument of `write_csv()` is deprecated as of readr 1.4.0.
Please use the `file` argument instead.
```
Since I've cheated a bit to make this easier to read in using SAS... hopefully that will be uneventful. 

```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          filename fileloc 'data/who_hiv.csv';
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
NOTE: The SAS System stopped processing this step because of errors.
9          PROC IMPORT  datafile = fileloc out=classdat.hiv REPLACE
10         DBMS = csv; /* comma delimited file */
11         GUESSINGROWS=500;
12         GETNAMES = YES;
13         RUN;
14         


ERROR: Errors printed on pages 9,11,12,13.
```
</details>

<details><summary>Original Data Structure (WHO HIV data)</summary>

```r
hiv %>%
  # Only look at 1st 6 cols, because there are too many
  select(1:6) %>%
  head()
# A tibble: 6 x 6
  Country  `Number of new H… `Number of new H… `Number of new … `Number of new …
  <chr>    <chr>             <chr>             <chr>            <chr>           
1 Afghani… 1400 [&lt;500–51… 1300 [&lt;500–48… 1200 [&lt;500–4… 1100 [&lt;500–3…
2 Albania  &lt;100 [&lt;100… &lt;100 [&lt;100… &lt;200 [&lt;10… &lt;200 [&lt;10…
3 Algeria  2000 [&lt;500–36… 1900 [510–3300]   1900 [610–3000]  1800 [780–2800] 
4 Angola   27 000 [20 000–3… 27 000 [21 000–3… 26 000 [20 000–… 26 000 [20 000–…
5 Argenti… 5700 [4100–8100]  6100 [4400–8200]  5900 [4400–8200] 6100 [4700–8300]
6 Armenia  &lt;200 [&lt;200… &lt;200 [&lt;200… &lt;200 [&lt;20… &lt;200 [&lt;20…
# … with 1 more variable: Number of new HIV infections; 2014; <chr>
```
Here, the column names (except for the first column) contain information about both group (Male, Female, total) and year. If we want to plot values over time, we're not going to have much fun. 
</details>

Thinking through the logical steps before writing the code can be helpful - even sketching out what you expect the data to (roughly) look like at each stage. 

Current data observations: 

- Our column names contain the year and the group (Both, Male, Female)
- Our values contain estimates with a confidence interval - so est (LB, UB)
    - Some intervals have `&lt;`, which is HTML code for `<`. We'll need to get rid of those.


Our final dataset should look like this:

Country | group | year | est | lb | ub
------- | ----- | ---- | --- | -- | --
narnia  | both  | 2020 | 0.3 | 0.2 | 0.4

(give or take column order, capitalization, and/or reality)

From this, our steps are:

1. Transpose the data - all columns except Country (our BY variable)
2. Separate the (what was column names) variable into group and year variables
    - convert year to numeric
3. Separate the (what was column values) variable into EST, LB, and UB columns
    - Remove `&lt;` from the variable so that it's readable as numeric
    - Remove `[`, `]` and `-` from the variable so that the values are separated by spaces
    - Read each value into a separate column that's  numeric
    - Rename the columns
4. Clean up any extra variables hanging around.

Now that we have a plan, lets execute that plan


<details><summary>Wide-to-long transformation in R  (WHO HIV data)</summary>

```r
hiv_tidier <- hiv %>%
  pivot_longer(-Country, names_to = "key", values_to = "rate")
hiv_tidier
# A tibble: 18,530 x 3
   Country     key                                 rate               
   <chr>       <chr>                               <chr>              
 1 Afghanistan Number of new HIV infections; 2018; 1400 [&lt;500–5100]
 2 Afghanistan Number of new HIV infections; 2017; 1300 [&lt;500–4800]
 3 Afghanistan Number of new HIV infections; 2016; 1200 [&lt;500–4200]
 4 Afghanistan Number of new HIV infections; 2015; 1100 [&lt;500–3700]
 5 Afghanistan Number of new HIV infections; 2014; 1000 [&lt;500–3200]
 6 Afghanistan Number of new HIV infections; 2013; 920 [&lt;500–2700] 
 7 Afghanistan Number of new HIV infections; 2012; 840 [&lt;500–2300] 
 8 Afghanistan Number of new HIV infections; 2011; 760 [&lt;500–2000] 
 9 Afghanistan Number of new HIV infections; 2010; 700 [&lt;500–1800] 
10 Afghanistan Number of new HIV infections; 2009; 640 [&lt;500–1600] 
# … with 18,520 more rows
```
From this point, it's pretty easy to use things we've used in the past (regular expressions, separate, extract)


```r
 hiv_tidy <- hiv_tidier %>%
  # Split the key into Rate (don't keep), year, and group (F, M, Both)
  separate(key, into = c(NA, "year", "group"), sep = "_", convert = T) %>%
  # Fix the HTML sign for less than - we could remove it as well
  mutate(rate = str_replace_all(rate, "&lt;", "<")) %>%
  # Split the rate into estimate, lower bound, and upper bound
  extract(rate, into = c("est", "lb", "ub"), regex = "([\\d\\.]{1,}) .([<\\d\\.]{1,}) - ([<\\d\\.]{1,}).", remove = T)
Warning: Expected 3 pieces. Missing pieces filled with `NA` in 3230 rows [1, 2,
3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 110, ...].
hiv_tidy
# A tibble: 18,530 x 6
   Country      year group est   lb    ub   
   <chr>       <int> <chr> <chr> <chr> <chr>
 1 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 2 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 3 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 4 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 5 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 6 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 7 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 8 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 9 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
10 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
# … with 18,520 more rows
```
</details>

<details><summary>Wide-to-long transformation in SAS (WHO HIV data) </summary>
I've thoroughly commented the code below to hopefully make the logical steps clear. 


```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          


8          PROC TRANSPOSE DATA=classdat.hiv OUT = classdat.hivtidy
NOTE: Data file CLASSDAT.HIV.DATA is in a format that is native to another 
      host, or the file encoding does not match the session encoding. 
      Cross Environment Data Access will be used, which might require 
      additional CPU resources and might reduce performance.
9          (rename=(col1=rate)) /* "values_to" in tidyr speak */
10         NAME = key;          /* "names_to" in tidyr speak */
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
11         /* specify notsorted unless you know your data are sorted */
12           BY Country NOTSORTED;
13         /* variables to transpose - just list start and end, with -- in
13       ! between  */
14           VAR Rate_2018_Both--Rate_1990_Female;
15         RUN;

WARNING: The variable col1 in the DROP, KEEP, or RENAME list has never 
         been referenced.
NOTE: There were 0 observations read from the data set CLASSDAT.HIV.
NOTE: The data set CLASSDAT.HIVTIDY has 87 observations and 2 variables.
WARNING: Data set CLASSDAT.HIVTIDY was not replaced because of NOREPLACE 
         option.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

16         
17         title 'Intermediate result';
18         PROC PRINT DATA=classdat.hivtidy(obs=5); RUN;
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

19         
20         /* Data step to clean up */
21         DATA classdat.hivtidy;
22           SET classdat.hivtidy ;
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
23         /* Create group and year variables from key */
24           group = scan(key,3,"_");
25           year = input(scan(key, 2, "_"), 4.);
26         
27         /* just get rid of the less than sign */
28           rate = PRXCHANGE("s/&lt;//", -1, rate);
WARNING: Apparent symbolic reference LT not resolved.
29           rate = PRXCHANGE("s/[\[\]-]//", -1, rate);
30         
31         /* Create 3 columns for the 3 values - est, lb, ub */
32           length v1-v3 4.2; /* define format */
33           array v(3) $; /* create a 3 column array to store values in */
34           do i = 1 to dim(v);
35             v[i]=scan(rate, i, ' '); /* get values from each row of rate
35       !  */
36           end;
37         
38           rename v1 = est v2 = lb v3 = ub; /* rename things to be pretty
38       !  */
39         
40         /* get rid of extra vars */
41           drop _name_ i key rate;
42         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      24:16   25:21   28:36   29:39   35:15   
NOTE: Character values have been converted to numeric 
      values at the places given by: (Line):(Column).
      28:10   29:10   35:5    
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
WARNING: Variable v1 cannot be renamed to est because est already exists.
WARNING: Variable v2 cannot be renamed to lb because lb already exists.
WARNING: Variable v3 cannot be renamed to ub because ub already exists.
WARNING: The variable _name_ in the DROP, KEEP, or RENAME list has never 
         been referenced.
NOTE: The data set CLASSDAT.HIVTIDY has 0 observations and 9 variables.
WARNING: Data set CLASSDAT.HIVTIDY was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

43         
44         title 'Final result';
45         PROC PRINT DATA=classdat.hivtidy(obs=5); RUN;
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

46         

ERROR: Errors printed on pages 9,11,12,13.
```

</details>

#### Try it out {- .tryitout}
In the next section, we'll be using the WHO surveillance of disease incidence data ([link](https://www.who.int/immunization/monitoring_surveillance/data/en/) - 3.1, [Excel link](http://www.who.int/entity/immunization/monitoring_surveillance/data/incidence_series.xls))

It will require some preprocessing before it's suitable for a demonstration. I'll do some of it, but in this section, you're going to do the rest :)


```r
library(readxl)
library(purrr) # This uses the map() function as a replacement for for loops. 
# It's pretty sweet

sheets <- excel_sheets("data/incidence_series.xls")
sheets <- sheets[-c(1, length(sheets))] # get rid of 1st and last sheet name

# This command says "for each sheet, read in the excel file with that sheet name"
# map_df means paste them all together into a single data frame
disease_incidence <- map_df(sheets, ~read_xls(path ="data/incidence_series.xls", sheet = .))

# Alternately, we could write a loop:
disease_incidence2 <- tibble() # Blank data frame
for(i in 1:length(sheets)) {
  disease_incidence2 <- bind_rows(
    disease_incidence2, 
    read_xls(path = "data/incidence_series.xls", sheet = sheets[i])
  )
}

# export for SAS (and R, if you want)
write_csv(disease_incidence, path = "data/who_disease_incidence.csv", na = ".")
```
Download the exported data [here](data/who_disease_incidence.csv) and import it into SAS and R. Transform it into long format, so that there is a year column. You should end up with a table that has dimensions of approximately 6 columns and 83,000 rows (or something close to that). 

Can you make a line plot of cases of measles in Bangladesh over time?

<details><summary>R solution</summary>

```r
who_disease <- read_csv("data/who_disease_incidence.csv", na = ".")

── Column specification ────────────────────────────────────────────────────────
cols(
  .default = col_double(),
  WHO_REGION = col_character(),
  ISO_code = col_character(),
  Cname = col_character(),
  Disease = col_character()
)
ℹ Use `spec()` for the full column specifications.

who_disease_long <- who_disease %>%
  pivot_longer(matches("\\d{4}"), names_to = "year", values_to = "cases") %>%
  rename(Country = Cname) %>%
  mutate(Disease = str_replace(Disease, "CRS", "Congenital Rubella"),
         year = as.numeric(year))

filter(who_disease_long, Country == "Bangladesh", Disease == "measles") %>%
  ggplot(aes(x = year, y = cases)) + geom_line()
```

<img src="image/tryitout-surveillance-cleaning-1.png" width="2100" />
</details>

<details><summary>SAS solution</summary>


```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          filename fileloc 'data/who_disease_incidence.csv';
NOTE: PROCEDURE IMPORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
NOTE: The SAS System stopped processing this step because of errors.
9          PROC IMPORT  datafile = fileloc out=classdat.who_disease REPLACE
10         DBMS = csv; /* comma delimited file */
11         GUESSINGROWS=500;
12         GETNAMES = YES;
13         RUN;
14         
15         /* Sort your data by the variables you want as the ID variables
15       ! */


16         PROC SORT DATA=classdat.who_disease OUT=who_dis_tmp;
NOTE: Data file CLASSDAT.WHO_DISEASE.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
17         BY Disease Cname;
18         RUN;

NOTE: The data set WORK.WHO_DIS_TMP has 0 observations and 0 variables.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

19         
20         PROC TRANSPOSE DATA = who_dis_tmp OUT = classdat.disease_long;
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
21         BY Disease Cname; /* Same variable order as used to sort */
ERROR: Variable DISEASE not found.
ERROR: Variable CNAME not found.
22         VAR _2018--_1980; /* variables to transpose */
ERROR: Variable _2018 not found.
23         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set CLASSDAT.DISEASE_LONG may be incomplete.  When this 
         step was stopped there were 0 observations and 0 variables.
WARNING: Data set CLASSDAT.DISEASE_LONG was not replaced because this step 
         was stopped.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
24         
25         title 'Intermediate result 1';


26         PROC PRINT DATA=classdat.disease_long(obs=5); RUN;
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

27         
28         /* Data step to clean up */
29         DATA classdat.disease_long;
30         SET classdat.disease_long (rename=col1=cases);
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
ERROR: Variable col1 is not on file CLASSDAT.DISEASE_LONG.
ERROR: Invalid DROP, KEEP, or RENAME option on file CLASSDAT.DISEASE_LONG.
31         year = input(scan(_name_,1,"_"), 4.);
32         drop _name_;
33         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      31:19   
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set CLASSDAT.DISEASE_LONG may be incomplete.  When this 
         step was stopped there were 0 observations and 1 variables.
WARNING: Data set CLASSDAT.DISEASE_LONG was not replaced because this step 
         was stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

34         
35         title 'Final result';
36         PROC PRINT DATA=classdat.disease_long(obs=5); RUN;
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

37         
38         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
39         CREATE TABLE bangladesh AS
40         SELECT * FROM classdat.disease_long WHERE (Cname = "Bangladesh")
40       !  & (Disease = "measles");
NOTE: Statement not executed due to NOEXEC option.
41         
42         title 'Measles in Bangladesh';
43         ODS GRAPHICS ON;
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


44         PROC SGPLOT DATA=bangladesh;
ERROR: File WORK.BANGLADESH.DATA does not exist.
45         SERIES X = year Y = cases;
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
46         RUN;

NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
47         ODS GRAPHICS OFF;

ERROR: Errors printed on pages 9,11,12,13,15.
```
</details>

### Wider

While it's very common to need to transform data into a longer format, it's not that uncommon to need to do the reverse operation. When an observation is scattered across multiple rows, your data is too long and needs to be made wider again.  

Table 2 is an example of a table that is in long format but needs to be converted to a wider layout to be "tidy" - there are separate rows for cases and population, which means that a single observation (one year, one country) has two rows. 


<div class="figure">
<img src="image/tidyr_pivot_wider.png" alt="A visual representation of what the pivot_wider operation looks like in practice." width="50%" />
<p class="caption">(\#fig:pivot-wider-pic)A visual representation of what the pivot_wider operation looks like in practice.</p>
</div>

<details><summary>In R, long-to-wide conversion operations are performed using `pivot_wider()`</summary>

```r
table2 %>%
  pivot_wider(names_from = type, values_from = count)
# A tibble: 6 x 4
  country      year  cases population
  <chr>       <int>  <int>      <int>
1 Afghanistan  1999    745   19987071
2 Afghanistan  2000   2666   20595360
3 Brazil       1999  37737  172006362
4 Brazil       2000  80488  174504898
5 China        1999 212258 1272915272
6 China        2000 213766 1280428583
```
</details>
<details><summary>In SAS, we use PROC TRANSPOSE again</summary>

```sashtml


6          DATA table2;
7          input country $12. year  type$12. count 12.;
8          datalines;

NOTE: The data set WORK.TABLE2 has 0 observations and 4 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

21         ;
22         
23         PROC TRANSPOSE DATA=table2 out=table2tmp;
24         ID type; /* Equivalent to names_from */
25         BY country year;  /* The combination of BY variables defines a
25       ! row */
26         VAR count; /* Equivalent to values_from */
27         RUN;

NOTE: There were 0 observations read from the data set WORK.TABLE2.
NOTE: The data set WORK.TABLE2TMP has 1 observations and 3 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

28         
29         PROC PRINT DATA=table2tmp;
30         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16.
```
</summary>

::: warning
If you don't sort your data properly before PROC TRANSPOSE in SAS, you may get a result that has an unexpected shape. SAS works rowwise (compared to R's column-wise operations) so the row order actually matters in SAS (it generally doesn't matter much in R). 
:::

Returning to our WHO HIV example, we might want our data to look like this:

Country | year | measurement | Both | Male | Female
------- | ---- | ----------- | ---- | ---- | ------
Afghanistan | 2018 | est | .02 | .03 | .01
 | 2018 | lb | .01 | .02 | .01
 | 2018 | ub | .04 | .06 | .03
 
As a reminder, the data currently looks like this: 

```r
hiv_tidy
# A tibble: 18,530 x 6
   Country      year group est   lb    ub   
   <chr>       <int> <chr> <chr> <chr> <chr>
 1 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 2 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 3 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 4 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 5 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 6 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 7 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 8 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
 9 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
10 Afghanistan    NA <NA>  <NA>  <NA>  <NA> 
# … with 18,520 more rows
```
 
::: tryitout

Think through the steps you'd need to take to get the data into this form. Sketch out any intermediate state your data will need to go through.

:::

<details><summary>WHO HIV Data: long-to-wide steps</summary>
1. We need est, lb, and ub in long form first, so we need to use a wide-to-long (pivot_longer) transpose operation.
    - names_to = "measure"
    - values_to = "value"
    - BY variables: Country, year, group
    - pivot variables (VAR in SAS): est, lb, ub

2. We need group to be 3 columns: Both, Male, and Female. So we need to use a long-to-wide (pivot_wider) transpose operation. 
    - By variables: Country, year, measure (so we'll need to sort in SAS)
    - ID variable: group
    - VAR variable: value
    
The intermediate form of the data will look like this:

Country | year | group | measure | value
------ | ---- | ---- | ----- | -----
Afghanistan | 2018 | Both | est | 0.02
Afghanistan | 2018 | Both | lb | 0.01
Afghanistan | 2018 | Both | ub | 0.04
Afghanistan | 2018 | Male | est | 0.03

</details>

<details><summary>WHO HIV Data: long-to-wide in R</summary>

```r
hiv_tidy %>%
  pivot_longer(est:ub, names_to = "measure", values_to = "value") %>%
  # Take the opportunity to transform everything to numeric at once...
  mutate(value = parse_number(value)) %>%
  pivot_wider(names_from = group, values_from = value)
Warning: Values are not uniquely identified; output will contain list-cols.
* Use `values_fn = list` to suppress this warning.
* Use `values_fn = length` to identify where the duplicates arise
* Use `values_fn = {summary_fun}` to summarise duplicates
# A tibble: 15,810 x 7
   Country      year measure `NA`       Both      Male      Female   
   <chr>       <int> <chr>   <list>     <list>    <list>    <list>   
 1 Afghanistan    NA est     <dbl [19]> <NULL>    <NULL>    <NULL>   
 2 Afghanistan    NA lb      <dbl [19]> <NULL>    <NULL>    <NULL>   
 3 Afghanistan    NA ub      <dbl [19]> <NULL>    <NULL>    <NULL>   
 4 Afghanistan  2019 est     <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
 5 Afghanistan  2019 lb      <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
 6 Afghanistan  2019 ub      <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
 7 Afghanistan  2018 est     <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
 8 Afghanistan  2018 lb      <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
 9 Afghanistan  2018 ub      <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
10 Afghanistan  2017 est     <NULL>     <dbl [1]> <dbl [1]> <dbl [1]>
# … with 15,800 more rows
```
</details>
<details><summary>WHO HIV Data: long-to-wide in SAS</summary>
In SAS, we can do the pivot operations in one step, but we have to sort everything first. 

```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          PROC SORT DATA = classdat.hivtidy;
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
9          BY Country year group;
10         RUN;

NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

11         
12         PROC TRANSPOSE DATA = classdat.hivtidy OUT = hivtmp name =
12       ! measure;
NOTE: Data file CLASSDAT.HIVTIDY.DATA is in a format that is native to 
      another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
13         BY Country year;
14         VAR est lb ub;
15         ID group;
16         RUN;

NOTE: There were 0 observations read from the data set CLASSDAT.HIVTIDY.
NOTE: The data set WORK.HIVTMP has 3 observations and 3 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

17         
18         PROC PRINT data=hivtmp(obs=5);
19         RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16.
```
</details>

#### Try it out {- .tryitout}
Use the long-format data you have from the previous Try It Out section (WHO Disease Incidence). Reshape this data into a "wide" format such that each disease is shown in a separate column. 

Before you start: 
- Which variable(s) will uniquely identify a row in your output data?
- Which variable(s) will be used to create column names?

Can you create a plot of polio cases over time for your 3 favorite countries?

<details><summary>R solution</summary>

```r
who_disease_wide <- who_disease_long %>%
  pivot_wider(id_cols = c(Country, year), names_from = Disease, values_from = cases)

who_disease_wide %>%
  filter(Country %in% c("Guatemala", "Central African Republic (the)", "Pakistan")) %>%
  select(Country, year, polio) %>%
  ggplot(aes(x = year, y = polio, color = Country)) + geom_line()
```

<img src="image/tryitout-disease-wide-R-1.png" width="2100" />
</details>

<details><summary>SAS solution</summary>


```sashtml
6          libname classdat "sas/";
NOTE: Libref CLASSDAT was successfully assigned as follows: 
      Engine:        V9 
      Physical Name: 
      /home/susan/Projects/Class/unl-stat850/stat850-textbook/sas
7          
8          PROC SORT DATA = classdat.disease_long OUT = dis_long;
NOTE: Data file CLASSDAT.DISEASE_LONG.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
9          BY Cname year; /* Variables we want to define rows of data */
10         RUN;

NOTE: The data set WORK.DIS_LONG has 0 observations and 0 variables.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

11         
12         PROC TRANSPOSE DATA = dis_long OUT = classdat.disease_wide;
NOTE: Data file CLASSDAT.DISEASE_WIDE.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
13         ID Disease; /* Variable we want to name columns of data */
ERROR: Variable DISEASE not found.
14         VAR cases; /* Variable we want to be the values in each column
14       ! */
ERROR: Variable CASES not found.
15         BY Cname year; /* These define a single row */
ERROR: Variable CNAME not found.
ERROR: Variable YEAR not found.
16         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set CLASSDAT.DISEASE_WIDE may be incomplete.  When this 
         step was stopped there were 0 observations and 0 variables.
WARNING: Data set CLASSDAT.DISEASE_WIDE was not replaced because this step 
         was stopped.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      
17         
18         title 'Polio incidence';


19         PROC SGPLOT DATA=classdat.disease_wide
20         /* We can use a where clause in the DATA statement, if we want
20       ! */
21           (WHERE=(Cname in ("Mexico", "Guatemala", "Pakistan")));
NOTE: Data file CLASSDAT.DISEASE_WIDE.DATA is in a format that is native 
      to another host, or the file encoding does not match the session 
      encoding. Cross Environment Data Access will be used, which might 
      require additional CPU resources and might reduce performance.
22         /* Specify the colors to use for lines */
23         styleattrs datacontrastcolors= (green orange purple);
24         /* Map variables to axes */
25         SERIES X = year Y = polio /
26           /* Color lines by Country */
27           GROUP = Cname
28           /* Give the color mapping a name so you can modify its legend
28       ! */
29           name = "a"
30           /* Make lines thicker so they are visible */
31           lineattrs=(thickness = 3);
32         /* Change the legend title and what it is showing (line color)
32       ! */
33         KEYLEGEND "a" / title = "Country" type = linecolor;
34         RUN;

NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18.
```
</details>

Congratulations! You now know how to reshape your data into all sorts of different formats. Use this knowledge wisely. 

## Relational Data and Joining Tables

We now know how to work extensively on one table at a time, but data doesn't always come organized in one table at a time. Instead, some data may be organized relationally - that is, certain aspects of the data apply to a group of data points, and certain aspects apply to individual data points, and there are relationships between individuals that have to be documented. 

<details><summary>Example: Primary School Organization</summary>

Each individual has certain characteristics: 
- full_name
- gender
- birth date
- ID number

Each student has specific characteristics:
- ID number 
- parent name
- parent phone number
- medical information
- Class ID

Teachers may also have additional information:
- ID number
- Class ID
- employment start date
- education level
- compensation level

There are also fields like grades, which occur for each student in each class, but multiple times  a year. 
- ID number
- Student ID
- Class ID
- year
- term number
- subject
- grade
- comment

And for teachers, there are employment records on a yearly basis
- ID number
- Employee ID
- year
- rating
- comment

But each class also has characteristics that describe the whole class as a unit: 
- location ID
- class ID
- meeting time
- grade level

Each location might also have some logistical information attached:
- location ID
- room number
- building
- number of seats
- AV equipment


![Primary School Database Schema](image/PrimarySchoolExample.png)
<!-- <a href="https://dbdiagram.io/embed/5ef387179ea313663b3b048e">Link to diagram of the database</a> -->

We could go on, but you can see that this data is hierarchical, but also relational: 
- each class has both a teacher and a set of students
- each class is held in a specific location that has certain equipment

It would be silly to store this information in a single table (though it probably can be done) because all of the teacher information would be duplicated for each student in each class; all of the student's individual info would be duplicated for each grade. There would be a lot of wasted storage space and the tables would be much more confusing as well. 

But, relational data also means we have to put in some work when we have a question that requires information from multiple tables. Suppose we want a list of all of the birthdays in a certain class. We would need to take the following steps: 

- get the Class ID
- get any teachers that are assigned that Class ID - specifically, get their ID number
- get any students that are assigned that Class ID - specifically, get their ID number
- append the results from teachers and students so that there is a list of all individuals in the class
- look through the "individual data" table to find any individuals with matching ID numbers, and keep those individuals' birth days. 
</details>

Table joins allow us to combine information stored in different tables, keeping certain information (the stuff we need) while discarding extraneous information. 

There are 3 main types of table joins:

- Filtering joins, which remove rows from a table based on whether or not there is a matching row in another table (but the columns in the original table don't change)    
Ex: finding all teachers or students who have class ClassID

- Set operations, which treat observations as set elements (e.g. union, intersection, etc.)    
Ex: taking the union of all student and teacher IDs to get a list of individual IDs

- Mutating joins, which add columns from one table to matching rows in another table    
Ex: adding birthday to the table of all individuals in a class

**keys** are values that are found in multiple tables that can be used to connect the tables. A key (or set of keys) uniquely identify an observation. A **primary key** identifies an observation in its own table. A **foreign key** identifies an observation in another table.

We're primarily going to focus on mutating joins, as filtering joins can be accomplished by ... filtering ... rather than by table joins. Feel free to read through the other types of joins [here](https://r4ds.had.co.nz/relational-data.html#filtering-joins)

<details><summary>Animating different types of joins</summary>
Note: all of these animations are stolen from https://github.com/gadenbuie/tidyexplain.

If we start with two tables, x and y, 

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/static/png/original-dfs.png)

We can do a filtering `inner_join` to keep only rows which are in both tables (but we keep all columns)

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/inner-join.gif)

But what if we want to keep all of the rows in x? We would do a `left_join`

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/left-join.gif)

If there are multiple matches in the y table, though, we might have to duplicate rows in x. This is still a left join, just a more complicated one. 

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/left-join-extra.gif)

If we wanted to keep all of the rows in y, we would do a `right_join`: 

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/right-join.gif)

(or, we could do a left join with y and x, but... either way is fine).

And finally, if we want to keep all of the rows, we'd do a `full_join`:

![](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/full-join.gif)

You can find other animations corresponding to filtering joins and set operations  [here](https://raw.githubusercontent.com/gadenbuie/tidyexplain/master/images/full-join.gif)

</details>

### Demonstration dataset setup

We'll use the `nycflights13` package in R. Unfortunately, the data in this package are too big for me to reasonably store on github (you'll recall, I had to use a small sample the last time we played with this data...). So before we can work with this data, we have to load the tables into SAS, which means saving them out from R. 
<details><summary>Instructions</summary>
We'll use a function in the `dbplyr` package to do that.^[Incidentally, dbplyr is basically dplyr for databases, and is worth checking out, even if we aren't covering it in this class.]


```r
if (!"nycflights13" %in% installed.packages()) install.packages("nycflights13")
if (!"dbplyr" %in% installed.packages()) install.packages("dbplyr")
library(nycflights13)
library(dbplyr)

Attaching package: 'dbplyr'
The following objects are masked from 'package:dplyr':

    ident, sql
nycflights13_sqlite(path = "data/")
Caching nycflights db at data//nycflights13.sqlite
<SQLiteConnection>
  Path: /home/susan/Projects/Class/unl-stat850/stat850-textbook/data/nycflights13.sqlite
  Extensions: TRUE
```

Then, you'll have to figure out where on your system database locations (DSNs) are stored. On Unix systems, it's /etc/odbc.ini (for system-wide access) and ~/.odbc.ini. On windows, you'll need to use the ODBC Data Source Administrator to set this up. 

````
[nycflight]
Description = NYC flights database
Driver = SQLite3
Database = data/nycflights13.sqlite

````

</details>



#### Try it out {- .tryitout}

Sketch a diagram of which fields in each table match fields in other tables. 

You can find the solution [here](https://r4ds.had.co.nz/relational-data.html#nycflights13-relational) (scroll down a bit).


### Mutating joins

A mutating join combines variables in two tables. There are excellent visual representations of the types of mutating joins [here](https://r4ds.had.co.nz/relational-data.html#mutating-joins). 


Every join has a "left side" and a "right side" - so in `some_join(A, B)`, A is the left side, B is the right side. 

Joins are differentiated based on how they treat the rows and columns of each side. In mutating joins, the columns from both sides are always kept. 

<table><tr><td></td><td colspan = 2>Left Side</td><td colspan = 2>Right Side</td></tr>
<th><td>Join Type</td><td>Rows</td><td>Cols</td><td>Rows</td><td>Cols</td></th>
<tr><td>inner</td><td>matching</td><td>all</td><td>matching</td><td>all</td></tr>
<tr><td>left</td><td>all</td><td>all</td><td>matching</td><td>all</td></tr>
<tr><td>right</td><td>matching</td><td>all</td><td>all</td><td>all</td></tr>
<tr><td>outer</td><td>all</td><td>all</td><td>all</td><td>all</td></tr>
</table>

<details><summary>Mutating joins in R</summary>

```r
t1 <- tibble(x = c("A", "B", "D"), y = c(1, 2, 3))
t2 <- tibble(x = c("B", "C", "D"), z = c(2, 4, 5))
```

An inner join keeps only rows that exist on both sides, but keeps all columns.

```r
inner_join(t1, t2)
Joining, by = "x"
# A tibble: 2 x 3
  x         y     z
  <chr> <dbl> <dbl>
1 B         2     2
2 D         3     5
```

A left join keeps all of the rows in the left side, and adds any columns from the right side that match rows on the left. Rows on the left that don't match get filled in with NAs. 


```r
left_join(t1, t2)
Joining, by = "x"
# A tibble: 3 x 3
  x         y     z
  <chr> <dbl> <dbl>
1 A         1    NA
2 B         2     2
3 D         3     5
left_join(t2, t1)
Joining, by = "x"
# A tibble: 3 x 3
  x         z     y
  <chr> <dbl> <dbl>
1 B         2     2
2 C         4    NA
3 D         5     3
```

There is a similar construct called a right join that is equivalent to flipping the arguments in a left join. The row and column ordering may be different, but all of the same values will be there


```r
right_join(t1, t2)
Joining, by = "x"
# A tibble: 3 x 3
  x         y     z
  <chr> <dbl> <dbl>
1 B         2     2
2 D         3     5
3 C        NA     4
right_join(t2, t1)
Joining, by = "x"
# A tibble: 3 x 3
  x         z     y
  <chr> <dbl> <dbl>
1 B         2     2
2 D         5     3
3 A        NA     1
```

An outer join keeps everything - all rows, all columns. In dplyr, it's known as a `full_join`. 


```r
full_join(t1, t2)
Joining, by = "x"
# A tibble: 4 x 3
  x         y     z
  <chr> <dbl> <dbl>
1 A         1    NA
2 B         2     2
3 D         3     5
4 C        NA     4
```
</details>

In SAS, you can do joins using a data step or PROC SQL. To do a join with data steps, you have to have your data sorted by columns that overlap. PROC SQL has no such requirement.

[This guide shows the syntax for PROC SQL and DATA step joins side-by-side.](https://support.sas.com/resources/papers/proceedings/pdfs/sgf2008/178-2008.pdf)

<details><summary>PROC SQL Mutating joins</summary>

```sashtml


6          data t1;
7          input x $ y;
8          datalines;

NOTE: The data set WORK.T1 has 0 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

12         ;
13         
14         data t2;
15         input x $ z;
16         datalines;

NOTE: The data set WORK.T2 has 0 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

20         ;
21         
22         title 'Inner join';
23         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
24         SELECT * FROM t1 as p1
25         INNER JOIN t2 as p2
26         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
27         
28         title 'Left join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


29         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
30         SELECT * FROM t1 as p1
31         LEFT JOIN t2 as p2
32         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
33         
34         title 'Right join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      


35         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
36         SELECT * FROM t1 as p1
37         RIGHT JOIN t2 as p2
38         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
39         
40         title 'Full Outer join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


41         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
42         SELECT * FROM t1 as p1
43         FULL OUTER JOIN t2 as p2
44         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
45         
46         /* Use coalesce to prevent column duplication */
47         
48         title 'Inner join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


49         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
50         SELECT COALESCE(p1.x, p2.x) AS x, y, z
51         FROM t1 as p1 INNER JOIN  t2 as p2
52         on p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
53         
54         title 'Left join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


55         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
56         SELECT COALESCE(p1.x, p2.x) AS x, y, z
57         FROM t1 as p1 LEFT JOIN t2 as p2
58         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
59         
60         title 'Right join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


61         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
62         SELECT COALESCE(p1.x, p2.x) AS x, y, z
63         FROM t1 as p1 RIGHT JOIN t2 as p2
64         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
65         
66         title 'Full Outer join';
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


67         PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
68         SELECT COALESCE(p1.x, p2.x) AS x, y, z
69         FROM t1 as p1 FULL OUTER JOIN t2 as p2
70         ON p1.x = p2.x;
NOTE: Statement not executed due to NOEXEC option.
71         
72         title;
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19.
```
</details>

<details><summary>Data Step Mutating joins</summary>

```sashtml
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      


6          data t1;
7          input x $ y;
8          datalines;

NOTE: The data set WORK.T1 has 0 observations and 2 variables.
WARNING: Data set WORK.T1 was not replaced because this step was stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

12         ;
13         
14         data t2;
15         input x $ z;
16         datalines;

NOTE: The data set WORK.T2 has 0 observations and 2 variables.
WARNING: Data set WORK.T2 was not replaced because this step was stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

20         ;
21         
22         DATA inner;
23         MERGE t1 (IN = p1) t2 (IN = p2);
24         BY x;
25         IF p1 AND p2;
26         RUN;

NOTE: The data set WORK.INNER has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

27         
28         PROC PRINT DATA=inner;RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

29         
30         DATA left;
31         MERGE t1 (IN = p1) t2 (IN = p2);
32         BY x;
33         IF p1;
34         RUN;

NOTE: The data set WORK.LEFT has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

35         
36         PROC PRINT DATA=left;RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

37         
38         DATA right;
39         MERGE t1 (IN = p1) t2 (IN = p2);
40         BY x;
41         IF p2;
42         RUN;

NOTE: The data set WORK.RIGHT has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

43         
44         PROC PRINT DATA=right;RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

45         
46         DATA outer;
47         MERGE t1 (IN = p1) t2 (IN = p2);
48         BY x;
49         RUN;

NOTE: The data set WORK.OUTER has 0 observations and 3 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

50         
51         PROC PRINT DATA=outer;RUN;

NOTE: PROCEDURE PRINT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


ERROR: Errors printed on pages 9,11,12,13,15,16,18,19.
```
</details>

As before, these functions may become a bit more interesting once we try them out on real-world data. Using the flights data, let's determine whether there's a relationship between the age of a plane and its delays. 

<details><summary>In R</summary>

```r
library(nycflights13)

plane_age <- planes %>%
  mutate(age = 2013 - year) %>% # This gets us away from having to deal with 2 different year columns
  select(tailnum, age, manufacturer)

delays_by_plane <- flights %>%
  select(dep_delay, arr_delay, carrier, flight, tailnum)

# We only need to keep delays that have a plane age, so use inner join
res <- inner_join(delays_by_plane, plane_age, by = "tailnum")

ggplot(res, aes(x = age, y = dep_delay, group = cut_width(age, 1, center = 0))) + 
  geom_boxplot() + 
  ylab("Departure Delay (min)") + 
  xlab("Plane age") + 
  coord_cartesian(ylim = c(-20, 50))
Warning: Removed 5306 rows containing missing values (stat_boxplot).
Warning: Removed 4068 rows containing non-finite values (stat_boxplot).
```

<img src="image/flights-delay-age-R-1.png" width="45%" />

```r

ggplot(res, aes(x = age, y = arr_delay, group = cut_width(age, 1, center = 0))) + 
  geom_boxplot() + 
  ylab("Arrival Delay (min)") + 
  xlab("Plane age") + 
  coord_cartesian(ylim = c(-30, 60))
Warning: Removed 5306 rows containing missing values (stat_boxplot).
Warning: Removed 5011 rows containing non-finite values (stat_boxplot).
```

<img src="image/flights-delay-age-R-2.png" width="45%" />
It doesn't look like there's much of a relationship to me. If anything, older planes are more likely to be early, but I suspect there aren't enough of them to make that conclusion (3.54% are over 25 years old, and 0.28% are over 40 years old).
</details>

<details><summary>In SAS</summary>

```sashtml
6          libname nycair odbc complete =
6        ! XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
ERROR: CLI error trying to establish connection: [unixODBC][Driver 
       Manager]Can't open lib 'libsqlite3odbc.so' : file not found
ERROR: Error in the LIBNAME statement.
7          
8          PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
9          CREATE TABLE tmp1 AS
10         SELECT 2013 - year AS age, tailnum FROM nycair.planes
11         WHERE ^missing(year);
NOTE: Statement not executed due to NOEXEC option.
12         
13         CREATE TABLE tmp2 AS
14         SELECT tailnum, dep_delay, arr_delay, air_time, distance, hour,
14       ! carrier, origin
15         FROM nycair.flights;
NOTE: Statement not executed due to NOEXEC option.
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22.
```
Now that the prep work is done, we can get on with answering the question.

```sashtml
6          
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.01 seconds
      cpu time            0.01 seconds
      


7          PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
8          CREATE TABLE agedelay AS
9          SELECT COALESCE(p1.tailnum, p2.tailnum) AS tailnum,
10                 age, dep_delay, arr_delay, air_time, distance, hour,
10       ! carrier, origin
11         FROM tmp1 as p1 INNER JOIN tmp2 as p2
12         ON p1.tailnum = p2.tailnum
13         WHERE age < 25 /* only work with areas where there's enough data
13       !  */
14         ORDER BY age;
NOTE: Statement not executed due to NOEXEC option.
15         
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      


16         PROC MEANS DATA = agedelay NOPRINT;
ERROR: File WORK.AGEDELAY.DATA does not exist.
17         BY age;
ERROR: No data set open to look up variables.
18         VAR dep_delay arr_delay;
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
19         OUTPUT OUT = agemeans;
20         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.AGEMEANS may be incomplete.  When this step was 
         stopped there were 0 observations and 0 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
21         


22         PROC TRANSPOSE DATA = agemeans(where = (_STAT_="MEAN"))
23           OUT = agemeanst(drop= _Label_)
ERROR: Variable _STAT_ is not on file WORK.AGEMEANS.
24           name=VAR;
25         BY age _FREQ_; /* Just to keep _FREQ_ around */
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
26         VAR dep_delay arr_delay;
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
27         ID _STAT_;
ERROR: No data set open to look up variables.
28         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.AGEMEANST may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22.
```
In theory, we could use some sort of linear model, but lets start with a simple plot of age * average delay and see where that takes us. 


```sashtml


6          PROC SGPANEL DATA = agemeanst;
7          PANELBY VAR;
ERROR: Variable VAR not found.
8          SCATTER X = age Y = MEAN;
ERROR: Variable AGE not found.
ERROR: Variable MEAN not found.
9          RUN;

NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SGPANEL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23.
```
I started wondering about that pattern - to me, it doesn't look like there's any particular trend so much as there's just low - high - low clusters. So I decided to plot frequency as well, and, lo and behold, the frequency count is similarly distributed. So my current working hypothesis is that there are a lot more observations in the middle group of planes that are 5-15 years old.



```sashtml
6          


7          PROC SGPLOT DATA = agemeanst;
8          SCATTER X = age Y = _FREQ_;
ERROR: Variable AGE not found.
ERROR: Variable _FREQ_ not found.
9          RUN;

NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23.
```
It's also entirely possible that planes between 5-15 years of age have more mechanical issues, but I suspect most delays are due to airport, weather, etc. rather than mechanical malfunctions.  
</details>


## Example: Gas Prices Data {.tryitout .tabset}
The US Energy Information Administration tracks gasoline prices, with data available on a weekly level since late 1994. You can go to [this site](https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emm_epm0u_pte_nus_dpg&f=w) to see a nice graph of gas prices, along with a corresponding table (or you can look at the screenshot below, as I don't really trust that the site design will stay the same...)

![Gas prices at US EIA site](image/06_gas_prices_screenshot.png)

The data in the table is structured in a fairly easy to read form: each row is a month; each week in the month is a set of two columns: one for the date, one for the average gas price. While this data is definitely not tidy, it is readable.

But looking at the chart at the top of the page, it's not clear how we might get that chart from the data in the format it's presented here: to get a chart like that, we would need a table where each row was a single date, and there were columns for date and price. That would be tidy form data, and so we have to get from the wide, human-readable form into the long, tidier form that we can graph.

### Option 1: Manual formatting in Excel

An excel spreadsheet of the data as downloaded in Sept 2020 is available [here](data/gas_prices.xlsx). Can you manually format the data (or even just the first year or two of data) into a long, skinny format?

<details><summary>What steps are involved?</summary>

1. Copy the year-month column, creating one vertical copy for every set of columns

2. Move each block of two columns down to the corresponding vertical copy

3. Delete empty rows

4. Format dates

5. Delete empty columns

[Here is a video of me doing most of these steps](https://youtu.be/n70eAKJmzRo). I skipped out on the data cleaning stage because Excel is miserable for working with dates. 
</details>


### Option 2: R
This section shows you how to clean the data up without any sort of database merges, but with 2 pivot operations. The SAS section shows how to clean the data up with database merges and a single pivot operation. You can, of course, use either approach in either language. 

If you want to try this for yourself first, there is a skeleton file [here](code/06_gas_prices_start.R) that you can fill in. Use the intermediate datasets shown to guide you through the steps, then click on the expandable sections to see the code that was used. 

<details><summary>Reading in the data from the web</summary>


```r
library(rvest) # scrape data from the web

Attaching package: 'rvest'
The following object is masked from 'package:readr':

    guess_encoding
library(xml2) # parse xml data
url <- "https://www.eia.gov/dnav/pet/hist/LeafHandler.ashx?n=pet&s=emm_epm0u_pte_nus_dpg&f=w"

htmldoc <- read_html(url)
gas_prices_raw <- html_table(htmldoc, fill = T, trim = T) [[5]]
```
</details>

```r
head(gas_prices_raw)
# A tibble: 6 x 13
  `Year-Month` `Week 1`  `Week 1` `Week 2`  `Week 2` `Week 3`  `Week 3` `Week 4`
  <chr>        <chr>     <chr>    <chr>     <chr>    <chr>     <chr>    <chr>   
1 "Year-Month" "End Dat… "Value"  "End Dat… "Value"  "End Dat… "Value"  "End Da…
2 "1994-Nov"   ""        ""       ""        ""       ""        ""       "11/28" 
3 "1994-Dec"   "12/05"   "1.143"  "12/12"   "1.118"  "12/19"   "1.099"  "12/26" 
4 ""           ""        ""       ""        ""       ""        ""       ""      
5 "1995-Jan"   "01/02"   "1.104"  "01/09"   "1.111"  "01/16"   "1.102"  "01/23" 
6 "1995-Feb"   "02/06"   "1.103"  "02/13"   "1.099"  "02/20"   "1.093"  "02/27" 
# … with 5 more variables: Week 4 <chr>, Week 5 <chr>, Week 5.1 <chr>,  <lgl>,
#   .1 <lgl>
```

<details><summary>Initial data cleaning - fix up column names, get rid of empty rows</summary>

```r
library(tidyverse)
── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──
✓ forcats 0.5.1     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
x lubridate::as.difftime() masks base::as.difftime()
x lubridate::date()        masks base::date()
x tidyr::extract()         masks magrittr::extract()
x dplyr::filter()          masks stats::filter()
x rvest::guess_encoding()  masks readr::guess_encoding()
x dbplyr::ident()          masks dplyr::ident()
x lubridate::intersect()   masks base::intersect()
x dplyr::lag()             masks stats::lag()
x purrr::set_names()       masks magrittr::set_names()
x lubridate::setdiff()     masks base::setdiff()
x dbplyr::sql()            masks dplyr::sql()
x lubridate::union()       masks base::union()
library(magrittr) # pipe friendly operations
# Function to clean up column names
# Written as an extra function because it makes the code a lot cleaner
fix_gas_names <- function(x) {
  # Add extra header row information
  paste(x, c("", rep(c("Date", "Value"), times = 5))) %>%
    # trim leading/trailing spaces
    str_trim() %>%
    # replace characters in names that aren't ok for variables in R
    make.names()
}

# Clean up the table a bit
gas_prices_raw <- gas_prices_raw %>%
  set_names(fix_gas_names(names(.))) %>%
  # remove first row that is really an extra header row
  filter(Year.Month != "Year-Month") %>%
  # get rid of empty rows
  filter(Year.Month != "")
```
</details>

```r
head(gas_prices_raw)
# A tibble: 6 x 13
  Year.Month Week.1.Date Week.1.Value Week.2.Date Week.2.Value Week.3.Date
  <chr>      <chr>       <chr>        <chr>       <chr>        <chr>      
1 1994-Nov   ""          ""           ""          ""           ""         
2 1994-Dec   "12/05"     "1.143"      "12/12"     "1.118"      "12/19"    
3 1995-Jan   "01/02"     "1.104"      "01/09"     "1.111"      "01/16"    
4 1995-Feb   "02/06"     "1.103"      "02/13"     "1.099"      "02/20"    
5 1995-Mar   "03/06"     "1.103"      "03/13"     "1.096"      "03/20"    
6 1995-Apr   "04/03"     "1.116"      "04/10"     "1.134"      "04/17"    
# … with 7 more variables: Week.3.Value <chr>, Week.4.Date <chr>,
#   Week.4.Value <chr>, Week.5.Date <chr>, Week.5.Value <chr>, X <lgl>,
#   Date <lgl>
```

<details><summary>Separate year and month into different columns</summary>

```r
gas_prices_raw <- gas_prices_raw %>%
  separate(Year.Month, into = c("year", "month"), sep = "-")
Warning: Expected 2 pieces. Additional pieces discarded in 1 rows [320].
Warning: Expected 2 pieces. Missing pieces filled with `NA` in 2 rows [321,
322].
```
</details>

```r
head(gas_prices_raw)
# A tibble: 6 x 14
  year  month Week.1.Date Week.1.Value Week.2.Date Week.2.Value Week.3.Date
  <chr> <chr> <chr>       <chr>        <chr>       <chr>        <chr>      
1 1994  Nov   ""          ""           ""          ""           ""         
2 1994  Dec   "12/05"     "1.143"      "12/12"     "1.118"      "12/19"    
3 1995  Jan   "01/02"     "1.104"      "01/09"     "1.111"      "01/16"    
4 1995  Feb   "02/06"     "1.103"      "02/13"     "1.099"      "02/20"    
5 1995  Mar   "03/06"     "1.103"      "03/13"     "1.096"      "03/20"    
6 1995  Apr   "04/03"     "1.116"      "04/10"     "1.134"      "04/17"    
# … with 7 more variables: Week.3.Value <chr>, Week.4.Date <chr>,
#   Week.4.Value <chr>, Week.5.Date <chr>, Week.5.Value <chr>, X <lgl>,
#   Date <lgl>
```

<details><summary>Move from wide to long format (part 1: extra-long format)</summary>

```r
gas_prices_long <- pivot_longer(gas_prices_raw, -c(year, month),
                                names_to = "variable", values_to = "value")
```
</details>

```r
head(gas_prices_long)
# A tibble: 6 x 4
  year  month variable     value
  <chr> <chr> <chr>        <chr>
1 1994  Nov   Week.1.Date  ""   
2 1994  Nov   Week.1.Value ""   
3 1994  Nov   Week.2.Date  ""   
4 1994  Nov   Week.2.Value ""   
5 1994  Nov   Week.3.Date  ""   
6 1994  Nov   Week.3.Value ""   
```

<details><summary>Move from wide to long format (part 2: data cleaning and pivot long-to-wide)</summary>
We need to get our variables into two columns: one for what the value contains, and one indicating which week the value is from.

```r
gas_prices_long <- gas_prices_long %>%
  # First, take "Week." off of the front
  mutate(variable = str_remove(variable, "Week\\.")) %>%
  # Then separate the two values
  separate(variable, into = c("week", "variable"), sep = "\\.")
Warning: Expected 2 pieces. Missing pieces filled with `NA` in 644 rows [11,
12, 23, 24, 35, 36, 47, 48, 59, 60, 71, 72, 83, 84, 95, 96, 107, 108, 119,
120, ...].
```


```r
head(gas_prices_long)
# A tibble: 6 x 5
  year  month week  variable value
  <chr> <chr> <chr> <chr>    <chr>
1 1994  Nov   1     Date     ""   
2 1994  Nov   1     Value    ""   
3 1994  Nov   2     Date     ""   
4 1994  Nov   2     Value    ""   
5 1994  Nov   3     Date     ""   
6 1994  Nov   3     Value    ""   
```

Now we're ready to move back into wide-er form

```r
# 
gas_prices <- gas_prices_long %>%
  # filter out empty values
  filter(value != "") %>%
  pivot_wider(
    names_from = variable,
    values_from = value
  )
```
</details>

```r
head(gas_prices)
# A tibble: 6 x 5
  year  month week  Date  Value
  <chr> <chr> <chr> <chr> <chr>
1 1994  Nov   4     11/28 1.175
2 1994  Dec   1     12/05 1.143
3 1994  Dec   2     12/12 1.118
4 1994  Dec   3     12/19 1.099
5 1994  Dec   4     12/26 1.088
6 1995  Jan   1     01/02 1.104
```


<details><summary>Clean up dates and format variables properly</summary>
We can read the date in as MDY format if we just add the year to the end of the month/day column. 

```r

library(lubridate) # dates and times
gas_prices <- gas_prices %>%
  mutate(Date = paste(Date, year, sep = "/")) %>%
  mutate(Date = mdy(Date))

# And now we can get rid of redundant columns
gas_prices <- gas_prices %>%
  select(Date, Value)

# Finally, our value variable is a character variable, so lets fix that quick
gas_prices <- gas_prices %>%
  mutate(Value = as.numeric(Value))
```
</details>

```r
head(gas_prices)
# A tibble: 6 x 2
  Date       Value
  <date>     <dbl>
1 1994-11-28  1.18
2 1994-12-05  1.14
3 1994-12-12  1.12
4 1994-12-19  1.10
5 1994-12-26  1.09
6 1995-01-02  1.10

# Lets look at our data:
ggplot(gas_prices, aes(x = Date, y = Value)) + geom_line()
```

<img src="image/cleaning-up-dates-view-1.png" width="2100" />

The full code file for this analysis is [here](code/06_gas_prices.R).

### Option 3: SAS

If you want to try this for yourself first, there is a skeleton file [here](code/06_gas_prices_start.sas) that you can fill in. Use the intermediate datasets shown to guide you through the steps, then click on the expandable sections to see the code that was used. 

::: note
I spent quite a while trying to get collectcode = T to run so that I could put the SAS code in in smaller bites, but couldn't get it to work. Please forgive the screenshots, but ugh, I'm tired of fooling with SAS at the moment. 
:::


<details><summary>Read in the data</summary>

```sashtml
6          /*********************************************************/
7          /* Step 1: Read in the data and drop missing rows/cols   */
8          /*********************************************************/
9          options missing=' ';


10         data gas_raw;
11         infile 'data/gas_prices_raw.csv' firstobs=3 delimiter = ','
11       ! MISSOVER DSD;
12         informat ym $10. ;
13         informat date1 $8. ; informat value1 4.3 ;
14         informat date2 $8. ; informat value2 4.3 ;
15         informat date3 $8. ; informat value3 4.3 ;
16         informat date4 $8. ; informat value4 4.3 ;
17         informat date5 $8. ; informat value5 4.3 ;
18         informat blank $2. ; informat blank $2. ;
19         format ym $10. ;
20         format date1 $8. ; format value1 4.3 ;
21         format date2 $8. ; format value2 4.3 ;
22         format date3 $8. ; format value3 4.3 ;
23         format date4 $8. ; format value4 4.3 ;
24         format date5 $8. ; format value5 4.3 ;
25         format blank $2. ; format blank $2. ;
26         input ym $ date1 $ value1 date2 $ value2 date3 $ value3 date4 $
26       ! value4 date5 $ value5 blank $ blank $;
27         /* drop extra columns */
28         drop blank;
29         
30         /* delete any rows where ym is not there */
31         if missing(ym) then delete;
32         run;

NOTE: The data set WORK.GAS_RAW has 0 observations and 11 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

33         

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23.
```

Dates are formated as 8-character strings, values as numbers with 3 decimal places.

The options missing piece allows us to test for whether information is missing or not. 
</details>

![SAS output - gas_raw](image/06-transforming-data_insertimage_1.png)

<details><summary>Split up year and month, format month properly</summary>

```sashtml
6          
7          proc format;
8          value $ mon 'Jan' = 1 'Feb' = 2 'Mar' = 3 'Apr' = 4 'May' = 5
                               _
                               22
                               76
8        ! 'Jun' = 6 'Jul' = 7 'Aug' = 8 'Sep' = 9 'Oct' = 10 'Nov' = 11
8        ! 'Dec' = 12;
ERROR 22-322: Syntax error, expecting one of the following: 
              a quoted string, a format name.  

ERROR 76-322: Syntax error, statement will be ignored.

9          run;

WARNING: RUN statement ignored due to previous errors. Submit QUIT; to 
         terminate the procedure.
NOTE: PROCEDURE FORMAT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
NOTE: The SAS System stopped processing this step because of errors.
10         


11         data gas_raw;
12            set gas_raw;
13            length var1-var2 $4.;
14            array var(2) $;
NOTE: The array var has the same name as a SAS-supplied or user-defined 
      function.  Parentheses following this name are treated as array 
      references and not function references.
15            do i = 1 to dim(var);
16               var[i]=scan(ym,i,'-');
17            end;
18         rename var1 = year var2 = month;
19         drop i ym;
20         if date1 = "NA" then delete; /* get rid of NA stuff */
21         run;

NOTE: The data set WORK.GAS_RAW has 0 observations and 12 variables.
WARNING: Data set WORK.GAS_RAW was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

22         
23         /* format month as a number */
24         data gas_raw;
25         set gas_raw;
26         format month $ mon.;
                          ____
                          48
ERROR 48-59: The format $MON was not found or could not be loaded.

27         run;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.GAS_RAW may be incomplete.  When this step was 
         stopped there were 0 observations and 12 variables.
WARNING: Data set WORK.GAS_RAW was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23.
```

</details>
![SAS output - gas_raw ](image/06-transforming-data_insertimage_2.png)

<details><summary>Get long data with just the dates</summary>


```sashtml
6          
7          PROC TRANSPOSE DATA = gas_raw OUT = split_long1
8          (rename=(col1=date)) NAME = week;
9          BY year month NOTSORTED;
ERROR: Variable YEAR not found.
ERROR: Variable MONTH not found.
10         VAR date1 date2 date3 date4 date5;
11         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.SPLIT_LONG1 may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
12         


13         data split_long1;
14         set split_long1;
15         IF _N_ = 1 THEN DO;
16             REGEXname = PRXPARSE("s/date//");
17         END;
18         RETAIN REGEXname;
19         
20         CALL PRXCHANGE(REGEXname, -1, week, week);
                _________
                716
WARNING 716-185: Argument #4 is a numeric variable, while a character 
                 variable must be passed to the PRXCHANGE subroutine call 
                 in order for the variable to be updated.

21         DROP REGEXname;
22         IF missing(date) THEN delete;
23         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      20:31   20:37   
NOTE: The data set WORK.SPLIT_LONG1 has 0 observations and 2 variables.
WARNING: Data set WORK.SPLIT_LONG1 was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

24         
25         PROC SORT data = split_long1 out = split_long1;
26         BY year month week;
ERROR: Variable YEAR not found.
ERROR: Variable MONTH not found.
ERROR: Variable WEEK not found.
27         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.SPLIT_LONG1 may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
WARNING: Data set WORK.SPLIT_LONG1 was not replaced because this step was 
         stopped.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23,24.
```
</details>

![SAS output - split_long1](image/06-transforming-data_insertimage_3.png)

<details><summary>Get long data with just the prices</summary>

```sashtml
6          


7          PROC TRANSPOSE DATA=gas_split OUT =split_long2
ERROR: File WORK.GAS_SPLIT.DATA does not exist.
8          (rename=(col1=price)) NAME = week;
9          BY year month NOTSORTED;
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
10         VAR value1 value2 value3 value4 value5;
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
ERROR: No data set open to look up variables.
11         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.SPLIT_LONG2 may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
NOTE: PROCEDURE TRANSPOSE used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
12         


13         data split_long2;
14         set split_long2;
15         IF _N_ = 1 THEN DO;
16             REGEXname = PRXPARSE("s/value//");
17         END;
18         RETAIN REGEXname;
19         
20         CALL PRXCHANGE(REGEXname, -1, week, week);
                _________
                716
WARNING 716-185: Argument #4 is a numeric variable, while a character 
                 variable must be passed to the PRXCHANGE subroutine call 
                 in order for the variable to be updated.

21         DROP REGEXname;
22         IF missing(price) THEN delete;
23         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      20:31   20:37   
NOTE: The data set WORK.SPLIT_LONG2 has 0 observations and 2 variables.
WARNING: Data set WORK.SPLIT_LONG2 was not replaced because this step was 
         stopped.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

24         
25         PROC SORT data = split_long2 out = split_long2;
26         BY year month week;
ERROR: Variable YEAR not found.
ERROR: Variable MONTH not found.
ERROR: Variable WEEK not found.
27         RUN;

NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.SPLIT_LONG2 may be incomplete.  When this step 
         was stopped there were 0 observations and 0 variables.
WARNING: Data set WORK.SPLIT_LONG2 was not replaced because this step was 
         stopped.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      
28         


ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23,24,25.
```
</details>

![SAS output - split_long2](image/06-transforming-data_insertimage_4.png)

<details><summary>Merge the two long datasets together</summary>

```sashtml
6          


7          PROC SQL;
NOTE: PROC SQL set option NOEXEC and will continue to check the syntax of 
      statements.
8          CREATE TABLE gas_prices AS
9          SELECT COALESCE(p1.year, p2.year) AS year,
10                COALESCE(p1.month, p2.month) AS month,
11                COALESCE(p1.week, p2.week) AS week,
12                date, price
13         FROM split_long1 as p1
14         RIGHT JOIN split_long2 as p2
15         ON p1.year = p2.year AND p1.month = p2.month AND p1.week =
15       ! p2.week;
NOTE: Statement not executed due to NOEXEC option.
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23,24,25,26.
```
</details>

![SAS output - gas prices ](image/06-transforming-data_insertimage_5.png)

<details><summary>Format dates</summary>

```sashtml
6          
NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SQL used (Total process time):
      real time           0.01 seconds
      cpu time            0.02 seconds
      


7          DATA split2;
8             SET gas_prices;
ERROR: File WORK.GAS_PRICES.DATA does not exist.
9             length var1-var2 3;
10            array var(2);
NOTE: The array var has the same name as a SAS-supplied or user-defined 
      function.  Parentheses following this name are treated as array 
      references and not function references.
11            do i = 1 to dim(var);
12               var[i]=scan(date,i,'/');
13            end;
14         RENAME var1 = monthnum var2 = day;
15         DROP i date; /* month is also in numeric form */
16         RUN;

NOTE: Numeric values have been converted to character 
      values at the places given by: (Line):(Column).
      12:19   
NOTE: Character values have been converted to numeric 
      values at the places given by: (Line):(Column).
      12:7   
NOTE: The SAS System stopped processing this step because of errors.
WARNING: The data set WORK.SPLIT2 may be incomplete.  When this step was 
         stopped there were 0 observations and 2 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

17         
18         DATA gas_prices;
19         SET split2;
20         date = MDY(monthnum, day, year);
21         FORMAT date yymmdd10.;
22         KEEP date price;
23         RUN;

WARNING: The variable price in the DROP, KEEP, or RENAME list has never 
         been referenced.
NOTE: The data set WORK.GAS_PRICES has 0 observations and 1 variables.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

24         
25         PROC SORT DATA=gas_prices OUT = gas_prices;
26         BY date;
27         RUN;

NOTE: The data set WORK.GAS_PRICES has 0 observations and 0 variables.
WARNING: Data set WORK.GAS_PRICES was not replaced because new file is 
         incomplete.
NOTE: PROCEDURE SORT used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23,24,25,26.
```
</details>

![SAS output - gas prices, final version ](image/06-transforming-data_insertimage_6.png)

```sashtml
6          
7          PROC SGPLOT DATA = gas_prices;
8          SERIES X = date Y = price;
ERROR: Variable PRICE not found.
9          TITLE 'Gas Prices';
10         RUN;

NOTE: The SAS System stopped processing this step because of errors.
NOTE: PROCEDURE SGPLOT used (Total process time):
      real time           0.00 seconds
      cpu time            0.01 seconds
      

ERROR: Errors printed on pages 9,11,12,13,15,16,18,19,22,23,24,25,26,27.
```

![](image/06_sas_gas_prices_plot.png)

You can see the full script [here](code/06_gas_prices.sas).


## References {- .learn-more}

String manipulation

- [R4DS chapter - strings](https://r4ds.had.co.nz/strings.html)
- [SAS and Perl regular expressions](https://support.sas.com/resources/papers/proceedings/proceedings/sugi29/265-29.pdf)
- [PCRE tester](https://regex101.com/)
- [R regex tester](https://spannbaueradam.shinyapps.io/r_regex_tester/) - has a short timeout period and will disconnect you if you're idle too long. But you can also clone the repo [here](https://github.com/AdamSpannbauer/r_regex_tester_app) and run it locally. 
- [SAS scan statement](https://documentation.sas.com/?docsetId=ds2ref&docsetTarget=p13adatt2vvhcxn1ext6w6eet24p.htm&docsetVersion=9.4&locale=en#p1ub8nub953289n1dpsvh7gm88qs)

Tidy data tutorials/references

- [Tidy Data - Data Skills for Reproducible Science](https://psyteachr.github.io/msc-data-skills/tidyr.html)
- [Five Ways to Flip-Flop Your Data](http://cinsug.org/uploads/3/6/2/9/36298586/horstman_five_ways_to_flip_flop_your_data_paper.pdf)
- [PROC TRANSPOSE reference](https://documentation.sas.com/?docsetId=proc&docsetVersion=9.4&docsetTarget=n1xno5xgs39b70n0zydov0owajj8.htm&locale=en)
- [tidyr reference](https://tidyr.tidyverse.org/)

Relational Data & Joins:

- [R4DS chapter - Relational data](https://r4ds.had.co.nz/relational-data.html)
- [Merge statement in SAS](https://documentation.sas.com/?docsetId=lestmtsref&docsetTarget=n1i8w2bwu1fn5kn1gpxj18xttbb0.htm&docsetVersion=9.4&locale=en)
- [5 little known, but highly valuable and widely useful PROC SQL Programming Techniques](https://www.mwsug.org/proceedings/2014/BB/MWSUG-2014-BB03.pdf)

Other references

- [SAS rename statement](https://documentation.sas.com/?docsetId=lestmtsref&docsetTarget=n0x16kvqkxxdx5n1t04voifvo8wo.htm&docsetVersion=9.4&locale=en)
- [SAS graph customization](https://www.pharmasug.org/proceedings/2016/DG/PharmaSUG-2016-DG04.pdf)
- [SAS SGPLOT procedure](https://documentation.sas.com/?docsetId=grstatproc&docsetTarget=n0yjdd910dh59zn1toodgupaj4v9.htm&docsetVersion=9.4&locale=en)
- [Data Visualization with ggplot](https://psyteachr.github.io/msc-data-skills/ggplot.html)
- [R graph gallery](https://www.r-graph-gallery.com/)

- [Videos of analysis of new data from Tidy Tuesday](https://www.youtube.com/playlist?list=PL19ev-r1GBwkuyiwnxoHTRC8TTqP8OEi8) - may include use of other packages, but almost definitely includes use of tidyr/dplyr as well. 


::: learn-more
Way back in Module 2, I briefly mentioned list-columns in tibbles. At the time, you didn't have enough R knowledge to use that information, but now you do!! 

You can see a couple of examples [here](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html) (but they assume that you know things that you'll only learn in a few modules). 
:::
