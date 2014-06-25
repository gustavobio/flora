#' Get downstream taxa
#' 
#' Get all downstream taxa from a family or genus name.
#'
#' @param taxon a character vector with either a family or genus name
#' @export
#' @examples
#' lower.taxa("Acosmium")
#' lower.taxa("Zygophyllaceae")

lower.taxa <- function(taxon) {
  taxon <- fixCase(trim(taxon))
  where <- apply(all.taxa[, c("family", "genus")], 2, function(x) grepl(paste("^", taxon, "$", sep = ""), x))
  where <- rowSums(where) == 1L
  all.taxa[where, "search.str"]
}