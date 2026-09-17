# Fixed effects meta analysis vectorised across multiple SNPs

Assumes effects across studies are all on the same scale

## Usage

``` r
fixed_effects_meta_analysis_fast(beta_mat, se_mat)
```

## Arguments

- beta_mat:

  Matrix of betas - rows are SNPs, columns are studies

- se_mat:

  Matrix of SEs - rows are SNPs, columns are studies

## Value

list of meta analysis betas and SEs
