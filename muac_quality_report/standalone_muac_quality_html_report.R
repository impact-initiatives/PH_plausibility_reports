# Example for Standalone HTML MUAC Plausibility Report

# Please adapt with your own dataset and values.
# please ensure the input MUAC values are in cm.
# MUAC indicators must be standardized with impactR4PHU before using generating the run_muac_plaus_html_report function.

library(dplyr)
library(purrr)
library(fs)

base_path <- here::here("muac_quality_report")

fs::dir_ls(here::here("R"), recurse = TRUE, glob = "*.R") |>
  purrr::walk(
    ~ source(.x)
  )

data.test <- readxl::read_xlsx(
  here::here("muac_quality_report", "inputs", "MUAC sample data.xlsx"),
)

# Set Parameters

loop_var <- "cluster"
grouping_var <- "enum"
uuidVar <- "_uuid"

# Add MUAC Indicators for Plausibility

data.test2 <- data.test %>%
  dplyr::mutate(muac = round(as.numeric(muac) / 10, 1)) %>%
  impactR4PHU::add_muac(
    nut_muac_cm = "muac",
    child_age_months = "age_months",
    child_sex = "sex",
    value_male_sex = "m",
    edema_confirm = "oedema",
    value_edema_confirm = "y"
  ) %>%
  impactR4PHU::add_mfaz(
    nut_muac_cm = "muac",
    child_age_months = "age_months",
    child_sex = "sex",
    value_male_sex = "m",
    edema_confirm = "oedema",
    value_edema_confirm = "y"
  ) %>%
  impactR4PHU::check_anthro_flags(
    nut_muac_cm = "muac",
    edema_confirm = "oedema",
    value_edema_confirm = "y",
    uuid = "child_person_id"
  )


"nut_edema_confirm" %in% names(data.test2)

loop_values <- unique(data.test2[[loop_var]])


reports_dir <- fs::path(base_path, "reports")
fs::dir_create(reports_dir)

for (i in 1:length(loop_values)) {
  print(loop_values[[i]])

  file_name <- paste0(
    "muac_plaus_report_",
    loop_values[[i]],
    "_",
    Sys.Date(),
    ".html"
  )

  data.test3 <- data.test2 %>%
    dplyr::filter(!!sym(loop_var) == loop_values[[i]])

  run_muac_plaus_html_report(
    .dataset = data.test2,
    uuid_var = uuidVar,
    group_var = grouping_var,
    output_dir = reports_dir,
    output_file = file_name
  )
}
