# Load libraries.
library(rstan)

# Specify the data values for simulation in a list.
sim_values <- list(
  N = 100,           # Number of observations.
  P = 3,             # Number of product alternatives.
  L = 10             # Number of (estimable) attribute levels.
)

# Specify the number of draws.
R <- 1000

# Simulate data.
sim_data <- stan(
  file = here::here("Code", "mnl_simulate.stan"), 
  data = sim_values,
  iter = R,
  warmup = 0, 
  chains = 1, 
  refresh = R,
  seed = 42,
  algorithm = "Fixed_param"
)

# Extract the simulated values.
sim_y <- extract(sim_data)$Y
sim_x <- extract(sim_data)$X
sim_b <- extract(sim_data)$B

# Possible prior predictive checks:
# - Bar plots of how often each attribute level was in the chosen alternative.
# - Mosaic plots comparing how often each attribue level was in the chosen alternative.
# - Visualizing how often each attribute level appears with every other attribute level?


