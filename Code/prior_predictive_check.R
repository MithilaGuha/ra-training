# Load libraries.
library(rstan)

# Specify the data values in a list.
data_values <- list(
  N = 100,           # Number of respondents.
  P = 3,             # Number of product alternatives.
  L = 10             # Number of (estimable) attribute levels.
)

# Simulate data.
fit <- stan(
  file = here::here("Code", "mnl_simulate.stan"), 
  data = data_values,
  iter = 100,
  warmup = 0, 
  chains = 1, 
  refresh = 100,
  seed = 42, 
  algorithm = "Fixed_param"
)



# simu_lambdas <- extract(fit)$lambda
# simu_ys <- extract(fit)$y