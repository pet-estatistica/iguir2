library(shiny)

shinyServer(
    function(input, output) {
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
