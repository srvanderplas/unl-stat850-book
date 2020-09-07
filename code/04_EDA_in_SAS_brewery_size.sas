FILENAME testurl URL "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-03-31/brewer_size.csv";

data _null_;
   infile testurl dsd truncover ;
   file 'to_sas.csv' dsd ;
   length word $200 ;
   do i = 1 to 6;
      input word @;
      if word='NA' then word=' ';
      put word @;
   end;
   put;
run;

PROC IMPORT file = 'to_sas.csv' out = work.brewsize dbms = csv REPLACE;
RUN;

PROC PRINT data = work.brewsize (obs=10);
RUN;

PROC CONTENTS data = work.brewsize;
RUN;

PROC MEANS data = work.brewsize;
VAR n_of_brewers  taxable_removals total_barrels total_shipped year;
RUN;

/* create a format to group missing and nonmissing */
proc format;
 value $missfmt ' '='Missing' other='Not Missing';
 value  missfmt  . ='Missing' other='Not Missing';
run;

proc freq data=work.brewsize; 
BY brewer_size NOTSORTED;
format _NUMERIC_ missfmt.;
tables _NUMERIC_ / missing missprint nocum nopercent;
run;
