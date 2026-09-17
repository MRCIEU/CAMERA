# CAMERA_local class

A simple wrapper function for importing data from local files for use
with the CAMERA class.

## Public fields

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  details for info on columns

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference

- `mc.cores`:

  The number of processor cores to use

- `plink_bin`:

  Location of executable plink (version 1.90 is recommended)

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

Create a new dataset and initialise an R interface

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
  details for info on columns

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference

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

Standardise the allele coding

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

------------------------------------------------------------------------

### `CAMERA_local$read_file()`

Function to read in a file

#### Usage

    CAMERA_local$read_file(m, minmaf = 0.01)

#### Arguments

- `m`:

  File object

- `minmaf`:

  Minimum allele frequency per dataset

------------------------------------------------------------------------

### `CAMERA_local$pool_tophits()`

Pool the top hits

#### Usage

    CAMERA_local$pool_tophits(
      rawdat,
      tophits,
      metadata,
      radius = 250000,
      pthresh = 5e-08,
      mc.cores = 10
    )

#### Arguments

- `rawdat`:

  The raw data

- `tophits`:

  The top hits

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  details for info on columns

- `radius`:

  Genomic window size to extract SNPs

- `radius`:

  Default 250000

- `pthresh`:

  P-value threshold for instrument inclusion

- `mc.cores`:

  Number of cores to use

------------------------------------------------------------------------

### `CAMERA_local$organise_data()`

A function to organise the data

#### Usage

    CAMERA_local$organise_data(
      metadata = self$metadata,
      plink_bin = self$plink_bin,
      ld_ref = self$ld_ref,
      pthresh = self$pthresh,
      minmaf = self$minmaf,
      radius = self$radius,
      mc.cores = self$mc.cores
    )

#### Arguments

- `metadata`:

  Data frame with information about the data. One row per dataset. See
  details for info on columns

- `plink_bin`:

  Location of executable plink (version 1.90 is recommended)

- `ld_ref`:

  Data frame with two columns - pop = population (referencing the pop
  values in metadata), bfile = path to plink file for that reference

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

------------------------------------------------------------------------

### `CAMERA_local$fixed_effects_meta_analysis_fast()`

A function to perform fixed effect meta-analysis

#### Usage

    CAMERA_local$fixed_effects_meta_analysis_fast(beta_mat, se_mat)

#### Arguments

- `beta_mat`:

  Matrix of beta coefficients

- `se_mat`:

  Matrix of SEs

------------------------------------------------------------------------

### `CAMERA_local$organise()`

Organise the output

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
