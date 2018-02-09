#' Get the listed endemism for a list of taxa
#'
#' @param taxa A data frame with taxon names as returned by get.taxa()
#'
#' @return A data frame as returned by get.taxa with an extra column named vegtype.
#' @export
#' @examples
#' \dontrun{
#' taxa <- get.taxa(c("Myrcia guianensis", "bleh", "Xylopia", "Miconia albicans", "bleh", "Poa annua"))
#' get_endemism(taxa)
#' }
get_endemism <- function(taxa) {
  get_sp_endemism <- function(id) {
    if (is.na(id)) return(NA)
    sp_info <- jsonlite::fromJSON(paste0("http://floradobrasil.jbrj.gov.br/reflora/listaBrasil/ConsultaPublicaUC/ResultadoDaConsultaCarregaTaxonGrupo.do?&idDadosListaBrasil=", id))
    paste(sp_info$endemismo, collapse = "|")
  }
  endemism <- sapply(taxa$id, get_sp_endemism)
  taxa$endemism <- endemism
  taxa
}