# Import to CAMERA from local data

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`CAMeRa`](https://github.com/MRCIEU/CAMERA)`)`

You can supply to CAMERA from text files or from OpenGWAS (currently not
a mixture of both, though you can download the studies in OpenGWAS to be
used as raw files).

## Generating the data manually

You need to supply the following data:

- `instrument_raw` = a data frame of pooled instruments across all
  ancestries, that has been extracted from each ancestry for the
  exposure traits. Optionally also provide the same for the outcome
  traits.
- `instrument_outcome` = instruments in `instrument_raw` extracted from
  the outcome datasets
- `instrument_regions` = named list of data frames of length number of
  unique instruments in `instrument_raw`. Names of each item are the
  instruments. Each item is a list of regional extracts around the
  instrument from each population exposure study.
- `instrument_outcome_regions` = as above but for the outcome datasets.

Examples of these datasets can be seen in the following file:

\
[`load`](https://rdrr.io/r/base/load.html)`(`[`system.file`](https://rdrr.io/r/base/system.file.html)`(``package``=``"CAMeRa"``, ``"extdata/example-local.rdata"``)``)`\
[`head`](https://rdrr.io/r/utils/head.html)`(``instrument_raw``)`\
`#>   chr  position   eaf       beta         se        p ea nea             rsid`\
`#> 1   3 122285218 0.224  0.0203948 0.00583030 4.69e-04  C  CT 3:122285218_C_CT`\
`#> 2   3 122285218 0.438  0.0198445 0.00542238 2.52e-04  C  CT 3:122285218_C_CT`\
`#> 3   3 122285218 0.302  0.0189980 0.00166078 2.66e-30  C  CT 3:122285218_C_CT`\
`#> 4   3 122285218 0.237  0.0139407 0.00808064 8.45e-02  C  CT 3:122285218_C_CT`\
`#> 5   3 122285218 0.296  0.0154089 0.00777522 4.75e-02  C  CT 3:122285218_C_CT`\
`#> 6   5 139567696 0.244 -0.0126912 0.01723630 4.62e-01  G   T  5:139567696_G_T`\
`#>   trait pop      id nstudies target_trait`\
`#> 1   LDL AFR LDL AFR        5          LDL`\
`#> 2   LDL EAS LDL EAS        5          LDL`\
`#> 3   LDL EUR LDL EUR        5          LDL`\
`#> 4   LDL AMR LDL AMR        5          LDL`\
`#> 5   LDL SAS LDL SAS        5          LDL`\
`#> 6   LDL AFR LDL AFR        5          LDL`

\
[`head`](https://rdrr.io/r/utils/head.html)`(``instrument_outcome``)`\
`#>   chr  position    eaf    beta     se       p ea nea            rsid  trait pop`\
`#> 1   5 139567696 0.2304  0.0069 0.0080 0.38670  G   T 5:139567696_G_T Stroke EUR`\
`#> 2   5 139567696 0.2474 -0.0483 0.0385 0.20930  G   T 5:139567696_G_T Stroke AFR`\
`#> 3   5 139567696 0.2618  0.0183 0.0831 0.82570  G   T 5:139567696_G_T Stroke AMR`\
`#> 4   6  27067657 0.9275 -0.0011 0.0132 0.93400  A   T  6:27067657_A_T Stroke EUR`\
`#> 5   6  27067657 0.9754  0.2119 0.2189 0.33310  A   T  6:27067657_A_T Stroke AMR`\
`#> 6   6 161010118 0.9362 -0.0427 0.0136 0.00177  A   G 6:161010118_A_G Stroke EUR`\
`#>                                          id nstudies target_trait`\
`#> 1                           Stroke European        5          LDL`\
`#> 2 Stroke African American or Afro-Caribbean        5          LDL`\
`#> 3         Stroke Hispanic or Latin American        5          LDL`\
`#> 4                           Stroke European        5          LDL`\
`#> 5         Stroke Hispanic or Latin American        5          LDL`\
`#> 6                           Stroke European        5          LDL`

Each region contains a data frame for each population, e.g. the first
few rows of the first population in the first region:

\
[`names`](https://rdrr.io/r/base/names.html)`(``instrument_regions``[[``1``]``]``)`\
`#> [1] "LDL AFR" "LDL AMR" "LDL EAS" "LDL EUR" "LDL SAS"`\
[`head`](https://rdrr.io/r/utils/head.html)`(``instrument_regions``[[``1``]``]``[[``1``]``]``)`\
`#>   chr  position    eaf        beta         se     p ea nea            rsid`\
`#> 1   3 121981372 0.9842  0.02316450 0.02038330 0.256  C   T 3:121981372_C_T`\
`#> 2   3 121981609 0.0346  0.01894390 0.01342740 0.158  A   G 3:121981609_A_G`\
`#> 3   3 121981619 0.1460  0.00208076 0.00690027 0.763  G   T 3:121981619_G_T`\
`#> 4   3 121981629 0.9778 -0.00524940 0.01672870 0.754  A   G 3:121981629_A_G`\
`#> 5   3 121981835 0.8230 -0.00165270 0.00632628 0.794  C   G 3:121981835_C_G`\
`#> 6   3 121981836 0.1720  0.00212244 0.00644822 0.742  A   G 3:121981836_A_G`\
`#>   trait pop      id`\
`#> 1   LDL AFR LDL AFR`\
`#> 2   LDL AFR LDL AFR`\
`#> 3   LDL AFR LDL AFR`\
`#> 4   LDL AFR LDL AFR`\
`#> 5   LDL AFR LDL AFR`\
`#> 6   LDL AFR LDL AFR`

\
[`names`](https://rdrr.io/r/base/names.html)`(``instrument_outcome_regions``[[``1``]``]``)`\
`#> [1] "Stroke African American or Afro-Caribbean"`\
`#> [2] "Stroke Hispanic or Latin American"        `\
`#> [3] "Stroke East Asian"                        `\
`#> [4] "Stroke European"                          `\
`#> [5] "Stroke South Asian"`\
[`head`](https://rdrr.io/r/utils/head.html)`(``instrument_outcome_regions``[[``1``]``]``[[``1``]``]``)`\
`#>   chr  position    eaf    beta     se      p ea nea            rsid  trait pop`\
`#> 1   3 122289921 0.3870 -0.0073 0.0302 0.8075  C   T 3:122289921_C_T Stroke AFR`\
`#> 2   3 122108718 0.3450 -0.0224 0.0297 0.4514  G   T 3:122108718_G_T Stroke AFR`\
`#> 3   3 122356077 0.1535  0.0322 0.0422 0.4450  G   T 3:122356077_G_T Stroke AFR`\
`#> 4   3 122125052 0.3089  0.0319 0.0306 0.2967  A   G 3:122125052_A_G Stroke AFR`\
`#> 5   3 122467637 0.0267  0.1760 0.1027 0.0864  C   T 3:122467637_C_T Stroke AFR`\
`#> 6   3 122297742 0.3234 -0.0286 0.0303 0.3444  A   G 3:122297742_A_G Stroke AFR`\
`#>                                          id`\
`#> 1 Stroke African American or Afro-Caribbean`\
`#> 2 Stroke African American or Afro-Caribbean`\
`#> 3 Stroke African American or Afro-Caribbean`\
`#> 4 Stroke African American or Afro-Caribbean`\
`#> 5 Stroke African American or Afro-Caribbean`\
`#> 6 Stroke African American or Afro-Caribbean`

For example scripts on how these data were generated see
<https://github.com/yoonsucho/CAMERA_analysis/tree/main/scripts/ldl_stroke_analysis>

## Generating the data using `CAMERA_local`

We have developed a separate set of functions to organise data from text
files to generate the data above.

\
`metadata`` ``<-`` `[`readRDS`](https://rdrr.io/r/base/readRDS.html)`(`[`system.file`](https://rdrr.io/r/base/system.file.html)`(``package``=``"CAMeRa"``, ``"extdata/example-metadata.rds"``)``)`\
`metadata`\
`#>        what pop  trait                                        id       n`\
`#> 1  exposure AFR    LDL                                   LDL AFR   91144`\
`#> 2  exposure EAS    LDL                                   LDL EAS   79831`\
`#> 3  exposure EUR    LDL                                   LDL EUR  900191`\
`#> 4  exposure AMR    LDL                                   LDL AMR   44790`\
`#> 5  exposure SAS    LDL                                   LDL SAS   30412`\
`#> 6   outcome EUR Stroke                           Stroke European 1308460`\
`#> 7   outcome EAS Stroke                         Stroke East Asian  264655`\
`#> 8   outcome AFR Stroke Stroke African American or Afro-Caribbean   23991`\
`#> 9   outcome AMR Stroke         Stroke Hispanic or Latin American    5662`\
`#> 10  outcome SAS Stroke                        Stroke South Asian   11312`\
`#>    rsid_col chr_col pos_col eaf_col beta_col se_col pval_col ea_col oa_col`\
`#> 1         1       2       3       8        9     10       12      5      4`\
`#> 2         1       2       3       8        9     10       12      5      4`\
`#> 3         1       2       3       8        9     10       12      5      4`\
`#> 4         1       2       3       8        9     10       12      5      4`\
`#> 5         1       2       3       8        9     10       12      5      4`\
`#> 6        NA       1       2       3        4      5        6     10     11`\
`#> 7        NA       1       2       3        4      5        6     10     11`\
`#> 8        NA       1       2       3        4      5        6     10     11`\
`#> 9        NA       1       2       3        4      5        6     10     11`\
`#> 10       NA       1       2       3        4      5        6     10     11`\
`#>                                                                                                                   fn`\
`#> 1  /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/LDL_INV_AFR_HRC_1KGP3_others_ALL.meta.singlevar.results.gz`\
`#> 2             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/LDL_INV_EAS_1KGP3_ALL.meta.singlevar.results.gz`\
`#> 3  /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/LDL_INV_EUR_HRC_1KGP3_others_ALL.meta.singlevar.results.gz`\
`#> 4             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/LDL_INV_HIS_1KGP3_ALL.meta.singlevar.results.gz`\
`#> 5  /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/LDL_INV_SAS_HRC_1KGP3_others_ALL.meta.singlevar.results.gz`\
`#> 6                             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/GCST90104539_buildGRCh37.tsv.gz`\
`#> 7                             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/GCST90104544_buildGRCh37.tsv.gz`\
`#> 8                             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/GCST90104549_buildGRCh37.tsv.gz`\
`#> 9                             /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/GCST90104554_buildGRCh37.tsv.gz`\
`#> 10                            /home/gh13047/repo/CAMERA_analysis/data/stroke_ldl/raw/GCST90104559_buildGRCh37.tsv.gz`\
`#>    units`\
`#> 1     SD`\
`#> 2     SD`\
`#> 3     SD`\
`#> 4     SD`\
`#> 5     SD`\
`#> 6  logOR`\
`#> 7  logOR`\
`#> 8  logOR`\
`#> 9  logOR`\
`#> 10 logOR`

\
`ld_ref`` ``<-`` ``dplyr``::`[`tibble`](https://tibble.tidyverse.org/reference/tibble.html)`(`\
`    pop ``=`` `[`unique`](https://rdrr.io/r/base/unique.html)`(``metadata``$``pop``)``,`\
`    bfile ``=`` `[`file.path`](https://rdrr.io/r/base/file.path.html)`(``"path/to/plink_files/"``, ``pop``)`\
`)`\
`ld_ref`\
`#> ``# A tibble: 5 × 2`\
`#>   pop   bfile                   `\
`#>   ``<chr>`` ``<chr>``                   `\
`#> ``1`` AFR   path/to/plink_files//AFR`\
`#> ``2`` EAS   path/to/plink_files//EAS`\
`#> ``3`` EUR   path/to/plink_files//EUR`\
`#> ``4`` AMR   path/to/plink_files//AMR`\
`#> ``5`` SAS   path/to/plink_files//SAS`

\
`localdata`` ``<-`` `[`CAMERA_local`](https://mrcieu.github.io/CAMERA/reference/CAMERA_local.md)`$``new``(``metadata ``=`` ``metadata``, ld_ref ``=`` ``ld_ref``, plink_bin ``=`` ``"path/to/plink"``)`\
`localdata``$``organise``(``)`

This will read the files specified in the metadata and attempt to
arrange the data as described above, generating
`localdata$instrument_raw`, `localdata$instrument_outcome` etc.

You can then generate the `CAMERA` object e.g.

\
`l`` ``<-`` `[`CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md)`$``new``(``)`\
`l``$``import_from_local``(`\
`  instrument_raw``=``instrument_raw``, `\
`  instrument_outcome``=``instrument_outcome``, `\
`  instrument_regions``=``instrument_regions``, `\
`  instrument_outcome_regions``=``instrument_outcome_regions``, `\
`  exposure_ids``=`[`unique`](https://rdrr.io/r/base/unique.html)`(``instrument_raw``$``id``)``, `\
`  outcome_ids``=`[`unique`](https://rdrr.io/r/base/unique.html)`(`[`names`](https://rdrr.io/r/base/names.html)`(``instrument_outcome_regions``[[``1``]``]``)``)``,`\
`  pops``=`[`c`](https://rdrr.io/r/base/c.html)`(``"AFR"``, ``"EAS"``, ``"EUR"``, ``"AMR"``, ``"SAS"``)`\
`)`\
`#> list()`\
\
`l``$``instrument_heterogeneity``(``)`\
`#> ``# A tibble: 14 × 9`\
`#>    Reference Replication  nsnp agreement     se     pval      Q   Q_pval`\
`#>    ``<chr>``     ``<chr>``       ``<int>``     ``<dbl>``  ``<dbl>``    ``<dbl>``  ``<dbl>``    ``<dbl>`\
`#> `` 1`` LDL AFR   LDL EAS         3     1.06  0.371  4.27``e``- 3`` 14.5   6.99``e``- 4`\
`#> `` 2`` LDL AFR   LDL EUR         3     0.942 0.020``7`` 0   `` ``     0.168 9.19``e``- 1`\
`#> `` 3`` LDL AFR   LDL AMR         4     0.901 0.138  7.04``e``-11``  1.77  6.22``e``- 1`\
`#> `` 4`` LDL AFR   LDL SAS         2     1.06  0.261  4.93``e``- 5``  1.10  2.94``e``- 1`\
`#> `` 5`` LDL EAS   LDL AFR         3     0.656 0.125  1.41``e``- 7``  2.11  3.49``e``- 1`\
`#> `` 6`` LDL EAS   LDL EUR         3     0.692 0.151  4.65``e``- 6`` 41.3   1.10``e``- 9`\
`#> `` 7`` LDL EAS   LDL AMR         3     0.793 0.175  6.20``e``- 6``  0.399 8.19``e``- 1`\
`#> `` 8`` LDL EAS   LDL SAS         3     0.726 0.156  3.47``e``- 6``  0.216 8.98``e``- 1`\
`#> `` 9`` LDL EUR   LDL AFR         8     0.990 0.117  2.62``e``-17``  2.27  9.43``e``- 1`\
`#> ``10`` LDL EUR   LDL EAS         5     1.07  0.235  5.06``e``- 6`` 14.3   6.36``e``- 3`\
`#> ``11`` LDL EUR   LDL AMR        10     0.883 0.146  1.63``e``- 9`` 11.6   2.40``e``- 1`\
`#> ``12`` LDL EUR   LDL SAS         8     0.835 0.189  1.02``e``- 5``  9.85  1.97``e``- 1`\
`#> ``13`` LDL AMR   LDL AFR         2     0.931 0.198  2.68``e``- 6``  2.18  1.39``e``- 1`\
`#> ``14`` LDL AMR   LDL EUR         2     1.02  0.148  5.49``e``-12`` 40.1   2.47``e``-10`\
`#> ``# ℹ 1 more variable: I2 <dbl>`
