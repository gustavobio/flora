#' Get the phytogeographic domain of a list of taxa
#'
#' @param taxa A data frame with taxon names as returned by get.taxa()
#'
#' @return A data frame as returned by get.taxa with an extra column named domain.
#' @export
#' @examples
#' \dontrun{
#' taxa <- get.taxa(c("Myrcia guianensis", "bleh", "Xylopia", "Miconia albicans", "bleh", "Poa annua"))
#' get_domains(taxa)
#' }
get_domains <- function(taxa) {
  taxa <- dplyr::left_join(taxa, distribution[, c("id", "domain")], 
                          by = "id")
  taxa
}