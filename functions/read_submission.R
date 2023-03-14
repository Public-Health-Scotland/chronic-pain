################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: read_submission_function                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 4.1.2
#
#   Packages required: dplyr(1.0.1), openxlsx(4.2.5.2), purrr(1.0.1), 
#                      tidyr(1.3.0)
#                       
#                                                                                   
#   Description: This script reads V3 of quarterly submission form                                 
#                                                                                   
################################################################################

### Function for combining 14 quarterly submissions 
read_submission <- 
  function(files, current_qtr_end)
  {
    ### 1 - Create df containing current_quarter_end and read in Board name ----
    
    # Create dataframe containing current_qtr_end
    date <- as.data.frame(current_qtr_end) %>%
      rename(`Report Date` = `current_qtr_end`)
    
    # Read in Board name from B8 on NHS Board details sheet
    board <- read.xlsx(files, 
                       sheet = 4, 
                       skipEmptyRows = TRUE, 
                       cols = 2, 
                       rows = 8, 
                       colNames = FALSE) %>%
      rename(`Health Board` = `X1`)
    
    
    ### 2 - Create WaitTime column ----
    
    # Read in WaitTime bands 
    waittime <- read.xlsx(files, 
                          sheet = 5, 
                          skipEmptyRows = TRUE, 
                          cols = 3:108, 
                          rows = 5, 
                          colNames = FALSE) %>%
      pivot_longer(cols = `X1`:`X105`, 
                   values_to = "WaitTime") %>%
      select(-name)
    
    # Trim trailing white space, so that text for the waiting time bands 
    # matches the text in the ALL DATA file
    waittime$WaitTime <- trimws(waittime$WaitTime)
    
    
    ### 3 - Read in adjusted data ----
    
    # Read in all adjusted data
    
    adj <- read.xlsx(files, 
                     sheet = 5,
                     cols = 3:108, 
                     rows = c(5:10)) %>%
      pivot_longer(cols = `0.-.7.days.(<=.1.week)`:`>.728.days.(>105.weeks)`,
                   names_to = "Wait_Time",
                   values_to = "count") %>%
      pivot_wider(names_from = "X1",
                  values_from = "count") %>%
      select(-Wait_Time) %>%
      cbind(waittime) %>%
      rename(`adj patients waiting at pain clinic` = `Pain Clinic - Patients on the waiting list for a 1st appointment/assessment at a pain clinic/service (ongoing waits)`) %>%
      rename(`adj patients waiting at Pain psyc` = `Pain Psychology -  Patients on the waiting list for a 1st appointment/assessment at a pain pyschology service (ongoing waits)`) %>%
      rename(`adj patients seen at pain clinic` = `Pain Clinic - Experienced (actual) waiting time for 1st appointment/assessment at a pain clinic/service (completed waits)`) %>%
      rename(`adj patients seen pain psyc` = `Pain Psychology - Experienced (actual) waiting time for 1st appointment/assessment at a pain clinic/service (completed waits)`) %>%
      select(WaitTime, 
             `adj patients waiting at pain clinic`, 
             `adj patients waiting at Pain psyc`, 
             `adj patients seen at pain clinic`,
             `adj patients seen pain psyc`)
    
    
    ### 4 - Read in unadjusted data ----
    
    # Read in all unadjusted data
    unadj <- read.xlsx(files, 
                       sheet = 6,
                       cols = 3:108, 
                       rows = c(5:10)) %>%
      pivot_longer(cols = `0.-.7.days.(<=.1.week)`:`>.728.days.(>105.weeks)`,
                   names_to = "Wait_Time",
                   values_to = "count") %>%
      pivot_wider(names_from = "X1",
                  values_from = "count") %>%
      select(-Wait_Time) %>%
      cbind(waittime) %>%
      rename(`unadj patients waiting at pain clinic` = `Pain Clinic - Patients on the waiting list for a 1st appointment/assessment at a pain clinic/service (ongoing waits)`) %>%
      rename(`unadj patients waiting at Pain psyc` = `Pain Psychology -  Patients on the waiting list for a 1st appointment/assessment at a pain pyschology service (ongoing waits)`) %>%
      rename(`unadj patients seen at pain clinic` = `Pain Clinic - Experienced (actual) waiting time for 1st appointment/assessment at a pain clinic/service (completed waits)`) %>%
      rename(`unadj patients seen pain psyc` = `Pain Psychology - Experienced (actual) waiting time for 1st appointment/assessment at a pain clinic/service (completed waits)`) %>%
      select(WaitTime, 
             `unadj patients waiting at pain clinic`, 
             `unadj patients waiting at Pain psyc`, 
             `unadj patients seen at pain clinic`,
             `unadj patients seen pain psyc`)
    
    
    ### 5 - Read in Referrals data ----
    
    # Column 1 is included and then dropped incase there is a full row of NAs.
    # This would create an empty df and cbind() doesn't work
    
    # Read in pain clinic data from the Referrals tab
    ref_pc <- read.xlsx(path, 
                        sheet = 7, 
                        skipEmptyRows = TRUE,
                        cols = 1:5, 
                        rows = c(8, 9)) %>%
      select(-X1) %>%
      rename(`Pain Clinic Referrals` = `Total.referrals`) %>%
      rename(`Pain clinic rejected referrals` = `Rejected.referrals`) %>%
      rename(`No of 1st Pain Clinic appointments` = `Number.of.patients.seen`) %>%
      rename(`No of 1st appointment pain clinic DNA's` = `Number.of.DNAs.for.1st.appt`)
    
    
    # Read in pain psychology data from the Referrals tab
    ref_pp <- read.xlsx(path, 
                        sheet = 7, 
                        skipEmptyRows = TRUE,
                        cols = 1:5, 
                        rows = c(8, 10)) %>%
      select(-X1) %>%
      rename(`Pain Psychology Referrals` = `Total.referrals`) %>%
      rename(`Pain Psychology rejected referrals` = `Rejected.referrals`) %>%
      rename(`No of 1st pain psychology appointments` = `Number.of.patients.seen`) %>%
      rename(`No of 1st appointments pain psychology DNA's` = `Number.of.DNAs.for.1st.appt`)
    
    
    ### 6 - Read in Removals data  ----
    
    # Column 1 is included and then dropped incase there is a full row of NAs.
    # This would create an empty df and cbind() doesn't work
    
    # Read in Removals data
    removals <- read.xlsx(path, 
                          sheet = 8, 
                          skipEmptyRows = TRUE, 
                          cols = 1:3, 
                          rows = c(8, 9)) %>%
      select(-X1) %>%
      rename(`Pain clinic removal reasons` = `Removed.from.list.for.Pain.clinic./service`) %>%
      rename(`Pain Psychology removal reasons` = `Removed.from.list.for.Pain.psychology`)
    
    
    ### 7 - Create one dataframe for the Board  ----
    
    current_quarter <- left_join(adj, unadj, by = "WaitTime") %>%
      cbind(ref_pc,
            ref_pp,
            removals,
            date,
            board,
            row.names = NULL) %>%
      select(`Health Board`, 
             `Report Date`, 
             everything()) %>%
      mutate(suppressWarnings(across(`adj patients waiting at pain clinic`:`Pain Psychology removal reasons`, as.numeric)))
    
  }


### END OF SCRIPT ###
