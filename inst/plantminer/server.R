library(shiny)
library(flora)
ex <- get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"))
shinyServer(function(input, output) {
  output$contents <- renderDataTable({
    if (input$taxa == "Miconia albicans\nMyrcia lingua\nCofea arabica" & input$synonyms & input$suggest) {
      res <- ex
    } else {
      x <- unlist(strsplit(input$taxa, "\n"))
      res <- get.taxa(x, 
                      replace.synonyms = input$synonyms, 
                      suggest.names = input$suggest, 
                      life.form = input$life.form, 
                      habitat = input$habitat, 
                      vernacular = input$vernacular, 
                      states = input$states, 
                      establishment = input$establishment,
                      suggestion.distance = input$distance)
    }
    output$downloadData <- downloadHandler(
      filename = "results.csv",
      content = function(file = filename) {      
        # Write to a file specified by the 'file' argument
        write.csv(res, file,
                  row.names = FALSE, quote = TRUE)
      }
    )
    
    links.flora <- 
      paste("<a target=\"_blank\" href = \"http://floradobrasil.jbrj.gov.br/jabot/listaBrasil/FichaPublicaTaxonUC/FichaPublicaTaxonUC.do?id=FB", res$id, "\">", "FloraBR","</a>", sep = "")
    #links.flora <- gsub("FBNA", NA, links.flora)
    links.flora[grep("NA", links.flora)] <- ""
    links.splink <- 
      paste("<a target=\"_blank\" href = \"http://www.splink.org.br/search?sciname=", res$search.str, "\">", "spLink","</a>", sep = "")
    links.splink[grep("NA", links.splink)] <- ""
    out <- data.frame(link.out = paste(links.flora, "<br/>", links.splink), res[-1])
    names(out) <- gsub("\\.", " ", names(out))
    out
  }, options = list(bFilter = TRUE))
})