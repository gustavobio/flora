library(shiny)
library(flora)
library(shinydashboard)
library(DT)

# Paragraphs
# Don't think I need to paste text here

p_suggestion <- p(
  paste("How conservative the name guessing should be?",
        "Lower values are less conservative and may result in",
        "incorrect suggestions.")
)
p_lifeform <- p(
  
)
p_results <- p(
  "Columns might be automatically removed from display to",
  "fit the width of your screen. IDs are links to taxa on the",
  tags$a("Brazilian Flora 2020 website",
         href = "http://floradobrasil.jbrj.gov.br/jabot/listaBrasil/PrincipalUC/PrincipalUC.do"
  ),
  ", which is the source of all data used here. Please cite them accordingly.",
  "Threat statuses are determined by",
  tags$a("CNC Flora", href = "http://cncflora.jbrj.gov.br"),
  "and follow the IUCN convention.",
  tags$strong("Dataset last updated on 8th Jan 2021"), tags$br(),tags$br()
)


p_lab <- p(tags$strong("Gustavo Carvalho"), tags$br(), "gustavo.bio@gmail.com", align = "center")
header <- dashboardHeader(title = "Plantminer")


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Select a database:"),
    menuItem("Brazilian Flora 2020", tabName = "flora", icon = icon("leaf")),
    menuItem("API & About the data", tabName = "data", icon = icon("question")),
    menuItem("Source code on Github", icon = icon("file-code-o"),
             href = "http://github.com/gustavobio/plantminer/"),
    sidebarUserPanel("Gustavo Carvalho",
                     image = "https://avatars2.githubusercontent.com/u/30267?v=3&s=460",
                     subtitle = tags$a("Profile on Github", href = "http://www.github.com/gustavobio")
    )
  )
)
body <- dashboardBody(
  tabItems(
    tabItem(
      ## Brazilian Flora UI
      tabName = "flora",
      h4("Brazilian Flora 2020 - ",
         tags$a("Flora R package", href = "http://github.com/gustavobio/flora"),
         "frontend"
      ),
      fluidRow(
        column(width = 3,
               box(title = "1. Name options", width = NULL, collapsible = TRUE,
                   checkboxInput("synonyms", label = "Replace synonyms", value = TRUE),
                   checkboxInput("suggest", label = "Correct misspelled names", value = TRUE),
                   checkboxInput("parse", label = "Remove authors (slow)", value = FALSE),
                   p_suggestion,
                   sliderInput("distance", label = "",
                               min = 0.7, max = 1, value = 0.9, animate = TRUE)),
               box(title = "2. Life form & more", width = NULL, collapsible = TRUE, collapsed = FALSE,
                   p_lifeform,
                   checkboxInput("life.form", label = "Life form", value = FALSE),
                   checkboxInput("habitat", label = "Habitat", value = FALSE),
                   checkboxInput("vegetation.type", label = "Vegetation type", value = FALSE),
                   checkboxInput("states", label = "Occurrence", value = FALSE),
                   checkboxInput("vernacular", label = "Show common names", value = FALSE),
                   checkboxInput("establishment", label = "Establishment", value = FALSE),
                   checkboxInput("domain", label = "Domain", value = FALSE)),
               box(title = "3. Paste your taxa without authors (or select 'Remove authors')", width = NULL, solidHeader = TRUE, collapsible = TRUE,
                   tags$form(
                     tags$textarea(id = "taxa", rows= 8 , cols = 21,
                                   "Miconia albicans\nMyrcia lingua\nFabaceae sp.1"
                     ),
                     tags$br(),
                     submitButton(text = "Process list")))),
        column(width = 9,
               box(title = "4. Processed taxa", width = NULL,
                   p_results,
                   DT::dataTableOutput(outputId="contents")),
               box(title = "5. Download", width = NULL, collapsible = TRUE, collapsed = FALSE,
                   # p("The files linked below have columns separated by commas, semicolons, or tabulations.
                   #  All of them can be opened in virtually any spreadsheet and statistical software.
                   #  The phylomatic taxa file is used with", tags$a("Phylomatic", href = "http://phylodiversity.net/phylocom/"), "to generate a phylogenetic tree.
                   #  Taxa Plantminer couldn't match against the database are ommited from this file, but not from the others."),
                   #  fluidRow(
                   #  valueBoxOutput("stats.found", width = 2),
                   #  valueBoxOutput("stats.notfound", width = 2),
                   #  valueBoxOutput("stats.synonyms", width = 2),
                   #  valueBoxOutput("stats.misspeled", width = 2),
                   #  valueBoxOutput("stats.total", width = 1)
                   # ),
                   downloadButton('downloadDataCsv', 'Comma-delimited'),
                   downloadButton('downloadDataCsv2', 'Semicolon-delimited'),
                   downloadButton('downloadDataTab', 'Tab-delimited'),
                   downloadButton('downloadDataPhylomatic', 'Phylomatic taxa')
               ),
               p_lab
        )
      )),
    ## The Plant List UI
    tabItem(
      tabName = "data",
      h2("Brazilian Flora 2020 Checklist"),
      h3("API call"),
      p("Use the /flora method to GET request a taxon using the `taxon` querystring:"),
      tags$a("http://www.plantminer.com/flora?taxon=Coffea%20arabica",
             href = "http://www.plantminer.com/flora?taxon=Coffea%20arabica"),
      p("The response is always a json object, even if there is no match."),
      h3("Fields"),
      h4("id"),
      p("Taxon id in the Brazilian Flora Checklist."),
      h4("scientific name"),
      p("Full name with authors"),
      h4("original search"),
      p("Character string supplied by the user and matched against the database."),
      h4("search str"),
      p("Character string used internally to query the database.
        If the user entered a misspelled name and a suggestion could be made,
        this will not match the original search."),
      h4("taxon status"),
      p("Taxonomical status. Possible values are as follows:"),
      tags$ul(
        tags$li("accepted"),
        tags$li("synonym")
      ),
      h4("notes"),
      p("Notes about a taxon. Empty string if there is nothing to report. Otherwise,
        possible values are as follows:"),
      tags$ul(
        tags$li("`not found`, if a name was not found."),
        tags$li("`was misspelled`, if a name was misspelled."),
        tags$li("`replaced synonym`, if a name was a synonym and was replaced by an accepted name."),
        tags$li("`check no accepted name` if a synonym is not linked to a accepted name."),
        tags$li("`check no accepted +1 synonyms` if a supplied taxon matches several names listed
                as synonyms and none are linked to an accepted name."),
        tags$li("`check +1 accepted` if a synonym is linked to two or more accepted names."),
        tags$li("`check +1 entries` if a supplied taxon matches several entries in the database."),
        tags$li("`check undefined status` if a name is neither accepted or a synonym according to the data.")
      ),
      p("Multiple notes are separated with a `|`"),
      h4("taxon rank"),
      p("Taxonomical rank of the user supplied taxon. Possible values are:"),
      tags$ul(
        tags$li("`family`"),
        tags$li("`genus`"),
        tags$li("`species")
      ),
      h4("family"),
      p("Taxon family according to the Brazilian Flora Checklist"),
      h4("threat status"),
      p("Taxon threat status according to CNC Flora 2013. Statuses follow the IUCN convention."),
      h2("The Plant List"),
      h3("API call"),
      p("Use the /tpl method to GET request a taxon using the `taxon` querystring:"),
      tags$a("http://www.plantminer.com/tpl?taxon=Coffea%20arabica",
             href = "http://www.plantminer.com/tpl?taxon=Coffea%20arabica"),
      p("The response is always a json object, even if a match couldn't be made."),
      h3("Fields"),
      h4("id"),
      p("Taxon id in The Plant List"),
      h4("family"),
      p("Taxon family according to The Plant List. There is an option to return APG families instead."),
      h4("genus"),
      p("Taxon genus"),
      h4("species"),
      p("Specific epiteth"),
      h4("infraspecific rank"),
      p("Taxon infraspecific rank"),
      h4("infraspecific epithet"),
      p("Taxon infraspecific epithet"),
      h4("authorship"),
      p("Taxon author(s)"),
      h4("taxonomic status in tpl"),
      p("Taxon status according to The Plant List. Possible values are:"),
      tags$ul(
        tags$li("`Accepted`"),
        tags$li("`Synonym`")
      ),
      h4("confidence level"),
      p("Status confidence level. Possible values are:"),
      tags$ul(
        tags$li("`H`: high confidence"),
        tags$li("`M`: medium confidence"),
        tags$li("`L`: low confidence")
      ),
      h4("source"),
      p("Source of the data. Please check their website for a list of all possible sources and how to cite them."),
      h4("accepted id"),
      p("id of the accepted name of a taxon in The Plant List. Return only if the user chooses not to automatically replace synonyms."),
      h4("name"),
      p("Taxon name without authors."),
      h4("note"),
      p("Notes about the taxon matching. Possible values are:"),
      tags$ul(
        tags$li("`not found`, if a name was not found."),
        tags$li("`was misspelled`, if a name was misspelled."),
        tags$li("`replaced synonym`, if a name is listed as a synonym and an accepted name was found.")
      ),
      p("Multiple notes are separated with a `|`"),
      h4("original search"),
      p("The user supplied character string.")
    )
  )
)
ui <- fluidPage(dashboardPage(skin = "blue", header, sidebar, body))
server <- function(input, output) {
  ##
  ## Brazilian flora server side
  ##
  
  process.taxa <- reactive({
    user.taxa <- trimws(unlist(strsplit(input$taxa, "\n")))
    user.taxa <- user.taxa[user.taxa != ""]
    processed.list <- list()
    withProgress(message = "Performing search", value = 0, min = 0, max = length(user.taxa), {
      for (i in 1:length(user.taxa)) {
        processed.list[[i]] <- get.taxa(user.taxa[i],
                                        replace.synonyms = input$synonyms,
                                        suggest.names = input$suggest,
                                        life.form = input$life.form,
                                        habitat = input$habitat,
                                        vegetation.type = input$vegetation.type,
                                        vernacular = input$vernacular,
                                        states = input$states,
                                        establishment = input$establishment,
                                        suggestion.distance = input$distance,
                                        parse = input$parse,
                                        domain = input$domain)
        incProgress(1, detail = paste(i, "of", length(user.taxa)))
      }
    })
    processed.list <- do.call("rbind.data.frame", processed.list)
    # if (input$domain) {
    #   processed.list <- get_domains(processed.list)
    # }
    links.flora <-
      paste("<a target=\"_blank\" href = \"http://floradobrasil.jbrj.gov.br/reflora/listaBrasil/FichaPublicaTaxonUC/FichaPublicaTaxonUC.do?id=FB",
            processed.list$id, "\">", processed.list$id,"</a>", sep = "")
    links.flora <- gsub("FBNA", NA, links.flora)
    out <- data.frame(id = links.flora, processed.list[, -c(1, 3)])
    first.columns <- c("id", "scientific.name", "original.search", "search.str", "taxon.status", "notes", "taxon.rank")
    other.columns <- names(out)[!names(out) %in% first.columns]
    out <- out[c(first.columns, other.columns)]
    names(out) <- gsub("\\.", " ", names(out))
    output$downloadDataCsv <- downloadHandler(
      filename = "results.csv",
      content = function(file = filename) {
        write.csv(processed.list, file,
                  row.names = FALSE, quote = TRUE)
      }
    )
    output$downloadDataCsv2 <- downloadHandler(
      filename = "results.csv",
      content = function(file = filename) {
        write.csv2(processed.list, file,
                   row.names = FALSE, quote = TRUE)
      }
    )
    output$downloadDataTab <- downloadHandler(
      filename = "results_tab.txt",
      content = function(file = filename) {
        write.table(processed.list, file,
                    row.names = FALSE, quote = TRUE)
      }
    )
    output$downloadDataPhylomatic <- downloadHandler(
      filename = "results_phylomatic.txt",
      content = function(file = filename) {
        cat(df2phytaxa(processed.list), file = file, sep = "\n")
      }
    )
    out
  })
  values <- reactiveValues()
  observe({values$out <- process.taxa()})
  output$contents <- DT::renderDataTable(values$out
                                         , extensions = c('Responsive', 'ColReorder'), options = list(dom = 'Rlfrtip', deferRender = TRUE), escape = 1)
}
shinyApp(ui, server)