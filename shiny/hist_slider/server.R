##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

x <- precip

## Extremos com amplitude estendida em 5%
a <- extendrange(x, f=0.05)

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$hist.reactive <- renderPlot({
            bks <- seq(a[1], a[2], length.out=input$nclass+1)
            hist(x,
                 breaks=bks,
                 main=NULL,
                 col="#008A8A",
                 ylab="Frequência absoluta",
                 xlab="Precipitação")
        })
    })
