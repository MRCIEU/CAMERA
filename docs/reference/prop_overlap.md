# Estimate expected vs observed replication of effects between discovery and replication datasets

Taken from Okbay et al 2016. Under the assumption that all discovery
effects are unbiased, what fraction of associations would replicate in
the replication dataset, given the differential power of the discovery
and replication datasets. Uses standard error of the replication dataset
to account for differences in sample size and distribution of
independent variable

## Usage

``` r
prop_overlap(b_disc, b_rep, se_disc, se_rep, alpha)
```

## Arguments

- b_disc:

  Vector of discovery betas

- b_rep:

  Vector of replication betas

- se_disc:

  Vector of discovery standard errors

- se_rep:

  Vector of replication standard errors

- alpha:

  Nominal replication significance threshold

## Value

List of results

- res: aggregate expected replication rate vs observed replication rate

- variants: per variant expected replication rates
