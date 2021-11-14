# install required packages -----------------------------------------------

if (!require("pacman")) install.packages("pacman")

pkgs <- c("here",
          "zen4R",
          "tidyverse",
          "ggplot2",
          "readxl",
          "gtsummary",
          "sf",
          "tmap",
          "rnaturalearth",
          "countrycode",
          "metafor",
          "arsenal")

pacman::p_load(pkgs, character.only=T)

# load data ---------------------------------------------------------------

df1 <- download_zenodo("10.5281/zenodo.5701127", path = here("data"))

df2 <- read_xlsx(here("data","data_raw.xlsx"),sheet="data_raw")

data_duplicates <- read_xlsx(here("data","data_raw.xlsx"),sheet="data_duplicates")

data_psych <- read_xlsx(here("data","data_raw.xlsx"),sheet="psych_dictionary") %>%
  write_rds(file = here("data", "data_psych.rds"))

data_fund <- read_xlsx(here("data","data_raw.xlsx"),sheet="funder_dictionary") %>%
  write_rds(file = here("data", "data_fund.rds"))
