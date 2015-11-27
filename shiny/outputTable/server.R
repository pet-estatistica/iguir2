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
        output$mtcarsTable <- renderDataTable({
            mtcars[,input$variables]
        },
        options=list(orderClasses=TRUE))
    })

