################################################################################
#                                                                                    
#   Chronic Pain Publication                                                         
#   Script: 01_2 combine_submission                                                     
#                                                                                    
#   Written for: R Studio Server                                                     
#   R Version: 4.1.2
#
#   Packages required: here(1.0.1), purrr(1.0.1)
#                      
#                                                                                   
#   Description: This script uses map_dfr to run the read_submisson function  
#                and combine 14 quarterly submission files                                
#                                                                                   
################################################################################

### 1 - Get file names and set path ----

# Get list of files

files <- list.files(here("data", "submissions"), full.names = TRUE)


### 2 - Use map_dfr() to run the read_submission function and produce one dataframe

current_quarter <- map_dfr(files, read_submission, current_qtr_end, .id = NULL)


### 3 - Convert WaitTime to a factor and set order of the levels ----

current_quarter$WaitTime <- factor(current_quarter$WaitTime, 
                          levels = c("0 - 7 days (<= 1 week)", "8 - 14 days (<= 2 weeks)",
                                     "15 - 21 days (<= 3 weeks)", "22 - 28 days (<= 4 weeks)",
                                     "29 - 35 days (<= 5 weeks)", "36 - 42 days (<= 6 weeks)",
                                     "43 - 49 days (<= 7 weeks)", "50 - 56 days (<= 8 weeks)",
                                     "57 - 63 days (<= 9 weeks)", "64 - 70 days (<= 10 weeks)",
                                     "71 - 77 days (<= 11 weeks)", "78 - 84 days (<= 12 weeks)",
                                     "85 - 91 days (<= 13 weeks)", "92 - 98 days (<= 14 weeks)",
                                     "99 - 105 days (<= 15 weeks)", "106 - 112 days (<= 16 weeks)",
                                     "113 - 119 days (<= 17 weeks)", "120 - 126 days (<= 18 weeks)",
                                     "127 - 133 days (<= 19 weeks)", "134 - 140 days (<= 20 weeks)",
                                     "141 - 147 days (<= 21 weeks)", "148 - 154 days (<= 22 weeks)",
                                     "155 - 161 days (<= 23 weeks)", "162 - 168 days (<= 24 weeks)",
                                     "169 - 175 days (<= 25 weeks)", "176 - 182 days (<= 26 weeks)",
                                     "183 - 189 days (<= 27 weeks)", "190 - 196 days (<= 28 weeks)",
                                     "197 - 203 days (<= 29 weeks)", "204 - 210 days (<= 30 weeks)",
                                     "211 - 217 days (<= 31 weeks)", "218 - 224 days (<= 32 weeks)",
                                     "225 - 231 days (<= 33 weeks)", "232 - 238 days (<= 34 weeks)",
                                     "239 - 245 days (<= 35 weeks)", "246 - 252 days (<= 36 weeks)",
                                     "253 - 259 days (<= 37 weeks)", "260 - 266 days (<= 38 weeks)",
                                     "267 - 273 days (<= 39 weeks)", "274 - 280 days (<= 40 weeks)",
                                     "281 - 287 days (<= 41 weeks)", "288 - 294 days (<= 42 weeks)",
                                     "295 - 301 days (<= 43 weeks)", "302 - 308 days (<= 44 weeks)",
                                     "309 - 315 days (<= 45 weeks)", "316 - 322 days (<= 46 weeks)",
                                     "323 - 329 days (<= 47 weeks)", "330 - 336 days (<= 48 weeks)",
                                     "337 - 343 days (<= 49 weeks)", "344 - 350 days (<= 50 weeks)",
                                     "351 - 357 days (<= 51 weeks)", "358 - 364 days (<= 52 weeks)",
                                     "365 - 371 days (<= 53 weeks)", "372 - 378 days (<= 54 weeks)",
                                     "379 - 385 days (<= 55 weeks)", "386 - 392 days (<= 56 weeks)",
                                     "393 - 399 days (<= 57 weeks)", "400 - 406 days (<= 58 weeks)",
                                     "407 - 413 days (<= 59 weeks)", "414 - 420 days (<= 60 weeks)",
                                     "421 - 427 days (<= 61 weeks)", "428 - 434 days (<= 62 weeks)",
                                     "435 - 441 days (<= 63 weeks)", "442 - 448 days (<= 64 weeks)",
                                     "449 - 455 days (<= 65 weeks)", "456 - 462 days (<= 66 weeks)",
                                     "463 - 469 days (<= 67 weeks)", "470 - 476 days (<= 68 weeks)",
                                     "477 - 483 days (<= 69 weeks)", "484 - 490 days (<= 70 weeks)",
                                     "491 - 497 days (<= 71 weeks)", "498 - 504 days (<= 72 weeks)",
                                     "505 - 511 days (<= 73 weeks)", "512 - 518 days (<= 74 weeks)",
                                     "519 - 525 days (<= 75 weeks)", "526 - 532 days (<= 76 weeks)",
                                     "533 - 539 days (<= 77 weeks)", "540 - 546 days (<= 78 weeks)",
                                     "547 - 553 days (<= 79 weeks)", "554 - 560 days (<= 80 weeks)",
                                     "561 - 567 days (<= 81 weeks)", "568 - 574 days (<= 82 weeks)",
                                     "575 - 581 days (<= 83 weeks)", "582 - 588 days (<= 84 weeks)",
                                     "589 - 595 days (<= 85 weeks)", "596 - 602 days (<= 86 weeks)",
                                     "603 - 609 days (<= 87 weeks)", "610 - 616 days (<= 88 weeks)",
                                     "617 - 623 days (<= 89 weeks)", "624 - 630 days (<= 90 weeks)",
                                     "631 - 637 days (<= 91 weeks)", "638 - 644 days (<= 92 weeks)",
                                     "645 - 651 days (<= 93 weeks)", "652 - 658 days (<= 94 weeks)",
                                     "659 - 665 days (<= 95 weeks)", "666 - 672 days (<= 96 weeks)",
                                     "673 - 679 days (<= 97 weeks)", "680 - 686 days (<= 98 weeks)",
                                     "687 - 693 days (<= 99 weeks)", "694 - 700 days (<= 100 weeks)",
                                     "701 - 707 days (<= 101 weeks)", "708 - 714 days (<= 102 weeks)",
                                     "715 - 721 days (<= 103 weeks)", "722 - 728 days (<= 104 weeks)",
                                     "> 728 days (>105 weeks)"
                          )
)


### 4 - Create Scotland rows by using the sum_groups function ----

# Remove Health Board column
# Group data use sum_groups() to create Scotland rows
scotland_rows <- current_quarter %>%
  select(-`Health Board`) %>%
  group_by(`Report Date`, `WaitTime`) %>%
  summarise(across(where(is.numeric), ~ sum_groups(.x))) %>%
  ungroup() %>%
  mutate(`Health Board` = "Scotland") %>%
  select(`Health Board`, everything())


### 5 - Combine current_quarter and scotland_rows ----

# Use rbind to bind the scotland_rows onto the bottom of current_quarter
current_quarter <- rbind(current_quarter, scotland_rows) 


### 6 - Write file with current_quarter_end date included in file name  ----

write_rds(current_quarter, paste0(path_input, current_qtr_end, "_current.rds"))


### END OF SCRIPT ###
