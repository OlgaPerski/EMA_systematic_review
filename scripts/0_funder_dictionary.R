data_fund <- read_rds(here::here("data", "data_fund.rds"))

#research

research_names <- data_fund %>%
  distinct(`research`) %>%
  pull()
research_dictionary <- rep("research", length(research_names))
names(research_dictionary) <- research_names

#society

society_names <- data_fund %>%
  distinct(`society`) %>%
  drop_na() %>%
  pull()
society_dictionary <- rep("society", length(society_names))
names(society_dictionary) <- society_names

#charity

charity_names <- data_fund %>%
  distinct(`charity`) %>%
  drop_na() %>%
  pull()
charity_dictionary <- rep("charity", length(charity_names))
names(charity_dictionary) <- charity_names

#university_health_institution

university_health_institution_names <- data_fund %>%
  distinct(`university_health_institution`) %>%
  drop_na() %>%
  pull()
university_health_institution_dictionary <- rep("university_health_institution", length(university_health_institution_names))
names(university_health_institution_dictionary) <- university_health_institution_names

#industry

industry_names <- data_fund %>%
  distinct(`industry`) %>%
  drop_na() %>%
  pull()
industry_dictionary <- rep("industry", length(industry_names))
names(industry_dictionary) <- industry_names

#none

none_names <- data_fund %>%
  distinct(`none`) %>%
  drop_na() %>%
  pull()
none_dictionary <- rep("none", length(none_names))
names(none_dictionary) <- none_names

combined_dictionary <- c(research_dictionary, society_dictionary, charity_dictionary, university_health_institution_dictionary, industry_dictionary,
                         none_dictionary)

write_rds(combined_dictionary, here("data", "fund_dictionary.rds"))