# Download raw NHANES data (cycles 2011-2018) and save as .rds files

library(nhanesA)

cycles <- c("G", "H", "I", "J") # 2011-12, 2013-14, 2015-16, 2017-18

tables <- c(
  "DEMO",  # demographics, survey design
  "MCQ",   # medical conditions (CHD outcome)
  "CDQ",   # cardiovascular health (Rose angina)
  "BPX",   # blood pressure measurements
  "BPQ",   # blood pressure questionnaire
  "BMX",   # body measures
  "TCHOL", # total cholesterol
  "HDL",   # HDL cholesterol
  "GHB",   # HbA1c
  "DIQ",   # diabetes
  "SMQ",   # smoking
  "RHQ",   # reproductive health
  "DPQ"    # depression (PHQ-9)
)

for (table in tables) {
  for (cycle in cycles) {
    name <- paste0(table, "_", cycle)
    path <- file.path("data", "raw", paste0(name, ".rds"))

    if (file.exists(path)) {
      message("Skipping ", name, " (already downloaded)")
      next
    }

    message("Downloading ", name, " ...")
    df <- nhanes(name, translated = FALSE)
    saveRDS(df, path)
  }
}

message("Done.")