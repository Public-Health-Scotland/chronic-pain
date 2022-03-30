################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_narrative                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1
#
#   Packages required: here(1.0.1), purrr(0.3.4)
#                      
#                                                                                   
#   Description: This script uses map_dfr to run the read_narrative function  
#                from the 14 quarterly submission files                                
#                                                                                   
################################################################################

### 1 - Get file names ----

# Get list of files

files <- walk(list.files(here("data", "submissions"), full.names = TRUE), source)


### 2 - Use map() to run the read_narrative function

current_quarter <- map_dfr(files, read_narrative)


### 3 - Write file with current_quarter_end date included in file name  ----

write_xlsx(notes, paste0(path_narrative, current_qtr_end, "_Narrative.xlsx" ))


### END OF SCRIPT ###