target_directory <- "C:/Users/jzsloan/University of Michigan Dropbox/Jared Sloan/AI-Powered Lawyering - Anonymized Replication Package as of March 6th 2025/analysis/data"

# List all subdirectories
all_subdirectories <- list.dirs(path = target_directory, full.names = TRUE, recursive = FALSE)

# Get file information for each subdirectory
dir_info <- file.info(all_subdirectories)

# Find the index of the most recently modified directory
most_recent_index <- which.max(dir_info$mtime)

# Get the full path of the most recent folder
most_recent_folder <- all_subdirectories[most_recent_index]


setwd(most_recent_folder)
#install.packages("systemfit")
#install.packages('sandwich')
#install.packages('lmtest')
library(systemfit)
library(sandwich)
library(lmtest)
library(dplyr)
library(tidyr)

task_dfs <- lapply(1:6, function(t) {
  df <- read.csv(paste0("task", t, "_data_cleaned.csv"))
  df$Student_ID <- as.factor(df$Student_Number)
  df$AI_Condition <- factor(df$AI_Condition,
                            levels = c("No AI","Vincent","GPT 01"))  # set base
  df
})
names(task_dfs) <- paste0("task", 1:6)

common_ids <- Reduce(intersect, lapply(task_dfs, function(df) df$Student_ID))
length(common_ids)


task_dfs_balanced <- lapply(task_dfs, function(df) {
  df %>% filter(Student_ID %in% common_ids)
})


outcome_vars <- lapply(1:6, function(t) {
  grep(paste0("^P", t, "_Criteria"), names(task_dfs_balanced[[t]]), value=TRUE)
})
outcome_vars_clean <- lapply(outcome_vars, function(vars) {
  gsub(" ", "", vars)
})
outcome_vars_clean <- lapply(outcome_vars_clean, function(vars) {
  gsub("_", "", vars)
})
names(outcome_vars_clean) <- paste0("task", 1:6)

task_dfs_balanced <- lapply(task_dfs_balanced, function(df) {
  
  # Current names
  old_names <- names(df)
  
  # Identify only those containing "Criteria"
  crit_cols <- grep("Criteria", old_names, value = TRUE)
  
  # Build new names by removing underscores
  new_names <- gsub("_", "", crit_cols)
  
  # Replace in the dataframe
  names(df)[match(crit_cols, old_names)] <- new_names
  
  df
})
task_dfs_balanced <- lapply(seq_along(task_dfs_balanced), function(i) {
  df <- task_dfs_balanced[[i]]
  names(df)[names(df) == "AI_Condition"] <- paste0("P", i, "_AI_Condition")
  df
})
wide_df <- Reduce(function(x, y) merge(x, y, by = c("Student_ID")),
                  task_dfs_balanced)


outcome_names <- unlist(outcome_vars_clean)
wide_df_clean <- wide_df[complete.cases(wide_df[, outcome_names]),]
eqns <- list()
for (task_num in 1:6) {
  # Get outcome names for this task
  outcomes <- grep(paste0("^P", task_num, "Criteria"), names(wide_df_clean), value = TRUE)
  
  # Treatment variable for this task
  treat_var <- paste0("P", task_num, "_AI_Condition")
  
  # Build formulas
  for (outcome in outcomes) {
    eqn_name <- outcome
    eqns[[eqn_name]] <- as.formula(paste(outcome, "~", treat_var))
  }
}

fit_sur <- systemfit(eqns, method="SUR", data=wide_df_clean)
summary(fit_sur)
fit_sum <- summary(fit_sur)

# Extract coefficients table (matrix)
coef_mat <- fit_sum$coefficients
# Columns: Estimate, Std. Error, t value, Pr(>|t|)

# Convert to data.frame and keep what you need
coef_df <- as.data.frame(coef_mat)[, c("Estimate", "Std. Error", "Pr(>|t|)")]

# Add coefficient (parameter) names as a column
coef_df$Coefficient <- rownames(coef_mat)

# Reorder columns
coef_df <- coef_df[, c("Coefficient", "Estimate", "Std. Error", "Pr(>|t|)")]

corr_mat <- fit_sum$residCor

outcomes <- unique(gsub("^P[0-9]+", "", rownames(corr_mat)))

# Initialize an empty 5x5 matrix
n_outcomes <- length(outcomes)
avg_corr <- matrix(NA, nrow = n_outcomes, ncol = n_outcomes,
                   dimnames = list(outcomes, outcomes))

# Loop over outcome pairs and compute mean within-task correlation
for (i in seq_len(n_outcomes)) {
  for (j in seq_len(n_outcomes)) {
    if (i == j) {
      avg_corr[i, j] <- 1
    } else {
      # Collect correlations across tasks
      vals <- c()
      for (task in 1:6) {
        oi <- paste0("P", task, outcomes[i])
        oj <- paste0("P", task, outcomes[j])
        if (oi %in% rownames(corr_mat) && oj %in% colnames(corr_mat)) {
          vals <- c(vals, corr_mat[oi, oj])
        }
      }
      avg_corr[i, j] <- mean(vals, na.rm = TRUE)
    }
  }
}

# Convert to data.frame for nicer viewing
avg_corr_df <- as.data.frame(avg_corr)
corr_df <- as.data.frame(corr_mat)

wd = getwd()
file_path = paste0(wd,  "/SUR_Results.csv")
# Export to CSV
write.csv(coef_df, file_path, row.names = FALSE)
write.csv(avg_corr_df, "avg_corr.csv")
write.csv(corr_df,"full_corr.csv")
print(paste0("file printed to ", file_path))

resids_list <- residuals(fit_sur)