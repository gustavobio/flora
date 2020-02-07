#' Get the listed vegetation types for a list of taxa
#'
#' @param taxa A data frame with taxon names as returned by get.taxa()
#'
#' @return A data frame as returned by get.taxa with an extra column named vegtype.
#' @export
#' @examples
#' \dontrun{
#' taxa <- get.taxa(c("Myrcia guianensis", "bleh", "Xylopia", "Miconia albicans", "bleh", "Poa annua"))
#' get_vegtype(taxa)
#' }
get_vegtype <- function(taxa) {
    taxa <- dplyr::left_join(taxa, species.profiles[, c("id", "vegetation.type")], 
                            by = "id")
    taxa
}