##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

ht <- hist(precip, plot = FALSE)

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$hist.reactive <- renderPlot({
            input$acao
            col <- sample(colors(), size=1)
            plot(ht, main=NULL,
                 ylab="Frequência absoluta", xlab="Precipitação",
                 col=col, sub=col)
        })
    })
