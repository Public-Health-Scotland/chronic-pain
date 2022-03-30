################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_board_narrative                                               
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1                                                                 
#   Packages required: dplyr(1.0.1), readxl(1.3.1), tidyr(1.1.0), writexl(1.3),      
#                      stringr(1.4.0), here(1.0.1), openxlsx(4.1.5)                                                
#                                                                                    
#   Description: This script reads the sheet = "NHS Board details",                  
#                range = "C17:C41" from the 14 Board submissions and                 
#                creates a dataframe of one column for the Excel Workbook            
#                                                                                    
################################################################################

### Function for combining 14 quarterly submissions 
read_narrative <- 
  function(current_qtr_end)
  {
    ### 1 - Read in Board name ----
    
    # Read in Board name from the B8 on NHS Board details sheet
    board <- read.xlsx(path_readsubmissions, sheet = 4, skipEmptyRows = TRUE, 
                       cols = c(2, 2), rows = c(7, 8)) %>%
      rename(`Health Board` = `Health.Board`)
    
    ### 2 - Read in narrative ----
    notes <- read.xlsx(path_readsubmissions, sheet = 4, skipEmptyRows = TRUE, 
                       cols = c(2, 2), rows = c(17, 41)) %>%
      rename(`Board narrative` = `...1`)
    
    # Replace 2 lines of heading text with shorter line of text
    notes %<>%
      mutate(`Board narrative` = case_when(
        `Board narrative` == "*Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "*Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
        `Board narrative` == "Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
        TRUE ~ (as.character(`Board narrative`)) 
      ))
    
    ### 3 - Create notes dataframe ----
    notes <- rbind(boardname, notes)
    
  }


### END OF SCRIPT ###

# OLDER VERSION

# ### Function for combining Board narratives from 14 submissions 
# read_narrative <- 
#   function(current_qtr_end)
#   {
#     
#     ### 1 - Get file names ----
# 
#     # Get list of files
#     
#     filenames <- walk(list.files(here("data", "submissions"), full.names = TRUE), source)
# 
#     ### 2 - Read board narrative from submission forms ----
# 
#     # Initiate a blank data frame
#     notes <- data.frame()
# 
#     for (file in filenames){
#   
#     temp_notes <- read_excel(file, sheet = "NHS Board details", range = "C17:C41") %>%
#       rename(`Board narrative` = `...1`)
# 
#     # Replace 2 lines of heading text with shorter line of text
#     temp_notes %<>%
#       mutate(`Board narrative` = case_when(
#         `Board narrative` == "*Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
#         `Board narrative` == "*Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
#         `Board narrative` == "Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
#         `Board narrative` == "Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
#         TRUE ~ (as.character(`Board narrative`)) 
#       ))
#     
#     boardname <- data.frame(paste0("NHS ", file)) %>%
#               rename(`Board narrative` = `paste0..NHS....file.`)
#     
#     notes <- rbind(notes, boardname, temp_notes)
#     rm(boardname)
#     rm(temp_notes)
#     
#     notes %<>% 
#       mutate(`Board narrative` = str_remove_all(`Board narrative`, "\\.xlsx$"))
#     
#     }
# 
# 
#     ### 3 - Write Excel file for the workbook ----
# 
#     # Set path for saving Board narrative
#     #path_narrative =  here("data", "output")
#     #path_tables =  here("data", "output", "Narrative_xxxxxxxx.xlsx")
# 
#     # Write Excel file to output folder
#     
#     #write_xlsx(notes, path_tables)
#     write_xlsx(notes, paste0(path_narrative, current_qtr_end, "_Narrative.xlsx" ))
#     
#   }
# 
# 
# ### END OF SCRIPT ###
# 








