#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

utils::globalVariables(c(".", "a", "a_se", "b", "b_se", "metric"))

# Dummy function to suppress check NOTE Namespaces in Imports field not imported from:
#' @noRd
dummy <- function() {
  ggplot2::ggplot
  ieugwasr::associations
  tidyr::any_of
}
