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

### 1 - Get file names ----

# Get list of files
files <- walk(list.files(here("data", "submissions"), full.names = TRUE), source)


### 2 - Use map() to run the read_submission function
current_quarter <- map_dfr(files, read_submission)


### 3 - Write file with current_quarter_end date included in file name  ----

# NEED TO decide if writing current_quarter file is needed longer-term? Or would 
# current_quarter be created in R and then added to the bottom of the ALL DATA 
# file without saving current_quarter first?

# Is line 36 correct - I think map_dfr will produce a df called current_quarter 
# that will contain all 14 submissions bound together using row binding?

write.xlsx(current_quarter, paste0(path_currentquarter, current_qtr_end, ".xlsx"))

# Or should I use write_RDS instead?
#write_rds(current_quarter, paste0(path_currentquarter, current_qtr_end, ".rds"))


### END OF SCRIPT ###
