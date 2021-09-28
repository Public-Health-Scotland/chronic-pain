################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_combine_data                                                          
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1                                                                 
#   Packages required: dplyr(1.0.1), readxl(1.3.1), stringr(1.4.0), tidyr(1.1.0)     
#                      writexl(1.3)                                                    
#                                                                                    
#   Description: This script sources the function for combining the historical       
#                ALL DATA file with data from the Current Quarter                    
#                                                                                      
#   NOTE: Update lines 32 - 34 BEFORE running the function                           
#   Line 32: Input last quarter end date):  e.g. "2021-03-31"                                                                         
#   Line 33: Input current quarter end date): e.g. "2021-06-30"                                                                                
#   Line 34: Input current quarter end date): e.g. "2021-06-30"                                                                    
#                                                                                    
#   NOTE: The output file will be saved to 3 locations:                                             
#   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database             
#   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Data\Database\            
#   previous versions                                                                  
#   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery                 
#   \\nssstats01.csa.scot.nhs.uk\WaitingTimes\Chronic-Pain\Discovery\archive         
#                                                                                    
################################################################################

### Source the function for combining the most recent versions of ALLDATA and Current Quarter 
source("//PHI_conf/WaitingTimes/Chronic-Pain/RAP/chronic-pain-main/functions/01_combine_data_function.R")


# Update the dates required as input arguments BEFORE running the function 
Combine_ALLDATA_Currentquarter(date_existing_ALLDATA = "2021-03-31",
                               date_currentquarter = "2021-06-30",
                               date_new_ALLDATA = "2021-06-30")