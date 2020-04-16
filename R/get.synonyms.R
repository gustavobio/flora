#' List all synonyms of a given taxa
#' 
#' This function returns all the synonyms of a given taxon according to the Brazilian Flora 2020.
#' 
#' 
#' @param taxon a character vector containing a name.
#' @param fix should the function fix issues (synonyms, mispelled names) in taxon?
#' @param relationship return the kind of relationship?
#' @return a character vector
#' @export
#' @examples
#' \dontrun{
#' get.synonyms("Myrcia lingua")
#' }

get.synonyms <- function(taxon, fix = FALSE, relationship = FALSE) {
  if (length(taxon) == 0) stop("Please provide a name.")
  if (length(taxon) > 1) stop("Please provide only one name")
  if (fix) {
    processed_taxon <- get.taxa(taxon, replace.synonyms = TRUE, suggest.names = TRUE)
  } else {
    processed_taxon <- get.taxa(taxon, replace.synonyms = FALSE, suggest.names = FALSE)
  }
  if (is.na(processed_taxon$id)) {
    return(NA)
  }
  else {
    synonyms <-
      relationships[with(relationships, {
        which(related.id %in% processed_taxon$id)
      }),]
  }
  if (NROW(synonyms) == 0) {
    return(NULL)
  } else {
    res <- all.taxa[all.taxa$id %in% synonyms$id, ]
    if (relationship) {
      rl <- relationships[relationships$id %in% processed_taxon$id, ]
      rl_spp <- all.taxa[all.taxa$id %in% rl$related.id, ]
      rl_all <- merge(rl, rl_spp, by.x = "related.id", by.y = "id")
      return(data.frame(spp = processed_taxon$search.str, synonym = rl_all$search.str, relationship = rl_all$relationship))
    } else {
      return(res$search.str)
    }
  }
}