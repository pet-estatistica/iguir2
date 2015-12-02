##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(function(input, output) {
    output$hist.reactive <- renderPlot({
        x <- precip
        hist(x,
             col=paste0("#", input$html),
             breaks=input$sl,
             main=NULL,
             ylab="Frequência absoluta",
             xlab="Precipitação")
        if(input$rg){
            rug(x)
        }
    })
})
