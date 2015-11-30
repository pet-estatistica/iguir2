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
        output$ui <- renderUI({
            switch(input$regexjob,
                   "grepl"={
                       output$text <- renderText({
                           grepl(x=as.character(input$string),
                                 pattern=as.character(input$pattern))
                       })
                       wellPanel(
                           textInput(inputId="string",
                                     label="Termo:"),
                           textInput(inputId="pattern",
                                     label="Padrão REGEX:")
                       )
                   },
                   "gsub"={
                       output$text <- renderText({
                           gsub(x=as.character(input$string),
                                pattern=as.character(input$pattern),
                                replacement=as.character(input$replacement))
                       })
                       wellPanel(
                           textInput(inputId="string",
                                     label="Termo:"),
                           textInput(inputId="pattern",
                                     label="Padrão REGEX de busca:"),
                           textInput(inputId="replacement",
                                     label="Padrão REGEX de substituição:")
                       )
                   }
            )
        })
    })
