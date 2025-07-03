
############################################################################################
################ User Requirements for Running This Script #################################

# 1. Your data must have columns for teams and enumerators, if you want to do enumerator level quality checks.
# 2. Your data must have the following column names at least in the various main, roster, and deaths datasets.
  # list_main_columns <- c( "today", "recall_date", "start", "end")
  # list_roster_columns <- c("ind_gender", "calc_final_age_years", "final_ind_dob",)
  # list_deaths_columns <- c("sex_died","calc_final_age_years_died", "dob_died", "final_date_death", "calc_final_age_years_died")
# 3. You must 'pre-filter' your data by region or team before running the rmarkdown function. Best done with a for loop to iterate through each team.
# 4. You must pre-determine your 'expected' demographic values for some of the statistical tests. STU can support with this step.
###############################################################################################

# 1. Load libraries and source functions
library(tidyverse)
library(ggplot2)
library(dplyr)
library(flextable)
library(purrr)
library(fs)

fs::dir_ls(here::here("R"), recurse = TRUE, glob = "*.R") |>
  purrr::walk(
    ~ source(.x)
  )

# 2. Load  datasets ---
main_path   <- here::here("mortality_quality_report", "inputs", "HTI2502 download data - 2025-06-30.xlsx")
df_main     <- readxl::read_xlsx(main_path, sheet = "main")
df_roster   <- readxl::read_xlsx(main_path, sheet = "roster") %>%
  dplyr::rename(final_ind_dob = ind_dob_final, calc_final_age_years = ind_under5_age_years)
df_died     <- readxl::read_xlsx(main_path, sheet = "died_member")

# 3. Set your PARAMETERS 
UUID_MAIN      <- "_index"
UUID_ROSTER    <- "_parent_index"
UUID_DEATHS    <- "_parent_index"
LANG           <- "fr" # en / fr
LOOP_VAR       <- "zone"
GROUPING_VAR   <- "admin1"
FILE_PATH      <- "reports"
START_DATE     <- "2024-06-01"
END_DATE       <- "2026-09-30"

EXP_SEX_RATIO         <- 0.048 # Estimated sex ratio, assuming 50% male.
EXP_AGE_RATIO_01_35   <- 0.42 # Estimated proportion of children under-2 out of all under-5 children.
EXP_AGE_RATIO_05_10   <- 0.51 # Estimated proportion of children under-5 out of all under-10 children.
EXP_AGE_RATIO_05_5PLUS<- 0.15 # Estimated proportion of children under-5 out of all people.
EXP_MEAN_HH_SIZE      <- 4.4  # Estimated average household size.
EXP_DEATHS_PER_HH     <- 0.057816 # Estimated number of deaths per household, based on estimated CDR, length of recall period, and household size
# Expected deaths per household = CDR * Average HH Size * Number recall days / 10000
# (a <- (0.73*4.4*180) / 10000 )
# 0.057816
EXP_BIRTHS_PER_HH     <- 0.05 # Estimated number of births per household, based on estimated Birth Rate, length of recall period, and household size
# Expected births per household = Births per 1000 people per year * (Number recall days / 365 days per year) * Avg household size
# (b <- (22.2*180*4.4)/(365*1000))

# ---- Derived Parameters (computed from user parameters) ----
OUTPUT_DIR =  here::here("mortality_quality_report", FILE_PATH , Sys.Date())
dir.create(OUTPUT_DIR)

# 4. Iterate through your groups to produce pdf reports for each. Set the file naming conventions and output folder.

loop_values <- unique(df_main[[LOOP_VAR]])


# Use all_of() for tidyselect compatibility and to avoid warnings
df_main <- df_main %>%
  rename(hh_uuid = all_of(UUID_MAIN)) %>%
  dplyr::mutate(hh_uuid = as.character(hh_uuid))

df_roster <- df_roster %>%
  rename(hh_uuid = all_of(UUID_ROSTER)) %>%
  dplyr::mutate(hh_uuid = as.character(hh_uuid))

df_died <- df_died %>%
  rename(hh_uuid = all_of(UUID_DEATHS)) %>%
  dplyr::mutate(hh_uuid = as.character(hh_uuid))

for (i in 1:length(loop_values)) {

  print(loop_values[[i]])

  FILE_NAME <- paste0("mortality_quality_report_", loop_values[[i]], "_", Sys.Date(), ".html")

  df_main2 <- df_main %>%
    dplyr::filter(!!sym(LOOP_VAR) == loop_values[[i]]) %>%
    dplyr::filter(today >= as.Date(START_DATE) & today <= as.Date(END_DATE))

  df_roster2 <- df_roster %>% dplyr::filter(hh_uuid %in% df_main$hh_uuid)
  df_died2 <- df_died %>% dplyr::filter(hh_uuid %in% df_main$hh_uuid)

  render_quality_report(
    main_data = df_main2,
    roster_data = df_roster2,
    deaths_data = df_died2,
    uuid_main = UUID_MAIN,
    uuid_roster = UUID_ROSTER,
    uuid_deaths = UUID_DEATHS,
    lang = LANG,
    start_date = START_DATE,
    end_date = END_DATE,
    group_var = GROUPING_VAR,
    exp_sexRatio = EXP_SEX_RATIO,
    exp_ageRatio_01_35 = EXP_AGE_RATIO_01_35,
    exp_ageRatio_05_10 = EXP_AGE_RATIO_05_10,
    exp_ageRatio_05_5plus = EXP_AGE_RATIO_05_5PLUS,
    exp_meanHH_size = EXP_MEAN_HH_SIZE,
    exp_deathsPer_hh = EXP_DEATHS_PER_HH,
    exp_birthsPer_hh = EXP_BIRTHS_PER_HH,
    output_file = FILE_NAME,
    output_dir = OUTPUT_DIR
  )
}
