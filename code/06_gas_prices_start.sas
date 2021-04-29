
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


/*********************************************************/
/* Step 2: Split up year-month and format month properly */
/*********************************************************/
proc format;
value $ mon 'Jan' = 1 'Feb' = 2 'Mar' = 3 'Apr' = 4 'May' = 5 'Jun' = 6 'Jul' = 7 'Aug' = 8 'Sep' = 9 'Oct' = 10 'Nov' = 11 'Dec' = 12;
run;




/*********************************************************/
/* Step 3: Get long dataset of weeks and end dates       */
/*********************************************************/





/*********************************************************/
/* Step 4: Get long dataset of weeks and prices          */
/*********************************************************/






/*********************************************************/
/* Step 5: Merge                                         */
/*********************************************************/






/*********************************************************/
/* Step 6: Format dates properly                         */
/*********************************************************/







/*********************************************************/
/* Step 7: Plot                                          */
/*********************************************************/

PROC SGPLOT DATA = gas_prices;
SERIES X = date Y = price;
TITLE 'Gas Prices';
RUN;
