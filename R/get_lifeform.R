#' Get the listed vegetation life forms for a list of taxa
#'
#' @param taxa A data frame with taxon names as returned by get.taxa()
#'
#' @return A data frame as returned by get.taxa with an extra column named life.form
#' @export
#' @examples
#' \dontrun{
#' taxa <- get.taxa(c("Myrcia guianensis", "bleh", "Xylopia", "Miconia albicans", "bleh", "Poa annua"))
#' get_lifeform(taxa)
#' }
get_lifeform <- function(taxa) {
  get_sp_lifeform <- function(id) {
    if (is.na(id)) return(NA)
    sp_info <- jsonlite::fromJSON(paste0("http://floradobrasil.jbrj.gov.br/reflora/listaBrasil/ConsultaPublicaUC/ResultadoDaConsultaCarregaTaxonGrupo.do?&idDadosListaBrasil=", id))
    paste(sp_info$formaVida, collapse = "|")
  }
  lifeforms <- sapply(taxa$id, get_sp_lifeform)
  taxa$life.form <- lifeforms
  taxa
}