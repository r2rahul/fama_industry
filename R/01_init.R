suppressMessages({
  suppressWarnings({
    suppressPackageStartupMessages({
      library(targets)
      library(tarchetypes)
      library(tidyverse)
      library(glue)
      library(readr)
      library(stringr)
      library(ggthemes)
      library(here)
      library(qs)
      library(rvest)
    })
  })
})

# Start defining the parameters
fama_url <- "https://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/Siccodes49.zip" #nolint
sic_sec_url <- "https://www.sec.gov/corpfin/division-of-corporation-finance-standard-industrial-classification-sic-code-list" #nolint
sic_wiki_url <- "https://en.wikipedia.org/wiki/Standard_Industrial_Classification" #nolint
folder_loc <- "data/famaind"
out_dir <- "data/famatxt"
out_tidy <- "data/famatidy/fama_sic.csv"
rpt_path <- "inst/rmd/fama_sic_data_report.Rmd"

