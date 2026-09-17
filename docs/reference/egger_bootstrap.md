# Perform MR GxE

For a single variant estimated in different sub groups.

## Usage

``` r
egger_bootstrap(b_gx, se_gx, b_gy, se_gy, nboot = 1000)
```

## Arguments

- b_gx:

  Vector of instrument-exposure associations, one for each sub group

- se_gx:

  Vector of standard errors to b_gx

- b_gy:

  Vector of instrument-outcome associations, one for each sub group

- se_gy:

  Vector of standard errors for b_gy

- nboot:

  Number of bootstraps. Default=1000

## Value

List

- a = intercept estimate (pleiotropy)

- b = slope estimate (b_iv effect)

- a_se = standard error of intercept

- b_se = standard error of slope

- a_pval = p-value of intercept estimate

- b_pval = p-value of slope estimate

- a_mean = mean value of intercept from bootstraps

- b_mean = mean value of slope estimates from bootstraps

## Details

Estimate the degree of pleiotropy using MR GxE. This method uses a
negative control type approach based on an assumption that the
instrument-exposure association is uncorrelated with the pleiotropic
effect. Therefore, as the instrument-exposure association reduces in
magnitude, the effect on the outcome will reduce towards an intercept
term which represents the pleiotropic effect.

Standard errors are obtained from parametric bootstrap
