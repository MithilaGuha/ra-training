# Load libraries.
library(tidyverse)
library(tidybayes)
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

# Possible prior predictive checks:
# - Mosaic plots comparing how often each attribue level was in the chosen alternative.
# - Visualizing how often each attribute level appears with every other attribute level?

# Count of attribute levels in the chosen alternative.
sim_data %>% 
  spread_draws(Y[n], X[n][p, l]) %>% 
  filter(Y == p) %>% 
  group_by(l) %>% 
  summarize(sum_x = sum(X)) %>% 
  ggplot(aes(x = as.factor(l), y = sum_x)) +
  geom_col() +
  labs(
    title = "Count of attribute levels in the chosen alternative",
    x = "Attribute Levels",
    y = "Count"
  ) +
  coord_flip()
  
# sim_data %>% 
#   spread_draws(X[l])
# 
# sim_data %>% 
#   gather_draws(B[l])

str(extract(sim_data)$Y)

sim_y <- extract(sim_data)$Y
sim_x <- extract(sim_data)$X
sim_b <- extract(sim_data)$B

# Bayesplot?
