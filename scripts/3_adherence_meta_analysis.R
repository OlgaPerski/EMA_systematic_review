source(here::here("scripts", "0_packages.R"))

data_duplicate_ids <- read_xlsx(here("data","data_raw.xlsx"),sheet="data_duplicates") %>%
  filter(Multi_paper_study == 1 & Duplicate == 1) %>%
  pull(id)

data_clean <- read_rds(here("data", "data_clean.rds")) %>%
  filter(!id %in% data_duplicate_ids)

data_clean <- data_clean %>%
  mutate(frequency = as.factor(coalesce(PA_psych_1_frequency,
                              A_psych_1_frequency,
                              S_psych_1_frequency,
                              E_psych_1_frequency,
                              SH_psych_1_frequency)))

data_clean <- data_clean %>%
  mutate(prompting = as.factor(coalesce(PA_EMA_method,
                                        A_EMA_method,
                                        S_EMA_method,
                                        E_EMA_method,
                                        SH_EMA_method)))

data_clean$behaviour1 <- as.factor(data_clean$behaviour1)

#prepare moderator vars for random-effects meta-analysis

moderators <- data_clean %>%
  mutate(adherence = coalesce(percentage_adherence_EMA_general, percentage_adherence_EMA_beh, percentage_adherence_EMA_psych),
         country_ma = as.factor(case_when(country == "United States" ~ "US",
                                          TRUE ~ "Other")),
         pop_ma = as.factor(case_when(population_type == "General population" ~ "General population",
                                      population_type == "Students" ~ "Students",
                                      TRUE ~ "Other")),
         EMA_study_type_ma = as.factor(case_when(EMA_study_type == "Observational" ~ "Observational",
                                       EMA_study_type == "Interventional" ~ "Interventional",
                                       TRUE ~ "Observational")),
         EMA_delivery_mode_ma = as.factor(case_when(EMA_delivery_mode == "Mobile phone - SMS" ~ "Mobile phone/smartphone",
                                          EMA_delivery_mode == "Mobile phone - app" ~ "Mobile phone/smartphone",
                                          EMA_delivery_mode == "Mobile phone - multiple/other" ~ "Mobile phone/smartphone",
                                          EMA_delivery_mode == "Handheld device" ~ "Handheld device",
                                          EMA_delivery_mode == "Pen-and-paper" ~ "Pen-and-paper",
                                          EMA_delivery_mode == "Wrist-worn device" ~ "Wrist/hip/thigh-worn device",
                                          EMA_delivery_mode == "Website/online" ~ "Website/online",
                                          EMA_delivery_mode == "Hip/thigh-worn device" ~ "Wrist/hip/thigh-worn device",
                                          EMA_delivery_mode == "Multiple" ~ "Multiple",
                                          EMA_delivery_mode == "Other" ~ "Other",
                                          TRUE ~ "Not reported")),
         own_device_EMA_ma = as.factor(case_when(own_device_EMA == "All" ~ "All/majority",
                                       own_device_EMA == "Some" ~ "Some",
                                       own_device_EMA == "None" ~ "None",
                                       TRUE ~ "Not applicable")),
         year_ma = (as.numeric(year)-1987)/10,
         study_days_ma = as.numeric(study_duration_days - mean(study_duration_days, na.rm=T)), #mean center study duration var
         incentive_schedule_ma = as.factor(case_when(incentive_schedule == "Flat payment based on study completion" ~ "Incentive",
                                           incentive_schedule == "Flat payment irrespective of study completion" ~ "Incentive",
                                           incentive_schedule == "Payment per EMA" ~ "Incentive",
                                           incentive_schedule == "Course credit" ~ "Incentive",
                                           incentive_schedule == "Prize draw" ~ "Incentive",
                                           incentive_schedule == "None" ~ "No incentive",
                                           incentive_schedule == "Multiple" ~ "Incentive",
                                           incentive_schedule == "Other" ~ "Incentive",
                                           incentive_schedule == "Not reported" ~ "Not reported",
                                           incentive_schedule == "NR" ~ "Not reported",
                                           TRUE ~ "Not reported")),
         frequency_ma = as.factor(case_when(frequency == "daily on the EMA days" ~ "Daily",
                                            frequency == "Weekly/Thursday, Friday and Saturday" ~ "Weekly",
                                            frequency == "NA" ~ "Not reported",
                                            frequency == "Daily" ~ "Daily",
                                            frequency == "Hourly" ~ "Hourly/multiple times per day",
                                            frequency == "Weekly" ~ "Weekly",
                                            frequency == "Multiple times per day" ~ "Hourly/multiple times per day")),
         prompting_ma = as.factor(case_when(prompting == "Event contingent" ~ "Event contingent",
                                            prompting == "NA" ~ "Not reported",
                                            prompting == "not reported" ~ "Not reported",
                                            prompting == "Fixed (e.g. every evening)" ~ "Fixed",
                                            prompting == "Multiple" ~ "Multiple",
                                            prompting == "Signal contingent - fixed timing" ~ "Signal contingent - fixed timing",
                                            prompting == "Signal contingent - random timing" ~ "Signal contingent - random timing")),
         adherence_cutoff_ma = as.factor(case_when(adherence_cutoff == "No" ~ "No",
                                                   adherence_cutoff == "Yes" ~ "Yes",
                                                   TRUE ~ "Not reported")))

moderators$country_ma <- relevel(moderators$country_ma, "Other")
moderators$pop_ma <- relevel(moderators$pop_ma, "General population")
moderators$EMA_study_type_ma <- relevel(moderators$EMA_study_type_ma, "Observational")
moderators$EMA_delivery_mode_ma <- relevel(moderators$EMA_delivery_mode_ma, "Handheld device")
moderators$own_device_EMA_ma <- relevel(moderators$own_device_EMA_ma, "None")
moderators$incentive_schedule_ma <- relevel(moderators$incentive_schedule_ma, "No incentive")
moderators$frequency_ma <- relevel(moderators$frequency_ma, "Weekly")
moderators$behaviour1 <- relevel(moderators$behaviour1, "Sexual health")
moderators$prompting_ma <- relevel(moderators$prompting_ma, "Fixed")
moderators$adherence_cutoff_ma <- relevel(moderators$adherence_cutoff_ma, "No")

#prepare data for meta-analysis

vars <- c("author", "year", "sample_size_analytic_sample", "adherence", "country_ma", "pop_ma", "behaviour1",
          "incentive_schedule_ma", "EMA_study_type_ma", "EMA_delivery_mode_ma", "frequency_ma", 
          "own_device_EMA_ma", "year_ma", "prompting_ma", "adherence_cutoff_ma", "study_days_ma")

df <- moderators %>%
  select(any_of(vars)) %>%
  filter(complete.cases(.)) %>%
  mutate(sample_size_analytic_sample = as.numeric(sample_size_analytic_sample),
         adherence_prop = adherence/100,
         number_event = adherence_prop*sample_size_analytic_sample)

df <- droplevels(df)

adherence_ES <- escalc(measure = "PR", xi = number_event, ni = sample_size_analytic_sample, data = df, slab=paste(author, year, sep=", "))

#random-effects meta-analysis without moderators

ma1 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES)

predict(ma1)

#random-effects meta-analysis with moderators

ma2 <- rma(yi, vi, mods = ~factor(country_ma) + factor(pop_ma) + factor(incentive_schedule_ma) + factor(EMA_study_type_ma) +
             factor(EMA_study_type_ma) + factor(EMA_delivery_mode_ma) + factor(frequency_ma) + + factor(prompting_ma) +
             factor(own_device_EMA_ma) + factor(behaviour1) + factor(adherence_cutoff_ma) + year_ma + study_days_ma, method = "ML", level = 95, data = adherence_ES)

summary(ma2)

model_results <- tibble("variables" = attr(ma2$beta, "dimnames")[[1]], "beta" = round(ma2$beta[,1], 3), "lower_ci" = round(ma2$ci.lb, 3), 
                        "upper_ci" = round(ma2$ci.ub, 3), "p" = round(ma2$pval, 3))

write.table(model_results, here("outputs", "model_table.txt"), sep = ",")

#random-effects meta-analyses by target behaviour

ma1_1 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES, subset = (behaviour1 == "Alcohol"))
ma1_2 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES, subset = (behaviour1 == "Smoking"))
ma1_3 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES, subset = (behaviour1 == "Physical activity"))
ma1_4 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES, subset = (behaviour1 == "Healthy eating"))
ma1_5 <- rma(yi, vi, method = "ML", level = 95, data = adherence_ES, subset = (behaviour1 == "Sexual health"))

png(filename = "ma_alcohol.png", width = 1280, height = 1820)
forest.rma(ma1_1, ilab.xpos = c(-0.25), cex=1)
dev.off()
png(filename = "ma_smoking.png", width = 1280, height = 1820)
forest.rma(ma1_2, ilab.xpos = c(-0.25), cex=1)
dev.off()
png(filename = "ma_activity.png", width = 1280, height = 1820)
forest.rma(ma1_3, ilab.xpos = c(-0.25), cex=1)
dev.off()
png(filename = "ma_eating.png", width = 1280, height = 1820)
forest.rma(ma1_4, ilab.xpos = c(-0.25), cex=1)
dev.off()
png(filename = "ma_sexual_health.png", width = 1280, height = 1820)
forest.rma(ma1_5, ilab.xpos = c(-0.25), cex=1)
dev.off()
