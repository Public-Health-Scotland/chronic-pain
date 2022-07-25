################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: sum_groups_function                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 3.6.1
#
#   Packages required: 
#                                                                                   
#   Description: This script creates the sum_groups function                                
#                                                                                   
################################################################################

### 1 - Create sum_groups function that will give NA if 14 NAs are added together ----

# Create sum_groups function
sum_groups <- function(x) {
  if(all(is.na(x))) {
    NA
  } else {
    sum(x, na.rm = TRUE)
  }
}


### END OF SCRIPT ###