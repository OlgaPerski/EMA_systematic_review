#when multiple adherence values are reported, calculate the average
#when a range is reported, extract and retain the lower bound

# Use to identify potential values for recoding
# a <- data_raw %>%
#   mutate(num_adherence = as.numeric(percentage_adherence_EMA_general)) %>%
#   filter(is.na(num_adherence)) %>%
#   select(num_adherence, percentage_adherence_EMA_general)
# unique(a$percentage_adherence_EMA_general)
# 
# b <- data_raw %>%
#   mutate(num_adherence = as.numeric(percentage_adherence_EMA_beh)) %>%
#   filter(is.na(num_adherence)) %>%
#   select(num_adherence, percentage_adherence_EMA_beh)
# unique(b$percentage_adherence_EMA_beh)
# 
# c <- data_raw %>%
#   mutate(num_adherence = as.numeric(percentage_adherence_EMA_psych)) %>%
#   filter(is.na(num_adherence)) %>%
#   select(num_adherence, percentage_adherence_EMA_psych)
# unique(c$percentage_adherence_EMA_psych)

adherence_recode <- function(data) {
  adherence_recode <- data %>%
    mutate(percentage_adherence_EMA_general = recode(percentage_adherence_EMA_general,
                                                     "NR" = "NA",
                                                     "For analyses of the daily data, we included participants who completed the online diary 
                                                     for at least 15 days of the 30-day-diary phase during at least 1 year of the study. 
                                                     This inclusion criterion resulted in a fi nal useable sample of 537 participants, 
                                                     with 530 participants responding adequately during Year 1 of the study (99%), 
                                                     452 during Year 2 (85%), and 413 during Year 3 (78%)." = "87.3",
                                                     "NA" = "NA",
                                                     "Retention at each measurement burst from the original sample of 744 students ranged from 
                                                     96.2% in Fall 1st year to 79.4% in Fall 4th year" = "87.8",
                                                     "80.51 (for prompts); 84.30 (for daily assessments)" = "82.4",
                                                     "93-39%" = "39",
                                                     "0.72" = "72",
                                                     "0.91" = "91",
                                                     "66.65 of random prompts" = "66.65",
                                                     "76 (although 85% answered the prompts, only 76% of valid accelerometer data)" = "76",
                                                     "86.7 for morning assessments, 85.9 for random assessments" = "85.9",
                                                     "87.1 (women); 83.1 (men)" = "85.1",
                                                     "88%) of participants completed at least 15 daily surveys" = "NA",
                                                     "92% morning reports, 77% random prompts, 82% for drinking follow-up reports" = "92",
                                                     "EVENT-CONTIGENCY" = "NA",
                                                     "For analyses of the daily data, we included participants who completed the online diary for at least 15 days of the 30-day-diary phase during at least 1 year of the study. This inclusion criterion resulted in a fi nal useable sample of 537 participants, with 530 participants responding adequately during Year 1 of the study (99%), 452 during Year 2 (85%), and 413 during Year 3 (78%)." = "NA",
                                                     "Not applicable (an average of 26.33 (SD= 3.68) diary surveys in Wave 1 and 27.92(SD= 3.33) diary surveys in Wave 2)" = "NA",
                                                     "NR (although the authors suggest a 100% adherence)" = "NA",
                                                     "nr event-contigency reports" = "NA",
                                                     "Participants completed, on average,6.14 (SD= 1.70) daily diary entries out of the possible seven" = "NA",
                                                     "Retention at each measurement burst from the original sample of 744 students ranged from 96.2% in Fall 1st year to 79.4% in Fall 4th year" = "NA"),
           percentage_adherence_EMA_beh = recode(percentage_adherence_EMA_beh,
                                                 "NR" = "NA",
                                                 "NA" = "NA",
                                                 "Missing data on these reports varied across participants, ranging from 0 (n = 25) to 15 (n = 1) days (mean [SD] days = 2.08 [3.19])." = "NA"),
           percentage_adherence_EMA_psych = recode(percentage_adherence_EMA_psych,
                                                 "NR" = "NA",
                                                 "NA" = "NA",
                                                 "0.99" = "99",
                                                 "The amount of missing affect data varied across participants, ranging from 0 (n = 30) to 17 (n = 1) days (mean =1.92 [3.32] days)" = "NA",
                                                 "Participants completed an average of 5.72 ± 0.98 surveys (out of 6) on days included in analyses, and provided data for an average of 6.12 ± 1.56 days." = "NA")) %>%
    naniar::replace_with_na(replace = list(percentage_adherence_EMA_general = "NA",
                                           percentage_adherence_EMA_beh = "NA",
                                           percentage_adherence_EMA_psych = "NA")) %>% #replaces character NAs with real NAs
    mutate(percentage_adherence_EMA_general = as.numeric(percentage_adherence_EMA_general),
           percentage_adherence_EMA_beh = as.numeric(percentage_adherence_EMA_beh),
           percentage_adherence_EMA_psych = as.numeric(percentage_adherence_EMA_psych)) #replaces characters with numbers
}
