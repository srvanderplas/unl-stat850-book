indoc <- '
---
title: "Basic SASmarkdown Doc"
output: html_document
---

```{r load-sas-libraries, echo =T, message = F, warning = F}
library(SASmarkdown)
sas_enginesetup()
```
```{r}
writeLines(c(
"PROC SGPLOT data=sashelp.snacks;",
"SCATTER x = date y = QtySold /
  markerattrs=(size=8pt symbol=circlefilled)
  group = product; /* maps to point color by default */",
"RUN;
QUIT;"
), con = "reprex.sas")
```

```{r, engine = "sashtml", engine.path="sas"}
%include 'reprex.sas'
```

```{r}
system("sas reprex.sas")
```
![](SGPlot.png)

'
knitr::knit(text=indoc, output="test.md")
rmarkdown::render("test.md")
