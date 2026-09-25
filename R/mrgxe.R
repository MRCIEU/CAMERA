# Start will all SNPs
# Select SNPs that show heterogeneity across groups
# Perform mrgxe_1 for each SNP

#' @description
#' Test for heterogeneity of effect estimates between populations.
#' For each SNP this function will provide a Cochran's Q test statistic - a measure of heterogeneity of effect sizes between populations. A low p-value means high heterogeneity.
#' In addition, for every SNP it gives a per population p-value - this can be interpreted as asking for each SNP is a particular giving an outlier estimate.
#'
#' @param dat Harmonised data. Default is `x$harmonised_dat`.
#'
#' @return Data frame of the Q statistic, its p-value and FDR adjusted p-value for each SNP, also stored in `x$instrument_heterogeneity_per_variant`
CAMERA$set("public", "estimate_instrument_heterogeneity_per_variant", function(dat = self$harmonised_dat) {
    self$instrument_heterogeneity_per_variant <- dat %>%
        dplyr::group_by(SNP) %>%
        dplyr::do({
            o <- fixed_effects_meta_analysis(.$beta.x, .$se.x)
            dplyr::tibble(
                SNP = .$SNP[1],
                Qdf = o$Qdf,
                Q = o$Q,
                Qpval = o$Qpval
            )
        }) %>%
        dplyr::ungroup() %>%
        dplyr::mutate(Qfdr = p.adjust(Qpval, "fdr"))
    return(self$instrument_heterogeneity_per_variant)
})

#' Perform MR GxE
#'
#' For a single variant estimated in different sub groups.
#'
#' Estimate the degree of pleiotropy using MR GxE. This method uses a negative control type approach based on an assumption that the instrument-exposure association is uncorrelated with the pleiotropic effect. Therefore, as the instrument-exposure association reduces in magnitude, the effect on the outcome will reduce towards an intercept term which represents the pleiotropic effect.
#'
#' Standard errors are obtained from parametric bootstrap
#'
#' @param b_gx Vector of instrument-exposure associations, one for each sub group
#' @param se_gx Vector of standard errors to b_gx
#' @param b_gy Vector of instrument-outcome associations, one for each sub group
#' @param se_gy Vector of standard errors for b_gy
#' @param nboot Number of bootstraps. Default=1000
#'
#' @return List
#' - a = intercept estimate (pleiotropy)
#' - b = slope estimate (b_iv effect)
#' - a_se = standard error of intercept
#' - b_se = standard error of slope
#' - a_pval = p-value of intercept estimate
#' - b_pval = p-value of slope estimate
#' - a_mean = mean value of intercept from bootstraps
#' - b_mean = mean value of slope estimates from bootstraps
#'
#' @export
egger_bootstrap <- function(b_gx, se_gx, b_gy, se_gy, nboot=1000) {
    npop <- length(b_gx)
    stopifnot(length(se_gx) == npop)
    stopifnot(length(b_gy) == npop)
    stopifnot(length(se_gy) == npop)

    ind <- b_gx[b_gx < 0]
    b_gx[ind] <- b_gx[ind] * -1
    b_gy[ind] <- b_gy[ind] * -1

    mod <- summary(stats::lm(b_gy ~ b_gx))

    # standard errors
    o <- lapply(1:nboot, \(i) {
        bgxb <- stats::rnorm(npop, b_gx, se_gx)
        bgyb <- stats::rnorm(npop, b_gy, se_gy)
        modb <- summary(stats::lm(bgyb ~ bgxb))$coef
        dplyr::tibble(boot=i, a=modb[1,1], b=modb[2,1])
    }) %>% dplyr::bind_rows()

    res <- dplyr::tibble(
        a = mod$coef[1,1],
        b = mod$coef[2,1],
        a_se = stats::sd(o$a),
        b_se = stats::sd(o$b),
        a_pval = stats::pnorm(abs(a) / a_se, lower.tail=FALSE),
        b_pval = stats::pnorm(abs(b) / b_se, lower.tail=FALSE),
        a_mean = mean(o$a),
        b_mean = mean(o$b)
    )
    return(res)
}


#' @description
#' Estimate the pleiotropic effect of each variant using MR GxE across populations, see `egger_bootstrap()`
#' @param dat Harmonised data. Default is `x$harmonised_dat`.
#' @param variant_list SNPs to analyse. Default is the SNPs with FDR < 0.05 in `x$instrument_heterogeneity_per_variant`.
#' @param nboot Number of bootstraps. Default is 100.
#' @return Data frame of the MR GxE results, also stored in `x$mrgxe_res`
CAMERA$set("public", "mrgxe", function(dat = self$harmonised_dat, variant_list = subset(self$instrument_heterogeneity_per_variant, Qfdr < 0.05)$SNP, nboot = 100) {
    self$mrgxe_res <- dat %>%
        dplyr::filter(SNP %in% variant_list) %>%
        dplyr::group_by(SNP) %>%
        dplyr::do({
            egger_bootstrap(.$beta.x, .$se.x, .$beta.y, .$se.y, nboot) %>%
                dplyr::mutate(SNP=.$SNP[1])
        }) %>%
        dplyr::ungroup()
    return(self$mrgxe_res)
})


#' @description
#' Plot the MR GxE pleiotropy estimates for each variant
#' @param mrgxe_res Results from `mrgxe()`. Default is `x$mrgxe_res`.
#' @return Plot
CAMERA$set("public", "mrgxe_plot", function(mrgxe_res = self$mrgxe_res) {
    mrgxe_res %>%
        dplyr::arrange(a) %>%
        ggplot2::ggplot(., ggplot2::aes(x=a, y=SNP)) +
            ggplot2::geom_point() +
            ggplot2::geom_errorbar(ggplot2::aes(xmin=a-1.96*a_se, xmax=a+1.96*a_se), width=0, orientation="y") +
            ggplot2::geom_vline(xintercept=0, linetype="dotted") +
            ggplot2::scale_y_discrete(limits=dplyr::arrange(mrgxe_res, a)$SNP)
})


#' @description
#' Plot the instrument-exposure against instrument-outcome associations across populations for selected variants
#' @param variant SNPs to plot. Default is the SNPs with FDR < 0.05 for the pleiotropy estimate in `x$mrgxe_res`.
#' @param dat Harmonised data. Default is `x$harmonised_dat`.
#' @return Plot
CAMERA$set("public", "mrgxe_plot_variant", function(variant = self$mrgxe_res %>% dplyr::ungroup() %>% dplyr::filter(p.adjust(a_pval, "fdr") < 0.05) %>% {.$SNP}, dat = self$harmonised_dat) {
    dat <- subset(dat, SNP %in% variant)
    ind <- dat$beta.x < 0
    dat$beta.x <- abs(dat$beta.x)
    dat$beta.y[ind] <- dat$beta.y[ind] * -1
    dat %>%
        ggplot2::ggplot(., ggplot2::aes(x=beta.x, y=beta.y)) +
        ggplot2::geom_point() +
        ggplot2::geom_errorbar(ggplot2::aes(ymin=beta.y-1.96*se.y, ymax=beta.y+1.96*se.y), colour="grey", width=0) +
        ggplot2::geom_errorbar(ggplot2::aes(xmin=beta.x-1.96*se.x, xmax=beta.x+1.96*se.x), colour="grey", width=0, orientation="y") +
        ggplot2::facet_wrap(~ SNP, scale="free") +
        ggplot2::geom_smooth(method="lm", formula=y ~ x) +
        ggplot2::geom_vline(xintercept=0, linetype="dotted") +
        ggplot2::geom_hline(yintercept=0, linetype="dotted")
})
