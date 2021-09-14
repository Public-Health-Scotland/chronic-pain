##########################################################################################
###                                                                                    ###
###   Chronic Pain Publication                                                         ###
###   Script: 01_combine_board_narrative                                               ###
###                                                                                    ###
###   Written for: R Studio Server                                                     ###
###   R Version: 3.6.1                                                                 ###
###   Packages required: dplyr(1.0.1), readxl(1.3.1), tidyr(1.1.0), writexl(1.3)       ###
###                                                                                    ###
###   Description: This script reads the notes from the 14 Board submissions           ###
###   and creates a dataframe of one column for the Excel Workbookwith                 ###
###                                                                                    ###
##########################################################################################

###   1. Get file names   ###

# Set working directory
setwd("//PHI_conf/WaitingTimes/Chronic-Pain/Data/Submissions & emails/Current Quarter/")

# Get list of files
filenames <- list.files()

# Get list of board names without file extensions
names <- tools::file_path_sans_ext(filenames)


###   2. Read board narrative from submission forms   ###

# Initiate a blank data frame
notes <- data.frame()

for (file in filenames){
  
    #temp_notes <- read_excel(file, sheet = "NHS Board", range = "D4:D15") %>%
    temp_notes <- read_excel(file, sheet = "NHS Board details", range = "C17:C53") %>%
      rename(`Board narrative` = `...1`)

    # Drop blank rows
    #temp_notes <- temp_notes[-c(2, 4:8), ]
    
    # Replace 2 lines of heading text with shorter line of text
    temp_notes <- temp_notes %>%
      mutate(`Board narrative` = case_when(
        `Board narrative` == "*Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "*Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
        `Board narrative` == "Please use the space below to update us on your progress to tackle the longest waits/ waiting list queue." ~ "Progress to tackle the longest waits/waiting list queue:", 
        `Board narrative` == "Please use the space below to add any additional comments to help with interpretation of the data you have submitted this quarter." ~ "Additional comments to aid interpretation of the data submitted this month:",
       # `Board narrative` == "Please explain why a full data submission can't be provided.",
        TRUE ~ (as.character(`Board narrative`)) 
      ))
    
    boardname <- data.frame(paste0("NHS ", file)) %>%
              rename(`Board narrative` = `paste0..NHS....file.`)
    
    notes <- rbind(notes, boardname, temp_notes)
    rm(boardname)
    rm(temp_notes)
    
}

# Remove .xlsx from Board names
notes <- notes %>%
  mutate(`Board narrative` = case_when(
    `Board narrative` == "NHS Ayrshire & Arran.xlsx" ~ "NHS Ayrshire & Arran", 
    `Board narrative` == "NHS Borders.xlsx" ~ "NHS Borders",
    `Board narrative` == "NHS Dumfries & Galloway.xlsx" ~ "NHS Dumfries & Galloway", 
    `Board narrative` == "NHS Fife.xlsx" ~ "NHS Fife",
    `Board narrative` == "NHS Forth Valley.xlsx" ~ "NHS Forth Valley", 
    `Board narrative` == "NHS Grampian.xlsx" ~ "NHS Grampian",
    `Board narrative` == "NHS Greater Glasgow.xlsx" ~ "NHS Greater Glasgow & Clyde", 
    `Board narrative` == "NHS Highland.xlsx" ~ "NHS Highland",
    `Board narrative` == "NHS Lanarkshire.xlsx" ~ "NHS Lanarkshire", 
    `Board narrative` == "NHS Lothian.xlsx" ~ "NHS Lothian",
    `Board narrative` == "NHS Orkney.xlsx" ~ "NHS Orkney", 
    `Board narrative` == "NHS Shetland.xlsx" ~ "NHS Shetland",
    `Board narrative` == "NHS Tayside.xlsx" ~ "NHS Tayside", 
    `Board narrative` == "NHS Western Isles.xlsx" ~ "NHS Western Isles",
    TRUE ~ (as.character(`Board narrative`)) 
  ))


###   3. Write Excel file

# Set path for exporting tables
# Replace xxxxxxxx with date in format, e.g. 2021-06-30
path_tables = "//PHI_conf/WaitingTimes/Chronic-Pain/Publications/Outputs/Narrative_xxxxxxxx.xlsx"

# Write Excel file
write_xlsx(notes, path_tables)

###############TO DO:
# Turn into function
# Better way to remove .xlsx
# Remove commented out lines
# Is there a better way of writing this script?







