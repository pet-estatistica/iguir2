##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$summaryLm <- renderPrint({
            m0 <- lm(Fertility~1+.,
                     data=swiss[,c("Fertility", input$variables)])
            summary(m0)
        })
    })
