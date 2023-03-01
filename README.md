Tidy Data of Fama 49 Industry Classification to SIC Industry Classification Mapping
================

If you are looking for Fama 49 industry classification to SIC mapping in the tabular format then this file will be good to go [SIC-Fama Data](data/famatidy/fama_sic.csv). If further customization or other Fama Industry files needs to be used then code might serve as an example for the use-case. Especially the regular expression used in the code will be very useful in adapting the analysis to another Fama industry files. The code section contains further details. 

## Introduction

The code converts the Fama and French 49 Industry classification into the tidy data,
so that the data can be integrated into the analysis pipeline according to the tidy principles [1].
The main output of the code is file [SIC-Fama Data](data/famatidy/fama_sic.csv).

## Data Dictionary

The table below provide data dictionary for the output
file [SIC-Fama Data](data/famatidy/fama_sic.csv)

| Column  | Description   |
|---|---|
|  sic_code |  SIC 4 digit Code |
|  sic_group_name | SIC description  |
|  fama_sic_start | Fama SIC start 4-digit code  |
| fama_sic_end  | Fama SIC end 4-digit code  |
|sic_fama_desc| SIC Industry Name as Per Fama data |
|fama_ind49| Fama industry code |
|fama_grpdesc| Fama Industry description|

## Code

The code can be referenced for any other industry data tidying like Fama 10 industry 
classification. The code will provide ideas and reduce effort in tidying the data. The
code uses functional approach of coding, so while and for loops are not used.
Further, code uses targets [targets](https://github.com/ropensci/targets) 
package for executing the task pipeline [2].

The below code will check for missing library and install the missing libraries

```r
list_packages <- c("targets", "tarchetypes", "tidyverse", "glue",
  "readr", "stringr", "ggthemes", "here", "qs", "rvest")
if (length(setdiff(list_packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(list_packages, rownames(installed.packages())))  
}
```

After that run from R console

```r
tar_make()
# or 
source("run.R")
```

Next, code in two files, which are important are `02_getdata.R` and `03_prepdata.R`. 

+ `02_getdata.R` contains codes to pull information from url's and fama and french 
website. 

+ `03_prepdata.R` contains code to extract information from Fama text file and convert the data
into tabular or tidy format.

Codes in these two files can serve as an template for tidying other
French industry text files. 


The SIC classification is based on these public information:  
+ [OSHA SIC Reference](https://www.osha.gov/data/sic-search). The file I used from Webscrapped data from Github [OSHA SIC Manual Scrapper](https://github.com/storydrivendatasets-pre-2022-archive/osha-sic-code-manual-scraper)  
+ [SEC SIC list](https://www.sec.gov/corpfin/division-of-corporation-finance-standard-industrial-classification-sic-code-list)  
+ [Wikipedia SIC list](https://en.wikipedia.org/wiki/Standard_Industrial_Classification)  

## References
  
1. Wickham, H. . (2014). Tidy Data. Journal of Statistical Software, 59(10), 1–23. https://doi.org/10.18637/jss.v059.i10
2. Landau, W. M., (2021). The targets R package: a dynamic Make-like
  function-oriented pipeline toolkit for reproducibility and
  high-performance computing. Journal of Open Source Software, 6(57),
  2959, https://doi.org/10.21105/joss.02959

