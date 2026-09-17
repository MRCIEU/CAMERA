# Identify blown up estimates

Sometimes estimates appear unstable. They are likely unreliable and best
to not use for heterogeneity analyses etc.

## Usage

``` r
identify_blownup_estimates(b, se, infl)
```

## Arguments

- b:

  Vector of betas

- se:

  Vector of SEs

- infl:

  Inflation factor - how much larger is the estimate than the estimate
  of the tightest SE

## Value

index of betas to remove
