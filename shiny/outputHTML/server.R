##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")
require(xtable)

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$summaryAov <- renderPrint({
            m0 <- lm(Fertility~1+.,
                     data=swiss[,c("Fertility", input$variables)])
            print(xtable(anova(m0)), type="html")
        })
    })
