################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_board_narrative                                               
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 4.1.2                                                                 
#   Packages required: dplyr(1.1.0), here(1.0.1), openxlsx(4.2.5.2), 
#                      readxl(1.4.2), stringr(1.5.0), tidyr(1.3.0), 
#                      writexl(1.4.2)   
#                                                                      
#                                                                                    
#   Description: This script reads the sheet = "NHS Board details",                  
#                range = "C17:C41" from the 14 Board submissions and                 
#                creates a dataframe of one column for the Excel Workbook            
#                                                                                    
################################################################################

### Function for combining 14 quarterly submissions 
read_narrative <- 
  function(files, current_qtr_end)
  {
    ### 1 - Read in Board name ----
    
    # Read in Board name from B8 on NHS Board details sheet
    board <- read.xlsx(files, 
                       sheet = 4, 
                       skipEmptyRows = TRUE, 
                       cols = 2, 
                       rows = 8, 
                       colNames = FALSE) %>%
      rename(`Health Board` = `X1`)
    
    ### 2 - Read in narrative ----
    notes <- read.xlsx(files, 
                       sheet = 4, 
                       skipEmptyRows = TRUE, 
                       cols = 2, 
                       rows = c(17, 41)) %>%
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






