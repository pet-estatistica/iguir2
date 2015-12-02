##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$hist.reactive <- renderPlot({
            L <- switch(input$obj,
                        precip=list(x=precip, xlab="Precipitação anual média (polegadas)"),
                        rivers=list(x=rivers, xlab="Comprimento dos rios (milhas)"),
                        islands=list(x=islands, xlab="Área de ilhas (1000 milhas quadradas)"))
            hist(L$x,
                 breaks=input$nclass,
                 col="#8F0047",
                 main=NULL,
                 ylab="Frequência absoluta",
                 xlab=L$xlab)
            rug(L$x)
        })
    })
