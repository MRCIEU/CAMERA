# Cross Ancestry Mendelian Randomisation

<!-- badges: start -->
[![R-CMD-check](https://github.com/MRCIEU/CAMERA/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/MRCIEU/CAMERA/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The goal of CAMeRa is to estimate causal effects using summary
statistics in multiple ancestries. CAMeRa provides:

1)  Selecting genetic instruments for multiple populations.
2)  Estimating the causal effect where exposure and outcome summary
    statistics are from different ancestral populations.
3)  Jointly modelling causal and pleiotropic effects across multiple
    populations.

## Installation

Install CAMeRa from our MRCIEU R-Universe

```r
install.packages('CAMeRa', repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))
```

or from its GitHub repository

``` r
install.packages("remotes")
remotes::install_github("MRCIEU/CAMERA")
```

## Example

See the vignettes for examples

## Citation

If using this software or methodology please cite:

Yoonsu Cho, Amanda Chong, Tom Palmer, Amy Mason, John Ferguson, David Evans, George Davey Smith, Gibran Hemani. **Jointly modelling multiple ancestral populations using GWAS summary data improves causal inference**. 27 March 2025, PREPRINT (Version 1) available at Research Square <https://doi.org/10.21203/rs.3.rs-6091701/v1>
