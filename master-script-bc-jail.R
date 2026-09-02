

library(tidyverse)
library(httr2)
library(readxl)
library(writexl)
library(janitor)

# Fetching 7 am report

am_url <- "https://report.boonemo.gov/mrcjava/servlet/RMS01_MP.R00070s?run=1&D_DETAIL=1&outfmt=13"

am_resp <- request(am_url) |> 
  req_perform()

today <- Sys.Date()
am_filename <- file.path("updated-data/raw-files", paste0("seven_am_report_", today, ".xlsx"))

resp_body_raw(am_resp) |> 
  writeBin(con = am_filename)

first_bytes <- readBin(am_filename, what = "raw", n = 2)
is_valid_xlsx <- rawToChar(first_bytes) == "PK"

if (!is_valid_xlsx) {
  stop("Downloaded file doesn't look like a valid xlsx — got something else instead.")
}

# Updating past data 

new_dt <- read_excel(am_filename)

new_dt <- new_dt |> clean_names() |> mutate(download_date = today)

past_dt <- read_excel("updated-data/past_7_am_reports.xlsx")

if (!file.exists("updated-data/past_7_am_reports.xlsx")) {
  stop("Past data file was not found.")
}

updated_log <- bind_rows(new_dt, past_dt) |> distinct()

# Exporting updated data

write_xlsx(updated_log, "updated-data/past_7_am_reports.xlsx")


# Fetching current detainees

cd_url <- "https://report.boonemo.gov/mrcjava/servlet/RMS01_MP.R00030s?run=1&D_DETAIL=1&R001=&R002=&outfmt=13"

cd_resp <- request(cd_url) |> 
  req_perform()

cd_filename <- file.path("updated-data/raw-files", paste0("current_detainees", today, ".xlsx"))

resp_body_raw(cd_resp) |> 
  writeBin(con = cd_filename)

first_bytes <- readBin(cd_filename, what = "raw", n = 2)
is_valid_xlsx <- rawToChar(first_bytes) == "PK"

if (!is_valid_xlsx) {
  stop("Downloaded file doesn't look like a valid xlsx — got something else instead.")
}

# Updating past data 

new_cd <- read_excel(cd_filename)

new_cd <- new_cd |> clean_names() |> mutate(download_date = today)

past_cd <- read_excel("updated-data/past_current_detainees.xlsx")

if (!file.exists("updated-data/past_current_detainees.xlsx")) {
  stop("Past data file was not found.")
}

updated_cd <- bind_rows(new_cd, past_cd)


# Exporting updated data

write_xlsx(updated_cd, "updated-data/past_current_detainees.xlsx")

