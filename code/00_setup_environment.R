################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 00_setup_environment                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 4.1.2                                                                 
#                                                                                   
#   Description: This script sets up the environment                                 
#                                                                                   
################################################################################

### 0 - Manual Variable(s) - TO UPDATE ----

# UPDATE - Last day of reporting quarter (ddmmyyyy)

current_qtr_end <- lubridate::dmy(30062023)


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

# Path for copying in 14 quarterly submissions for most recent quarter
path_submissions = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Submissions & emails/Current Quarter/"

# Path for copying in ALL DATA file from previous quarter
path_alldata = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/"

# Path for copying in lookup file for rate of referral calculation
path_lookup = "//PHI_conf/WaitingTimes/Chronic-Pain/R development work/Lookups/Populationestimatemid2021_18+.xlsx"

# Path for writing out the current quarter dataframe that will be used to update
# the ALL DATA file
path_input = here("data", "input/")

# Path for writing outputs for the workbook, the Discovery file 
# and the new updated ALL DATA file
path_output =  here("data", "output/")


### 4 - Read data files in external folders into project ----

# Read in 14 submissions for current quarter
submissions <- list.files(path_submissions, full.names = T)
file.copy(submissions, here("data", "submissions"), overwrite = TRUE)


# Read in ALL DATA file from previous quarter
file.copy(paste0(path_alldata, previous_qtr_end, " ALL DATA.xlsx"), path_input, overwrite = TRUE)


# Read in population lookup for use in referral rates calculation
file.copy(path_lookup, here("lookups"), overwrite = TRUE)


### 5 - Read all functions from the /functions directory ----
walk(list.files(here("functions"), full.names = TRUE), source)


### END OF SCRIPT ###
