data_psych <- read_rds(here::here("data", "data_psych.rds"))

#identifying unique values that need to be accounted for within the google drive psych construct dictionary

# all_psych <- unique(vctrs::vec_c(data_raw$PA_psych_1, data_raw$PA_psych_2, data_raw$PA_psych_3, data_raw$PA_psych_4, data_raw$PA_psych_5,
#                                  data_raw$E_psych_1, data_raw$E_psych_2, data_raw$E_psych_3, data_raw$E_psych_4, data_raw$E_psych_5,
#                                  data_raw$S_psych_1, data_raw$S_psych_2, data_raw$S_psych_3, data_raw$S_psych_4, data_raw$S_psych_5,
#                                  data_raw$SH_psych_1, data_raw$SH_psych_2, data_raw$SH_psych_3, data_raw$SH_psych_4, data_raw$SH_psych_5))

#creating named vectors, with names corresponding to the higher order constructs agreed on within the review team

#feeling states - unspecified

feeling_unspecified_names <- data_psych %>%
  distinct(`feeling states - unspecified`) %>%
  drop_na() %>%
  pull()
feeling_unspecified_dictionary <- rep("feeling states - unspecified", length(feeling_unspecified_names))
names(feeling_unspecified_dictionary) <- feeling_unspecified_names

#positive feeling states

positive_feeling_names <- data_psych %>%
  distinct(`positive feeling states`) %>%
  drop_na() %>%
  pull()
positive_feeling_dictionary <- rep("positive feeling states", length(positive_feeling_names))
names(positive_feeling_dictionary) <- positive_feeling_names

#negative feeling states

negative_feeling_names <- data_psych %>%
  distinct(`negative feeling states`) %>%
  drop_na() %>%
  pull()
negative_feeling_dictionary <- rep("negative feeling states", length(negative_feeling_names))
names(negative_feeling_dictionary) <- negative_feeling_names

#momentary trait manifestations and physical states

momentary_traits_names <- data_psych %>%
  distinct(`momentary trait manifestations and physical states`) %>%
  drop_na() %>%
  pull()
momentary_traits_dictionary <- rep("momentary trait manifestations and physical states", length(momentary_traits_names))
names(momentary_traits_dictionary) <- momentary_traits_names

#motivation and goals

motivation_names <- data_psych %>%
  distinct(`motivation and goals`) %>%
  drop_na() %>%
  pull()
motivation_dictionary <- rep("motivation and goals", length(motivation_names))
names(motivation_dictionary) <- motivation_names

#beliefs about capabilities

beliefs_capabilities_names <- data_psych %>%
  distinct(`beliefs about capabilities`) %>%
  drop_na() %>%
  pull()
beliefs_capabilities_dictionary <- rep("beliefs about capabilities", length(beliefs_capabilities_names))
names(beliefs_capabilities_dictionary) <- beliefs_capabilities_names

#beliefs about consequences

beliefs_consequences_names <- data_psych %>%
  distinct(`beliefs about consequences`) %>%
  drop_na() %>%
  pull()
beliefs_consequences_dictionary <- rep("beliefs about consequences", length(beliefs_consequences_names))
names(beliefs_consequences_dictionary) <- beliefs_consequences_names

#behavioural regulation

beh_reg_names <- data_psych %>%
  distinct(`behavioural regulation`) %>%
  drop_na() %>%
  pull()
beh_reg_dictionary <- rep("behavioural regulation", length(beh_reg_names))
names(beh_reg_dictionary) <- beh_reg_names

#memory, attention and decision processes

mem_att_dec_names <- data_psych %>%
  distinct(`memory, attention and decision processes`) %>%
  drop_na() %>%
  pull()
mem_att_dec_dictionary <- rep("memory, attention and decision processes", length(mem_att_dec_names))
names(mem_att_dec_dictionary) <- mem_att_dec_names

#social influences

social_influences_names <- data_psych %>%
  distinct(`social influences`) %>%
  drop_na() %>%
  pull()
social_influences_dictionary <- rep("social influences", length(social_influences_names))
names(social_influences_dictionary) <- social_influences_names

#environmental context and physical/environmental resources

context_names <- data_psych %>%
  distinct(`environmental context and physical/environmental resources`) %>%
  drop_na() %>%
  pull()
context_dictionary <- rep("environmental context and physical/environmental resources", length(context_names))
names(context_dictionary) <- context_names

#nature of the behaviours

nature_names <- data_psych %>%
  distinct(`nature of the behaviours`) %>%
  drop_na() %>%
  pull()
nature_dictionary <- rep("nature of the behaviours", length(nature_names))
names(nature_dictionary) <- nature_names

#other

other_names <- data_psych %>%
  distinct(`other`) %>%
  drop_na() %>%
  pull()
other_dictionary <- rep("other", length(other_names))
names(other_dictionary) <- other_names

combined_dictionary <- c(feeling_unspecified_dictionary, positive_feeling_dictionary,
                         motivation_dictionary, negative_feeling_dictionary, momentary_traits_dictionary,
                         beliefs_capabilities_dictionary, beliefs_consequences_dictionary, beh_reg_dictionary,
                         mem_att_dec_dictionary, social_influences_dictionary, context_dictionary, nature_dictionary, other_dictionary)

write_rds(combined_dictionary, here("data", "psych_dictionary.rds"))