require(plyr)
require(jsonlite)
require(tidyverse)
require(finch)
require(usethis)
require(flora)

# Careful with this if you have other IPT files in your cache!

dwca_cache$delete_all()

ipt.files <-
  dwca_read(
    "http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil",
    read = T,
    na.strings = "",
    encoding = "UTF-8"
  )

all.taxa <- ipt.files$data$taxon.txt[-c(2:5, 26)]

status_cnc <-
  read.csv("data-raw/status_cnc.csv",
           stringsAsFactors = F,
           h = T)

status_mma <-
  read.csv("data-raw/status_mma.csv",
           stringsAsFactors = F,
           h = T)

status_mma2022 <-
  read.csv("data-raw/status_mma_2022.csv",
           stringsAsFactors = F,
           h = T)

distribution <- ipt.files$data$distribution.txt

relationships <- ipt.files$data$resourcerelationship.txt

#relationships$relationshipOfResource <-
#  iconv(relationships$relationship, to = "windows-1252", from = "utf8")

relationships$relationshipOfResource <- relationships$relationship

species.profiles <- ipt.files$data$speciesprofile.txt

types <- ipt.files$data$typesandspecimen.txt

vernacular.names <- ipt.files$data$vernacularname.txt

binder <-
  function(taxonRank,
           phylum,
           order,
           class,
           family,
           genus,
           specificEpithet,
           infraspecificEpithet,
           scientificName,
           scientificNameAuthorship) {
    if (taxonRank == "CLASSE") {
      return(class)
    }
    if (taxonRank == "DIVISAO") {
      return(phylum)
    }
    if (taxonRank == "ESPECIE") {
      return(paste(genus, specificEpithet))
    }
    if (taxonRank == "FAMILIA") {
      return(family)
    }
    if (taxonRank == "FORMA") {
      return(paste(genus, specificEpithet, "fo.", infraspecificEpithet))
    }
    if (taxonRank == "GENERO") {
      return(genus)
    }
    if (taxonRank == "ORDEM") {
      return(order)
    }
    if (taxonRank == "SUB_ESPECIE") {
      return(paste(genus, specificEpithet, "subsp.", infraspecificEpithet))
    }
    if (taxonRank == "SUB_FAMILIA") {
      return(trim(gsub(
        "subfam\\.",
        "",
        strsplit(scientificName, scientificNameAuthorship)[[1]]
      )))
    }
    if (taxonRank == "TRIBO") {
      return(trim(strsplit(
        scientificName, scientificNameAuthorship
      )[[1]]))
    }
    if (taxonRank == "VARIEDADE") {
      return(paste(genus, specificEpithet, "var.", infraspecificEpithet))
    }
  }

searchStr <-
  mapply(
    binder,
    all.taxa$taxonRank,
    all.taxa$phylum,
    all.taxa$order,
    all.taxa$class,
    all.taxa$family,
    all.taxa$genus,
    all.taxa$specificEpithet,
    all.taxa$infraspecificEpithet,
    all.taxa$scientificName,
    all.taxa$scientificNameAuthorship
  )

all.taxa <-
  data.frame(all.taxa, searchStr, stringsAsFactors = FALSE)

names(all.taxa) <-
  c(
    "id",
    "scientific.name",
    "accepted.name",
    "parent.name",
    "published.in",
    "published.year",
    "higher.class",
    "kingdom",
    "phylum",
    "class",
    "order",
    "family",
    "genus",
    "specific.epiteth",
    "infra.epiteth",
    "taxon.rank",
    "authorship",
    "taxon.status",
    "name.status",
    "modified",
    "citation",
    "search.str"
  )

all.taxa$taxon.status <-
  gsub("NOME_ACEITO", "accepted", all.taxa$taxon.status)

all.taxa$taxon.status <-
  gsub("SINONIMO", "synonym", all.taxa$taxon.status)

all.taxa$search.str <- trim(all.taxa$search.str)
#all.taxa$search.str <- iconv(all.taxa$search.str, to = "windows-1252", from = "utf8")

all.taxa$name.status <-
  gsub("AINDA_DESCONHECIDO", "unknown", all.taxa$name.status)

all.taxa$name.status <-
  gsub("^NOME_CORRETO$", "correct", all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_CORRETO_VIA_CONSERVACAO",
       "correct via conservation",
       all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_ILEGITIMO", "ilegitimate", all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_LEGITIMO_MAS_INCORRETO",
       "legitimate, but incorrect, ",
       all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_MAL_APLICADO", "missapplied", all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_NAO_EFETIVAMENTE_PUBLICADO",
       "not published",
       all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_NAO_VALIDAMENTE_PUBLICADO",
       "not validly published",
       all.taxa$name.status)

all.taxa$name.status <-
  gsub("NOME_REJEITADO", "rejected", all.taxa$name.status)

all.taxa$name.status <-
  gsub("VARIANTE_ORTOGRAFICA",
       "orthographical variant",
       all.taxa$name.status)

all.taxa$taxon.rank <- gsub("CLASSE", "class", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("DIVISAO", "division", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("^ESPECIE$", "species", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("^FAMILIA$", "family", all.taxa$taxon.rank)

all.taxa$taxon.rank <- gsub("FORMA", "form", all.taxa$taxon.rank)

all.taxa$taxon.rank <- gsub("GENERO", "genus", all.taxa$taxon.rank)

all.taxa$taxon.rank <- gsub("ORDEM", "order", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("SUB_ESPECIE", "subspecies", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("SUB_FAMILIA", "subfamily", all.taxa$taxon.rank)

all.taxa$taxon.rank <- gsub("TRIBO", "tribe", all.taxa$taxon.rank)

all.taxa$taxon.rank <-
  gsub("VARIEDADE", "variety", all.taxa$taxon.rank)

all.taxa <-
  subset(
    all.taxa,
    select = -c(
      parent.name,
      modified,
      published.in,
      published.year,
      higher.class,
      citation,
      order,
      phylum,
      kingdom,
      class
    )
  )

names(distribution) <-
  c("id", "occurrence", "country", "establishment", "occremarks")

distribution <- subset(distribution, select = -c(country))

distribution <-
  aggregate(cbind(occurrence, establishment, occremarks) ~ id, distribution, function(x)
    paste(unique(x), collapse = "|"))

distribution$establishment  <-
  gsub("CULTIVADA", "cultivated", distribution$establishment)

distribution$establishment  <-
  gsub("NATIVA", "native", distribution$establishment)

distribution$establishment  <-
  gsub("NATURALIZADA", "naturalized", distribution$establishment)

names(relationships)  <- c("id", "related.id", "relationship")

relationships <- relationships[, 1:3]

names(species.profiles) <- c("id", "life.form", "habitat")

species.profiles <- species.profiles[, -3]

process <- function(x) {
  if (is.na(x)) {
    x <- list()
    x$lifeForm <- NA
    x$habitat <- NA
    x$vegetationType <- NA
  }
  else
  {
    x <- fromJSON(x)
    x$lifeForm <- paste(unique(x$lifeForm), collapse = "|")
    if (x$lifeForm == "")
      x$lifeForm <- NA
    x$habitat <- paste(unique(x$habitat), collapse = "|")
    if (x$habitat == "")
      x$habitat <- NA
    x$vegetationType <-
      paste(unique(x$vegetationType), collapse = "|")
    if (x$vegetationType == "")
      x$vegetationType <- NA
  }
  as.data.frame(x)
}

species.profiles <- species.profiles %>%
  mutate(life.form = map(life.form, process)) %>% unnest()

names(species.profiles) <-
  c("id", "life.form", "habitat", "vegetation.type")

process_dist <- function(x) {
  if (is.na(x)) {
    x <- list()
    x$endemism <- NA
    x$phytogeographicDomain <- NA
  }
  else
  {
    x <- fromJSON(x)
    if (is.null(x$endemism))
      x$endemism <- NA
    if (!is.na(x$endemism) & x$endemism == "")
      x$endemism <- NA
    x$phytogeographicDomain <-
      paste(unique(x$phytogeographicDomain), collapse = "|")
    if (x$phytogeographicDomain == "" |
        is.null(x$phytogeographicDomain))
      x$phytogeographicDomain <- NA
  }
  as.data.frame(x)
}

distribution <- distribution %>%
  mutate(occremarks = map(occremarks, process_dist)) %>% unnest()

names(distribution) <-
  c("id", "occurrence", "establishment", "endemism", "domain")

names(vernacular.names) <-
  c("id", "vernacular.name", "language", "locality")

collapsed.vernaculars <-
  apply(vernacular.names[-1], 1, paste, collapse = "/")

vernacular.names <-
  data.frame(vernacular.names[1], vernacular.name = collapsed.vernaculars)

vernacular.names <-
  aggregate(vernacular.name ~ id, vernacular.names, paste, collapse = " | ")

flora.url = "http://floradobrasil.jbrj.gov.br/jabot/listaBrasil/ConsultaPublicaUC/ResultadoDaConsultaCarregaTaxonGrupo.do?&idDadosListaBrasil="

words <- unique(unlist(strsplit(all.taxa$search.str, " ")))

words <- words[-which(words == "&")]

words <- words[-which(words == "ex")]

words <-
  c(words, "cf", "cf.", "aff", "aff.", "Indet.", "f.", "minor")

all.taxa <- all.taxa %>%
  left_join(status_cnc)

all.taxa <- all.taxa %>%
  left_join(status_mma)

all.taxa <- all.taxa %>%
  left_join(status_mma2022)

all.taxa.accepted <- subset(all.taxa, taxon.status == "accepted")

all.taxa.synonyms <- subset(all.taxa, taxon.status == "synonym")

all.taxa.undefined <- subset(all.taxa, is.na(taxon.status))

occurrences <- strsplit(distribution$occurrence, "\\|")

names(occurrences) <- distribution$id

distribution$occurrence <-
  unlist(lapply(lapply(
    strsplit(distribution$occurrence, "\\|"), sort
  ), paste, collapse = "|"))

usethis::use_data(
  all.taxa.undefined,
  all.taxa.accepted,
  all.taxa.synonyms,
  all.taxa,
  words,
  distribution,
  vernacular.names,
  relationships,
  species.profiles,
  flora.url,
  overwrite = TRUE,
  internal = TRUE,
  compress = 'xz'
)

plants <- c("Banisteriopsis paraguariensis", "Cassia caespitosa", "Eriocaulon bahiense", 
            "Parkya igneiflora", "Adipe longicornis", "Ardisia panurenses", 
            "Manettia pleiodon", "Cipocereus bradei", "Sporobolus purpurascens", 
            "Caesalpynia peltophoroides", "Protium laxiflorum", "Hypolytrum ceylanicum", 
            "Caladium picturatum var. lemaireanum", "Ouratea ovalis", "Cryptarrhena kegelii", 
            "Acer tataricum")

usethis::use_data(plants, overwrite = T)
