#' R6 class for CAMERA
#' @docType class
#' @description
#' A simple wrapper function.
#' Using a summary set, identify set of instruments for the traits, and perform SEM MR to test the association across the population.
#' @param x R6 Environment created for CAMERA. Default = x
#' @param exposure_ids Exposures IDs obtained from IEU GWAS database (<https://gwas.mrcieu.ac.uk>) for each population
#' @param outcome_ids Outcome IDs obtained from IEU GWAS database (<https://gwas.mrcieu.ac.uk>) for each population
#' @param pops Ancestry information for each population (i.e., AFR, AMR, EUR, EAS, SAS)
#' @param bfiles Locations of LD reference files for each population (Download from: <http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz>)
#' @param plink Location of executable plink (version 1.90 is recommended)
#' @param radius Genomic window size to extract SNPs
#' @param clump_pop Reference population for clumping
#' @param dat Instruments for the exposure that are selected by using the provided methods in CAMERA (`x$instrument_raw`, `x$instrument_maxz`, `x$instrument_susie`, `x$instrument_paintor`). Default is `x$instrument_raw`.
#' @param standardise_unit Use this option if unit information is not matched.
#' @param standardise_scale Use this option if genetic effects are substantially different due to study power.
#' @param scaling_method Choose the methods to obtain scaling units (MR estimates of exposure 1 and exposure 2 or outcome 1 and outcome 2). Default is `"simple_mode"`.
#' @export
CAMERA <- R6::R6Class("CAMERA", list(
  #' @field output A list for the output
  output = list(),
  #' @field source The source of the data.
  source = NULL,
  #' @field exposure_ids Exposures IDs obtained from IEU GWAS database (<https://gwas.mrcieu.ac.uk>) for each population
  exposure_ids = NULL,
  #' @field outcome_ids Outcome IDs obtained from IEU GWAS database (<https://gwas.mrcieu.ac.uk>) for each population
  outcome_ids = NULL,
  #' @field exposure_metadata Exposure metadata
  exposure_metadata = NULL,
  #' @field outcome_metadata Outcome metadata
  outcome_metadata = NULL,
  #' @field radius Genomic window size to extract SNPs
  radius = NULL,
  #' @field pops Ancestry information for each population (i.e., AFR, AMR, EUR, EAS, SAS)
  pops = NULL,
  #' @field bfiles Locations of LD reference files for each population (Download from: <http://fileserve.mrcieu.ac.uk/ld/1kg.v3.tgz>)
  bfiles = NULL,
  #' @field plink Location of executable plink (version 1.90 is recommended)
  plink = NULL,
  #' @field clump_pop Reference population for clumping
  clump_pop = NULL,
  #' @field instrument_raw Instruments for the exposures obtained from `extract_instruments()`
  instrument_raw = NULL,
  #' @field instrument_regions Genomic regions around each instrument obtained from `extract_instrument_regions()`
  instrument_regions = NULL,
  #' @field ld_matrices LD matrices for each instrument region obtained from `regional_ld_matrices()`
  ld_matrices = NULL,
  #' @field susie_results Fine-mapping results from `susie_finemap_regions()`
  susie_results = NULL,
  #' @field paintor_results Fine-mapping results from `paintor_finemap_regions()`
  paintor_results = NULL,
  #' @field mscaviar_results Fine-mapping results from `MsCAVIAR_finemap_regions()`
  mscaviar_results = NULL,
  #' @field expected_replications Expected replication of instruments across populations
  expected_replications = NULL,
  #' @field instrument_region_zscores Z scores for the SNPs in each instrument region obtained from `scan_regional_instruments()`
  instrument_region_zscores = NULL,
  #' @field instrument_fema Instruments selected by meta-analysis across populations obtained from `fema_regional_instruments()`
  instrument_fema = NULL,
  #' @field instrument_fema_regions Meta-analysis results for each instrument region obtained from `fema_regional_instruments()`
  instrument_fema_regions = NULL,
  #' @field instrument_maxz Instruments selected by maximum Z score obtained from `scan_regional_instruments()`
  instrument_maxz = NULL,
  #' @field instrument_susie Instruments selected by susieR fine-mapping obtained from `susie_finemap_regions()`
  instrument_susie = NULL,
  #' @field instrument_paintor Instruments selected by PAINTOR fine-mapping obtained from `paintor_finemap_regions()`
  instrument_paintor = NULL,
  #' @field instrument_mscaviar Instruments selected by MsCAVIAR fine-mapping obtained from `MsCAVIAR_finemap_regions()`
  instrument_mscaviar = NULL,
  #' @field harmonised_data_check Checks of the harmonised data
  harmonised_data_check = NULL,
  #' @field standardised_instrument_raw Standardised `instrument_raw` obtained from `standardise_data()`
  standardised_instrument_raw = NULL,
  #' @field standardised_instrument_maxz Standardised `instrument_maxz` obtained from `standardise_data()`
  standardised_instrument_maxz = NULL,
  #' @field standardised_instrument_susie Standardised `instrument_susie` obtained from `standardise_data()`
  standardised_instrument_susie = NULL,
  #' @field standardised_instrument_paintor Standardised `instrument_paintor` obtained from `standardise_data()`
  standardised_instrument_paintor = NULL,
  #' @field standardised_instrument_mscaviar Standardised `instrument_mscaviar` obtained from `standardise_data()`
  standardised_instrument_mscaviar = NULL,
  #' @field standardised_outcome Standardised outcome data obtained from `standardise_data()`
  standardised_outcome = NULL,
  #' @field instrument_specificity Instrument specificity results obtained from `estimate_instrument_specificity()`
  instrument_specificity = NULL,
  #' @field instrument_specificity_summary Summary of the instrument specificity results obtained from `estimate_instrument_specificity()`
  instrument_specificity_summary = NULL,
  #' @field instrument_outcome Outcome data for the instruments obtained from `make_outcome_data()`
  instrument_outcome = NULL,
  #' @field instrument_outcome_regions Outcome data for each instrument region imported with `import_from_local()`
  instrument_outcome_regions = NULL,
  #' @field harmonised_dat_sem Harmonised data for the SEM analysis
  harmonised_dat_sem = NULL,
  #' @field harmonised_dat Harmonised exposure and outcome data obtained from `harmonise()`
  harmonised_dat = NULL,
  #' @field sem_result SEM results obtained from `perform_basic_sem()`
  sem_result = NULL,
  #' @field pleiotropy_agreement Agreement of pleiotropy outlier effects across populations obtained from `pleiotropy()`
  pleiotropy_agreement = NULL,
  #' @field pleiotropy_outliers Pleiotropy outliers obtained from `pleiotropy()`
  pleiotropy_outliers = NULL,
  #' @field pleiotropy_Q_outliers Heterogeneity for each pleiotropy outlier and population obtained from `pleiotropy()`
  pleiotropy_Q_outliers = NULL,
  #' @field summary Summary of the exposure, outcome and population metadata obtained from `set_summary()`
  summary = NULL,
  #' @field mrres MR estimates obtained from `cross_estimate()`
  mrres = NULL,
  #' @field instrument_heterogeneity_per_variant Heterogeneity of the instrument-exposure associations for each variant obtained from `estimate_instrument_heterogeneity_per_variant()`
  instrument_heterogeneity_per_variant = NULL,
  #' @field mrgxe_res MR GxE results obtained from `mrgxe()`
  mrgxe_res = NULL,

  # for convenience can migrate the results from a previous CAMERA into this one
  #' @description
  #' Migrate the results from a previous CAMERA
  #' @param x A CAMERA object to import results from
  import = function(x) {
    nom <- names(self)
    for (i in nom)
    {
      if (!i %in% c(".__enclos_env__", "clone") & is.null(self[[i]])) {
        self[[i]] <- x[[i]]
      }
    }
  },

  #' @description
  #' Assign values to fields of the CAMERA object
  #' @param ... Named arguments, where each name is a field and each value is assigned to it
  assign = function(...) {
    l <- list(...)
    lapply(names(l), \(n) {
      message("Assigning ", n)
      try(self[[n]] <- l[[n]])
    })
  },

  #' @description
  #' Import instrument and outcome data from local summary statistics, e.g. as organised by `CAMERA_local`
  #' @param instrument_raw Data frame of instruments for the exposures
  #' @param instrument_outcome Data frame of instrument associations with the outcomes
  #' @param instrument_regions List of genomic regions around each instrument for the exposures
  #' @param instrument_outcome_regions List of genomic regions around each instrument for the outcomes
  #' @param ... Further named arguments passed to `assign()`
  import_from_local = function(instrument_raw, instrument_outcome, instrument_regions, instrument_outcome_regions, exposure_ids, outcome_ids, pops, ...) {
    self[["instrument_raw"]] <- instrument_raw %>% generate_vid()
    self[["instrument_outcome"]] <- instrument_outcome  %>% generate_vid()
    self[["instrument_regions"]] <- lapply(instrument_regions, \(x) lapply(x, generate_vid))
    self[["instrument_outcome_regions"]] <- lapply(instrument_outcome_regions, \(x) lapply(x, generate_vid))
    self[["exposure_ids"]] <- exposure_ids
    self[["outcome_ids"]] <- outcome_ids
    self$source <- "Local"
    self$pops <- pops
    # Get instrument_outcome

    self$assign(...)
  },

  # Methods
  #' @description
  #' Create a new dataset and initialise an R interface
  #' @param x Import data where available
  initialize = function(exposure_ids = NULL, outcome_ids = NULL, pops = NULL, bfiles = NULL, plink = NULL, radius = NULL, clump_pop = NULL, x = NULL) {
    if (!is.null(x)) {
      import(x)
    }
    self$exposure_ids <- exposure_ids
    self$outcome_ids <- outcome_ids
    self$pops <- pops
    self$bfiles <- bfiles
    self$plink <- plink
    self$radius <- radius
    self$clump_pop <- clump_pop
    if(!is.null(exposure_ids)) {
      self$source <- "OpenGWAS"
      self$get_metadata()
    }
  }
))
