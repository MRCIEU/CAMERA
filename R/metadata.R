#' @description
#' Get metadata for the exposures and outcomes from the OpenGWAS API
#' @param exposure_ids IDs for the exposures. Default is `x$exposure_ids`.
#' @param outcome_ids IDs for the outcomes. Default is `x$outcome_ids`.
#' @return List of the exposure and outcome metadata, also stored in `x$exposure_metadata` and `x$outcome_metadata`
CAMERA$set("public", "get_metadata", function(exposure_ids=self$exposure_ids, outcome_ids=self$outcome_ids) {
    self$exposure_metadata <- ieugwasr::gwasinfo(exposure_ids)
    self$outcome_metadata <- ieugwasr::gwasinfo(outcome_ids)
    return(list(self$exposure_metadata, self$outcome_metadata))
})
