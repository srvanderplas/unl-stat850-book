libname classdat "/home/susan/Projects/Class/unl-stat850/2020-stat850/sas/";
/* Create a library of class data */

filename loc  "~/Projects/Class/unl-stat850/2020-stat850/data/06_brfss_factors.csv";

proc import datafile = loc out=classdat.brfssfac
  DBMS = csv /* comma delimited file */
  replace;
  GETNAMES = YES;
  GUESSINGROWS = 50000 /* use all data for guessing the variable type */
  ;


proc SQL;
CREATE TABLE tmpbrfss AS
SELECT STATE, MEAN(SEX1=1) AS PctMale
FROM classdat.brfssfac
GROUP BY STATE;

proc gmap data=tmpbrfss map=maps.us;
id state;
choro PctMale;
run;
