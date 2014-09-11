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
    
    links <- 
      paste("<a target=\"_blank\" href = \"http://floradobrasil.jbrj.gov.br/jabot/listaBrasil/FichaPublicaTaxonUC/FichaPublicaTaxonUC.do?id=FB", res$id, "\">", res$id,"</a>", sep = "")
    links <- gsub("FBNA", NA, links)
    out <- data.frame(id = links, res[-1])
    names(out) <- gsub("\\.", " ", names(out))
    out    
  }, options = list(bFilter = TRUE))
})