A Tidy Bayesian Workflow
================

This **tidy Bayesian workflow** details the process of conducting
Bayesian inference using tidy principles and modern tools and
diagnostics. In particular, we will employ the tidyverse for data
wrangling and visualization and Stan for modeling.

The workflow is composed of three sections: **model building**, **model
calibration**, and **model validation**. The material draws heavily from
Michael Betancourt’s case studies and training on using Stan at Drexel
University in Fall 2018.

## Model Building

### Describe the Model Conceptually

A model starts conceptually: What is the data generating process? In
other words, where do the data come from? This conceptual model often
lives within a literature of model building, motivated by theory, and at
its most basic may simply be a consideration of how to relax assumptions
in an existing model. Document this description, as it likely serves as
the beginning of an introduction to the project. Above all, the model
needs to be consistent with our domain expertise.

### Define Observations and Relevant Summary Statistics

As part of this conceptual description of the model, we should consider
the ideal dataset as well as what summary statistics, including
visualizations, we can use to evaluate the model. We encode the
information about the observations using the `data` block in Stan.

``` stan
data {
  int N;
  int y[N];
}
```

### Build a Generative Model

Next, we translate the simplest expression of the conceptual model into
a mathematical specification. A fully generative model includes both the
likelihood
![p(y|\\theta)](https://latex.codecogs.com/png.latex?p%28y%7C%5Ctheta%29
"p(y|\\theta)") (i.e., the data generating process) and the prior
![p(\\theta)](https://latex.codecogs.com/png.latex?p%28%5Ctheta%29
"p(\\theta)"). We start simple so we can build the model by adding
complexity as needed. This is encoded in the `parameters` and `model`
blocks in Stan. For example:

``` stan
parameters {
  real<lower=0> lambda;
}

model {
  lambda ~ normal(0, 6.44787);
  y ~ poisson(lambda);
}
```

The specified model can be compared with competing models to build
evidence for and against the motivating theory. In this way we can view
science as a sequence of models that serve as evidence in continuously
revising and updating theory.

## Model Calibration

### Perform Prior Predictive Checks

Now that we’ve built the (simple) model, we need to ensure that the
specified model is performing as expected (i.e., that it is consistent
with our domain expertise). Specifically, we need to be sure that the
likelihood and prior are *interacting* as expected, something impossible
to do just looking at the model specification. To do this, we need to
perform **prior predictive checks** (i.e., prior to the actual data):

  - Draw parameter values from the prior ![\\tilde{\\theta} \\sim
    p(\\theta)](https://latex.codecogs.com/png.latex?%5Ctilde%7B%5Ctheta%7D%20%5Csim%20p%28%5Ctheta%29
    "\\tilde{\\theta} \\sim p(\\theta)").
  - Draw data from the likelihood parameterized by the draws of the
    parameter values ![\\tilde{y} \\sim
    p(y|\\tilde{\\theta})](https://latex.codecogs.com/png.latex?%5Ctilde%7By%7D%20%5Csim%20p%28y%7C%5Ctilde%7B%5Ctheta%7D%29
    "\\tilde{y} \\sim p(y|\\tilde{\\theta})").
  - Summarize these data
    ![\\tilde{y}](https://latex.codecogs.com/png.latex?%5Ctilde%7By%7D
    "\\tilde{y}") by visualizing the relevant summary statistics.
  - Repeat this process many times, returning to modify the likelihood
    and prior as needed.

This **prior predictive distribution** should be plausible based on your
domain expertise and provides a cleaner way to communicate and evaluate
the consequences of the assumptions you’ve made in building your model.
We accomplish this by using the `generated quantities` block in Stan.
For example:

``` stan
generated quantities {
  real<lower=0> lambda = fabs(normal_rng(0, 6.44787));
  int y[N];
    for (n in 1:N) y[n] = poisson_rng(lambda);
}
```

We then call the generative model from R and extract the simulated data
to perform the prior predictive check. For example:

``` r
R <- 1000
N <- 1000

simu_data <- list("N" = N)

fit <- stan(
  file = "generative_ensemble.stan", 
  data = simu_data,
  iter = R,
  warmup = 0, 
  chains = 1, 
  refresh = R,
  seed = 42, 
  algorithm = "Fixed_param"
)

simu_lambdas <- extract(fit)$lambda
simu_ys <- extract(fit)$y
```

We could also simulate data just using R. However, simulating data using
Stan does a few things for us.

  - We will be using Stan to estimate the model, so we reduce
    duplicating efforts by keeping the simulation in stan.
  - Some of the distributions we’ll want to use (e.g., the LKJ
    distribution) don’t exist outside Stan.

### Calibrate the Model with Simulated Data and Evaluate

Are our computational tools sufficient to accurately fit the model?

Once we have a fully specified generative model that accurately reflects
our domain expertise, we are ready to calibrate or estimate the model.
To first confirm that the model and estimation routine are performing as
expected, we calibrate the model using simulated data to evaluate
estimation and and demonstrate parameter recovery.

#### Evaluate Diagnostics

HMC has built-in diagnostics.

#### Reparameterize

#### Evaluate Prior-Posterior Consistency

#### Confirm Parameter Recovery

> “Parameter recovery is an additional calibration that you might
> require of a model as there are no general guarantees of posterior
> behavior in Bayesian inference. That said, non- or weak-
> identifiability can manifest in especially poor calibrations.”
> -Michael Betancourt

#### Perform Simulation-Based Calibration

As a general diagnostic (with or without HMC), we can use
**simulation-based calibration**. If we simulate from the joint
distribution, construct posteriors, and then average over the
posteriors, we should get back the priors. This is using the
self-consistency of the Bayesian joint distribution. Ten simulations are
better than one.

  
![\\pi\_s (\\theta^\\prime) = \\int dy \\ d\\theta \\ \\pi\_s
(\\theta^\\prime | y) \\ \\pi\_s (y,
\\theta)](https://latex.codecogs.com/png.latex?%5Cpi_s%20%28%5Ctheta%5E%5Cprime%29%20%3D%20%5Cint%20dy%20%5C%20d%5Ctheta%20%5C%20%5Cpi_s%20%28%5Ctheta%5E%5Cprime%20%7C%20y%29%20%5C%20%5Cpi_s%20%28y%2C%20%5Ctheta%29
"\\pi_s (\\theta^\\prime) = \\int dy \\ d\\theta \\ \\pi_s (\\theta^\\prime | y) \\ \\pi_s (y, \\theta)")  

Let’s consider this step-by-step:

  - ![\\tilde{\\theta} \\sim
    \\pi\_s(\\theta)](https://latex.codecogs.com/png.latex?%5Ctilde%7B%5Ctheta%7D%20%5Csim%20%5Cpi_s%28%5Ctheta%29
    "\\tilde{\\theta} \\sim \\pi_s(\\theta)")
  - ![\\tilde{y} \\sim \\pi\_s(y |
    \\tilde{\\theta})](https://latex.codecogs.com/png.latex?%5Ctilde%7By%7D%20%5Csim%20%5Cpi_s%28y%20%7C%20%5Ctilde%7B%5Ctheta%7D%29
    "\\tilde{y} \\sim \\pi_s(y | \\tilde{\\theta})")
  - ![\\tilde{\\theta}^\\prime\_n \\sim \\pi\_s(\\theta^\\prime |
    \\tilde{y})](https://latex.codecogs.com/png.latex?%5Ctilde%7B%5Ctheta%7D%5E%5Cprime_n%20%5Csim%20%5Cpi_s%28%5Ctheta%5E%5Cprime%20%7C%20%5Ctilde%7By%7D%29
    "\\tilde{\\theta}^\\prime_n \\sim \\pi_s(\\theta^\\prime | \\tilde{y})")

Ranks may be the best way to test this self-consistency: ![r =
\\\#\\{\\tilde{\\theta} \<
\\tilde{\\theta}^\\prime\_n\\}](https://latex.codecogs.com/png.latex?r%20%3D%20%5C%23%5C%7B%5Ctilde%7B%5Ctheta%7D%20%3C%20%5Ctilde%7B%5Ctheta%7D%5E%5Cprime_n%5C%7D
"r = \\#\\{\\tilde{\\theta} \< \\tilde{\\theta}^\\prime_n\\}"). This
should give us a uniform distribution. This is **simulation-based
calibration** (SBC). It should be obvious when there are problems.

### Calibrate the Model with Real Data and Evaluate

Once we feel confident that the model is a correct reflection of the
underlying conceptual model and that the model is performing as expected
on simulated data, we can estimate the model using real data.

#### Diagnostics

## Model Validation

### Perform Posterior Predictive Checks

  - Draw values of the parameters from the posterior.
  - Draw predicted observations from the proposed likelihood
    parameterized by the drawn values of the parameters.
  - Visualize a comparison between these predicted observations and the
    actual observations to see if something is wrong.
  - Repeat many times.

This is known as generating prior predictive draws. If you have good
priors, your prior predictive draws will look vaguely plausible based on
our domain expertise.

We can produce the **posterior predictive distribution** (i.e.,
posterior to the data). In other words, what are the parameter values
consistent with our prior and what we’ve learned from the data.

So how good is our model? How close is it to the true data generating
process? A single measure of predictive fit is very limiting.
KL-divergence is at the core, with an estimate of the true data
generating process, is sensitive to the tails of the posterior. In
general, this means we can’t focus on the parts of the posterior that we
care about.

In general, when the small world doesn’t contain the true data
generating process, our model is **misfit**. Isolate the relevant
structure of the posterior using those **same summary statistics** from
the prior predictive checks. (This assumes we have the right summary
statistics.) Misfit results in tension between these posterior
predictive distributions and the summary statistics: our model doesn’t
have enough structure.

Even if the small world does contain the true data generating process,
our model can **overfit**. Conflict between two different data sets: our
model has too much structure.

  - Compare the predictive distribution to the data (check for misfit).
  - Compare the predictive distribution to the held-out data (check for
    overfitting).

![\\tilde{\\theta} \\sim \\pi\_s(\\theta |
\\tilde{y})](https://latex.codecogs.com/png.latex?%5Ctilde%7B%5Ctheta%7D%20%5Csim%20%5Cpi_s%28%5Ctheta%20%7C%20%5Ctilde%7By%7D%29
"\\tilde{\\theta} \\sim \\pi_s(\\theta | \\tilde{y})")

![\\tilde{y}^\\prime \\sim \\pi\_s(y^\\prime |
\\tilde{\\theta})](https://latex.codecogs.com/png.latex?%5Ctilde%7By%7D%5E%5Cprime%20%5Csim%20%5Cpi_s%28y%5E%5Cprime%20%7C%20%5Ctilde%7B%5Ctheta%7D%29
"\\tilde{y}^\\prime \\sim \\pi_s(y^\\prime | \\tilde{\\theta})")

![t(\\tilde{y}^\\prime)](https://latex.codecogs.com/png.latex?t%28%5Ctilde%7By%7D%5E%5Cprime%29
"t(\\tilde{y}^\\prime)")

Robust **posterior predictive checks** can be used in place of (or in
addition to) model comparison.

### Model Comparison

### Interpret Posterior Distributions

With the model estimated, we now need to interpret the output and make
correct inferences. This often starts in terms of model comparison. We
can use model fit statistics to see which of a competing set of models
performs best in terms of in-sample and out-of-sample fit.

  - LOO or/and WAIC (w/weights)?

See tidybayes/bayesplot for more ways to properly visualize/summarize
model output. Consider building in more predictive tasks.

## Links

  - [Towards a Principled Bayesian
    Workflow](https://betanalpha.github.io/assets/case_studies/principled_bayesian_workflow.html)
  - [tidybayes: Bayesian analysis + tidy data +
    geoms](http://mjskay.github.io/tidybayes/)
