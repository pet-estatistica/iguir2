##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

x <- precip

ht <- hist(x)
col <- rep("#3366CC", length(ht$counts))

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$hist.reactive <- renderPlot({
            if(input$modal){
                col[which.max(ht$counts)] <- "#142952"
            }
            plot(ht, col=col, main=NULL,
                 ylab="Frequência absoluta",
                 xlab="Precipitação")
            if(input$rg){
                rug(x)
            }
        })
    })
