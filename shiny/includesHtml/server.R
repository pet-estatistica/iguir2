##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output) {
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$TEXT <- renderPrint(
            cat(paste0(
                '<style> p { line-height: ',
                input$HEIGHT,
                'pt; } </style>',
                '<p><font face="',
                input$FONT,
                '" font color="',
                input$COLOR,
                '">Aqui temos um texto qualquer que muda de cor!',
                '</font></p>',
                '<p><font color="',
                input$COLOR,
                '">Esse aqui também muda.</font></p>')
            )
        )
    })
