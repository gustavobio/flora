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
  get_sp_domain <- function(id) {
    if (is.na(id)) return(NA)
    sp_info <- jsonlite::fromJSON(paste0("http://floradobrasil.jbrj.gov.br/reflora/listaBrasil/ConsultaPublicaUC/ResultadoDaConsultaCarregaTaxonGrupo.do?&idDadosListaBrasil=", id))
    paste(sp_info$dominioFitogeografico, collapse = "|")
  }
  domains <- sapply(taxa$id, get_sp_domain)
  taxa$domain <- domains
  taxa
}