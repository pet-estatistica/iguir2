##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(function(input, output) {
    output$hist.reactive <- renderPlot({
        x <- precip
        ## Amplitude total aumentada.
        at <- extendrange(range(x), f=0.025)
        ## Classes.
        bks <- seq(from=at[1], to=at[2], length.out=input$cls+1)
        hist(x,
             col=rgb(
                 red=input$sr,
                 green=input$sg,
                 blue=input$sb),
             breaks=bks,
             main=NULL,
             ylab="Frequência absoluta",
             xlab="Precipitação")
        if(input$rg){
            rug(x)
        }
    })
})
