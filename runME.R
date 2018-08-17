# rm(list=ls())

# path to the directory containing folder 'ins-sirn-2018' here
path_to_working_directory <- ""

# path to working directory
working_directory <-
  paste0(path_to_working_directory, "ins-sirn-2018")

# set working_directory
setwd(working_directory)

# 0 - R packages required  --------------------------------------------------

library(foreach)
library(dplyr)

# 1 - Functions required  --------------------------------------------------

source(file = paste0(working_directory, "/functions/sourceME.R"))

# 2 - loading the datasets in a dictionary  --------------------------------------------------

# load the datasets
load(file = paste0(working_directory, "/cv-data/cv_Canada.RData"))
load(file = paste0(working_directory, "/cv-data/cv_usconsumption.RData"))
load(file = paste0(working_directory, "/cv-data/cv_tableF2_2.RData"))
load(file = paste0(working_directory, "/cv-data/cv_tableF5_2.RData"))
load(file = paste0(working_directory, "/cv-data/cv_germancons.RData"))
load(file = paste0(working_directory, "/cv-data/cv_usexp.RData"))
load(file = paste0(working_directory, "/cv-data/cv_housing.RData"))
load(file = paste0(working_directory, "/cv-data/cv_ausmacro.RData"))
load(file = paste0(working_directory, "/cv-data/cv_ips.RData"))

# save them in a dictionary
cv_results <- list(
  cv_Canada,
  cv_usconsumption,
  cv_tableF2_2,
  cv_tableF5_2,
  cv_germancons,
  cv_usexp,
  cv_housing,
  cv_ausmacro,
  cv_ips
)
names(cv_results) <- c(
  "Canada",
  "usconsumption",
  "tableF2_2",
  "tableF5_2",
  "germancons",
  "usexp",
  "housing",
  "ausmacro",
  "ips"
)

# 3 - Summary of cross-validation errors (on validation set) for each dataset, by horizon  --------------------------------------------------

summary_cv_data(cv_Canada)$mean
summary_cv_data(cv_usconsumption)$mean
summary_cv_data(cv_tableF2_2)$mean
summary_cv_data(cv_tableF5_2)$mean
summary_cv_data(cv_germancons)$mean
summary_cv_data(cv_usexp)$mean
summary_cv_data(cv_housing)$mean
summary_cv_data(cv_ausmacro)$mean
summary_cv_data(cv_ips)$mean

# 4 - Ranking the methods --------------------------------------------------

cv_data_ranking(cv_results)
