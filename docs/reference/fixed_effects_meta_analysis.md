# Perform fixed effects meta analysis for one association

Perform fixed effects meta analysis for one association

## Usage

``` r
fixed_effects_meta_analysis(beta_vec, se_vec, infl = 10000)
```

## Arguments

- beta_vec:

  Vector of betas

- se_vec:

  Vector of ses

- infl:

  Inflation factor - how much larger is the estimate than the estimate
  of the tightest SE - for use in removing unreliable estimates

## Value

list of results
