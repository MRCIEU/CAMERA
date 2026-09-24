# CAMERA_local class

A simple wrapper function for importing data from local files for use
with the CAMERA class.

Create the object with `CAMERA_local$new()` and then call its
`organise()` method. This reads the summary statistics files listed in
`metadata`, finds and clumps the top hits for each dataset, pools them
across populations, and extracts the region around each instrument from
every dataset. The results are stored in the `instrument_raw`,
`instrument_outcome`, `instrument_regions` and
`instrument_outcome_regions` fields, which can be passed to the
`import_from_local()` method of a
[CAMERA](https://mrcieu.github.io/CAMERA/reference/CAMERA.md) object.

See
[`vignette("import-local", package = "CAMeRa")`](https://mrcieu.github.io/CAMERA/articles/import-local.md)
for a worked example.

## Details

`metadata` must be a data frame with one row per summary statistics file
(i.e. per trait and population) and the following columns:

- `what`: either `"exposure"` or `"outcome"`

- `trait`: name of the trait, the same for all populations of a trait

- `pop`: population, e.g. `"EUR"`; must match the `pop` column of
  `ld_ref`

- `id`: a unique identifier for the dataset

- `fn`: path to the summary statistics file, which is read with
  [`data.table::fread()`](https://rdrr.io/pkg/data.table/man/fread.html)

- `chr_col`, `pos_col`, `ea_col`, `oa_col`, `eaf_col`, `beta_col`,
  `se_col`, `pval_col`: the name or number of the column in the file
  containing the chromosome, base pair position, effect allele, other
  allele, effect allele frequency, effect estimate, standard error, and
  p-value respectively

Other columns are ignored. Variants are identified by chromosome,
position and alleles (as `chr:pos_a1_a2`, with the alleles in
alphabetical order), so all files must use the same genome build.

`ld_ref` must be a data frame with columns `pop` and `bfile`, giving for
each population the path to a PLINK binary fileset (without the
`.bed`/`.bim`/`.fam` extension) used as the LD reference for clumping.

Top hits are only taken from datasets with at least two variants with
p-value below `pthresh`. Currently `organise()` uses the first exposure
trait and the first outcome trait in `metadata`.

## See also

[CAMERA](https://mrcieu.github.io/CAMERA/reference/CAMERA.md),
[`vignette("import-local", package = "CAMeRa")`](https://mrcieu.github.io/CAMERA/articles/import-local.md)

## Public fields

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  Details for the required columns

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference

- `mc.cores`:

  The number of processor cores to use

- `plink_bin`:

  Location of executable plink (version 1.90 is recommended)

- `radius`:

  Genomic window size to extract SNPs

- `minmaf`:

  Minimum allele frequency per dataset

- `pthresh`:

  P-value threshold for instrument inclusion

- `instrument_raw`:

  A data frame of pooled instruments across all ancestries, that has
  been extracted from each ancestry for the exposure traits

- `instrument_outcome`:

  Instruments in `instrument_raw` extracted from the outcome datasets

- `instrument_regions`:

  Named list of data frames of length number of unique instruments in
  `instrument_raw`. Names of each item are the instruments. Each item is
  a list of regional extracts around the instrument from each population
  exposure study.

- `instrument_outcome_regions`:

  As per `instrument_regions` but for the outcome datasets.

## Methods

### Public methods

- [`CAMERA_local$new()`](#method-CAMERA_local-initialize)

- [`CAMERA_local$standardise()`](#method-CAMERA_local-standardise)

- [`CAMERA_local$read_file()`](#method-CAMERA_local-read_file)

- [`CAMERA_local$pool_tophits()`](#method-CAMERA_local-pool_tophits)

- [`CAMERA_local$organise_data()`](#method-CAMERA_local-organise_data)

- [`CAMERA_local$fixed_effects_meta_analysis_fast()`](#method-CAMERA_local-fixed_effects_meta_analysis_fast)

- [`CAMERA_local$organise()`](#method-CAMERA_local-organise)

- [`CAMERA_local$clone()`](#method-CAMERA_local-clone)

------------------------------------------------------------------------

### `CAMERA_local$new()`

Create a new `CAMERA_local` object

#### Usage

    CAMERA_local$new(
      metadata,
      ld_ref,
      plink_bin,
      mc.cores = 1,
      radius = 25000,
      pthresh = 5e-08,
      minmaf = 0.01
    )

#### Arguments

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  Details for the required columns

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference.
  See Details

- `plink_bin`:

  Location of executable plink (version 1.90 is recommended)

- `mc.cores`:

  Number of cores to use

- `radius`:

  Genomic window size to extract SNPs

- `radius`:

  Default 250000

- `pthresh`:

  P-value threshold for instrument inclusion

- `minmaf`:

  Minimum allele frequency per dataset

------------------------------------------------------------------------

### `CAMERA_local$standardise()`

Standardise the allele coding so that the effect allele is the
alphabetically first allele, flipping the effect estimate and allele
frequency where needed, and create a variant ID of the form
`chr:pos_ea_oa`

#### Usage

    CAMERA_local$standardise(
      d,
      ea_col = "ea",
      oa_col = "oa",
      beta_col = "beta",
      eaf_col = "eaf",
      chr_col = "chr",
      pos_col = "pos",
      vid_col = "vid"
    )

#### Arguments

- `d`:

  data.frame

- `ea_col`:

  Column name for effect allele

- `oa_col`:

  Column name for other allele

- `beta_col`:

  Column name containing beta coefficients

- `eaf_col`:

  Column name containing allele frequency for effect allele

- `chr_col`:

  Column name containing chromosome

- `pos_col`:

  Column name containing position

- `vid_col`:

  Column name containing variant ID

#### Returns

`d` with standardised alleles and a variant ID column

------------------------------------------------------------------------

### `CAMERA_local$read_file()`

Read in the summary statistics file for one dataset, drop variants with
minor allele frequency below `minmaf`, and standardise the alleles

#### Usage

    CAMERA_local$read_file(m, minmaf = self$minmaf)

#### Arguments

- `m`:

  File object

- `minmaf`:

  Minimum allele frequency per dataset

#### Returns

A tibble with columns `chr`, `pos`, `eaf`, `beta`, `se`, `pval`, `ea`,
`oa` and `vid`

------------------------------------------------------------------------

### `CAMERA_local$pool_tophits()`

Pool the top hits across datasets. For each trait, the regions within
`radius` of its top hits are merged, and the variants in each region are
extracted from every dataset. Within each region the variant with the
largest absolute z-score for the trait is selected, considering only
variants present in a number of datasets for which at least one such
variant has p-value below `pthresh`

#### Usage

    CAMERA_local$pool_tophits(
      rawdat,
      tophits,
      metadata,
      radius = 250000,
      pthresh = 5e-08,
      mc.cores = 1
    )

#### Arguments

- `rawdat`:

  The raw data

- `tophits`:

  The top hits

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  Details for the required columns

- `radius`:

  Genomic window size to extract SNPs

- `radius`:

  Default 250000

- `pthresh`:

  P-value threshold for instrument inclusion

- `mc.cores`:

  Number of cores to use

#### Returns

A list with elements `region_list` (the merged regions for each trait),
`region_extract` (the extracted variants in each region) and
`tophit_pool` (the selected variant from each region in every dataset)

------------------------------------------------------------------------

### `CAMERA_local$organise_data()`

Read in the data (unless `rawdat` is supplied), find the top hits in
each dataset by clumping the variants with p-value below `pthresh` using
[`ieugwasr::ld_clump()`](https://mrcieu.github.io/ieugwasr/reference/ld_clump.html),
and pool them with `pool_tophits()`

#### Usage

    CAMERA_local$organise_data(
      metadata = self$metadata,
      plink_bin = self$plink_bin,
      ld_ref = self$ld_ref,
      pthresh = self$pthresh,
      minmaf = self$minmaf,
      radius = self$radius,
      mc.cores = self$mc.cores,
      rawdat = NULL
    )

#### Arguments

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  Details for the required columns

- `plink_bin`:

  Location of executable plink (version 1.90 is recommended)

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference.
  See Details

- `pthresh`:

  P-value threshold for instrument inclusion

- `minmaf`:

  Minimum allele frequency per dataset

- `radius`:

  Genomic window size to extract SNPs

- `radius`:

  Default 250000

- `mc.cores`:

  Number of cores to use

- `rawdat`:

  The raw data

#### Returns

As for `pool_tophits()`

------------------------------------------------------------------------

### `CAMERA_local$fixed_effects_meta_analysis_fast()`

Fixed effect inverse variance weighted meta-analysis of each row of
`beta_mat` and `se_mat`

#### Usage

    CAMERA_local$fixed_effects_meta_analysis_fast(beta_mat, se_mat)

#### Arguments

- `beta_mat`:

  Matrix of beta coefficients

- `se_mat`:

  Matrix of SEs

#### Returns

A vector of p-values, one per row

------------------------------------------------------------------------

### `CAMERA_local$organise()`

Organise the data for the exposure and outcome, populating the
`instrument_raw`, `instrument_outcome`, `instrument_regions` and
`instrument_outcome_regions` fields

#### Usage

    CAMERA_local$organise()

------------------------------------------------------------------------

### `CAMERA_local$clone()`

The objects of this class are cloneable with this method.

#### Usage

    CAMERA_local$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
