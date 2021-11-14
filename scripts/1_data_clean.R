source(here::here("scripts", "0_packages_and_data.R"))
source(here::here("scripts", "0_psych_dictionary.R"))
source(here::here("scripts", "0_funder_dictionary.R"))
source(here("scripts", "0_adherence_recode_function.R"))

retained_variables <- c("id", "author", "year", "funder", "doi", "behaviour1", "behaviour1_specifics", "behaviour2", "behaviour2_specifics", "behaviour3", "behaviour3_specifics",
                        "behaviour4", "behaviour4_specifics", "country", "sample_size_consented", "sample_size_analytic_sample", "mean_age", "sd", "median_age", "range",
                        "female_sex_percentage", "ethnicity_white_percentage", "education_university_percentage", "population_type", "population_type_other", "EMA_study_type",
                        "EMA_intervention_level", "burst_design", "nr_bursts", "total_burst_period_weeks", "own_device_EMA", "EMA_delivery_mode", "study_duration_days",
                        "incentive_schedule", "description_incentive_schedule", "percentage_adherence_EMA_general", "percentage_adherence_EMA_beh", "percentage_adherence_EMA_psych",
                        "predictors_adherence", "adherence_cutoff", "minimum_threshold_adherence", "quality1", "quality2", "quality3", "quality4", "quality5")
                        
PA_variables <- c("PA_measurement_type", "PA_EMA_method", "PA_EMA_frequency", "PA_psych_1", "PA_psych_1_type", "PA_psych_1_measurement_type", "PA_psych_1_measure", "PA_psych_1_validated",
                        "PA_psych_1_frequency", "PA_psych_2", "PA_psych_2_type", "PA_psych_2_measurement_type", "PA_psych_2_measure", "PA_psych_2_validated", "PA_psych_2_frequency",
                        "PA_psych_3", "PA_psych_3_type", "PA_psych_3_measurement_type", "PA_psych_3_measure", "PA_psych_3_validated",
                        "PA_psych_3_frequency","PA_psych_4", "PA_psych_4_type", "PA_psych_4_measurement_type", "PA_psych_4_measure", "PA_psych_4_validated",
                        "PA_psych_4_frequency","PA_psych_5", "PA_psych_5_type", "PA_psych_5_measurement_type", "PA_psych_5_measure", "PA_psych_5_validated",
                        "PA_psych_5_frequency", "PA_model_type")
                        
E_variables <- c("E_measurement_type", "E_EMA_method", "E_EMA_frequency", "E_psych_1", "E_psych_1_type", "E_psych_1_measurement_type", "E_psych_1_measure", "E_psych_1_validated",
                        "E_psych_1_frequency", "E_psych_2", "E_psych_2_type", "E_psych_2_measurement_type", "E_psych_2_measure", "E_psych_2_validated", "E_psych_2_frequency",
                        "E_psych_3", "E_psych_3_type", "E_psych_3_measurement_type", "E_psych_3_measure", "E_psych_3_validated",
                        "E_psych_3_frequency","E_psych_4", "E_psych_4_type", "E_psych_4_measurement_type", "E_psych_4_measure", "E_psych_4_validated",
                        "E_psych_4_frequency","E_psych_5", "E_psych_5_type", "E_psych_5_measurement_type", "E_psych_5_measure", "E_psych_5_validated",
                        "E_psych_5_frequency", "E_model_type")
                        
S_variables <- c("S_measurement_type", "S_EMA_method", "S_EMA_frequency", "S_psych_1", "S_psych_1_type", "S_psych_1_measurement_type", "S_psych_1_measure", "S_psych_1_validated",
                 "S_psych_1_frequency", "S_psych_2", "S_psych_2_type", "S_psych_2_measurement_type", "S_psych_2_measure", "S_psych_2_validated", "S_psych_2_frequency",
                 "S_psych_3", "S_psych_3_type", "S_psych_3_measurement_type", "S_psych_3_measure", "S_psych_3_validated",
                 "S_psych_3_frequency","S_psych_4", "S_psych_4_type", "S_psych_4_measurement_type", "S_psych_4_measure", "S_psych_4_validated",
                 "S_psych_4_frequency","S_psych_5", "S_psych_5_type", "S_psych_5_measurement_type", "S_psych_5_measure", "S_psych_5_validated",
                 "S_psych_5_frequency", "S_model_type")

A_variables <- c("A_measurement_type", "A_EMA_method", "A_EMA_frequency", "A_psych_1", "A_psych_1_type", "A_psych_1_measurement_type", "A_psych_1_measure", "A_psych_1_validated",
                 "A_psych_1_frequency", "A_psych_2", "A_psych_2_type", "A_psych_2_measurement_type", "A_psych_2_measure", "A_psych_2_validated", "A_psych_2_frequency",
                 "A_psych_3", "A_psych_3_type", "A_psych_3_measurement_type", "A_psych_3_measure", "A_psych_3_validated",
                 "A_psych_3_frequency","A_psych_4", "A_psych_4_type", "A_psych_4_measurement_type", "A_psych_4_measure", "A_psych_4_validated",
                 "A_psych_4_frequency","A_psych_5", "A_psych_5_type", "A_psych_5_measurement_type", "A_psych_5_measure", "A_psych_5_validated",
                 "A_psych_5_frequency", "A_model_type")

SH_variables <- c("SH_measurement_type", "SH_EMA_method", "SH_EMA_frequency", "SH_psych_1", "SH_psych_1_type", "SH_psych_1_measurement_type", "SH_psych_1_measure", "SH_psych_1_validated",
                  "SH_psych_1_frequency", "SH_psych_2", "SH_psych_2_type", "SH_psych_2_measurement_type", "SH_psych_2_measure", "SH_psych_2_validated", "SH_psych_2_frequency",
                  "SH_psych_3", "SH_psych_3_type", "SH_psych_3_measurement_type", "SH_psych_3_measure", "SH_psych_3_validated",
                  "SH_psych_3_frequency","SH_psych_4", "SH_psych_4_type", "SH_psych_4_measurement_type", "SH_psych_4_measure", "SH_psych_4_validated",
                  "SH_psych_4_frequency","SH_psych_5", "SH_psych_5_type", "SH_psych_5_measurement_type", "SH_psych_5_measure", "SH_psych_5_validated",
                  "SH_psych_5_frequency", "SH_model_type")

data <- df2 %>%
  filter(!str_detect(id, "DC")) %>% #drop double checked rows
  mutate(final_decision = if_else(is.na(final_decision), "include", "exclude")) %>%
  filter(final_decision != "exclude") %>%
  select(all_of(retained_variables),
         all_of(PA_variables),
         all_of(E_variables),
         all_of(S_variables),
         all_of(A_variables),
         all_of(SH_variables))

summary(data)

numeric_cols <- c("sample_size_analytic_sample", "mean_age", "nr_bursts", "study_duration_days", "female_sex_percentage",
                  "ethnicity_white_percentage", "education_university_percentage")

data <- data %>%
  mutate(across(any_of(numeric_cols), as.numeric))

#recode percentage adherence variable with adherence recode function

data <- adherence_recode(data)

#recode funder variable

combined_fund_dictionary <- read_rds(here::here("data", "fund_dictionary.rds"))

data <- data %>%
  separate(col = funder, into = c("funder_1", "funder_2", "funder_3", "funder_4", "funder_5", "funder_6", "funder_7", "funder_8"), sep = "([;])") %>%
  mutate(across(all_of(starts_with("funder")), ~str_trim(., side = "both")),
         across(all_of(starts_with("funder")), ~recode(., !!!combined_fund_dictionary)))

#recode psych variables

PA_constructs <- c("PA_psych_1_1", "PA_psych_1_2", "PA_psych_1_3", "PA_psych_1_4","PA_psych_1_5",
                   "PA_psych_1_6", "PA_psych_1_7", "PA_psych_1_8", "PA_psych_1_9", "PA_psych_1_10",
                   "PA_psych_2_1", "PA_psych_2_2", "PA_psych_2_3", "PA_psych_2_4","PA_psych_2_5",
                   "PA_psych_3_1", "PA_psych_3_2", "PA_psych_3_3", "PA_psych_4_1", "PA_psych_4_2",
                   "PA_psych_4_3", "PA_psych_5_1", "PA_psych_5_2", "PA_psych_5_3")
E_constructs <- c("E_psych_1_1", "E_psych_1_2", "E_psych_1_3", "E_psych_1_4",
                  "E_psych_1_5", "E_psych_1_6", "E_psych_1_7", "E_psych_1_8",
                  "E_psych_1_9", "E_psych_1_10", "E_psych_2_1", "E_psych_2_2",
                  "E_psych_2_3", "E_psych_2_4","E_psych_2_5", "E_psych_3_1",
                  "E_psych_3_2", "E_psych_3_3", "E_psych_4_1", "E_psych_4_2",
                  "E_psych_4_3", "E_psych_5_1", "E_psych_5_2", "E_psych_5_3")
S_constructs <- c("S_psych_1_1", "S_psych_1_2", "S_psych_1_3", "S_psych_1_4",
                  "S_psych_1_5", "S_psych_1_6", "S_psych_1_7", "S_psych_1_8",
                  "S_psych_1_9", "S_psych_1_10", "S_psych_2_1", "S_psych_2_2",
                  "S_psych_2_3", "S_psych_2_4","S_psych_2_5", "S_psych_3_1",
                  "S_psych_3_2", "S_psych_3_3", "S_psych_4_1", "S_psych_4_2",
                  "S_psych_4_3", "S_psych_5_1", "S_psych_5_2", "S_psych_5_3")
A_constructs <- c("A_psych_1_1", "A_psych_1_2", "A_psych_1_3", "A_psych_1_4",
                  "A_psych_1_5", "A_psych_1_6", "A_psych_1_7", "A_psych_1_8",
                  "A_psych_1_9", "A_psych_1_10", "A_psych_2_1", "A_psych_2_2",
                  "A_psych_2_3", "A_psych_2_4","A_psych_2_5", "A_psych_3_1",
                  "A_psych_3_2", "A_psych_3_3", "A_psych_4_1", "A_psych_4_2",
                  "A_psych_4_3", "A_psych_5_1", "A_psych_5_2", "A_psych_5_3")
SH_constructs <- c("SH_psych_1_1", "SH_psych_1_2", "SH_psych_1_3", "SH_psych_1_4",
                   "SH_psych_1_5", "SH_psych_1_6", "SH_psych_1_7", "SH_psych_1_8",
                   "SH_psych_1_9", "SH_psych_1_10", "SH_psych_2_1", "SH_psych_2_2",
                   "SH_psych_2_3", "SH_psych_2_4","SH_psych_2_5", "SH_psych_3_1",
                   "SH_psych_3_2", "SH_psych_3_3", "SH_psych_4_1", "SH_psych_4_2",
                   "SH_psych_4_3", "SH_psych_5_1", "SH_psych_5_2", "SH_psych_5_3")

all_constructs <- c(PA_constructs, E_constructs, S_constructs, A_constructs, SH_constructs)

combined_psych_dictionary <- read_rds(here::here("data", "psych_dictionary.rds"))

data <- data %>%
  separate(col = "PA_psych_1", sep = ",", into = c("PA_psych_1_1", "PA_psych_1_2", "PA_psych_1_3", "PA_psych_1_4","PA_psych_1_5",
                                                   "PA_psych_1_6", "PA_psych_1_7", "PA_psych_1_8", "PA_psych_1_9", "PA_psych_1_10")) %>%
  separate(col = "PA_psych_2", sep = ",", into = c("PA_psych_2_1", "PA_psych_2_2", "PA_psych_2_3", "PA_psych_2_4","PA_psych_2_5")) %>%
  separate(col = "PA_psych_3", sep = ",", into = c("PA_psych_3_1", "PA_psych_3_2", "PA_psych_3_3")) %>%
  separate(col = "PA_psych_4", sep = ",", into = c("PA_psych_4_1", "PA_psych_4_2", "PA_psych_4_3")) %>%
  separate(col = "PA_psych_5", sep = ",", into = c("PA_psych_5_1", "PA_psych_5_2", "PA_psych_5_3")) %>%
  separate(col = "E_psych_1", sep = ",", into = c("E_psych_1_1", "E_psych_1_2", "E_psych_1_3", "E_psych_1_4","E_psych_1_5",
                                                  "E_psych_1_6", "E_psych_1_7", "E_psych_1_8", "E_psych_1_9", "E_psych_1_10")) %>%
  separate(col = "E_psych_2", sep = ",", into = c("E_psych_2_1", "E_psych_2_2", "E_psych_2_3", "E_psych_2_4","E_psych_2_5")) %>%
  separate(col = "E_psych_3", sep = ",", into = c("E_psych_3_1", "E_psych_3_2", "E_psych_3_3")) %>%
  separate(col = "E_psych_4", sep = ",", into = c("E_psych_4_1", "E_psych_4_2", "E_psych_4_3")) %>%
  separate(col = "E_psych_5", sep = ",", into = c("E_psych_5_1", "E_psych_5_2", "E_psych_5_3")) %>%
  separate(col = "S_psych_1", sep = ",", into = c("S_psych_1_1", "S_psych_1_2", "S_psych_1_3", "S_psych_1_4","S_psych_1_5",
                                                  "S_psych_1_6", "S_psych_1_7", "S_psych_1_8", "S_psych_1_9", "S_psych_1_10")) %>%
  separate(col = "S_psych_2", sep = ",", into = c("S_psych_2_1", "S_psych_2_2", "S_psych_2_3", "S_psych_2_4","S_psych_2_5")) %>%
  separate(col = "S_psych_3", sep = ",", into = c("S_psych_3_1", "S_psych_3_2", "S_psych_3_3")) %>%
  separate(col = "S_psych_4", sep = ",", into = c("S_psych_4_1", "S_psych_4_2", "S_psych_4_3")) %>%
  separate(col = "S_psych_5", sep = ",", into = c("S_psych_5_1", "S_psych_5_2", "S_psych_5_3")) %>%
  separate(col = "A_psych_1", sep = ",", into = c("A_psych_1_1", "A_psych_1_2", "A_psych_1_3", "A_psych_1_4","A_psych_1_5",
                                                  "A_psych_1_6", "A_psych_1_7", "A_psych_1_8", "A_psych_1_9", "A_psych_1_10")) %>%
  separate(col = "A_psych_2", sep = ",", into = c("A_psych_2_1", "A_psych_2_2", "A_psych_2_3", "A_psych_2_4","A_psych_2_5")) %>%
  separate(col = "A_psych_3", sep = ",", into = c("A_psych_3_1", "A_psych_3_2", "A_psych_3_3")) %>%
  separate(col = "A_psych_4", sep = ",", into = c("A_psych_4_1", "A_psych_4_2", "A_psych_4_3")) %>%
  separate(col = "A_psych_5", sep = ",", into = c("A_psych_5_1", "A_psych_5_2", "A_psych_5_3")) %>%
  separate(col = "SH_psych_1", sep = ",", into = c("SH_psych_1_1", "SH_psych_1_2", "SH_psych_1_3", "SH_psych_1_4","SH_psych_1_5",
                                                   "SH_psych_1_6", "SH_psych_1_7", "SH_psych_1_8", "SH_psych_1_9", "SH_psych_1_10")) %>%
  separate(col = "SH_psych_2", sep = ",", into = c("SH_psych_2_1", "SH_psych_2_2", "SH_psych_2_3", "SH_psych_2_4","SH_psych_2_5")) %>%
  separate(col = "SH_psych_3", sep = ",", into = c("SH_psych_3_1", "SH_psych_3_2", "SH_psych_3_3")) %>%
  separate(col = "SH_psych_4", sep = ",", into = c("SH_psych_4_1", "SH_psych_4_2", "SH_psych_4_3")) %>%
  separate(col = "SH_psych_5", sep = ",", into = c("SH_psych_5_1", "SH_psych_5_2", "SH_psych_5_3")) %>%
  mutate(across(all_of(all_constructs), ~str_trim(., side = "both")),
         across(all_of(all_constructs), ~recode(., !!!combined_psych_dictionary)),
         across(all_of(all_constructs), ~factor(.)))

# save data ---------------------------------------------------------------

write_rds(data, here("data", "data_clean.rds"))
