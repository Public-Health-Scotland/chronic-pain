################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_data_function                                                 
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1                                                                 
#   Packages required: dplyr(1.0.1), readxl(1.3.1), stringr(1.4.0), tidyr(1.1.0)     
#                      writexl(1.3), openxlsx(4.1.5)                                                    
#                                                                                    
#   Description: This function combines the historical ALL DATA file                 
#   with data from the Current Quarter                                               
#                                                                                      
#   NOTE: Two output files will be saved to the output folder:  
#   - One file will be the updated ALL DATA file that will be used for analysis
#   - One file will be for Discovery   
#                                                                                    
################################################################################

### Function for combining ALLDATA and the Current quarter files 
combine_data <- 
  function(previous_qtr_end, current_qtr_end)
  {
    ### 1 - Read in ALL DATA file and Current Quarter file ----
    
    # Read in most recent ALLDATA file
    #data <- read_excel(paste0(path_alldata, previous_qtr_end, " ALL DATA.xlsx"),
    data <- read_excel(here("data", "input", paste0(previous_qtr_end, " ALL DATA.xlsx")), 
                       col_types = c("text", "date", "text", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                     "numeric", "numeric")) %>% 
                       mutate(`Report Date` = as.Date(`Report Date`, "%Y%m%d"))
    
    # Read in Current data but need to save as Excel workbook without macro / formulas                    
    #current <- read_excel(paste0(path_currentquarter, current_qtr_end, ".xlsx"),
    current <- read_excel(here("data", "input", paste0(current_qtr_end, ".xlsx")),
                          col_types = c("text", "date", "text", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                        "numeric", "numeric")) %>% 
                       mutate(`Report Date` = as.Date(`Report Date`, "%Y%m%d"))
    
    
    ### 2 - Bind the 2 dataframes ----
    # Use rbind to bind the current quarter to the bottom of ALL DATA
    new_df <- rbind(data, current)
    
    
    ### 3 - Create df for Discovery with 2 new variables ----
    discovery <- new_df %>%
      mutate(WaitDays = str_split_fixed(WaitTime, "[(]",  2)[,1]) %>%
      mutate(WaitWeeks = str_split_fixed(WaitTime, "[(]",  2)[,2]) %>%
      select(`Health Board`, `Report Date`, WaitTime, WaitDays, WaitWeeks, everything())
    
    # Trim trailing white space
    discovery$WaitDays <- trimws(discovery$WaitDays)
    
    # Recode "> 728 days" 
    discovery %<>% 
      mutate(WaitDays = recode(WaitDays, 
                                `> 728 days` = "728 days or more",
                                .default = levels(WaitDays)))
    
    # Extract digits from strings
    discovery$WaitWeeks <- str_extract(discovery$WaitWeeks, "[0-9]+")
    
    
    ### 4 - Write dataframes to 2 Excel files ----
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database
    #path_1 = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/"
    
    # Write Excel file
    #write_xlsx(new_df, paste0(path_1, current_qtr_end, " ALL DATA.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database\previous versions
    #path_2 = "//PHI_conf/WaitingTimes/Chronic-Pain/Data/Database/previous versions/"
    
    # Write updated ALL DATA file
    write_xlsx(new_df, paste0(path_newalldata, current_qtr_end, " ALL DATA.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery\archive
    #path_3 = "//PHI_conf/WaitingTimes/Chronic-Pain/Discovery/archive/"

    # Write file for Discovery team
    write_xlsx(discovery, paste0(path_discovery, current_qtr_end, " Chronic Pain WT - All Data.xlsx"))
    
    # Set path for exporting to \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery
    #path_4 = "//PHI_conf/WaitingTimes/Chronic-Pain/Discovery/"
    
    # Write Excel file for Discovery with required naming convention
    # Will overwrite existing file
    #write_xlsx(discovery, paste0(path_4, "Chronic Pain WT - All Data.xlsx"))

  }


### END OF SCRIPT ###