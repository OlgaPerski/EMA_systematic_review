source(here::here("scripts", "0_packages.R"))

data_clean <- read_rds(here("data", "data_clean.rds"))

source(here("scripts", "0_helper_vectors.R"))

# study characteristics ---------------------------------------------------

# create a study map ---------------------------------------------------------

world <- ne_countries(returnclass = "sf") %>%
  select(iso_a3, continent) %>%
  rename("country_iso3" = iso_a3) %>%
  filter(continent != "Antarctica")

map_studies <- data_clean %>%
  mutate(country_iso3 = countrycode(country, origin = "country.name.en", destination = "iso3c")) %>%
  group_by(country_iso3) %>%
  summarise(n = n()) %>%
  drop_na(country_iso3) %>%
  full_join(., world, by = "country_iso3") %>%
  st_as_sf()

fig_2 <- tm_shape(map_studies) +
  tm_polygons(col = "n",
              palette = "PuBu",
              style = "fixed",
              breaks = c(1, 2, 4, 10, 20, 30, 50, 500),
              title = "Number of studies",
              textNA = "No included studies",
              lwd = 0.2)

if(!file.exists(here("outputs", "fig_2.png"))) tmap_save(fig_2, filename = here("outputs", "fig_2.png"), dpi = 320)

# studies over time, split by behaviour -------------------------------------------------------

fig_3 <- data_clean %>%
  ggplot(aes(x = year, fill = behaviour1)) +
  geom_bar() +
  theme_minimal() +
  scale_fill_manual(values = colour_palette) +
  facet_wrap(~ behaviour1, scales = "free") +
  labs(x  = NULL,
       y = "Number of studies") +
  theme(legend.position = "none") +
  theme(axis.line=element_line()) + 
  scale_x_continuous(limits=c(1985,2021)) + scale_y_continuous(limits=c(0,40))

if(!file.exists(here("outputs", "fig_3.png"))) ggsave(fig_3, filename = here("outputs", "fig_3.png"), dpi = 320, height = 8, width = 10)

# create table 1 ----------------------------------------------------------

table_1_prep <- data_clean %>%
  mutate(unite(across(any_of(starts_with("funder_")), ~case_when(.x == "research" ~ "Yes")), col = "research_funded", na.rm = T),
         research_funded = case_when(str_detect(research_funded, "Yes") ~ "Yes",
                                     TRUE ~ "No"),
         unite(across(any_of(starts_with("funder_")), ~case_when(.x == "society" ~ "Yes")), col = "society_funded", na.rm = T),
         society_funded = case_when(str_detect(society_funded, "Yes") ~ "Yes",
                                    TRUE ~ "No"),
         unite(across(any_of(starts_with("funder_")), ~case_when(.x == "charity" ~ "Yes")), col = "charity_funded", na.rm = T),
         charity_funded = case_when(str_detect(charity_funded, "Yes") ~ "Yes",
                                    TRUE ~ "No"),
         unite(across(any_of(starts_with("funder_")), ~case_when(.x == "university_health_institution" ~ "Yes")), col = "university_health_institution_funded", na.rm = T),
         university_health_institution_funded = case_when(str_detect(university_health_institution_funded, "Yes") ~ "Yes",
                                                          TRUE ~ "No"),
         unite(across(any_of(starts_with("funder_")), ~case_when(.x == "industry" ~ "Yes")), col = "industry_funded", na.rm = T),
         industry_funded = case_when(str_detect(industry_funded, "Yes") ~ "Yes",
                                     TRUE ~ "No"),
         unite(across(any_of(starts_with("funder_")), ~case_when(.x == "none" ~ "Yes")), col = "unfunded", na.rm = T),
         unfunded = case_when(str_detect(unfunded, "Yes") ~ "Yes",
                              TRUE ~ "No"),
         across(where(is.factor), ~fct_infreq(.)))

table_1_prep_recode <- table_1_prep %>%
  mutate(incentive_schedule_recode = recode(incentive_schedule, "NR" = "Not reported"),
         EMA_intervention_level_recode = recode(EMA_intervention_level, "NA" = "Not applicable"),
         country_recode = recode(country, "NR" = "Not reported"),
         sample_size_analytic_sample = as.numeric(sample_size_analytic_sample))

mylabels <- list(country_recode = "Country", research_funded = "Research funding", society_funded = "Society funding", 
                 charity_funded = "Charity funding", university_health_institution_funded = "University/Health institution funding",
                 industry_funded = "Industry funding", unfunded = "No funding",
                 EMA_study_type = "Study design", EMA_intervention_level_recode = "Intervention level", 
                 behaviour1 = "Target behaviour", population_type = "Population Type", 
                 sample_size_analytic_sample = "Sample size", mean_age = "Age", 
                 female_sex_percentage = "% Female", ethnicity_white_percentage = "% White ethnicity", 
                 education_university_percentage = "% University education",
                 incentive_schedule_recode = "Incentive schedule")

mycontrols <- tableby.control(numeric.stats = c("Nmiss", "median", "q1q3"),
                              stats.labels = list(N="Not reported", median = "Median", q1q3 = "IQR"))

t1_total <- tableby(~ country_recode + research_funded + society_funded + charity_funded + university_health_institution_funded + industry_funded + unfunded +
                      EMA_study_type + EMA_intervention_level_recode + behaviour1 + population_type + sample_size_analytic_sample +
                      mean_age + female_sex_percentage + ethnicity_white_percentage + 
                      education_university_percentage + incentive_schedule_recode, data = table_1_prep_recode, control = mycontrols, cat.simplify = F)

t1_strata <- tableby(~ country_recode + research_funded + society_funded + charity_funded + university_health_institution_funded + industry_funded + unfunded +
                EMA_study_type + EMA_intervention_level_recode + behaviour1 + population_type + sample_size_analytic_sample +
                mean_age + female_sex_percentage + ethnicity_white_percentage + 
                education_university_percentage + incentive_schedule_recode, data = table_1_prep_recode, control = mycontrols, strata = behaviour1, cat.simplify = F)

t1_total <- summary(t1_total, text = T, labelTranslations = mylabels, digits = 1)
t1_strata <- summary(t1_strata, text = T, labelTranslations = mylabels, digits = 1)

write2word(t1_total,here("outputs","table1_total.doc"))
write2word(t1_strata,here("outputs","table1_strata.doc"))

#proportion sub-behaviours within each target behaviour

data_clean %>%
  filter(behaviour1 == "Alcohol") %>%
  group_by(behaviour1_specifics) %>%
  summarise(n=n()) %>%
  mutate(prop = round(n/sum(n)*100, digits = 1)) %>%
  arrange(-prop)

data_clean %>%
  filter(behaviour1 == "Physical activity") %>%
  group_by(behaviour1_specifics) %>%
  summarise(n=n()) %>%
  mutate(prop = round(n/sum(n)*100, digits = 1)) %>%
  arrange(-prop)

data_clean %>%
  filter(behaviour1 == "Smoking") %>%
  group_by(behaviour1_specifics) %>%
  summarise(n=n()) %>%
  mutate(prop = round(n/sum(n)*100, digits = 1)) %>%
  arrange(-prop)

data_clean %>%
  filter(behaviour1 == "Healthy eating") %>%
  group_by(behaviour1_specifics) %>%
  summarise(n=n()) %>%
  mutate(prop = round(n/sum(n)*100, digits = 1)) %>%
  arrange(-prop)

data_clean %>%
  filter(behaviour1 == "Sexual health") %>%
  group_by(behaviour1_specifics) %>%
  summarise(n=n()) %>%
  mutate(prop = round(n/sum(n)*100, digits = 1)) %>%
  arrange(-prop)

# EMA characteristics -----------------------------------------------------

#summarise % EMA sampling frequency

data_clean <- data_clean %>%
  mutate(frequency = coalesce(PA_psych_1_frequency,
                              A_psych_1_frequency,
                              S_psych_1_frequency,
                              E_psych_1_frequency,
                              SH_psych_1_frequency))

#summarise % EMA sampling method

data_clean <- data_clean %>%
  mutate(EMA_method = coalesce(PA_EMA_method,
                              A_EMA_method,
                              S_EMA_method,
                              E_EMA_method,
                              SH_EMA_method))

#create table 2

data_clean <- data_clean %>%
  mutate(adherence = coalesce(percentage_adherence_EMA_general, percentage_adherence_EMA_beh, percentage_adherence_EMA_psych))

table_2_prep_recode <- data_clean %>%
  mutate(burst_design_recode = recode(burst_design, "yes" = "Yes"),
         own_device_EMA_recode = recode(own_device_EMA, "NR" = "Not reported"),
         EMA_delivery_mode_recode = recode(EMA_delivery_mode, "Smartphone app" = "Mobile phone - app"),
         adherence_cutoff_recode = recode(adherence_cutoff, "no" = "No",
                                          "yes" = "Yes",
                                          "NR" = "Not reported"),
         frequency_recode = recode(frequency, "daily on the EMA days" = "Daily",
                                   "Weekly/Thursday, Friday and Saturday" = "Weekly"))

mylabels <- list(study_duration_days = "Study duration (days)", burst_design_recode = "Burst design", nr_bursts = "Number of bursts", 
                 own_device_EMA_recode = "% Own device",
                 EMA_delivery_mode_recode = "% EMA delivery mode",
                 adherence_cutoff_recode = "Adherence cut-off",
                 frequency_recode = "% EMA sampling frequency",
                 EMA_method = "% EMA sampling method",
                 adherence = "% Adherence")

t2_total <- tableby(~ study_duration_days + burst_design_recode + nr_bursts + own_device_EMA_recode + EMA_delivery_mode_recode + adherence + adherence_cutoff_recode + 
                      frequency_recode + EMA_method, data = table_2_prep_recode, control = mycontrols, cat.simplify = F)
t2_strata <- tableby(~ study_duration_days + burst_design_recode + nr_bursts + own_device_EMA_recode + EMA_delivery_mode_recode + adherence + adherence_cutoff_recode + 
                       frequency_recode + EMA_method, data = table_2_prep_recode, strata = behaviour1, control = mycontrols, cat.simplify = F)

t2_total <- summary(t2_total, text = T, labelTranslations = mylabels, digits = 1)
t2_strata <- summary(t2_strata, text = T, labelTranslations = mylabels, digits = 1)

write2word(t2_total,here("outputs","table2_total.doc"))
write2word(t2_strata,here("outputs","table2_strata.doc"))

#summarise unique psych/contextual vars across studies

unique_predictors <- data_clean %>%
  select(id, any_of(all_constructs)) %>% 
  pivot_longer(cols = !id) %>%
  distinct(value)

#summarise % multiple items and % precedent (denominator all studies) 

multiple_items <- data_clean %>%
  select(id, any_of(contains(c("PA_psych", "E_psych", "A_psych", "S_psych", "SH_psych")))) %>%
  select(id, any_of(contains(c("measure")))) %>%
  pivot_longer(cols = !id) %>%
  filter(!str_detect(name, "measurement_type")) %>%
  drop_na() %>%
  count(value)

precdent <- data_clean %>%
  select(id, any_of(contains(c("PA_psych", "E_psych", "A_psych", "S_psych", "SH_psych")))) %>%
  select(id, any_of(contains(c("validated")))) %>%
  pivot_longer(cols = !id) %>%
  drop_na() %>%
  count(value)
  
#summarise % multiple items and % precedent (denominator total psych/contextual vars per study)

all_measurement <- data_clean %>%
  select(id, any_of(contains(c("PA_psych", "E_psych", "A_psych", "S_psych", "SH_psych")))) %>%
  select(id, any_of(contains(c("measure")))) %>%
  pivot_longer(cols = !id) %>%
  filter(!str_detect(name, "measurement_type")) %>%
  drop_na() %>% 
  group_by(id) %>%
  mutate(n_in_study = n(),
         prop_multiple = sum(value == "Multiple items", na.rm = T)/n_in_study) %>%
  distinct(id, prop_multiple)

median(all_measurement$prop_multiple)
quantile(all_measurement$prop_multiple)
hist(all_measurement$prop_multiple)
table(all_measurement$prop_multiple)

all_validated <- data_clean %>%
  select(id, any_of(contains(c("PA_psych", "E_psych", "A_psych", "S_psych", "SH_psych")))) %>%
  select(id, any_of(contains(c("validated")))) %>%
  pivot_longer(cols = !id) %>%
  drop_na() %>% 
  group_by(id) %>%
  mutate(n_in_study = n(),
         prop_precedent = sum(value == "Precedent", na.rm = T)/n_in_study) %>%
  distinct(id, prop_precedent)

median(all_validated$prop_precedent)
quantile(all_validated$prop_precedent)
hist(all_validated$prop_precedent)
table(all_validated$prop_precedent)

#psych construct frequency by target behaviour

PA_plot <- pivot_longer(data_clean %>%
                          select(id, behaviour1, all_of(PA_constructs)), 
                        cols = c(PA_constructs)) %>%
  drop_na(value) %>%
  filter(value != "other" & behaviour1 == "Physical activity") %>%
  mutate(construct = "Physical activity")

E_plot <- pivot_longer(data_clean %>%
                          select(id, behaviour1, all_of(E_constructs)),
                        cols = c(E_constructs)) %>%
  drop_na(value) %>%
  filter(value != "other" & behaviour1 == "Healthy eating") %>%
  mutate(construct = "Healthy eating")

S_plot <- pivot_longer(data_clean %>%
                         select(id, behaviour1, all_of(S_constructs)),
                       cols = c(S_constructs)) %>%
  drop_na(value) %>%
  filter(value != "other" & behaviour1 == "Smoking") %>%
  mutate(construct = "Smoking")

A_plot <- pivot_longer(data_clean %>%
                         select(id, behaviour1, all_of(A_constructs)),
                       cols = c(A_constructs)) %>%
  drop_na(value) %>%
  filter(value != "other" & behaviour1 == "Alcohol") %>%
  mutate(construct = "Alcohol")

SH_plot <- pivot_longer(data_clean %>%
                         select(id, behaviour1, all_of(SH_constructs)),
                       cols = c(SH_constructs)) %>%
  drop_na(value) %>%
  filter(value != "other" & behaviour1 == "Sexual health") %>%
  mutate(construct = "Sexual health")

plot_constructs <- bind_rows(PA_plot,
                             E_plot,
                             S_plot,
                             A_plot,
                             SH_plot) %>%
  mutate(value = str_to_sentence(value))

#summarise % psych/contextual constructs across all studies

table(plot_constructs$value)
399/1896*100
312/1896*100

#summarise % psych/contextual constructs by target behaviour

summary(PA_plot)
summary(E_plot)
summary(S_plot)
summary(A_plot)
summary(SH_plot)

#summarise median (q1, q3) number of psych/contextual constructs per study

nr_constructs <- plot_constructs %>%
  group_by(id) %>%
  summarise(n = n())

range(nr_constructs$n)
median(nr_constructs$n)
quantile(nr_constructs$n)

#produce figure 4

fig_4 <- plot_constructs %>%
  ggplot() +
  geom_bar(aes(x = fct_rev(fct_infreq(value)), fill = behaviour1)) +
  scale_fill_manual(values = colour_palette) +
  coord_flip() +
  theme_minimal() +
  facet_wrap(~ construct, scales = "free_x") +
  theme(legend.position = "none") +
  labs(x = NULL,
       y = NULL)

if(!file.exists(here("outputs", "fig_4.png"))) ggsave(fig_4, filename = here("outputs", "fig_4.png"), dpi = 320, height = 8, width = 10)
 
# quality appraisal -------------------------------------------------------

table_3_prep_recode <- data_clean %>%
  mutate(quality3_recode = recode(quality3, "NA" = "Not reported",
                                  "NR" = "Not reported"),
         quality4_recode = recode(quality4, "n.a." = "Weak",
                                   "NA" = "Weak"))

mylabels <- list(quality1 = "Quality 1", quality2 = "Quality 2", quality3_recode = "Quality 3", quality4_recode = "Quality 4")

t3_total <- tableby(~ quality1 + quality2 + quality3_recode + quality4_recode, data = table_3_prep_recode, control = mycontrols, cat.simplify = F)
t3_strata <- tableby(~ quality1 + quality2 + quality3_recode + quality4_recode, data = table_3_prep_recode, control = mycontrols, strata = behaviour1, cat.simplify = F)

t3_total <- summary(t3_total, text = T, labelTranslations = mylabels, digits = 1)
t3_strata <- summary(t3_strata, text = T, labelTranslations = mylabels, digits = 1)

write2word(t3_total,here("outputs","table3_total.doc"))
write2word(t3_strata,here("outputs","table3_strata.doc"))
