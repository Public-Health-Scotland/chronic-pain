################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_submission                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1
#
#   Packages required: here(1.0.1), purrr(0.3.4)
#                      
#                                                                                   
#   Description: This script uses map_dfr to run the read_submisson function  
#                and combine 14 quarterly submission files                                
#                                                                                   
################################################################################

### 1 - Get file names and set path ----

# Get list of files

files <- list.files(here("data", "submissions"), full.names = TRUE)


### 2 - Use map_dfr() to run the read_submission function and produce one dataframe

current_quarter <- map_dfr(files, read_submission, current_qtr_end)


### 3 - Write file with current_quarter_end date included in file name  ----

write_rds(current_quarter, paste0(path_input, current_qtr_end, "current.rds"))


### END OF SCRIPT ###
