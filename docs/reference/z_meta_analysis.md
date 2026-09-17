# P-value based meta analysis

Uses weighted Z scores following advice from
https://onlinelibrary.wiley.com/doi/full/10.1111/j.1420-9101.2005.00917.x
Suggested weights are 1/se^2 However se is scale dependent and it would
be ideal to avoid scale issues at this stage So using instead calculate
expected se based on n and af. Assumes continuous traits in the way it
uses n (i.e. not case control aware at the moment)

## Usage

``` r
z_meta_analysis(beta_mat, se_mat, n, eaf_mat)
```

## Arguments

- beta_mat:

  Matrix of betas - rows are SNPs, columns are studies

- se_mat:

  Matrix of SEs - rows are SNPs, columns are studies

- n:

  Vector of sample sizes for each

- eaf_mat:

  Matrix of allele frequencies - rows are SNPs, columns are studies
