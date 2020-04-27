require(rvest)
require(flora)
require(tidyverse)

families <- read_html("http://cncflora.jbrj.gov.br/portal/pt-br/listavermelha/") %>%
  html_nodes(".name") %>%
  html_text() %>%
  trimws()

grabber <- function(family) {
  print(family)
  fam_url = read_html(paste("http://cncflora.jbrj.gov.br/portal/pt-br/listavermelha/", family, sep = ""))
  
  species <- fam_url %>%
    html_nodes("#species a") %>%
    html_text() %>%
    trimws()
  
  threat <- fam_url %>%
    html_nodes(".category") %>%
    html_text() %>%
    trimws()
  
  list(family = rep(family, length(species)), species = species, threat = threat)
}

all_families <- bind_rows(sapply(families, grabber, simplify = F))

all_families$accepted_name <- get.taxa(all_families$species)$search.str

all_families <- all_families %>%
  mutate(synonym = accepted_name != species)

all_families <- all_families %>%
  group_by(accepted_name) %>%
  filter(!is.na(accepted_name)) %>%
  count() %>%
  ungroup() %>%
  right_join(all_families) %>%
  filter(!is.na(accepted_name)) %>%
  group_by(accepted_name) %>%
  mutate(threat = paste(threat, collapse = "|")) %>%
  ungroup() %>%
  bind_rows(filter(all_families, is.na(accepted_name))) %>%
  arrange(desc(n))

all_families %>%
  gather(accepted_name, species, key = accepted, value = search.str) %>%
  select(-n, -family, -synonym, -accepted) %>%
  distinct() %>%
  rename(threat.status = threat) %>%
  write.csv(file = "data-raw/status_cnc.csv", row.names = F)
