##########################################################################################
###                                                                                    ###
###   Chronic Pain Publication                                                         ###
###   Script: 01_combine_data_function                                                 ###
###                                                                                    ###
###   Written for: R Studio Server                                                     ###
###   R Version: 3.6.1                                                                 ###
###   Packages required: dplyr(1.0.1), readxl(1.3.1), stringr(1.4.0), tidyr(1.1.0)     ###
###                      writexl(1.3)                                                  ###  
###                                                                                    ###
###   Description: This function combines the historical ALL DATA file                 ###
###   with data from the Current Quarter                                               ###
###                                                                                    ###  
###   NOTE: The output file will be saved to 3 locations:                              ###               
###   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database             ###
###   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database\            ###
###   previous versions                                                                ###  
###   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery                 ### 
###                                                                                    ###
##########################################################################################

### Function for combining ALLDATA and the Current quarter files
Combine_ALLDATA_Currentquarter <- 
  function(date_existing_ALLDATA, date_currentquarter,date_new_ALLDATA)
  {
    ###   Read in ALL DATA file and Current Quarter file   ###
    
    # Set path for most recent ALLDATA file
    path_ALLDATA = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/"
    
    # Read in most recent ALLDATA file
    data <- read_excel(paste0(path_ALLDATA, date_existing_ALLDATA, " ALL DATA.xlsx"),
                       col_types = c("text", "date", "text", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric")) %>% 
                       mutate(`Report Date` = as.Date(`Report Date`, "%Y%m%d"))
    
    # Set path for current quarter file after saving it as Excel workbook without macro/formulas
    path_Currentquarter = "//PHI_conf/WaitingTimes/Chronic-Pain/R development work/Data/Current Quarter_"
    
    # Read in Current data but need to save as Excel workbook without macro / formulas                    
    current <- read_excel(paste0(path_Currentquarter, date_currentquarter, ".xlsx"),
                          col_types = c("text", "date", "text", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric")) %>% 
                       mutate(`Report Date` = as.Date(`Report Date`, "%Y%m%d"))
    
    
    ###   Bind the 2 dataframes   ###
    # Use rbind to bind the current quarter to the bottom of ALL DATA
    New_df <- rbind(data, current)
    
    
    ###   Create df for Discovery with 2 new variables
    Discovery <- New_df %>%
      mutate(WaitDays = str_split_fixed(WaitTime, "[(]",  2)[,1]) %>%
      mutate(WaitWeeks = str_split_fixed(WaitTime, "[(]",  2)[,2]) %>%
      select(`Health Board`, `Report Date`, WaitTime, WaitDays, WaitWeeks, everything())
    
    # Trim trailing white space
    Discovery$WaitDays <- trimws(Discovery$WaitDays)
    
    # Recode "> 728 days" 
    Discovery <- Discovery %>% 
      mutate(WaitDays = recode(WaitDays, 
                                `> 728 days` = "728 days or more",
                                .default = levels(WaitDays)))
    
    # Extract digits from strings
    Discovery$WaitWeeks <- str_extract(Discovery$WaitWeeks, "[0-9]+")
    
    
    ### Write dataframes to an Excel file in 3 locations 
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database
    path_1 = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/"
    
    # Write Excel file
    write_xlsx(New_df, paste0(path_1, date_new_ALLDATA, " ALL DATA.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database\previous versions
    path_2 = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/previous versions/"
    
    # Write Excel file
    write_xlsx(New_df, paste0(path_2, date_new_ALLDATA, " ALL DATA.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery\archive
    path_3 = "//PHI_conf/WaitingTimes/Chronic-Pain/Discovery/archive/"

    # Write Excel file to archive
    write_xlsx(Discovery, paste0(path_3, date_new_ALLDATA, " Chronic Pain WT - All Data.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery
    path_4 = "//PHI_conf/WaitingTimes/Chronic-Pain/Discovery/"
    
    # Write Excel file for Discovery with required naming convention
    # Will overwrite existing file
    write_xlsx(Discovery, paste0(path_4, "Chronic Pain WT - All Data.xlsx"))

    # Write Excel file for Discovery with required naming convention
    # Will overwrite existing file
    write_xlsx(Discovery, paste0(path_3, "Chronic Pain WT - All Data.xlsx"))
    
  }