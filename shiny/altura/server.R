##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

text <- " <div style=\"text-align:justify;
padding-left: 20px; padding-right: 20px\">
<p> Este aplicativo faz uso da teoria de resposta ao item (TRI) e 
este mesmo estudo foi elaborado inicialmente pelos professores
Adilson do Anjos (UFPR) e Dalton F. de Andrade (UFSC) e descrito 
no <a href = http://www.ufpa.br/heliton/arquivos/tri/RTRIsinape.pdf>
material do 20º SINAPE</a>.</p>
<p>
O jogo consiste no objetivo de estimar sua altura. Você deve responder à
14 perguntas dicotômicas (sim ou não) e ao final teremos uma estimativa
intervalar de sua altura.
</p></div>"

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        
        ## Valores que armazenam as respostas do usuário
        v <- reactiveValues(x = 0, res = vector("integer", len = 14))
        
        ## Responde a estímulos no `input$go`.
        observeEvent(input$go, {
            v$x <- v$x + 1
        })

        ## Responde a estímulos no `input$return`.
        observeEvent(input$return, {
            v$x <- v$x - 1
        })
        
        ## Responde a estímulos no `input$clear`.
        observeEvent(input$clear, {
            v$x <- 1
        })
        
        ## Constrói o vetor de resposta do usuário
        observe({
            if(!is.null(input$radio)){
                v$res[v$x] <- ifelse("sim" == input$radio, 1, 0)
            }
        })

        ## Gera o `radioInput()` para as escolhas sim ou não e
        ## estímulo do `input$go` para iniciar a rodada de perguntas
        output$uiRadio <- renderUI({
            if(v$x < 1 ){
                return(
                    tagList(
                        HTML(text),
                        column(width = 2, offset = 4,
                               actionButton(
                                   inputId = "go", label = "Começar",
                                   class = "btn btn-success",
                                   icon = icon("fa fa-play"))
                               )
                    )
                )
            }
            if(v$x > 0 & v$x < 15){
                return(
                    radioButtons(inputId = "radio", 
                                 label = pergunta[v$x],
                                 choices = c("sim", "não"),
                                 selected = "",
                                 inline = TRUE)
                )
            }
        })

        ## Cria os botões para visualizar os resultados e recoeçar o
        ## jogo ao final das perguntas
        output$uiResult <- renderUI({
            if(v$x > 14){
                return(
                    tagList(
                        actionButton(
                            inputId = "result",
                            label = "Ver Resultado",
                            class = "btn btn-info"),
                        actionButton(
                            inputId = "clear",
                            label = "Recomeçar",
                            class = "btn btn-warning")
                    )
                )
            } else return()
        })

        ## Botões para transição entre perguntas
        output$go <- renderUI({
            if(v$x == 1){
                return(
                    actionButton(
                        inputId = "go", label = "Próxima",
                        icon = icon("fa fa-arrow-right"))
                )
            }
            if(v$x > 1 & v$x < 15){
                return(
                    tagList(
                        actionButton(
                            inputId = "return", label = "Anterior",
                            icon = icon("fa fa-arrow-left")),
                        actionButton(
                            inputId = "go", label = "Próxima",
                            icon = icon("fa fa-arrow-right"))
                    )
                )
            }
        })

        ## Constrói o gráfico de densidade estimado da altura do usuário 
        output$plotRes <- renderPlot({
            if(length(input$result) == 0){
            } else {
                if(input$result & v$x == 15){
                    curve.pred(v$res[-15])
                }
            }
        })
    })

