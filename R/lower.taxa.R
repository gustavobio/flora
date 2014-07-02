#' Get downstream taxa
#' 
#' Get all downstream taxa from a family or genus name.
#'
#' @param taxon a character vector with either a family or genus name
#' @param accepted list only accepted names?
#' @export
#' @examples
#' lower.taxa("Acosmium")
#' lower.taxa("Zygophyllaceae")

lower.taxa <- function(taxon, accepted = TRUE) {
  taxon <- fixCase(trim(taxon))
  where <- apply(all.taxa[, c("family", "genus")], 2, function(x) grepl(paste("^", taxon, "$", sep = ""), x))
  where <- rowSums(where) == 1L
  if (accepted) {
    all.taxa[where & all.taxa$taxon.status == "accepted", "search.str"]
  } else {
    all.taxa[where, "search.str"]
  }
}