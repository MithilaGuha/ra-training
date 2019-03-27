# Load libraries.
library(tidyverse)
library(rstan)

# Specify the data values for simulation in a list.
sim_values <- list(
  N = 100,           # Number of observations.
  P = 3,             # Number of product alternatives.
  L = 10             # Number of (estimable) attribute levels.
)

# Specify the number of draws (i.e., simulated datasets).
R <- 50

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

# Extract simulated data and parameters.
sim_x <- extract(sim_data)$X
sim_b <- extract(sim_data)$B

# Compute the implied choice probabilities.
probs <- NULL
for (r in 1:R) {
  for (n in 1:sim_values$N) {
    exp_xb <- exp(sim_x[r,n,,] %*% sim_b[r,])
    max_prob <- max(exp_xb / sum(exp_xb))
    probs <- c(probs, max_prob)
  }
}

# Make sure there aren't dominating alternatives.
tibble(probs) %>% 
  ggplot(aes(x = probs)) +
  geom_histogram()

# # Count of attribute levels in the chosen alternative.
# library(tidybayes)
# sim_data %>% 
#   spread_draws(Y[n], X[n][p, l]) %>% 
#   filter(Y == p) %>% 
#   group_by(l) %>% 
#   summarize(sum_x = sum(X)) %>% 
#   ggplot(aes(x = as.factor(l), y = sum_x)) +
#   geom_col() +
#   labs(
#     title = "Count of attribute levels in the chosen alternative",
#     x = "Attribute Levels",
#     y = "Count"
#   ) +
#   coord_flip()
