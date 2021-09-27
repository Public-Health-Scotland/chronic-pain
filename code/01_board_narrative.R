################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_board_narrative                                               
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1                                                                 
#   Packages required: dplyr(1.0.1), readxl(1.3.1), tidyr(1.1.0), writexl(1.3),      
#                      stringr(1.4.0), here(1.0.1)                                                
#                                                                                    
#   Description: This script reads the sheet = "NHS Board details",                  
#                range = "C17:C41" from the 14 Board submissions and                 
#                creates a dataframe of one column for the Excel Workbook            
#                                                                                    
################################################################################

### 1 - Get file names ----

# NEED TO GET RID OF THIS setwd( )
#setwd("//PHI_conf/WaitingTimes/Chronic-Pain/Data/Submissions & emails/Current Quarter/")

# Copy 14 submissions into project folder at start of each publication process?

# HOW DO I tell R to look in the data folder, list the names of the 14 submissions 
# and ignore the ALL DATA file containing historical data?

# Get list of files
here:here("data")

filenames <- list.files()


###   2. Read board narrative from submission forms   ###

# Initiate a blank data frame
notes <- data.frame()

for (file in filenames){
  
    temp_notes <- read_excel(file, sheet = "NHS Board details", range = "C17:C41") %>%
      rename(`Board narrative` = `...1`)

    # Replace 2 lines of heading text with shorter line of text
    temp_notes %<>%
      mutate(`Board narrative` = case_when(
        `Board narrative` == "*Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "*Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
        `Board narrative` == "Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
        TRUE ~ (as.character(`Board narrative`)) 
      ))
    
    boardname <- data.frame(paste0("NHS ", file)) %>%
              rename(`Board narrative` = `paste0..NHS....file.`)
    
    notes <- rbind(notes, boardname, temp_notes)
    rm(boardname)
    rm(temp_notes)
    
    notes %<>%
      mutate(`Board narrative` = str_remove_all(`Board narrative`, "\\.xlsx$"))
    
}


###   3. Write Excel file

# Set path for exporting tables
#path_tables = "//PHI_conf/WaitingTimes/Chronic-Pain/Publications/Outputs/Narrative_xxxxxxxx.xlsx"
#path_tables = "//PHI_conf/WaitingTimes/Chronic-Pain/RAP/chronic-pain-main/data/output/Narrative_xxxxxxxx.xlsx"
#data <- read_csv(here("./datafolder/datafile.csv"))
path_tables =  here::here("data", "output", "Narrative_xxxxxxxx.xlsx")

# NEED TO AUTOMATE DATE: Replace xxxxxxxx with date in format, e.g. 2021-06-30

# Write Excel file
write_xlsx(notes, path_tables)


### END OF SCRIPT ###









