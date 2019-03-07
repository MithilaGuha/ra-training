A Tidy Bayesian Workflow
================

This **tidy Bayesian workflow** details the process of conducting
Bayesian inference in a tidy way using modern tools and diagnostics. In
particular, we will employ the tidyverse and related packages for data
wrangling and visualization and Stan for modeling. The workflow is
composed of three sections: **model building**, **model calibration**,
and **model validation**. The material draws heavily from Michael
Betancourt’s case studies and training on using Stan at Drexel
University in Fall 2018.

## Overview

  - **Model Building**
    1.  Start by reasoning about an aspirational model, without
        limitations.
    2.  Then reason about a simple model that strips away most of the
        complexity of the aspirational model.
    3.  The difference between the simple model and the aspirational
        model can motivate the summary statistics we can use for prior
        and posterior predictive checks.
  - **Model Calibration**
    4.  Are our modeling assumptions consistent with our domain
        expertise?
    5.  Are our computational tools sufficient to accurately fit the
        model?
    6.  How should we expect our inferences to perform?
  - **Model Validation**
    7.  Is our model rich enough to capture the relevant structure of
        the true data generating process?

## Model Building

### Describe the Model Conceptually

A model starts conceptually. Where do the data come from (i.e., what is
the data generating process)? This conceptual model often lives within a
literature of model building, motivated by theory, and at its most basic
may simply be a consideration of how to relax assumptions in an existing
model. In short, the model needs to be consistent with our domain
expertise.

### Define a Simple Model

### Define Observations and Relevant Summary Statistics

As part of this conceptual description, we should consider the ideal
dataset as well as what summary statistics, including visualizations,
might reveal the need for the proposed model (i.e., model-free
evidence). We encode the information about the observations using the
data block in Stan.

`data { int N; int y[N]; }`

### Build a Generative Model

Next, we translate the conceptual model into a mathematical
specification. A fully generative model includes both the likelihood
(i.e., the data generating process) and the priors (which may include a
model of heterogeneity). This is the most meaningful contribution we
make in modeling. The specified model can be compared with competing
models to build evidence for and against the motivating theory. In this
way we can view science as a sequence of models that serve as evidence
in continuously revising and updating theory.

\` data { int N; int y\[N\]; }

parameters { real\<lower=0\> lambda; }

model { lambda ~ normal(0, 6.44787); y ~ poisson(lambda); } \`

## Model Calibration

### Evaluate the Prior Predictive Distribution

As part of model building, there is great need to ensure that the
specified model is performing as expected (i.e., is consistent with our
domain expertise). Specifically, we need to be sure that the likelihood
and the prior are interacting as expected. To do this, for some prior
\(p(theta)\):

  - Draw parameter values from the prior.
  - Draw data from the proposed likelihood parameterized by the draws of
    the parameter values.
  - Visualize these data to see if something is wrong.
  - Repeate many times.

If you have good priors, this **prior predictive distribution** will
look vaguely plausible based on your domain expertise. By prior we mean
prior to the data with a focus on evaluating if the prior and likelihood
are proper. Integrate out the parameters and look at what the joint
distribution says are reasonable values. Are they reasonable? We can’t
typically look at this whole distribution, so look at **meaningful
summary statistics**.

\` data { int N; int y\[N\]; }

generated quantities { real\<lower=0\> lambda = fabs(normal\_rng(0,
6.44787)); int y\[N\]; for (n in 1:N) y\[n\] = poisson\_rng(lambda); }
\`

\` R \<- 1000 N \<- 1000

simu\_data \<- list(“N” = N)

fit \<- stan(file=‘generative\_ensemble.stan’, data=simu\_data, iter=R,
warmup=0, chains=1, refresh=R, seed=4838282, algorithm=“Fixed\_param”)

simu\_lambdas \<- extract(fit)\(lambda simu_ys <- extract(fit)\)y \`

“Some of the distributions in Stan don’t have equivalent random number
generators in other languages. For example, the LKJ distribution.”
-Michael Betancourt

“The prior predictive distribution, however, is just another way of
communicating the consequences of your modeling assumptions hopefully to
make it easier to evaluate them in the context of your domain
expertise.” -Michael Betancourt

### Evaluate Relevant Summary Statistics

Projecting this distribution onto meaningful summary statistics allows
us to compare with domain expectations. These are **prior predictive
checks**.

In addition to the prior predictive check, we can also evaluate the
presence of the model-free evidence within the simulated data.

### Fit the Simulated Data and Evaluate

Once we have a fully specified generative model, we are ready to
estimate the model. To first confirm that the model and estimation
routine are performing as expected, we estimate the model using
simulated data to evaluate estimation and and demonstrate parameter
recovery.

  - Diagnostics
  - Parameter Recovery
  - Prior-Posterior Consistency
  - Reparameterization

Start with Stan (HMC has built-in diagnostics).

However, what if we don’t have the HMC diagnostics (or diagnostics in
general)? If we simulate from the joint distribution, construct
posteriors, and then average over the posteriors, we should get back the
priors. This is using the self-consistency of the Bayesian joint
distribution. Ten simulations are better than
one.

\[\pi_s (\theta^\prime) = \int dy \ d\theta \ \pi_s (\theta^\prime | y) \ \pi_s (y, \theta)\]

Let’s consider this step-by-step:

\(\tilde{\theta} \sim \pi_s(\theta)\)

\(\tilde{y} \sim \pi_s(y | \tilde{\theta})\)

\(\tilde{\theta}^\prime_n \sim \pi_s(\theta^\prime | \tilde{y})\)

Ranks may be the best way to test this self-consistency:
\(r = \#\{\tilde{\theta} < \tilde{\theta}^\prime_n\}\). This should give
us a uniform distribution. This is **simulation-based calibration**
(SBC). It should be obvious when there are problems.

“Parameter recovery is an additional calibration that you might require
of a model as there are no general guarantees of posterior behavior in
Bayesian inference. That said, non or weak identifiability can manifest
in especially poor calibrations.” -Michael Betancourt

## Fit the Data and Evaluate

Once we feel confident that the model is a correct reflection of the
underlying conceptual model and that the model is performing as expected
on simulated data, we can estimate the model using real data.

  - Diagnostics

## Model Validation

### Analyze the Posterior Predictive Distribution

  - Draw values of the parameters from the posterior.
  - Draw predicted observations from the proposed likelihood
    parameterized by the drawn values of the parameters.
  - Visualize a comparison between these predicted observations and the
    actual observations to see if something is wrong.
  - Repeate many times.

This is known as generating prior predictive draws. If you have good
priors, your prior predictive draws will look vaguely plausible based on
our domain
expertise.

### 4\. Is our model rich enough to capture the relevant structure of the true data generating process?

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

\(\tilde{\theta} \sim \pi_s(\theta | \tilde{y})\)

\(\tilde{y}^\prime \sim \pi_s(y^\prime | \tilde{\theta})\)

\(t(\tilde{y}^\prime)\)

Robust **posterior predictive checks** can be used in place of (or in
addition to) model comparison.

### Intepretation

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
