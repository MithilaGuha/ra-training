// Observed choices and the experimental design.
data {
  int N;             // Number of observations.
  int P;             // Number of product alternatives.
  int L;             // Number of (estimable) attribute levels.
  
  int Y[N];          // Vector of observed choices.
  matrix[P, L] X[N]; // Experimental design for each observations.
}

// Simulate data according to the multinomial logit model.
generated quantities {
  vector[L] B_tilde; // Vector of aggregate beta coefficients.
  
  // Draw parameter values from the prior.
  for (l in 1:L) {
    B_tilde[l] = normal_rng(0, 1);
  }
  
  // Draw data from the likelihood.
  for (n in 1:N) {
    Y_tilde[n] = categorical_logit_rng(X[n] * B_tilde);
  }
}

