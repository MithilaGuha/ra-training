// Observed choices and the experimental design.
data {
  int N;             // Number of respondents.
  int P;             // Number of product alternatives.
  int L;             // Number of (estimable) attribute levels.
  
  int Y[N];          // Vector of observed choices.
  matrix[P, L] X[N]; // Experimental design for each respondent.
}

// Parameters for the multinomial logit.
parameters {
  vector[L] B; // Vector of aggregate beta coefficients.
}

// Multinomial logit model.
model {
  // Standard normal prior for B.
  B ~ normal(0, 1);
  
  // Multinomial logit.
  for (n in 1:N) {
    Y[n] ~ categorical_logit(X[n] * B);
  }
}