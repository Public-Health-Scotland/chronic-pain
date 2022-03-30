################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 00_setup_environment                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1                                                                 
#                                                                                   
#  Description: This script sets up the environment                                 
#                                                                                   
################################################################################

### 0 - Manual Variable(s) - TO UPDATE ----

# UPDATE - Last day of reporting quarter (ddmmyyyy)

current_qtr_end <- lubridate::dmy(30062021)


### 1 - Load libraries required ----

library(dplyr)        # For data manipulation in the "tidy" way
library(readxl)       # For reading data from Excel into R. No external dependencies
library(stringr)      # For string manipulation, e.g. pattern matching
library(tidyr)        # For tidying your messy data: gather() , separate() and spread()
library(writexl)      # For writing Excel files from R
library(readr)        # For reading files
library(lubridate)    # For dealing with dates
library(janitor)      # For 'cleaning' variable names
library(phsmethods)   # For internal PHS functions
library(magrittr)     # For the %<>%
library(ggplot2)      # For creating charts
library(knitr)        # For creating tables in markdown
library(rmarkdown)    # For rendering markdown documents
library(zip)          # For archiving files
library(here)         # For the here() function
library(openxlsx)     # For reading and writing Excel files
library(purrr)        # For iterative functional programming with vectors


### 2 - Derive date variables ----

previous_qtr_end <- as_date(cut(ymd(current_qtr_end), "quarter")) - 1


### 3 - Set file paths ----

path_submissions = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/Submissions & emails/Current Quarter/"

path_alldata = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/"

path_lookup = "//PHI_conf/WaitingTimes/Chronic-Pain/R development work/Lookups/"

path_readsubmissions = here("data", "submissions")

path_narrative =  here("data", "output")

path_currentquarter = here("data", "input")

path_discovery =  here("data", "output")

path_newalldata = here("data", "output")


### 4 - Read data files in external folders into project ----

# Read in 14 submissions for current quarter

# Are lines 66 - 67 correct? 
#Will the 14 files be copied? 
#Not sure what source does?
submissions <- walk(list.files("path_submissions", full.names = TRUE), source)
file.copy(submissions, here("data", "submissions"))


# Read in ALL DATA file from previous quarter

file.copy(paste0(path_alldata, previous_qtr_end, " ALL DATA.xlsx"), here("data", "input"))


# Read in population lookup for use in referral rates calculation

file.copy(paste0(path_lookup, "Populationestimatemid2020_18+.xlsx"), here("lookups"))


### 5 - Read all functions from the /functions directory ----

walk(list.files(here("functions"), full.names = TRUE), source)


### END OF SCRIPT ###
