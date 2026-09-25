# CAMeRa 0.1.4

* `extract_instruments()` and `check_phenotypes()` now harmonise with TwoSampleMR `action = 1`, assuming all alleles are on the forward strand as they are in OpenGWAS. Previously the default `action = 2` inferred the strand of palindromic SNPs from their allele frequencies, which differ between populations, so palindromic SNPs whose allele frequencies were on different sides of 0.5 in the reference population had their `beta` and `eaf` wrongly flipped, and palindromic SNPs with intermediate allele frequencies were dropped. `extract_instruments()` gains a `harmonise_strictness` argument.
* Bump the required version of ieugwasr

# CAMeRa 0.1.3

* Fix `CAMERA_local` so it can be initialised and run: add the missing `radius` field, store `ld_ref`, call the class's own methods, fix the exposure/outcome subsetting, stop `mc.cores` being passed as `pthresh`, use `mc.cores` (default 1, so it works on Windows) in all parallel calls, use the `minmaf` setting when reading files, and declare its dependencies (data.table, GenomicRanges, IRanges, parallel) in Suggests (thanks @Mercy-Kimani)

# CAMeRa 0.1.2

* Additional amends to the tutorial
  * Show loading of the example data and state when it was created
  * Explain how to install genetics.binaRies or supply a plink executable
  * Remove the unused `x$clone()` and clarify how `make_outcome_data()` and `harmonise()` update the object
  * Add an overview of the `CAMERA` methods with links to their documentation
* Regenerate the example data used in the tutorial from OpenGWAS, using an ieugwasr version which corrects the signs of the `beta` and `eaf` of the ukb-e datasets returned by `associations()`, and update the tutorial text to match the new results
* Fix swapping of the effect and other alleles in `extract_instrument_regions()` when a dataset's effect allele differs from the first dataset's
* Expand the documentation of the `instrument_heterogeneity()`, `estimate_instrument_specificity()` and `cross_estimate()` methods, including their output columns and the null hypotheses of their p-values

# CAMeRa 0.1.1

* Various fixes to documentation and vignettes

# CAMeRa 0.1.0

* First release of package
