# Tutorial

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`CAMeRa`](https://github.com/MRCIEU/CAMERA)`)`

## Introduction

This software attempts to bring together various tools to improve
cross-ancestry Mendelian randomisation. It will use an example of
performing analysis of BMI on coronary heart disease across four major
ancestral groups.

Overview:

- Initialise data
- Check phenotype scales across ancestries
- Extract instruments
- Evaluate instrument heterogeneity across populations
- Extract outcome data
- Harmonise exposure and outcome data
- Perform analysis using raw instruments
- Perform regional scan to obtain LD agnostic instruments
- Re-perform analysis using regional instruments
- Evaluate similarity of pleiotropy across ancestry
- Evaluate similarity of instrument-exposure associations
- Use cross-population instrument-exposure heterogeneity in MR GxE
  framework to estimate pleiotropy distributions
- Saving and loading data

## Initialise data

CAMeRa begins by choosing an exposure and outcome hypothesis that can be
tested in multi-ancestral populations. Here, we will be estimating the
causal effect of body mass index (BMI) on coronary heart disease (CHD)
in European (EUR), East Asian (EAS), African (AFR) and South Asian (SAS)
ancestries.

Summary statistics data can be extracted from the IEU GWAS database
using the [TwoSampleMR](https://mrcieu.github.io/TwoSampleMR/) package.
A list of available traits can be obtained using:

\
`traits`` ``<-`` ``TwoSampleMR``::`[`available_outcomes`](https://mrcieu.github.io/TwoSampleMR/reference/available_outcomes.html)`(``)`

You can also browse the available traits here:
<https://gwas.mrcieu.ac.uk/>. Also see other vignettes on this site
about how you can use local summary statistics instead.

Querying the OpenGWAS API requires an access token, see the [ieugwasr
guide](https://mrcieu.github.io/ieugwasr/articles/guide.html#authentication)
for how to obtain and set one up. The examples in this vignette make
many API queries and so may use up a large part of your
[allowance](https://api.opengwas.io/api/#allowance). To keep this
vignette fast to build, the code chunks that query the API are not run
here, instead the results are loaded from an example object that ships
with the package.

Once you obtain the study IDs for the exposure and the outcome, open R6
class environment to run CAMERA. The minimum information required for
CAMERA is the following:

- Summary statistics for the exposure and the outcome
- Population information
- Plink (version 1.90)
- LD reference data

Plink (version 1.90) and LD reference data are required to identify
instruments that can be used for both populations. LD reference data can
be accessed from: <http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz>.

The example below uses the
[genetics.binaRies](https://github.com/MRCIEU/genetics.binaRies) package
to locate a plink executable. It is not installed with CAMeRa, so either
install it with

\
[`install.packages`](https://rdrr.io/r/utils/install.packages.html)`(``"genetics.binaRies"``, repos ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"https://mrcieu.r-universe.dev"``, ``"https://cloud.r-project.org"``)``)`

or set `plink` to the path of your own plink executable.

\
`bfile_dir`` ``<-`` ``"/path/to/ld_files"`\
`x`` ``<-`` `[`CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md)`$``new``(`\
`  exposure_ids``=`[`c`](https://rdrr.io/r/base/c.html)`(`\
`    ``"ukb-e-23104_CSA"``, `\
`    ``"ukb-e-21001_AFR"``, `\
`    ``"ukb-b-19953"``, `\
`    ``"bbj-a-1"`\
`  ``)``, `\
`  outcome_ids``=`[`c`](https://rdrr.io/r/base/c.html)`(`\
`    ``"ukb-e-411_CSA"``, `\
`    ``"ukb-e-411_AFR"``, `\
`    ``"ieu-a-7"``, `\
`    ``"bbj-a-109"`\
`  ``)``, `\
`  pops ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"SAS"``, ``"AFR"``, ``"EUR"``, ``"EAS"``)``,`\
`  bfiles``=`[`file.path`](https://rdrr.io/r/base/file.path.html)`(``bfile_dir``, `[`c`](https://rdrr.io/r/base/c.html)`(``"SAS"``, ``"AFR"``, ``"EUR"``, ``"EAS"``)``)``,`\
`  plink ``=`` ``genetics.binaRies``::``get_plink_binary``(``)``,        `\
`  radius``=``50000``, `\
`  clump_pop``=``"EUR"`\
`)`\
`x`

In this vignette the code chunks that query OpenGWAS or need plink are
shown but not run. Instead, we load the results of running them from an
example object that ships with the package. This object was created in
September 2026. The data in OpenGWAS can change over time, so if you run
the analysis yourself your results may differ from those shown here.

\
`x_example`` ``<-`` `[`readRDS`](https://rdrr.io/r/base/readRDS.html)`(`[`system.file`](https://rdrr.io/r/base/system.file.html)`(``package``=``"CAMeRa"``, ``"extdata/example-CAMERA.rds"``)``)`\
`x`` ``<-`` `[`CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md)`$``new``(``)`\
`x``$``import``(``x_example``)`\
[`rm`](https://rdrr.io/r/base/rm.html)`(``x_example``)`

## Check phenotype scales across ancestries

Make sure that the exposures/outcomes are matched across the
populations. The different populations should have the same
exposure-outcome pair, with exposure and outcome traits measured in the
same way and with the same units. Also, instrument-trait associations
should be consistent between the populations (e.g. how similar SNP-BMI
association in EUR to SNP-BMI association in EAS). You can check this as
follows:

\
`x``$``check_phenotypes``(``ids``=``x``$``exposure_ids``)`\
`x``$``check_phenotypes``(``ids``=``x``$``outcome_ids``)`

## Extract instruments

We can now perform the analysis, which will do the following:

1.  Extract instruments for the exposures
2.  Check the validity of the instruments across the populations
    (Standardise/scale the data if necessary)
3.  Extract new instruments based on LD information and fine-mapping
4.  Extract instruments for the outcomes
5.  Harmonise the exposure data and the outcome data
6.  Perform MR

See [`?CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md), or
the [CAMERA reference
page](https://mrcieu.github.io/CAMERA/reference/CAMERA.html), for
details of the options and outputs of each method. A summary of the
methods used in this vignette is given in the [Overview of
methods](#overview-of-methods) section at the end.

The following function identifies SNPs that have strong associations
with the exposure in each population. This is the same method as
instrument extraction for multivariable MR.

\
`x``$``extract_instruments``(``)`

A data frame of the extracted instruments is stored in
`x$instrument_raw`

\
[`str`](https://rdrr.io/r/utils/str.html)`(``x``$``instrument_raw``)`\
`#> 'data.frame':    1528 obs. of  14 variables:`\
`#>  $ rsid      : chr  "1:2723214_A_C" "1:6657424_A_C" "1:11207269_C_T" "1:19934900_A_G" ...`\
`#>  $ chr       : chr  "1" "1" "1" "1" ...`\
`#>  $ position  : int  2723214 6657424 11207269 19934900 23313353 33784146 39564930 47678458 49996959 66434743 ...`\
`#>  $ id        : chr  "ukb-e-23104_CSA" "ukb-e-23104_CSA" "ukb-e-23104_CSA" "ukb-e-23104_CSA" ...`\
`#>  $ beta      : num  -0.0266 -0.0235 0.0171 -0.0148 -0.0169 ...`\
`#>  $ se        : num  0.0154 0.0154 0.0192 0.0169 0.0146 ...`\
`#>  $ p         : num  0.0841 0.1262 0.3728 0.3823 0.2496 ...`\
`#>  $ ea        : chr  "A" "A" "C" "A" ...`\
`#>  $ nea       : chr  "C" "C" "T" "G" ...`\
`#>  $ eaf       : num  0.33 0.324 0.166 0.234 0.578 ...`\
`#>  $ units     : chr  "NA" "NA" "NA" "NA" ...`\
`#>  $ samplesize: num  8658 8658 8658 8658 8658 ...`\
`#>  $ method    : chr  "raw" "raw" "raw" "raw" ...`\
`#>  $ rsido     : chr  "rs4648450" "rs3866805" "rs2791643" "rs61740466" ...`

## Evaluate instrument heterogeneity across populations

It is important to ensure that the instruments for the exposure are
valid across the populations. Once instruments for the exposure trait
are identified for each population, we can assess specificity of the
instruments. Each of the following functions estimates heterogeneity of
the instruments between and calculates fraction of the instruments
(obtained from the Step 1) that are replicated between the populations.

\
`x``$``instrument_heterogeneity``(``)`\
`#> ``# A tibble: 6 × 9`\
`#>   Reference Replication  nsnp agreement     se      pval     I2      Q    Q_pval`\
`#>   ``<chr>``     ``<chr>``       ``<int>``     ``<dbl>``  ``<dbl>``     ``<dbl>``  ``<dbl>``  ``<dbl>``     ``<dbl>`\
`#> ``1`` ukb-b-19… ukb-e-2310…   373     0.676 0.047``8`` 2.78``e``- 45`` 0.031``5``  385.  3.09``e``-  1`\
`#> ``2`` ukb-b-19… ukb-e-2100…   373     0.476 0.068``3`` 3.35``e``- 12`` 0.103   416.  5.85``e``-  2`\
`#> ``3`` ukb-b-19… bbj-a-1       373     0.578 0.021``0`` 3.97``e``-166`` 0.635  ``1``022.  5.75``e``- 62`\
`#> ``4`` bbj-a-1   ukb-e-2310…    46     0.761 0.093``2`` 3.15``e``- 16`` 0.176    55.8 1.29``e``-  1`\
`#> ``5`` bbj-a-1   ukb-e-2100…    46     0.518 0.144  3.31``e``-  4`` 0.354    71.2 7.69``e``-  3`\
`#> ``6`` bbj-a-1   ukb-b-19953    46     0.843 0.054``4`` 5.12``e``- 54`` 0.953   975.  5.68``e``-175`

\
`x``$``estimate_instrument_specificity``(``instrument``=``x``$``instrument_raw``)`\
`#> Checking ukb-e-23104_CSA against ukb-e-21001_AFR`\
`#> Checking ukb-e-23104_CSA against ukb-b-19953`\
`#> Checking ukb-e-23104_CSA against bbj-a-1`\
`#> Checking ukb-e-21001_AFR against ukb-e-23104_CSA`\
`#> Checking ukb-e-21001_AFR against ukb-b-19953`\
`#> Checking ukb-e-21001_AFR against bbj-a-1`\
`#> Checking ukb-b-19953 against ukb-e-23104_CSA`\
`#> Checking ukb-b-19953 against ukb-e-21001_AFR`\
`#> Checking ukb-b-19953 against bbj-a-1`\
`#> Checking bbj-a-1 against ukb-e-23104_CSA`\
`#> Checking bbj-a-1 against ukb-e-21001_AFR`\
`#> Checking bbj-a-1 against ukb-b-19953`\
`#>          discovery     replication nsnp  metric    datum       value`\
`#> 1  ukb-e-21001_AFR ukb-e-23104_CSA    1 P-value Expected   0.9987758`\
`#> 2  ukb-e-21001_AFR ukb-e-23104_CSA    1 P-value Observed   1.0000000`\
`#> 3  ukb-e-21001_AFR ukb-e-23104_CSA    1    Sign Expected   0.9999995`\
`#> 4  ukb-e-21001_AFR ukb-e-23104_CSA    1    Sign Observed   1.0000000`\
`#> 5  ukb-e-21001_AFR     ukb-b-19953    1 P-value Expected   1.0000000`\
`#> 6  ukb-e-21001_AFR     ukb-b-19953    1 P-value Observed   1.0000000`\
`#> 7  ukb-e-21001_AFR     ukb-b-19953    1    Sign Expected   0.9999995`\
`#> 8  ukb-e-21001_AFR     ukb-b-19953    1    Sign Observed   1.0000000`\
`#> 9  ukb-e-21001_AFR         bbj-a-1    1 P-value Expected   1.0000000`\
`#> 10 ukb-e-21001_AFR         bbj-a-1    1 P-value Observed   1.0000000`\
`#> 11 ukb-e-21001_AFR         bbj-a-1    1    Sign Expected   0.9999995`\
`#> 12 ukb-e-21001_AFR         bbj-a-1    1    Sign Observed   1.0000000`\
`#> 13     ukb-b-19953 ukb-e-23104_CSA  373 P-value Expected   1.7599653`\
`#> 14     ukb-b-19953 ukb-e-23104_CSA  373 P-value Observed   2.0000000`\
`#> 15     ukb-b-19953 ukb-e-23104_CSA  373    Sign Expected 311.1377768`\
`#> 16     ukb-b-19953 ukb-e-23104_CSA  373    Sign Observed 270.0000000`\
`#> 17     ukb-b-19953 ukb-e-21001_AFR  373 P-value Expected   0.4125545`\
`#> 18     ukb-b-19953 ukb-e-21001_AFR  373 P-value Observed   1.0000000`\
`#> 19     ukb-b-19953 ukb-e-21001_AFR  373    Sign Expected 281.1770175`\
`#> 20     ukb-b-19953 ukb-e-21001_AFR  373    Sign Observed 232.0000000`\
`#> 21     ukb-b-19953         bbj-a-1  373 P-value Expected 127.0276153`\
`#> 22     ukb-b-19953         bbj-a-1  373 P-value Observed  41.0000000`\
`#> 23     ukb-b-19953         bbj-a-1  373    Sign Expected 368.2446361`\
`#> 24     ukb-b-19953         bbj-a-1  373    Sign Observed 327.0000000`\
`#> 25         bbj-a-1 ukb-e-23104_CSA   46 P-value Expected   1.4318562`\
`#> 26         bbj-a-1 ukb-e-23104_CSA   46 P-value Observed   2.0000000`\
`#> 27         bbj-a-1 ukb-e-23104_CSA   46    Sign Expected  42.1873456`\
`#> 28         bbj-a-1 ukb-e-23104_CSA   46    Sign Observed  40.0000000`\
`#> 29         bbj-a-1 ukb-e-21001_AFR   46 P-value Expected   0.2499113`\
`#> 30         bbj-a-1 ukb-e-21001_AFR   46 P-value Observed   1.0000000`\
`#> 31         bbj-a-1 ukb-e-21001_AFR   46    Sign Expected  38.9215168`\
`#> 32         bbj-a-1 ukb-e-21001_AFR   46    Sign Observed  29.0000000`\
`#> 33         bbj-a-1     ukb-b-19953   46 P-value Expected  45.3411632`\
`#> 34         bbj-a-1     ukb-b-19953   46 P-value Observed  38.0000000`\
`#> 35         bbj-a-1     ukb-b-19953   46    Sign Expected  45.9998778`\
`#> 36         bbj-a-1     ukb-b-19953   46    Sign Observed  45.0000000`\
`#>           pdiff`\
`#> 1  1.000000e+00`\
`#> 2  1.000000e+00`\
`#> 3  1.000000e+00`\
`#> 4  1.000000e+00`\
`#> 5  1.000000e+00`\
`#> 6  1.000000e+00`\
`#> 7  1.000000e+00`\
`#> 8  1.000000e+00`\
`#> 9  1.000000e+00`\
`#> 10 1.000000e+00`\
`#> 11 1.000000e+00`\
`#> 12 1.000000e+00`\
`#> 13 6.970256e-01`\
`#> 14 6.970256e-01`\
`#> 15 9.115926e-08`\
`#> 16 9.115926e-08`\
`#> 17 3.381940e-01`\
`#> 18 3.381940e-01`\
`#> 19 1.735794e-08`\
`#> 20 1.735794e-08`\
`#> 21 1.063832e-24`\
`#> 22 1.063832e-24`\
`#> 23 2.350641e-30`\
`#> 24 2.350641e-30`\
`#> 25 6.549345e-01`\
`#> 26 6.549345e-01`\
`#> 27 2.748258e-01`\
`#> 28 2.748258e-01`\
`#> 29 2.216606e-01`\
`#> 30 2.216606e-01`\
`#> 31 2.921155e-04`\
`#> 32 2.921155e-04`\
`#> 33 2.843716e-07`\
`#> 34 2.843716e-07`\
`#> 35 1.221987e-04`\
`#> 36 1.221987e-04`

## Extract outcome data

\
`x``$``make_outcome_data``(``)`

## Harmonise exposure and outcome data

\
`x``$``harmonise``(``)`\
`#> ``# A tibble: 4 × 4`\
`#>   pops  exposure_ids    outcome_ids   source  `\
`#>   ``<chr>`` ``<chr>``           ``<chr>``         ``<chr>``   `\
`#> ``1`` SAS   ukb-e-23104_CSA ukb-e-411_CSA OpenGWAS`\
`#> ``2`` AFR   ukb-e-21001_AFR ukb-e-411_AFR OpenGWAS`\
`#> ``3`` EUR   ukb-b-19953     ieu-a-7       OpenGWAS`\
`#> ``4`` EAS   bbj-a-1         bbj-a-109     OpenGWAS`\
`#> 'data.frame':    1528 obs. of  4 variables:`\
`#>  $ SNP : chr  "1:2723214_A_C" "1:6657424_A_C" "1:11207269_C_T" "1:19934900_A_G" ...`\
`#>  $ pops: chr  "SAS" "SAS" "SAS" "SAS" ...`\
`#>  $ beta: num  -0.0266 -0.0235 0.0171 -0.0148 -0.0169 ...`\
`#>  $ se  : num  0.0154 0.0154 0.0192 0.0169 0.0146 ...`\
`#> NULL`\
`#> 'data.frame':    2911 obs. of  4 variables:`\
`#>  $ SNP : chr  "1:11207269_C_T" "1:11207269_C_T" "1:11207269_C_T" "1:11207269_C_T" ...`\
`#>  $ pops: chr  "EAS" "EUR" "AFR" "SAS" ...`\
`#>  $ beta: num  0.023401 -0.003275 -0.09457 -0.06663 0.000183 ...`\
`#>  $ se  : num  0.0319 0.0112 0.0809 0.0594 0.016 ...`\
`#> NULL`\
`#> 'data.frame':    1507 obs. of  6 variables:`\
`#>  $ SNP   : chr  "1:2723214_A_C" "1:6657424_A_C" "1:11207269_C_T" "1:19934900_A_G" ...`\
`#>  $ pops  : chr  "SAS" "SAS" "SAS" "SAS" ...`\
`#>  $ beta.x: num  -0.0266 -0.0235 0.0171 -0.0148 -0.0169 ...`\
`#>  $ se.x  : num  0.0154 0.0154 0.0192 0.0169 0.0146 ...`\
`#>  $ beta.y: num  -0.0152 -0.0295 -0.0666 0.0603 0.0465 ...`\
`#>  $ se.y  : num  0.048 0.0479 0.0594 0.0527 0.0456 ...`\
`#> NULL`

## Perform analysis using raw instruments

We will perform an inverse variance weighted fixed effects MR method
within population and across all populations. Heterogeneity estimates
will be generated to evaluate if each population has a distinct
association compared to others. The combined estimate across all
populations assumes that the effect is drawn from the same distribution
and if that assumption holds then then power is improved because of the
combined information.

\
`x``$``cross_estimate``(``)`\
`#> ``# A tibble: 5 × 8`\
`` #>   pops  Estimate `Std. Error` `t value` `Pr(>|t|)`    Qj Qjpval   Qdf ``\
`#>   ``<chr>``    ``<dbl>``        ``<dbl>``     ``<dbl>``      ``<dbl>`` ``<dbl>``  ``<dbl>`` ``<dbl>`\
`#> ``1`` All      0.443       0.029``2``    15.2     1.27``e``-48`` 8.02  0.045``6``     3`\
`#> ``2`` AFR      0.131       0.214      0.613   5.40``e``- 1`` 2.12  0.145      1`\
`#> ``3`` EAS      0.611       0.074``5``     8.20    4.97``e``-16`` 5.09  0.024``1``     1`\
`#> ``4`` EUR      0.423       0.032``9``    12.9     5.81``e``-36`` 0.374 0.541      1`\
`#> ``5`` SAS      0.353       0.136      2.59    9.57``e``- 3`` 0.441 0.506      1`

In this example the estimates are broadly consistent across ancestries,
although the EAS estimate is somewhat larger than the others (see the
`Qjpval` column). Note that the `All` estimate is slightly more
precisely estimated than any of the others because it is combining
similar estimates.

We can visualise the estimates:

\
`x``$``plot_cross_estimate``(``)`

![](tutorial_files/figure-html/unnamed-chunk-14-1.png)

## Perform regional scan to obtain LD agnostic instruments

We can re-select the instruments scanning across the region. The
intention here is to allow all populations to contribute to a fixed
effects meta analysis to account for LD. Then the top variant in the
region from the meta analysis is used as the instrument for all
populations.

\
`x``$``extract_instrument_regions``(``)`

This has extracted regions around all the pooled instruments from each
exposure dataset. Now we can choose the best SNP in each region across
all ancestries using a fixed effects meta analysis. For the cases where
the most strongly associated SNPs are not available at exactly the same
position, the function searches alternative SNPs that are located near
the original SNP and show the largest effect size magnitude.

\
`x``$``fema_regional_instruments``(``)`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` `[`str`](https://rdrr.io/r/utils/str.html)`(``)`\
`#> tibble [1,524 × 13] (S3: tbl_df/tbl/data.frame)`\
`#>  $ id      : chr [1:1524] "ukb-e-23104_CSA" "ukb-e-21001_AFR" "ukb-b-19953" "bbj-a-1" ...`\
`#>  $ trait   : chr [1:1524] "Body mass index (BMI)" "Body mass index (BMI)" "Body mass index (BMI)" "Body mass index" ...`\
`#>  $ chr     : chr [1:1524] "1" "1" "1" "1" ...`\
`#>  $ position: int [1:1524] 2722848 2722848 2722848 2722848 6694927 6694927 6694927 6694927 11236410 11236410 ...`\
`#>  $ rsid    : chr [1:1524] "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" ...`\
`#>  $ ea      : chr [1:1524] "C" "C" "C" "C" ...`\
`#>  $ nea     : chr [1:1524] "T" "T" "T" "T" ...`\
`#>  $ eaf     : num [1:1524] 0.715 0.859 0.534 0.565 0.714 ...`\
`#>  $ beta    : num [1:1524] 0.0174 -0.0312 0.0144 0.012 0.0258 ...`\
`#>  $ se      : num [1:1524] 0.01609 0.02562 0.00199 0.00422 0.01579 ...`\
`#>  $ p       : num [1:1524] 2.80e-01 2.24e-01 5.10e-13 4.33e-03 1.02e-01 ...`\
`#>  $ n       : num [1:1524] NA NA 461460 NA NA ...`\
`#>  $ rsido   : chr [1:1524] "rs6692145" "rs6692145" "rs6692145" "rs6692145" ...`

Alternatively, use a Z-score based meta analysis if you are unsure about
whether the effect size scales are sufficiently consistent across the
studies:

\
`x``$``fema_regional_instruments``(``method``=``"zma"``)`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` `[`str`](https://rdrr.io/r/utils/str.html)`(``)`\
`#> tibble [1,524 × 13] (S3: tbl_df/tbl/data.frame)`\
`#>  $ id      : chr [1:1524] "ukb-e-23104_CSA" "ukb-e-21001_AFR" "ukb-b-19953" "bbj-a-1" ...`\
`#>  $ trait   : chr [1:1524] "Body mass index (BMI)" "Body mass index (BMI)" "Body mass index (BMI)" "Body mass index" ...`\
`#>  $ chr     : chr [1:1524] "1" "1" "1" "1" ...`\
`#>  $ position: int [1:1524] 2722848 2722848 2722848 2722848 6684906 6684906 6684906 6684906 11236410 11236410 ...`\
`#>  $ rsid    : chr [1:1524] "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" ...`\
`#>  $ ea      : chr [1:1524] "C" "C" "C" "C" ...`\
`#>  $ nea     : chr [1:1524] "T" "T" "T" "T" ...`\
`#>  $ eaf     : num [1:1524] 0.715 0.859 0.534 0.565 0.702 ...`\
`#>  $ beta    : num [1:1524] 0.0174 -0.0312 0.0144 0.012 0.027 ...`\
`#>  $ se      : num [1:1524] 0.01609 0.02562 0.00199 0.00422 0.01562 ...`\
`#>  $ p       : num [1:1524] 2.80e-01 2.24e-01 5.10e-13 4.33e-03 8.35e-02 ...`\
`#>  $ n       : num [1:1524] NA NA 461460 NA NA ...`\
`#>  $ rsido   : chr [1:1524] "rs6692145" "rs6692145" "rs6692145" "rs6692145" ...`

Example

\
`x``$``plot_regional_instruments``(`[`names`](https://rdrr.io/r/base/names.html)`(``x``$``instrument_regions``)``[``3``]``)`

![](tutorial_files/figure-html/unnamed-chunk-18-1.png)

Here, the European top hit is in LD with many other variants in the
European ancestry, but meta-analysing with the other ancestries
identified a similarly strongly associated variant in Europeans that is
also strongly associated in East Asians. Had we used the European top
hit then we would have missed the stronger association in the region
that associates with other ancestries too. Note that the sample sizes
for the SAS and AFR studies are very small and relatively underpowered
throughout the analysis.

## Re-perform analysis using regional instruments

We now repeat the analysis using the regional instruments in
`x$instrument_fema`. First, extract outcome data for the regional
instruments. Outcome data are only extracted for SNPs which are not
already in `x$instrument_outcome`, and are appended to it, so the
existing outcome data are kept.

\
`x``$``make_outcome_data``(``exp``=``x``$``instrument_fema``)`

Re-harmonise using the regional instruments. This replaces
`x$harmonised_dat`, so the analyses below use the regional instruments.

\
`x``$``harmonise``(``exp``=``x``$``instrument_fema``)`\
`#> ``# A tibble: 4 × 4`\
`#>   pops  exposure_ids    outcome_ids   source  `\
`#>   ``<chr>`` ``<chr>``           ``<chr>``         ``<chr>``   `\
`#> ``1`` SAS   ukb-e-23104_CSA ukb-e-411_CSA OpenGWAS`\
`#> ``2`` AFR   ukb-e-21001_AFR ukb-e-411_AFR OpenGWAS`\
`#> ``3`` EUR   ukb-b-19953     ieu-a-7       OpenGWAS`\
`#> ``4`` EAS   bbj-a-1         bbj-a-109     OpenGWAS`\
`#> tibble [1,524 × 4] (S3: tbl_df/tbl/data.frame)`\
`#>  $ SNP : chr [1:1524] "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" ...`\
`#>  $ pops: chr [1:1524] "SAS" "AFR" "EUR" "EAS" ...`\
`#>  $ beta: num [1:1524] 0.0174 -0.0312 0.0144 0.012 0.027 ...`\
`#>  $ se  : num [1:1524] 0.01609 0.02562 0.00199 0.00422 0.01562 ...`\
`#> NULL`\
`#> 'data.frame':    2911 obs. of  4 variables:`\
`#>  $ SNP : chr  "1:11207269_C_T" "1:11207269_C_T" "1:11207269_C_T" "1:11207269_C_T" ...`\
`#>  $ pops: chr  "EAS" "EUR" "AFR" "SAS" ...`\
`#>  $ beta: num  0.023401 -0.003275 -0.09457 -0.06663 0.000183 ...`\
`#>  $ se  : num  0.0319 0.0112 0.0809 0.0594 0.016 ...`\
`#> NULL`\
`#> tibble [1,517 × 6] (S3: tbl_df/tbl/data.frame)`\
`#>  $ SNP   : chr [1:1517] "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" "1:2722848_C_T" ...`\
`#>  $ pops  : chr [1:1517] "SAS" "AFR" "EUR" "EAS" ...`\
`#>  $ beta.x: num [1:1517] 0.0174 -0.0312 0.0144 0.012 0.027 ...`\
`#>  $ se.x  : num [1:1517] 0.01609 0.02562 0.00199 0.00422 0.01562 ...`\
`#>  $ beta.y: num [1:1517] -0.00619 -0.07145 0.00269 -0.01034 0.05529 ...`\
`#>  $ se.y  : num [1:1517] 0.05008 0.1119 0.00969 0.01632 0.04868 ...`\
`#> NULL`

Re-estimate the MR associations using the newly derived regional
instruments

\
`x``$``cross_estimate``(``)`\
`#> ``# A tibble: 5 × 8`\
`` #>   pops  Estimate `Std. Error` `t value` `Pr(>|t|)`     Qj Qjpval   Qdf ``\
`#>   ``<chr>``    ``<dbl>``        ``<dbl>``     ``<dbl>``      ``<dbl>``  ``<dbl>``  ``<dbl>`` ``<dbl>`\
`#> ``1`` All      0.453       0.028``9``     15.7    1.48``e``-51`` 1.50    0.682     3`\
`#> ``2`` AFR      0.372       0.192       1.93   5.33``e``- 2`` 0.179   0.672     1`\
`#> ``3`` EAS      0.519       0.068``9``      7.53   8.42``e``-14`` 0.916   0.339     1`\
`#> ``4`` EUR      0.445       0.033``2``     13.4    1.05``e``-38`` 0.058``4``  0.809     1`\
`#> ``5`` SAS      0.375       0.133       2.81   5.00``e``- 3`` 0.347   0.556     1`

In this example the estimates are more consistent across ancestries than
with the raw instruments (compare the `Qjpval` values), although they
are slightly less precise.

\
`x``$``plot_cross_estimate``(``)`

![](tutorial_files/figure-html/unnamed-chunk-22-1.png)

Evaluate instrument specificity. First using heterogeneity

\
`x``$``instrument_heterogeneity``(``x``$``instrument_fema``)`\
`#> ``# A tibble: 6 × 9`\
`#>   Reference   Replication      nsnp agreement     se      pval      I2      Q`\
`#>   ``<chr>``       ``<chr>``           ``<int>``     ``<dbl>``  ``<dbl>``     ``<dbl>``   ``<dbl>``  ``<dbl>`\
`#> ``1`` ukb-b-19953 ukb-e-23104_CSA   377     0.683 0.050``2`` 3.92``e``- 42`` 0.129    433. `\
`#> ``2`` ukb-b-19953 ukb-e-21001_AFR   377     0.526 0.077``4`` 1.02``e``- 11`` 0.302    540. `\
`#> ``3`` ukb-b-19953 bbj-a-1           377     0.696 0.023``8`` 1.58``e``-188`` 0.710   ``1``301. `\
`#> ``4`` bbj-a-1     ukb-e-23104_CSA    61     0.836 0.076``6`` 1.04``e``- 27`` 0.002``33``   61.1`\
`#> ``5`` bbj-a-1     ukb-e-21001_AFR    61     0.747 0.128  5.42``e``-  9`` 0.261     82.5`\
`#> ``6`` bbj-a-1     ukb-b-19953        61     0.866 0.035``4`` 7.68``e``-132`` 0.908    661. `\
`#> ``# ℹ 1 more variable: Q_pval <dbl>`

In this example, compared to above, the `agreement` regression slopes
are closer to 1 for most pairs of ancestries.

\
`x``$``estimate_instrument_specificity``(``x``$``instrument_fema``, alpha ``=`` ``"bonferroni"``)`\
`#> Checking ukb-e-23104_CSA against ukb-e-21001_AFR`\
`#> Checking ukb-e-23104_CSA against ukb-b-19953`\
`#> Checking ukb-e-23104_CSA against bbj-a-1`\
`#> Checking ukb-e-21001_AFR against ukb-e-23104_CSA`\
`#> Checking ukb-e-21001_AFR against ukb-b-19953`\
`#> Checking ukb-e-21001_AFR against bbj-a-1`\
`#> Checking ukb-b-19953 against ukb-e-23104_CSA`\
`#> Checking ukb-b-19953 against ukb-e-21001_AFR`\
`#> Checking ukb-b-19953 against bbj-a-1`\
`#> Checking bbj-a-1 against ukb-e-23104_CSA`\
`#> Checking bbj-a-1 against ukb-e-21001_AFR`\
`#> Checking bbj-a-1 against ukb-b-19953`\
`#>          discovery     replication nsnp  metric    datum       value`\
`#> 1  ukb-e-21001_AFR ukb-e-23104_CSA    1 P-value Expected   0.9987782`\
`#> 2  ukb-e-21001_AFR ukb-e-23104_CSA    1 P-value Observed   1.0000000`\
`#> 3  ukb-e-21001_AFR ukb-e-23104_CSA    1    Sign Expected   0.9999995`\
`#> 4  ukb-e-21001_AFR ukb-e-23104_CSA    1    Sign Observed   1.0000000`\
`#> 5  ukb-e-21001_AFR     ukb-b-19953    1 P-value Expected   1.0000000`\
`#> 6  ukb-e-21001_AFR     ukb-b-19953    1 P-value Observed   1.0000000`\
`#> 7  ukb-e-21001_AFR     ukb-b-19953    1    Sign Expected   0.9999995`\
`#> 8  ukb-e-21001_AFR     ukb-b-19953    1    Sign Observed   1.0000000`\
`#> 9  ukb-e-21001_AFR         bbj-a-1    1 P-value Expected   1.0000000`\
`#> 10 ukb-e-21001_AFR         bbj-a-1    1 P-value Observed   1.0000000`\
`#> 11 ukb-e-21001_AFR         bbj-a-1    1    Sign Expected   0.9999995`\
`#> 12 ukb-e-21001_AFR         bbj-a-1    1    Sign Observed   1.0000000`\
`#> 13     ukb-b-19953 ukb-e-23104_CSA  377 P-value Expected   1.8062068`\
`#> 14     ukb-b-19953 ukb-e-23104_CSA  377 P-value Observed   2.0000000`\
`#> 15     ukb-b-19953 ukb-e-23104_CSA  377    Sign Expected 314.6226158`\
`#> 16     ukb-b-19953 ukb-e-23104_CSA  377    Sign Observed 271.0000000`\
`#> 17     ukb-b-19953 ukb-e-21001_AFR  377 P-value Expected   0.3238810`\
`#> 18     ukb-b-19953 ukb-e-21001_AFR  377 P-value Observed   1.0000000`\
`#> 19     ukb-b-19953 ukb-e-21001_AFR  377    Sign Expected 285.3702608`\
`#> 20     ukb-b-19953 ukb-e-21001_AFR  377    Sign Observed 225.0000000`\
`#> 21     ukb-b-19953         bbj-a-1  377 P-value Expected 127.5615021`\
`#> 22     ukb-b-19953         bbj-a-1  377 P-value Observed  58.0000000`\
`#> 23     ukb-b-19953         bbj-a-1  377    Sign Expected 372.6560995`\
`#> 24     ukb-b-19953         bbj-a-1  377    Sign Observed 329.0000000`\
`#> 25         bbj-a-1 ukb-e-23104_CSA   61 P-value Expected   1.5812878`\
`#> 26         bbj-a-1 ukb-e-23104_CSA   61 P-value Observed   2.0000000`\
`#> 27         bbj-a-1 ukb-e-23104_CSA   61    Sign Expected  55.5707081`\
`#> 28         bbj-a-1 ukb-e-23104_CSA   61    Sign Observed  51.0000000`\
`#> 29         bbj-a-1 ukb-e-21001_AFR   61 P-value Expected   0.2222185`\
`#> 30         bbj-a-1 ukb-e-21001_AFR   61 P-value Observed   1.0000000`\
`#> 31         bbj-a-1 ukb-e-21001_AFR   61    Sign Expected  50.7653607`\
`#> 32         bbj-a-1 ukb-e-21001_AFR   61    Sign Observed  43.0000000`\
`#> 33         bbj-a-1     ukb-b-19953   61 P-value Expected  60.5406720`\
`#> 34         bbj-a-1     ukb-b-19953   61 P-value Observed  57.0000000`\
`#> 35         bbj-a-1     ukb-b-19953   61    Sign Expected  60.9999028`\
`#> 36         bbj-a-1     ukb-b-19953   61    Sign Observed  61.0000000`\
`#>           pdiff`\
`#> 1  1.000000e+00`\
`#> 2  1.000000e+00`\
`#> 3  1.000000e+00`\
`#> 4  1.000000e+00`\
`#> 5  1.000000e+00`\
`#> 6  1.000000e+00`\
`#> 7  1.000000e+00`\
`#> 8  1.000000e+00`\
`#> 9  1.000000e+00`\
`#> 10 1.000000e+00`\
`#> 11 1.000000e+00`\
`#> 12 1.000000e+00`\
`#> 13 7.031463e-01`\
`#> 14 7.031463e-01`\
`#> 15 2.038430e-08`\
`#> 16 2.038430e-08`\
`#> 17 2.767644e-01`\
`#> 18 2.767644e-01`\
`#> 19 6.677149e-12`\
`#> 20 6.677149e-12`\
`#> 21 1.087440e-15`\
`#> 22 1.087440e-15`\
`#> 23 3.515845e-34`\
`#> 24 3.515845e-34`\
`#> 25 6.729494e-01`\
`#> 26 6.729494e-01`\
`#> 27 6.573025e-02`\
`#> 28 6.573025e-02`\
`#> 29 1.995844e-01`\
`#> 30 1.995844e-01`\
`#> 31 1.478408e-02`\
`#> 32 1.478408e-02`\
`#> 33 1.191887e-03`\
`#> 34 1.191887e-03`\
`#> 35 1.000000e+00`\
`#> 36 1.000000e+00`\
`x``$``instrument_specificity``$``distinct`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` ``table`\
`#> .`\
`#> FALSE  TRUE `\
`#>  1148   169`

Instruments with `distinct` equal to `TRUE` were expected to replicate,
or to have the same sign, in another population but did not.

## Evaluate similarity of pleiotropy across ancestry

Note: the term pleiotropy used here refers to ‘horizontal pleiotropy’,
the influence of the SNP on the outcome not mediated through the
exposure.

Here we will find pleiotropy outliers from the MR analysis, and then
determine if the deviation of those outliers from the overall MR
estimates is consistent across populations

\
`x``$``pleiotropy``(``)`

Outliers are detected based on whether a SNP’s Wald ratio (in a
particular population) is substantially different from the overall
estimate. The overall estimate is the combined meta-analysis across all
populations and all SNPs, unless that population’s overall MR estimate
contributed substantially to heterogeneity. In that case, deviation is
estimated based on the population’s specific MR estimate.

\
`x``$``pleiotropy_outliers`\
`#> ``# A tibble: 36 × 16`\
`#>    SNP         pops    beta.x    se.x   beta.y    se.y   pval.x  pval.y       wr`\
`#>    ``<chr>``       ``<chr>``    ``<dbl>``   ``<dbl>``    ``<dbl>``   ``<dbl>``    ``<dbl>``   ``<dbl>``    ``<dbl>`\
`#> `` 1`` 10:1049422… SAS    0.015``4``  0.017``6``   3.00``e``-2`` 0.054``6``  1.90``e``- 1`` 2.91``e``-1``  1.95``e``+0`\
`#> `` 2`` 10:1049422… AFR    0.073``2``  0.086``7``  -``1.10``e``-5`` 0.385   1.99``e``- 1`` 5.00``e``-1`` -``1.50``e``-4`\
`#> `` 3`` 10:1049422… EUR    0.023``8``  0.003``70`` -``7.70``e``-2`` 0.014``4``  6.14``e``-11`` 4.69``e``-8`` -``3.24``e``+0`\
`#> `` 4`` 10:1049422… EAS    0.025``3``  0.004``23`` -``2.79``e``-2`` 0.017``7``  1.12``e``- 9`` 5.73``e``-2`` -``1.10``e``+0`\
`#> `` 5`` 11:1331520… SAS    0.001``15`` 0.014``5``  -``4.07``e``-2`` 0.045``3``  4.68``e``- 1`` 1.84``e``-1`` -``3.55``e``+1`\
`#> `` 6`` 11:1331520… AFR   -``0.102``   0.038``1``  -``2.18``e``-2`` 0.168   3.81``e``- 3`` 4.49``e``-1``  2.14``e``-1`\
`#> `` 7`` 11:1331520… EUR    0.016``4``  0.002``00``  4.00``e``-2`` 0.009``74`` 1.15``e``-16`` 2.00``e``-5``  2.44``e``+0`\
`#> `` 8`` 11:1331520… EAS    0.010``3``  0.004``51``  8.29``e``-3`` 0.018``9``  1.13``e``- 2`` 3.30``e``-1``  8.06``e``-1`\
`#> `` 9`` 11:1169473… SAS   -``0.009``40`` 0.026``7``  -``7.18``e``-2`` 0.083``0``  3.62``e``- 1`` 1.93``e``-1``  7.64``e``+0`\
`#> ``10`` 11:1169473… AFR   -``0.026``8``  0.032``7``   1.15``e``-1`` 0.144   2.06``e``- 1`` 2.12``e``-1`` -``4.28``e``+0`\
`#> ``# ℹ 26 more rows`\
`#> ``# ℹ 7 more variables: wr.se <dbl>, biv <dbl>, biv.se <dbl>, dif <dbl>,`\
`#> ``#   dif.se <dbl>, Qj <dbl>, Qjpval <dbl>`

For outliers from a population, are other populations showing similar
deviation to the outlier discovery population? e.g. look at whether the
sign is the same for outliers discovered in Europeans:

\
`x``$``pleiotropy_agreement`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` ``as.data.frame`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` `[`subset`](https://rdrr.io/r/base/subset.html)`(``disc`` ``==`` ``"EUR"`` ``&`` ``metric``==``"Sign"``)`\
`#>    disc rep nsnp metric    datum    value       pdiff`\
`#> 15  EUR SAS    7   Sign Expected 5.410300 0.051335225`\
`#> 16  EUR SAS    7   Sign Observed 3.000000 0.051335225`\
`#> 19  EUR AFR    7   Sign Expected 4.979110 0.111858226`\
`#> 20  EUR AFR    7   Sign Observed 3.000000 0.111858226`\
`#> 23  EUR EAS    7   Sign Expected 6.553344 0.007480742`\
`#> 24  EUR EAS    7   Sign Observed 4.000000 0.007480742`

Look at the overall relationship of outlier deviations across
populations

\
`x``$``plot_pleiotropy``(``)`

![](tutorial_files/figure-html/unnamed-chunk-30-1.png)

Identify any variants that showed substantial differences in pleiotropy
deviations across populations. Note that sometimes the pleiotropy
deviation estimate is unstable due to the SNP-exposure association being
very small. Unstable estimates are attempted to be removed automatically
from the heterogeneity analysis

\
`x``$``plot_pleiotropy_heterogeneity``(``pthresh``=``0.05``)`

![](tutorial_files/figure-html/unnamed-chunk-31-1.png)

In this example one SNP shows evidence of differences in pleiotropy
deviation across populations, driven by the very imprecise estimate in
AFR. Plot everything by relaxing the threshold

\
`x``$``plot_pleiotropy_heterogeneity``(``pthresh``=``1``)`

![](tutorial_files/figure-html/unnamed-chunk-32-1.png)

## MR GxE

The MR GxE model aims to estimate the horizontal pleiotropic effect of a
SNP. This is achieved by estimating its effect on the outcome in a
subset of the data where the SNP is not expected to have an association
(the zero relevance group). The cross-ancestry MR analysis can attempt
to make use of this approach by identifying variants that exhibit
heterogeneity in the instrument-exposure association across ancestries.
Those instruments can then be used to estimate the pleiotropic
association by evaluating their effect on the outcome across populations
showing differential SNP-exposure associations.

First identify examples of heterogeneity amongst instrument-exposure
associations

\
`x``$``estimate_instrument_heterogeneity_per_variant``(``)`\
`#> ``# A tibble: 381 × 5`\
`#> ``# Groups:   SNP [381]`\
`#>    SNP                Qdf      Q     Qpval      Qfdr`\
`#>    ``<chr>``            ``<dbl>``  ``<dbl>``     ``<dbl>``     ``<dbl>`\
`#> `` 1`` 10:104942244_G_T     3  0.650 0.885     0.885    `\
`#> `` 2`` 10:118650996_C_T     3 17.7   0.000``502``  0.000``502`` `\
`#> `` 3`` 10:132953074_C_T     3 22.3   0.000``055``6 0.000``055``6`\
`#> `` 4`` 10:134007008_A_C     3  8.12  0.043``6``    0.043``6``   `\
`#> `` 5`` 10:16750129_G_T      3  0.510 0.917     0.917    `\
`#> `` 6`` 10:18573654_A_G      3  6.63  0.084``7``    0.084``7``   `\
`#> `` 7`` 10:21830104_A_G      3  3.19  0.363     0.363    `\
`#> `` 8`` 10:33955430_C_T      3 13.5   0.003``75``   0.003``75``  `\
`#> `` 9`` 10:53673286_A_G      3  4.26  0.235     0.235    `\
`#> ``10`` 10:61842645_C_T      3  6.16  0.104     0.104    `\
`#> ``# ℹ 371 more rows`\
`x``$``instrument_heterogeneity_per_variant`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` ``dplyr``::`[`filter`](https://dplyr.tidyverse.org/reference/filter.html)`(``Qfdr`` ``<`` ``0.05``)`\
`#> ``# A tibble: 100 × 5`\
`#> ``# Groups:   SNP [100]`\
`#>    SNP                Qdf     Q      Qpval       Qfdr`\
`#>    ``<chr>``            ``<dbl>`` ``<dbl>``      ``<dbl>``      ``<dbl>`\
`#> `` 1`` 10:118650996_C_T     3 17.7  0.000``502``   0.000``502``  `\
`#> `` 2`` 10:132953074_C_T     3 22.3  0.000``055``6  0.000``055``6 `\
`#> `` 3`` 10:134007008_A_C     3  8.12 0.043``6``     0.043``6``    `\
`#> `` 4`` 10:33955430_C_T      3 13.5  0.003``75``    0.003``75``   `\
`#> `` 5`` 10:87490850_A_G      3  8.51 0.036``5``     0.036``5``    `\
`#> `` 6`` 10:99772885_A_G      3 18.8  0.000``298``   0.000``298``  `\
`#> `` 7`` 11:130795698_G_T     3 14.5  0.002``32``    0.002``32``   `\
`#> `` 8`` 11:13315205_C_T      3 11.9  0.007``86``    0.007``86``   `\
`#> `` 9`` 11:134589355_A_T     3  8.65 0.034``3``     0.034``3``    `\
`#> ``10`` 11:2858440_A_G       3 29.5  0.000``001``79 0.000``001``79`\
`#> ``# ℹ 90 more rows`

Next perform MR GxE (may take a couple of minutes while bootstrapping
standard errors)

\
`x``$``mrgxe``(``)`\
`#> ``# A tibble: 100 × 9`\
`#> ``# Groups:   SNP [100]`\
`#>    SNP                     a       b   a_se  b_se a_pval b_pval   a_mean b_mean`\
`#>    ``<chr>``               ``<dbl>``   ``<dbl>``  ``<dbl>`` ``<dbl>``  ``<dbl>``  ``<dbl>``    ``<dbl>``  ``<dbl>`\
`#> `` 1`` 10:118650996_C_T  0.045``0``   2.14   0.024``9``  1.65 0.035``3`` 0.097``6``  0.045``2``   1.93 `\
`#> `` 2`` 10:132953074_C_T -``0.039``9``   3.84   0.038``0``  3.47 0.147  0.134  -``0.041``3``   1.11 `\
`#> `` 3`` 10:134007008_A_C  0.003``26``  0.805  0.026``7``  2.45 0.451  0.371   0.007``53``  0.684`\
`#> `` 4`` 10:33955430_C_T   0.006``10`` -``0.195``  0.037``4``  1.66 0.435  0.453   0.016``0``  -``0.575`\
`#> `` 5`` 10:87490850_A_G  -``0.019``4``  -``0.030``5`` 0.042``6``  2.04 0.325  0.494  -``0.027``2``  -``0.130`\
`#> `` 6`` 10:99772885_A_G  -``0.019``5``  -``1.48``   0.029``6``  1.94 0.255  0.223  -``0.018``8``  -``1.24`` `\
`#> `` 7`` 11:130795698_G_T -``0.011``0``   2.17   0.040``1``  2.16 0.392  0.158  -``0.016``9``   2.35 `\
`#> `` 8`` 11:13315205_C_T   0.001``68``  0.283  0.023``6``  1.85 0.472  0.439   0.002``85``  0.341`\
`#> `` 9`` 11:134589355_A_T  0.075``6``  -``4.77``   0.087``6``  3.20 0.194  0.067``9``  0.057``9``  -``3.77`` `\
`#> ``10`` 11:2858440_A_G   -``0.084``8``   1.42   0.117   2.78 0.234  0.304  -``0.076``0``   0.799`\
`#> ``# ℹ 90 more rows`\
`x``$``mrgxe_res`\
`#> ``# A tibble: 100 × 9`\
`#> ``# Groups:   SNP [100]`\
`#>    SNP                     a       b   a_se  b_se a_pval b_pval   a_mean b_mean`\
`#>    ``<chr>``               ``<dbl>``   ``<dbl>``  ``<dbl>`` ``<dbl>``  ``<dbl>``  ``<dbl>``    ``<dbl>``  ``<dbl>`\
`#> `` 1`` 10:118650996_C_T  0.045``0``   2.14   0.024``9``  1.65 0.035``3`` 0.097``6``  0.045``2``   1.93 `\
`#> `` 2`` 10:132953074_C_T -``0.039``9``   3.84   0.038``0``  3.47 0.147  0.134  -``0.041``3``   1.11 `\
`#> `` 3`` 10:134007008_A_C  0.003``26``  0.805  0.026``7``  2.45 0.451  0.371   0.007``53``  0.684`\
`#> `` 4`` 10:33955430_C_T   0.006``10`` -``0.195``  0.037``4``  1.66 0.435  0.453   0.016``0``  -``0.575`\
`#> `` 5`` 10:87490850_A_G  -``0.019``4``  -``0.030``5`` 0.042``6``  2.04 0.325  0.494  -``0.027``2``  -``0.130`\
`#> `` 6`` 10:99772885_A_G  -``0.019``5``  -``1.48``   0.029``6``  1.94 0.255  0.223  -``0.018``8``  -``1.24`` `\
`#> `` 7`` 11:130795698_G_T -``0.011``0``   2.17   0.040``1``  2.16 0.392  0.158  -``0.016``9``   2.35 `\
`#> `` 8`` 11:13315205_C_T   0.001``68``  0.283  0.023``6``  1.85 0.472  0.439   0.002``85``  0.341`\
`#> `` 9`` 11:134589355_A_T  0.075``6``  -``4.77``   0.087``6``  3.20 0.194  0.067``9``  0.057``9``  -``3.77`` `\
`#> ``10`` 11:2858440_A_G   -``0.084``8``   1.42   0.117   2.78 0.234  0.304  -``0.076``0``   0.799`\
`#> ``# ℹ 90 more rows`

This is the distribution of the estimate of the pleiotropic effect of
each SNP that showed heterogeneity

\
`x``$``mrgxe_plot``(``)`

![](tutorial_files/figure-html/unnamed-chunk-35-1.png)

Any evidence of SNPs with substantial heterogeneity?

\
`x``$``mrgxe_res`` `[`%>%`](https://mrcieu.github.io/CAMERA/reference/pipe.md)` ``dplyr``::`[`filter`](https://dplyr.tidyverse.org/reference/filter.html)`(`[`p.adjust`](https://rdrr.io/r/stats/p.adjust.html)`(``a_pval``, ``"fdr"``)`` ``<`` ``0.05``)`\
`#> ``# A tibble: 7 × 9`\
`#> ``# Groups:   SNP [7]`\
`#>   SNP                    a       b   a_se  b_se  a_pval b_pval  a_mean  b_mean`\
`#>   ``<chr>``              ``<dbl>``   ``<dbl>``  ``<dbl>`` ``<dbl>``   ``<dbl>``  ``<dbl>``   ``<dbl>``   ``<dbl>`\
`#> ``1`` 10:118650996_C_T  0.045``0``  2.14   0.024``9``  1.65 0.035``3``  0.097``6``  0.045``2``  1.93  `\
`#> ``2`` 13:58259492_A_C  -``0.080``4`` -``4.47``   0.043``7``  3.31 0.032``9``  0.088``5`` -``0.076``2`` -``2.88``  `\
`#> ``3`` 16:19925612_C_T   0.070``5``  1.74   0.042``5``  2.11 0.048``5``  0.205   0.063``2``  1.29  `\
`#> ``4`` 16:76895693_A_G   0.056``7``  2.19   0.026``6``  3.06 0.016``7``  0.237   0.049``4``  1.91  `\
`#> ``5`` 19:33953354_G_T  -``0.068``1`` -``0.086``9`` 0.023``9``  1.69 0.002``24`` 0.479  -``0.062``1`` -``0.023``6`\
`#> ``6`` 2:161265910_C_T  -``0.032``3`` -``0.701``  0.019``4``  2.13 0.048``2``  0.371  -``0.028``2`` -``0.318`` `\
`#> ``7`` 3:62354425_A_G    0.038``5``  0.285  0.023``3``  1.62 0.049``0``  0.430   0.035``1`` -``0.065``5`

It’s worth always checking if these look credible e.g. this plots the
SNP-exposure against SNP-outcome associations for the identified SNPs.
You’d expect to see a slope reflecting the causal effect estimate with
the intercept reflecting the pleiotropic association.

\
`x``$``mrgxe_plot_variant``(``)`

![](tutorial_files/figure-html/unnamed-chunk-37-1.png)

In this case the associations are very noisy, and it would be difficult
to justify that they show convincing evidence of the pleiotropy
estimate.

## Saving and loading data

It can be useful to import data from one CAMERA object to another,
because for example you may have all your data, but the CAMERA class has
been updated, and you want to initialise a new class and import all the
old data into the new class.

Save CAMERA objects as RDS files e.g.

\
[`saveRDS`](https://rdrr.io/r/base/readRDS.html)`(``x``, file``=``"example-CAMERA.rds"``)`

And load them like this:

\
`x`` ``<-`` `[`readRDS`](https://rdrr.io/r/base/readRDS.html)`(``file``=``"example-CAMERA.rds"``)`

You can import data from one CAMERA object to another like this:

\
`x_new`` ``<-`` `[`CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md)`$``new``(``)`\
`x_new``$``import``(``x``)`

## Overview of methods

The analysis functions in CAMeRa are methods of the `CAMERA` class, so
they are called as `x$method()` and are documented together on the
[CAMERA reference
page](https://mrcieu.github.io/CAMERA/reference/CAMERA.html) (or
[`?CAMERA`](https://mrcieu.github.io/CAMERA/reference/CAMERA.md)). The
methods used in this vignette, in the order they are used, are:

| Step | Method | Results |
|----|----|----|
| Check phenotype scales across ancestries | [`check_phenotypes()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-check_phenotypes) | Printed table |
| Extract instruments | [`extract_instruments()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-extract_instruments) | `x$instrument_raw` |
| Instrument heterogeneity across populations | [`instrument_heterogeneity()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-instrument_heterogeneity) | Returned table |
| Instrument specificity across populations | [`estimate_instrument_specificity()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-estimate_instrument_specificity) | `x$instrument_specificity_summary`, `x$instrument_specificity` |
| Extract outcome data | [`make_outcome_data()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-make_outcome_data) | `x$instrument_outcome` |
| Harmonise exposure and outcome data | [`harmonise()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-harmonise) | `x$harmonised_dat` |
| MR within and across populations | [`cross_estimate()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-cross_estimate) | `x$mrres` |
| Plot MR estimates | [`plot_cross_estimate()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-plot_cross_estimate) | Plot |
| Extract regions around instruments | [`extract_instrument_regions()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-extract_instrument_regions) | `x$instrument_regions` |
| Select regional instruments by meta analysis | [`fema_regional_instruments()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-fema_regional_instruments) | `x$instrument_fema`, `x$instrument_fema_regions` |
| Plot a region | [`plot_regional_instruments()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-plot_regional_instruments) | Plot |
| Pleiotropy across ancestries | [`pleiotropy()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-pleiotropy) | `x$pleiotropy_outliers`, `x$pleiotropy_Q_outliers`, `x$pleiotropy_agreement` |
| Plot pleiotropy | [`plot_pleiotropy()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-plot_pleiotropy), [`plot_pleiotropy_heterogeneity()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-plot_pleiotropy_heterogeneity) | Plots |
| Per variant instrument-exposure heterogeneity | [`estimate_instrument_heterogeneity_per_variant()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-estimate_instrument_heterogeneity_per_variant) | `x$instrument_heterogeneity_per_variant` |
| MR GxE | [`mrgxe()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-mrgxe) | `x$mrgxe_res` |
| Plot MR GxE results | [`mrgxe_plot()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-mrgxe_plot), [`mrgxe_plot_variant()`](https://mrcieu.github.io/CAMERA/reference/CAMERA.html#method-CAMERA-mrgxe_plot_variant) | Plots |
