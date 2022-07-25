################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_3 combine_data_function                                                 
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

### 1 - Read in ALL DATA file and Current Quarter file ----
    
# Read in most recent ALLDATA file
data <- read_excel(here("data", "input", paste0(previous_qtr_end, " ALL DATA.xlsx")), 
                   col_types = c("text", "date", "text", "numeric", "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric", "numeric", "numeric", "numeric",
                                 "numeric", "numeric")) %>%
  mutate(`Report Date` = as.Date(`Report Date`, "%Y%m%d"))    


# Read in data for current quarter, which has been saved as .rds in input folder
    
# This https://mgimond.github.io/ES218/Week02b.html suggests col types 
# will be preserved. Is this correct? 
    
current <- read_rds(here("data", "input", paste0(current_qtr_end, "_current.rds")))
    
    
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


### 4 - Write dataframes as 2 Excel files to the output folder ----

# Write updated ALL DATA file that will be moved to stats drive
write_xlsx(new_df, paste0(path_output, current_qtr_end, " ALL DATA.xlsx"))

# Write .rds file to use for producing publication outputs and report
write_rds(current_quarter, paste0(path_input, current_qtr_end, " ALL DATA.rds"))

# Write file for Discovery team
write_xlsx(discovery, paste0(path_output, current_qtr_end, " Chronic Pain WT - All Data.xlsx"))



### END OF SCRIPT ###