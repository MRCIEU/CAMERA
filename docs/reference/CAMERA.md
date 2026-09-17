# R6 class for CAMERA

A simple wrapper function. Using a summary set, identify set of
instruments for the traits, and perform SEM MR to test the association
across the population.

## Public fields

- `output`:

  A list for the output

- `source`:

  The source of the data.

- `exposure_ids`:

  Exposures IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `outcome_ids`:

  Outcome IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `exposure_metadata`:

  Exposure metadata

- `outcome_metadata`:

  Outcome metadata

- `radius`:

  Genomic window size to extract SNPs

- `pops`:

  Ancestry information for each population (i.e., AFR, AMR, EUR, EAS,
  SAS)

- `bfiles`:

  Locations of LD reference files for each population (Download from:
  <http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz>)

- `plink`:

  Location of executable plink (version 1.90 is recommended)

- `clump_pop`:

  Reference population for clumping

- `instrument_raw`:

  Instruments for the exposures obtained from `extract_instruments()`

- `instrument_regions`:

  Genomic regions around each instrument obtained from
  `extract_instrument_regions()`

- `ld_matrices`:

  LD matrices for each instrument region obtained from
  `regional_ld_matrices()`

- `susie_results`:

  Fine-mapping results from `susie_finemap_regions()`

- `paintor_results`:

  Fine-mapping results from `paintor_finemap_regions()`

- `mscaviar_results`:

  Fine-mapping results from `MsCAVIAR_finemap_regions()`

- `expected_replications`:

  Expected replication of instruments across populations

- `instrument_region_zscores`:

  Z scores for the SNPs in each instrument region obtained from
  `scan_regional_instruments()`

- `instrument_fema`:

  Instruments selected by meta-analysis across populations obtained from
  `fema_regional_instruments()`

- `instrument_fema_regions`:

  Meta-analysis results for each instrument region obtained from
  `fema_regional_instruments()`

- `instrument_maxz`:

  Instruments selected by maximum Z score obtained from
  `scan_regional_instruments()`

- `instrument_susie`:

  Instruments selected by susieR fine-mapping obtained from
  `susie_finemap_regions()`

- `instrument_paintor`:

  Instruments selected by PAINTOR fine-mapping obtained from
  `paintor_finemap_regions()`

- `instrument_mscaviar`:

  Instruments selected by MsCAVIAR fine-mapping obtained from
  `MsCAVIAR_finemap_regions()`

- `harmonised_data_check`:

  Checks of the harmonised data

- `standardised_instrument_raw`:

  Standardised `instrument_raw` obtained from `standardise_data()`

- `standardised_instrument_maxz`:

  Standardised `instrument_maxz` obtained from `standardise_data()`

- `standardised_instrument_susie`:

  Standardised `instrument_susie` obtained from `standardise_data()`

- `standardised_instrument_paintor`:

  Standardised `instrument_paintor` obtained from `standardise_data()`

- `standardised_instrument_mscaviar`:

  Standardised `instrument_mscaviar` obtained from `standardise_data()`

- `standardised_outcome`:

  Standardised outcome data obtained from `standardise_data()`

- `instrument_specificity`:

  Instrument specificity results obtained from
  `estimate_instrument_specificity()`

- `instrument_specificity_summary`:

  Summary of the instrument specificity results obtained from
  `estimate_instrument_specificity()`

- `instrument_outcome`:

  Outcome data for the instruments obtained from `make_outcome_data()`

- `instrument_outcome_regions`:

  Outcome data for each instrument region imported with
  `import_from_local()`

- `harmonised_dat_sem`:

  Harmonised data for the SEM analysis

- `harmonised_dat`:

  Harmonised exposure and outcome data obtained from `harmonise()`

- `sem_result`:

  SEM results obtained from `perform_basic_sem()`

- `pleiotropy_agreement`:

  Agreement of pleiotropy outlier effects across populations obtained
  from `pleiotropy()`

- `pleiotropy_outliers`:

  Pleiotropy outliers obtained from `pleiotropy()`

- `pleiotropy_Q_outliers`:

  Heterogeneity for each pleiotropy outlier and population obtained from
  `pleiotropy()`

- `summary`:

  Summary of the exposure, outcome and population metadata obtained from
  `set_summary()`

- `mrres`:

  MR estimates obtained from `cross_estimate()`

- `instrument_heterogeneity_per_variant`:

  Heterogeneity of the instrument-exposure associations for each variant
  obtained from `estimate_instrument_heterogeneity_per_variant()`

- `mrgxe_res`:

  MR GxE results obtained from `mrgxe()`

## Methods

### Public methods

- [`CAMERA$import()`](#method-CAMERA-import)

- [`CAMERA$assign()`](#method-CAMERA-assign)

- [`CAMERA$import_from_local()`](#method-CAMERA-import_from_local)

- [`CAMERA$new()`](#method-CAMERA-initialize)

- [`CAMERA$instrument_heterogeneity()`](#method-CAMERA-instrument_heterogeneity)

- [`CAMERA$estimate_instrument_specificity()`](#method-CAMERA-estimate_instrument_specificity)

- [`CAMERA$replication_evaluation()`](#method-CAMERA-replication_evaluation)

- [`CAMERA$check_phenotypes()`](#method-CAMERA-check_phenotypes)

- [`CAMERA$cross_estimate()`](#method-CAMERA-cross_estimate)

- [`CAMERA$plot_cross_estimate()`](#method-CAMERA-plot_cross_estimate)

- [`CAMERA$extract_instruments()`](#method-CAMERA-extract_instruments)

- [`CAMERA$extract_instrument_regions()`](#method-CAMERA-extract_instrument_regions)

- [`CAMERA$scan_regional_instruments()`](#method-CAMERA-scan_regional_instruments)

- [`CAMERA$plot_regional_instruments_maxz()`](#method-CAMERA-plot_regional_instruments_maxz)

- [`CAMERA$regional_ld_matrices()`](#method-CAMERA-regional_ld_matrices)

- [`CAMERA$susie_finemap_regions()`](#method-CAMERA-susie_finemap_regions)

- [`CAMERA$paintor_finemap_regions()`](#method-CAMERA-paintor_finemap_regions)

- [`CAMERA$MsCAVIAR_finemap_regions()`](#method-CAMERA-MsCAVIAR_finemap_regions)

- [`CAMERA$fema_regional_instruments()`](#method-CAMERA-fema_regional_instruments)

- [`CAMERA$plot_regional_instruments()`](#method-CAMERA-plot_regional_instruments)

- [`CAMERA$get_metadata()`](#method-CAMERA-get_metadata)

- [`CAMERA$estimate_instrument_heterogeneity_per_variant()`](#method-CAMERA-estimate_instrument_heterogeneity_per_variant)

- [`CAMERA$mrgxe()`](#method-CAMERA-mrgxe)

- [`CAMERA$mrgxe_plot()`](#method-CAMERA-mrgxe_plot)

- [`CAMERA$mrgxe_plot_variant()`](#method-CAMERA-mrgxe_plot_variant)

- [`CAMERA$make_outcome_data()`](#method-CAMERA-make_outcome_data)

- [`CAMERA$make_outcome_local()`](#method-CAMERA-make_outcome_local)

- [`CAMERA$harmonise()`](#method-CAMERA-harmonise)

- [`CAMERA$set_summary()`](#method-CAMERA-set_summary)

- [`CAMERA$pleiotropy()`](#method-CAMERA-pleiotropy)

- [`CAMERA$plot_pleiotropy()`](#method-CAMERA-plot_pleiotropy)

- [`CAMERA$plot_pleiotropy_heterogeneity()`](#method-CAMERA-plot_pleiotropy_heterogeneity)

- [`CAMERA$perform_basic_sem()`](#method-CAMERA-perform_basic_sem)

- [`CAMERA$runsem()`](#method-CAMERA-runsem)

- [`CAMERA$standardise_data()`](#method-CAMERA-standardise_data)

- [`CAMERA$clone()`](#method-CAMERA-clone)

------------------------------------------------------------------------

### `CAMERA$import()`

Migrate the results from a previous CAMERA

#### Usage

    CAMERA$import(x)

#### Arguments

- `x`:

  A CAMERA object to import results from

------------------------------------------------------------------------

### `CAMERA$assign()`

Assign values to fields of the CAMERA object

#### Usage

    CAMERA$assign(...)

#### Arguments

- `...`:

  Named arguments, where each name is a field and each value is assigned
  to it

------------------------------------------------------------------------

### `CAMERA$import_from_local()`

Import instrument and outcome data from local summary statistics, e.g.
as organised by `CAMERA_local`

#### Usage

    CAMERA$import_from_local(
      instrument_raw,
      instrument_outcome,
      instrument_regions,
      instrument_outcome_regions,
      exposure_ids,
      outcome_ids,
      pops,
      ...
    )

#### Arguments

- `instrument_raw`:

  Data frame of instruments for the exposures

- `instrument_outcome`:

  Data frame of instrument associations with the outcomes

- `instrument_regions`:

  List of genomic regions around each instrument for the exposures

- `instrument_outcome_regions`:

  List of genomic regions around each instrument for the outcomes

- `exposure_ids`:

  Exposures IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `exposure_ids`:

  ID for the exposure. Default is x\$exposure_ids.

- `exposure_ids`:

  IDs for the exposures. Default is `x$exposure_ids`.

- `outcome_ids`:

  Outcome IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `outcome_ids`:

  IDs for the outcomes. Default is `x$outcome_ids`.

- `pops`:

  Ancestry information for each population (i.e., AFR, AMR, EUR, EAS,
  SAS)

- `...`:

  Further named arguments passed to
  [`assign()`](https://rdrr.io/r/base/assign.html)

------------------------------------------------------------------------

### `CAMERA$new()`

Create a new dataset and initialise an R interface

#### Usage

    CAMERA$new(
      exposure_ids = NULL,
      outcome_ids = NULL,
      pops = NULL,
      bfiles = NULL,
      plink = NULL,
      radius = NULL,
      clump_pop = NULL,
      x = NULL
    )

#### Arguments

- `exposure_ids`:

  Exposures IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `exposure_ids`:

  ID for the exposure. Default is x\$exposure_ids.

- `exposure_ids`:

  IDs for the exposures. Default is `x$exposure_ids`.

- `outcome_ids`:

  Outcome IDs obtained from IEU GWAS database
  (<https://gwas.mrcieu.ac.uk>) for each population

- `outcome_ids`:

  IDs for the outcomes. Default is `x$outcome_ids`.

- `pops`:

  Ancestry information for each population (i.e., AFR, AMR, EUR, EAS,
  SAS)

- `bfiles`:

  Locations of LD reference files for each population (Download from:
  <http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz>)

- `plink`:

  Location of executable plink (version 1.90 is recommended)

- `radius`:

  Genomic window size to extract SNPs

- `clump_pop`:

  Reference population for clumping

- `x`:

  Import data where available

------------------------------------------------------------------------

### `CAMERA$instrument_heterogeneity()`

The function evaluates heterogeneity in the association of selected
instruments and the exposure/outcome between the populations.
Heterogeneity (Q statistics) is calcuated based on an IVW or simple MODE
MR estimator. The instruments can be identified using "Raw", "MaxZ", or
fine-mapping (Susie, PAINTOR) methods.

#### Usage

    CAMERA$instrument_heterogeneity(
      instrument = self$instrument_raw,
      alpha = "bonferroni",
      method = "ivw",
      outlier_removal = FALSE
    )

#### Arguments

- `instrument`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_maxz,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `alpha`:

  Statistical threshold to determine significance. Default is
  "bonferroni", which is eqaul to 0.05/number of the instruments.

- `method`:

  IVW or Simple MODE

- `outlier_removal`:

  Remove outliers identified by radial IVW MR before estimating
  heterogeneity. Default is `FALSE`.

#### Returns

Table of the result

------------------------------------------------------------------------

### `CAMERA$estimate_instrument_specificity()`

The function estimates what fraction of the instuments is expected to be
replicated across the populations under the hypothesis that the effect
estimates are the same.

#### Usage

    CAMERA$estimate_instrument_specificity(
      instrument,
      alpha = "bonferroni",
      winnerscurse = FALSE
    )

#### Arguments

- `instrument`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_maxz,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `alpha`:

  Statistical threshold to determine significance. Default is
  "bonferroni", which is eqaul to 0.05/number of the instruments.

- `winnerscurse`:

  Use this option to correct winners' curse bias.

#### Returns

Table of the results. Summary of the results available in
x\$instrument_specificity_summary.

------------------------------------------------------------------------

### `CAMERA$replication_evaluation()`

The function explains what contributes to the replication of gene-trait
association between the populations, considering LD structure.

#### Usage

    CAMERA$replication_evaluation(
      instrument = self$instrument_raw,
      ld = self$ld_matrices
    )

#### Arguments

- `instrument`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_maxz,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `ld`:

  LD matrix obtained by using `x$regional_ld_matrices()`

#### Returns

Table of the regression result

------------------------------------------------------------------------

### `CAMERA$check_phenotypes()`

This function evaluates how competitable genetic associations in
population 1 are with those in population 2. The function checks
whether 1) the chosen IDs for the exposure or outcome can be used for
the further steps and 2) the units for the genetic associations are
comparable between populations.

#### Usage

    CAMERA$check_phenotypes(ids = self$exposure_ids)

#### Arguments

- `ids`:

  ID for the exposure or the outcome. Default is x\$exposure_ids.

#### Returns

Table of the result.

------------------------------------------------------------------------

### `CAMERA$cross_estimate()`

This method performs a IVW analysis on the harmonised data. It fits two
linear models, one considering all populations and another considering
each population separately. It then performs a fixed effects
meta-analysis to estimate the heterogeneity across different
populations. The results are stored in the `mrres` attribute of the
`CAMERA` object.

#### Usage

    CAMERA$cross_estimate(dat = self$harmonised_dat)

#### Arguments

- `dat`:

  A data frame containing the harmonised data. It should have the
  columns `beta.y`, `beta.x`, `se.y`, and `pops`. If not provided, the
  method uses the `harmonised_dat` attribute of the `CAMERA` object.

#### Returns

A list containing the results of the analysis. The list includes the
coefficients of the fitted models, and the results of the heterogeneity
analysis.

------------------------------------------------------------------------

### `CAMERA$plot_cross_estimate()`

Plot the results from `cross_estimate`

#### Usage

    CAMERA$plot_cross_estimate(est = self$mrres, qj_alpha = 0.05)

#### Arguments

- `est`:

  Results from `cross_estimate()`. Default is `x$mrres`.

- `qj_alpha`:

  Significance threshold for highlighting heterogeneous estimates.
  Default is 0.05.

#### Returns

Plot

------------------------------------------------------------------------

### `CAMERA$extract_instruments()`

This function searches for GWAS significant SNPs (P \< 5E-8) for a
specified set of the exposures. This method is equivalant to the
instrumnet extraction method for Multivariable MR. Reference here:
https://mrcieu.github.io/TwoSampleMR/reference/mv_extract_exposures.html.

#### Usage

    CAMERA$extract_instruments(exposure_ids = self$exposure_ids, ...)

#### Arguments

- `exposure_ids`:

  ID for the exposure. Default is x\$exposure_ids.

- `...`:

  Further arguments passed to
  [`TwoSampleMR::mv_extract_exposures()`](https://mrcieu.github.io/TwoSampleMR/reference/mv_extract_exposures.html)

#### Returns

Data frame in x\$instrument_raw

------------------------------------------------------------------------

### `CAMERA$extract_instrument_regions()`

This function extract genomic regions around each instrument (e.g. 50kb)
obtained from `x$extract_instruments()`.

#### Usage

    CAMERA$extract_instrument_regions(
      radius = self$radius,
      instrument_raw = self$instrument_raw,
      exposure_ids = self$exposure_ids
    )

#### Arguments

- `radius`:

  Set a range of the region to search

- `instrument_raw`:

  A set of instruments obtained from `x$extract_instruments()`

- `exposure_ids`:

  ID for the exposure. Default is x\$exposure_ids.

#### Returns

Data frame in x\$instrument_regions

------------------------------------------------------------------------

### `CAMERA$scan_regional_instruments()`

The function searches for a SNP that is best associated across the
poupulations within the identified regions by using
`x$extract_instrument_regions()`.

#### Usage

    CAMERA$scan_regional_instruments(
      instrument_raw = self$instrument_raw,
      instrument_regions = self$instrument_regions
    )

#### Arguments

- `instrument_raw`:

  Instruments for the exposures by using `x$extract_instrument()`

- `instrument_regions`:

  Genomic regions identified by using `x$extract_instrument_regions()`

#### Returns

List of z scores for the chosen SNPs in x\$instrument_region_zscores.
Data frame in x\$instrument_maxz

------------------------------------------------------------------------

### `CAMERA$plot_regional_instruments_maxz()`

The function draws a plot shows how CAMERA selected the instruments for
the exposure from the selected genomic regions.

#### Usage

    CAMERA$plot_regional_instruments_maxz(
      instrument_region_zscores = self$instrument_region_zscores,
      instruments = self$instrument_raw,
      region = 1:min(10, nrow(instruments)),
      comparison = FALSE
    )

#### Arguments

- `instrument_region_zscores`:

  Y axis. Z scores based on the SNP-exposure associations.

- `instruments`:

  Use this option to draw a separate plot for the selcted instruments.

- `region`:

  X axis. Number of genomic regions to be shown in the plot. Default is
  10.

- `comparison`:

  Use this option to compare the selected instruments by different
  instrument selection methods in one plot.

#### Returns

Plot

------------------------------------------------------------------------

### `CAMERA$regional_ld_matrices()`

Generate LD matrices for instrument regions. If we want to do fine
mapping we need to get an LD matrix for the whole region (for each
population) We then need to harmonise the LD matrix to the summary data,
and the summary datasets to each other The function obtains an LD matrix
for the selected genomic regions.

#### Usage

    CAMERA$regional_ld_matrices(
      instrument_regions = self$instrument_regions,
      bfiles = self$bfiles,
      pops = self$pops,
      plink = self$plink
    )

#### Arguments

- `instrument_regions`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `bfiles`:

  Location of LD reference files for each population (Download from:
  http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz)

- `pops`:

  Ancestry information for each population (i.e. AFR, AMR, EUR, EAS,
  SAS)

- `plink`:

  Location of executable plink (version 1.90 is recommended)

#### Returns

Data frame of LD matrix (x\$ld_matrices)

------------------------------------------------------------------------

### `CAMERA$susie_finemap_regions()`

Fine-mapping using susieR (https://github.com/stephenslab/susieR) to
extract instruments for the exposure for multiple populations. The
function identifies credible sets that overlap between the populations
and determine the best SNP in a genomic region to be used as instrument.

#### Usage

    CAMERA$susie_finemap_regions(
      dat = self$instrument_regions,
      ld = self$ld_matrices
    )

#### Arguments

- `dat`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `ld`:

  LD matrix obtained by using `x$regional_ld_matrices()`

#### Returns

Result from susieR in x\$susie_results. Data frame in
x\$instrument_susie

------------------------------------------------------------------------

### `CAMERA$paintor_finemap_regions()`

Fine-mapping using PAINTOR (https://github.com/gkichaev/PAINTOR_V3.0) to
extract instruments for the exposure for multiple populations. The
function chooses the SNP with highest posterior probability and
associations in each exposure.

#### Usage

    CAMERA$paintor_finemap_regions(
      region = self$instrument_regions,
      ld = self$ld_matrices,
      PAINTOR = "PAINTOR",
      workdir = tempdir()
    )

#### Arguments

- `region`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `ld`:

  LD matrix obtained by using `x$regional_ld_matrices()`

- `PAINTOR`:

  Path to executable PAINTOR. Default="PAINTOR"

- `workdir`:

  Working directory to save the output. Default=tempdir()

#### Returns

Result from PAINTOR in x\$paintor_results. Data frame in
x\$instrument_paintor

------------------------------------------------------------------------

### `CAMERA$MsCAVIAR_finemap_regions()`

Fine-mapping using MsCAVIAR (https://github.com/nlapier2/MsCAVIAR) to
extract instruments for the exposure for multiple populations.

#### Usage

    CAMERA$MsCAVIAR_finemap_regions(
      region = self$instrument_regions,
      ld = self$ld_matrices,
      MsCAVIAR = "MsCAVIAR",
      workdir = tempdir()
    )

#### Arguments

- `region`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `ld`:

  LD matrix obtained by using `x$regional_ld_matrices()`

- `MsCAVIAR`:

  Path to executable MsCAVIAR. Default="MsCAVIAR"

- `workdir`:

  Working directory to save the output. Default=tempdir()

#### Returns

Result from MsCAVIAR in x\$mscaviar_results. Data frame in
x\$instrument_mscaviar

------------------------------------------------------------------------

### `CAMERA$fema_regional_instruments()`

Identify the best variant for each region by meta-analysing the
associations across the populations

#### Usage

    CAMERA$fema_regional_instruments(
      method = "fema",
      instrument_regions = self$instrument_regions,
      instrument_raw = self$instrument_raw,
      n = self$exposure_metadata$sample_size
    )

#### Arguments

- `method`:

  Meta-analysis method, either `"fema"` (fixed effects meta-analysis) or
  `"zma"` (Z score meta-analysis). Default is `"fema"`.

- `instrument_regions`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `instrument_raw`:

  Instruments for the exposures obtained from `x$extract_instruments()`

- `n`:

  Sample sizes for each exposure, required for `method = "zma"`. Default
  is the sample sizes from `x$exposure_metadata`.

#### Returns

Data frame of the selected instruments, also stored in
`x$instrument_fema`

------------------------------------------------------------------------

### `CAMERA$plot_regional_instruments()`

Plot the associations in a region for each population and for the
meta-analysis

#### Usage

    CAMERA$plot_regional_instruments(
      region,
      instrument_regions = self$instrument_regions,
      meta_analysis_regions = self$instrument_fema_regions
    )

#### Arguments

- `region`:

  Name of the region to plot, i.e. one of `names(x$instrument_regions)`

- `instrument_regions`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `meta_analysis_regions`:

  Meta-analysis results for each region obtained from
  `x$fema_regional_instruments()`

#### Returns

Plot

------------------------------------------------------------------------

### `CAMERA$get_metadata()`

Get metadata for the exposures and outcomes from the OpenGWAS API

#### Usage

    CAMERA$get_metadata(
      exposure_ids = self$exposure_ids,
      outcome_ids = self$outcome_ids
    )

#### Arguments

- `exposure_ids`:

  IDs for the exposures. Default is `x$exposure_ids`.

- `outcome_ids`:

  IDs for the outcomes. Default is `x$outcome_ids`.

#### Returns

List of the exposure and outcome metadata, also stored in
`x$exposure_metadata` and `x$outcome_metadata`

------------------------------------------------------------------------

### `CAMERA$estimate_instrument_heterogeneity_per_variant()`

Test for heterogeneity of effect estimates between populations. For each
SNP this function will provide a Cochran's Q test statistic - a measure
of heterogeneity of effect sizes between populations. A low p-value
means high heterogeneity. In addition, for every SNP it gives a per
population p-value - this can be interpreted as asking for each SNP is a
particular giving an outlier estimate.

#### Usage

    CAMERA$estimate_instrument_heterogeneity_per_variant(dat = self$harmonised_dat)

#### Arguments

- `dat`:

  Harmonised data. Default is `x$harmonised_dat`.

#### Returns

Data frame of the Q statistic, its p-value and FDR adjusted p-value for
each SNP, also stored in `x$instrument_heterogeneity_per_variant`

------------------------------------------------------------------------

### `CAMERA$mrgxe()`

Estimate the pleiotropic effect of each variant using MR GxE across
populations, see
[`egger_bootstrap()`](https://mrcieu.github.io/CAMERA/reference/egger_bootstrap.md)

#### Usage

    CAMERA$mrgxe(
      dat = self$harmonised_dat,
      variant_list = subset(self$instrument_heterogeneity_per_variant, Qfdr < 0.05)$SNP,
      nboot = 100
    )

#### Arguments

- `dat`:

  Harmonised data. Default is `x$harmonised_dat`.

- `variant_list`:

  SNPs to analyse. Default is the SNPs with FDR \< 0.05 in
  `x$instrument_heterogeneity_per_variant`.

- `nboot`:

  Number of bootstraps. Default is 100.

#### Returns

Data frame of the MR GxE results, also stored in `x$mrgxe_res`

------------------------------------------------------------------------

### `CAMERA$mrgxe_plot()`

Plot the MR GxE pleiotropy estimates for each variant

#### Usage

    CAMERA$mrgxe_plot(mrgxe_res = self$mrgxe_res)

#### Arguments

- `mrgxe_res`:

  Results from `mrgxe()`. Default is `x$mrgxe_res`.

#### Returns

Plot

------------------------------------------------------------------------

### `CAMERA$mrgxe_plot_variant()`

Plot the instrument-exposure against instrument-outcome associations
across populations for selected variants

#### Usage

    CAMERA$mrgxe_plot_variant(
      variant = self$mrgxe_res %>% dplyr::filter(p.adjust(a_pval, "fdr") < 0.05) %>% {

          .$SNP
     },
      dat = self$harmonised_dat
    )

#### Arguments

- `variant`:

  SNPs to plot. Default is the SNPs with FDR \< 0.05 for the pleiotropy
  estimate in `x$mrgxe_res`.

- `dat`:

  Harmonised data. Default is `x$harmonised_dat`.

#### Returns

Plot

------------------------------------------------------------------------

### `CAMERA$make_outcome_data()`

The function extracts summary statistics of given a list of instruments
and the outcomes

#### Usage

    CAMERA$make_outcome_data(exp = self$instrument_raw, p_exp = 0.05/nrow(exp))

#### Arguments

- `exp`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_maxz,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `p_exp`:

  Statistical threshold to determine significance. Default is
  "bonferroni", which is eqaul to 0.05/number of the instruments.

#### Returns

Data frame in x\$instrument_outcome

------------------------------------------------------------------------

### `CAMERA$make_outcome_local()`

The function extracts summary statistics of given a list of instruments
and the outcomes from local data

#### Usage

    CAMERA$make_outcome_local(
      exp = self$instrument_raw,
      out = self$instrument_outcome_regions,
      p_exp = 0.05/nrow(exp)
    )

#### Arguments

- `exp`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_fema,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `out`:

  Outcome data for each instrument region. Default is
  x\$instrument_outcome_regions.

- `p_exp`:

  Statistical threshold to determine significance. Default is
  "bonferroni", which is eqaul to 0.05/number of the instruments.

#### Returns

Data frame in x\$instrument_outcome

------------------------------------------------------------------------

### `CAMERA$harmonise()`

This function harmonises the alleles and effects between the exposure
and outcome.

#### Usage

    CAMERA$harmonise(exp = self$instrument_raw, out = self$instrument_outcome)

#### Arguments

- `exp`:

  Intsruments for the exposure that are selected by using the provided
  methods in CAMERA (x\$instrument_raw, x\$instrument_fema,
  x\$instrument_susie, x\$instrument_paintor). Default is
  x\$instrument_raw.

- `out`:

  Intsruments for the outcome by using `make_outcome_data()`. Default is
  x\$instrument_outcome.

#### Returns

Data frame in x\$harmonised_dat_sem

------------------------------------------------------------------------

### `CAMERA$set_summary()`

Generate summary of exposure, outcome and population metadata

#### Usage

    CAMERA$set_summary()

#### Returns

data frame

------------------------------------------------------------------------

### `CAMERA$pleiotropy()`

Estimate similarity of horizontal pleiotropy across ancestries. For each
ancestry, identify outliers in the MR analysis based on per-variatn Q
statistics. Then estimate the deviation from the main estimates for all
outliers across all ancestries. Finally, determine if the pleiotropy
deviation is consistent across all ancestries

#### Usage

    CAMERA$pleiotropy(harmonised_dat = self$harmonised_dat, mrres = self$mrres)

#### Arguments

- `harmonised_dat`:

  Outcome from `harmonise` function

- `mrres`:

  Outcome from `cross_estimate`

#### Returns

- data frame of outliers `pleiotropy_outliers`

- data frame of heterogeneity for each outlier / ancestry combination
  `pleiotropy_Q_outliers`

- data frame of agreement of outlier effects `pleiotropy_agreement`

------------------------------------------------------------------------

### `CAMERA$plot_pleiotropy()`

Plot pleiotropy results

#### Usage

    CAMERA$plot_pleiotropy(dat = self$pleiotropy_outliers)

#### Arguments

- `dat`:

  Output from `pleiotropy` - `pleiotropy_outliers`

#### Returns

plot

------------------------------------------------------------------------

### `CAMERA$plot_pleiotropy_heterogeneity()`

Plot pleiotropy results per variant

#### Usage

    CAMERA$plot_pleiotropy_heterogeneity(
      dat = self$pleiotropy_Q_outliers,
      pthresh = 0.05
    )

#### Arguments

- `dat`:

  Output from `pleiotropy` - `pleiotropy_Q_outliers`

- `pthresh`:

  p-value from Q statistic for inclusion in plots

#### Returns

plot

------------------------------------------------------------------------

### `CAMERA$perform_basic_sem()`

Perform basic SEM analysis of the joint estimates in multiple
ancestries.

#### Usage

    CAMERA$perform_basic_sem(harmonised_dat = self$harmonised_dat_sem)

#### Arguments

- `harmonised_dat`:

  Harmonised dataset obtained by using `harmonised_dat()`

#### Returns

Table of the SEM results. Summary of the results available in
x\$sem_result.

------------------------------------------------------------------------

### `CAMERA$runsem()`

Fit an SEM model using lavaan

#### Usage

    CAMERA$runsem(model, data, modname)

#### Arguments

- `model`:

  lavaan model syntax

- `data`:

  Data frame of the data for the model

- `modname`:

  Name of the model used to label the results

#### Returns

Data frame of the SEM estimates for each population

------------------------------------------------------------------------

### `CAMERA$standardise_data()`

This function standardises the betas and SEs for the
instruments-exposure/outcome associations when unit information is not
matched across the populations. In case of large differences in genetic
effects observed between the populations (e.g. due to sample size
difference), the function scales the betas and SEs.

#### Usage

    CAMERA$standardise_data(
      dat = self$instrument_raw,
      standardise_unit = FALSE,
      standardise_scale = FALSE,
      scaling_method = "simple_mode"
    )

#### Arguments

- `dat`:

  Instruments for the exposure that are selected by using the provided
  methods in CAMERA (`x$instrument_raw`, `x$instrument_maxz`,
  `x$instrument_susie`, `x$instrument_paintor`). Default is
  `x$instrument_raw`.

- `dat`:

  A data frame containing the harmonised data. It should have the
  columns `beta.y`, `beta.x`, `se.y`, and `pops`. If not provided, the
  method uses the `harmonised_dat` attribute of the `CAMERA` object.

- `dat`:

  Genomic regions identified by using `x$extract_instrument_regions()`

- `dat`:

  Harmonised data. Default is `x$harmonised_dat`.

- `standardise_unit`:

  Use this option if unit information is not matched.

- `standardise_scale`:

  Use this option if genetic effects are substantially different due to
  study power.

- `scaling_method`:

  Choose the methods to obtain scaling units (MR estimates of exposure 1
  and exposure 2 or outcome 1 and outcome 2). Default is
  `"simple_mode"`.

------------------------------------------------------------------------

### `CAMERA$clone()`

The objects of this class are cloneable with this method.

#### Usage

    CAMERA$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
