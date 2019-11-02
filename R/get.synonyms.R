#' List all synonyms of a given taxa
#' 
#' This function returns all the synonyms of a given taxon according to the Brazilian Flora 2020.
#' 
#' 
#' @param taxon a character vector containing a name.
#' @param fix should the function fix issues (synonyms, mispelled names) in taxon?
#' @return a character vector
#' @export
#' @examples
#' \dontrun{
#' synonyms("Myrcia lingua")
#' }

get.synonyms <- function(taxon, fix = FALSE) {
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
    return(all.taxa[all.taxa$id %in% synonyms$id, ]$search.str)
  }
}