# Load libraries.
library(tidyverse)
library(rstan)

# Load simulated data.
sim_data <- readRDS(file = here::here("Data", "sim_data.RDS"))

# Extract the data from the first simulated dataset.
Y <- extract(sim_data)$Y[1,]
X <- extract(sim_data)$X[1,,,]

# Specify the data for calibration in a list.
data <- list(
  N = length(Y),           # Number of observations.
  P = nrow(X[1,,]),        # Number of product alternatives.
  L = ncol(X[1,,]),        # Number of (estimable) attribute levels.
  Y = Y,                   # Vector of observed choices.
  X = X                    # Experimental design for each observations.
)

# Calibrate the model.
fit <- stan(
  file = here::here("Code", "mnl_estimate.stan"),
  data = data,
  seed = 42
)

