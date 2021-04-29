
/*********************************************************/
/* Step 1: Read in the data and drop missing rows/cols   */
/*********************************************************/
PROC IMPORT FILE = "data/gas_prices_raw.csv" OUT=GAS_PRICES_RAW DBMS=CSV REPLACE;
GETNAMES=NO;
RUN;

options missing=' ';
data WORK.gas_raw    ;
infile 'data/gas_prices_raw.csv' firstobs=3 delimiter = ',' MISSOVER DSD;
informat ym $10. ;
informat date1 $8. ; informat value1 4.3 ;
informat date2 $8. ; informat value2 4.3 ;
informat date3 $8. ; informat value3 4.3 ;
informat date4 $8. ; informat value4 4.3 ;
informat date5 $8. ; informat value5 4.3 ;
informat blank $2. ; informat blank $2. ;
format ym $10. ;
format date1 $8. ; format value1 4.3 ;
format date2 $8. ; format value2 4.3 ;
format date3 $8. ; format value3 4.3 ;
format date4 $8. ; format value4 4.3 ;
format date5 $8. ; format value5 4.3 ;
format blank $2. ; format blank $2. ;
input ym $ date1 $ value1 date2 $ value2 date3 $ value3 date4 $ value4 date5 $ value5 blank $ blank $;
/* drop extra columns */
drop blank;

/* delete any rows where ym is not there */
if missing(ym) then delete;
run;

proc print data = gas_raw (obs=10);
run;

/*********************************************************/
/* Step 2: Split up year-month and format month properly */
/*********************************************************/
proc format;
value $ mon 'Jan' = 1 'Feb' = 2 'Mar' = 3 'Apr' = 4 'May' = 5 'Jun' = 6 'Jul' = 7 'Aug' = 8 'Sep' = 9 'Oct' = 10 'Nov' = 11 'Dec' = 12;
run;

data split;
   set gas_raw;
   length var1-var2 $4.;
   array var(2) $;
   do i = 1 to dim(var);
      var[i]=scan(ym,i,'-');
   end;
rename var1 = year var2 = month;
drop i ym;
if date1 = "NA" then delete;
run;

data split;
set split;
format month $ mon.;
run;

proc print data = split (obs=10);
run;

/*********************************************************/
/* Step 3: Get long dataset of weeks and end dates       */
/*********************************************************/
PROC TRANSPOSE DATA=split OUT =split_long1
(rename=(col1=date)) /* "values_to" in tidyr speak */
NAME = week;         /* "names_to" in tidyr speak */;
BY year month NOTSORTED;
VAR date1 date2 date3 date4 date5;
RUN;

data split_long1;
set split_long1;
IF _N_ = 1 THEN DO;
    REGEXname = PRXPARSE("s/date//");
END;
RETAIN REGEXname;

CALL PRXCHANGE(REGEXname, -1, week, week);
DROP REGEXname;
IF missing(date) THEN delete;
RUN;

PROC SORT data = split_long1 out = split_long1;
BY year month week;
RUN;

proc print data = split_long1 (obs=10);
run;

/*********************************************************/
/* Step 4: Get long dataset of weeks and prices          */
/*********************************************************/

PROC TRANSPOSE DATA=split OUT =split_long2
(rename=(col1=price)) /* "values_to" in tidyr speak */
NAME = week;         /* "names_to" in tidyr speak */;
BY year month NOTSORTED;
VAR value1 value2 value3 value4 value5;
RUN;

data split_long2;
set split_long2;
IF _N_ = 1 THEN DO;
    REGEXname = PRXPARSE("s/value//");
END;
RETAIN REGEXname;

CALL PRXCHANGE(REGEXname, -1, week, week);
DROP REGEXname;
IF missing(price) THEN delete;
RUN;

PROC SORT data = split_long2 out = split_long2;
BY year month week;
RUN;

proc print data = split_long2 (obs=10);
run;

/*********************************************************/
/* Step 5: Merge                                         */
/*********************************************************/
PROC SQL;
CREATE TABLE gas_prices AS
SELECT COALESCE(p1.year, p2.year) AS year,
       COALESCE(p1.month, p2.month) AS month,
       COALESCE(p1.week, p2.week) AS week,
       date, price
FROM split_long1 as p1
RIGHT JOIN split_long2 as p2
ON p1.year = p2.year AND p1.month = p2.month AND p1.week = p2.week;

proc print data = gas_prices (obs=10);
run;

/*********************************************************/
/* Step 6: Format dates properly                         */
/*********************************************************/

data gas_prices;
   set gas_prices;
   length var1-var2 3;
   array var(2);
   do i = 1 to dim(var);
      var[i]=scan(date,i,'/');
   end;
rename var1 = monthnum var2 = day;
drop i date; /* month is also in numeric form */
run;

data gas_prices;
set gas_prices;
date = MDY(monthnum, day, year);
format date yymmdd10.;
keep date price;
run;

PROC SORT DATA=gas_prices OUT = gas_prices;
BY date;
RUN;


proc print data = gas_prices (obs=10);
run;

/*********************************************************/
/* Step 7: Plot and clean up                             */
/*********************************************************/

PROC SGPLOT DATA = gas_prices;
SERIES X = date Y = price;
TITLE 'Gas Prices';
RUN;

PROC DELETE DATA = WORK.gas_prices_raw;
RUN;
PROC DELETE DATA = WORK.gas_raw;
RUN;
PROC DELETE DATA = WORK.split;
RUN;
PROC DELETE DATA = WORK.split2;
RUN;
PROC DELETE DATA = WORK.split_long1;
RUN;
PROC DELETE DATA = WORK.split_long2;
RUN;
