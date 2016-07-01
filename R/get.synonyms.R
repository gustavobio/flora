#' List all synonyms of a given taxa
#' 
#' This function returns all the synonyms of a given taxon according to the Brazilian Flora 2020.
#' 
#' 
#' @param taxon a character vector containing a name.
#' 
#' @return a character vector
#' @export
#' @examples
#' \dontrun{
#' synonyms("Myrcia lingua")
#' }

get.synonyms <- function(taxon) {
  if (length(taxon) == 0) stop("Please provide a name.")
  if (length(taxon) > 1) stop("Please provide only one name")
  processed_taxon <- get.taxa(taxon, replace.synonyms = FALSE, suggest.names = FALSE)
  if (is.na(processed_taxon$id)) {
    return(NA)
  }
  else {
    synonyms <- relationships[with(relationships, {
      related.id == processed_taxon$id & grepl("\u00C9 sin\u00F4nimo", relationship)
      }), ]
  }
  if (NROW(synonyms) == 0) {
    return(NULL)
  } else {
    return(all.taxa[all.taxa$id %in% synonyms$id, ]$search.str)
  }
}