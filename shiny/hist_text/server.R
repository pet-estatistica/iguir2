##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

x <- precip
ht <- hist(x, plot = FALSE)

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$hist.reactive <- renderPlot({
            plot(ht, col="#006666",
                 ylab="Frequência absoluta",
                 xlab="Precipitação",
                 main=input$main,
                 sub=input$sub)
        })
    })
