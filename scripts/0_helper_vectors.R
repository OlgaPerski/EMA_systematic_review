# helper vectors ----------------------------------------------------------

PA_constructs <- c("PA_psych_1_1", "PA_psych_1_2", "PA_psych_1_3", "PA_psych_1_4",
                   "PA_psych_1_5", "PA_psych_1_6", "PA_psych_1_7", "PA_psych_1_8", 
                   "PA_psych_1_9", "PA_psych_1_10", "PA_psych_2_1", "PA_psych_2_2",
                   "PA_psych_2_3", "PA_psych_2_4","PA_psych_2_5", "PA_psych_3_1", 
                   "PA_psych_3_2", "PA_psych_3_3", "PA_psych_4_1", "PA_psych_4_2",
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

colour_palette <- RColorBrewer::brewer.pal(5, "Dark2")
names(colour_palette) <- unique(data_clean$behaviour1)