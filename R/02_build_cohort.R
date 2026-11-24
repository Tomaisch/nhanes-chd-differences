# Build analysis cohort from NHANES 2011-2018

library(tidyverse)

cycles <- c("G", "H", "I", "J") # 2011-12, 2013-14, 2015-16, 2017-18
table_names <- c(
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

# Function to read NHANES data for a given table across all cycles
read_nhanes <- function(name) {
    tables <- paste0("data/raw/", name, "_", cycles, ".rds")
    table_list <- list()
    for (table in tables) {
        table_list[[table]] <- readRDS(table)
    }
    return(bind_rows(table_list))
}

# Read all NHANES tables and merge into a single data frame
data_list <- list()
for (tbl in table_names) {
    data_list[[tbl]] <- read_nhanes(tbl)
}
nhanes <- data_list[["DEMO"]]
for (tbl in table_names[-1]) {
    nhanes <- left_join(nhanes, data_list[[tbl]], by = "SEQN")
}
# Filter to adults aged 40+ and those who attended the MEC exam
nhanes_40 <- filter(nhanes, RIDAGEYR >= 40)
nhanes_40_mec <- filter(nhanes_40, RIDSTATR == 2)
