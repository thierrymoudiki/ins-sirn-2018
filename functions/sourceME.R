# avg rmse on validation set,
# by method/forecasting horizon
summary_cv_data <- function(cv_dataset)
{
    summary_cv_by_method <- function(cv_dataset,
                                fcast_method = c("rw", "mean", "VAR",
                                                 "lassoVAR", "ridge2", "glmboost",
                                                 "pls", "scnI", "scnIII"), h)
    {
      stopifnot(h %in% c(3, 6, 9, 12))
      h_choice <- h/3
      n_seeds <- 10
      fcast_method <- match.arg(fcast_method)
      fcast_method_choice <- switch(fcast_method,
                                    "rw" = 1,
                                    "mean" = 2,
                                    "VAR" = 3,
                                    "lassoVAR" = 4,
                                    "ridge2" = 5,
                                    "glmboost" = 6,
                                    "pls" = 7,
                                    "scnI" = 8,
                                    "scnIII" = 9)

      errors <- foreach::foreach(j = 1:n_seeds,
                                 .combine = rbind)%do%{
                                   cv_dataset[[fcast_method_choice]][[h_choice]][[j]]$errors_test}
      colnames(errors) <- paste0("test_rmse", 1:ncol(errors))

      errors_median <- apply(errors, 2, median) # robust to outliers, and more representative of a typical value

      list(errors = errors,
           errors_median = errors_median,
           mean = mean(errors_median),
           sd = sd(errors_median))
    }

  horizons <- c(3, 6, 9, 12)
  n_horizons <- length(horizons)
  fcast_methods <- c("rw", "mean", "VAR",
                     "lassoVAR", "ridge2", "glmboost",
                     "pls", "scnI", "scnIII")
  n_fcast_methods <- length(fcast_methods)
  results_mean <- results_sd <- matrix(NA, ncol = n_horizons,
                                       nrow = n_fcast_methods)
  rownames(results_mean) <- rownames(results_sd) <- fcast_methods
  colnames(results_mean) <- colnames(results_sd) <- paste0("h", horizons)

  for (i in 1:n_fcast_methods)
  {
    for (j in 1:n_horizons)
    {
      errs <- summary_cv_by_method(cv_dataset = cv_dataset,
                              fcast_method = fcast_methods[i],
                              h = horizons[j])

      results_mean[i, j] <- errs$mean
      results_sd[i, j] <- errs$sd
    }
  }

  return(list(mean = results_mean,
              sd = results_sd))
}

# average ranking of the methods
cv_data_ranking <- function(cv_results)
{
  n_datasets <- 9
  datasets_names <- c("Canada","usconsumption", "tableF2_2",
                      "tableF5_2","germancons","usexp",
                      "housing","ausmacro","ips")
  fcast_methods <- c("rw", "mean", "VAR",
                     "lassoVAR", "ridge2", "glmboost",
                     "pls", "scnI", "scnIII")

  ranks <- foreach::foreach(i = 1:n_datasets, .combine = rbind)%do%{
    cbind.data.frame(datasets_names[i], fcast_methods,
                     apply(summary_cv_data(cv_results[[i]])$mean, 2, rank))
  }
  colnames(ranks) <- c("dataset", "method",
                       "h3", "h6", "h9", "h12")
  rownames(ranks) <- NULL

  by_method <- dplyr::group_by(ranks, method)
  mean_ranks <- as.data.frame(dplyr::summarise(by_method,
                                               h3 = mean(h3, na.rm = TRUE),
                                               h6 = mean(h6, na.rm = TRUE),
                                               h9 = mean(h9, na.rm = TRUE),
                                               h12 = mean(h12, na.rm = TRUE)))

  best_rank <- rowMeans(mean_ranks[,-1])
  names(best_rank) <- sort(fcast_methods)

  return(list(ranks_detail = ranks,
              ranks_avg = mean_ranks,
              best_ranks = sort(best_rank)))
}
