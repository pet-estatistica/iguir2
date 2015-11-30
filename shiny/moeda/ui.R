##-------------------------------------------
## ui.R

require(shiny)
require(shinythemes)

shinyUI(
    fluidPage(
        ## theme = shinytheme("cerulean"),
        ## Cabeçalho IGUIR2
        htmlOutput("header"),
        
        titlePanel("Imite uma moeda"),
        
        sidebarLayout(
            sidebarPanel(
                ## Texto de ajuda e bloqueio (se nlanc < 20)
                p("Clique nos botões para declarar cara ou coroa"),
                uiOutput("bloqueio"),

                ## Botões para declarar cara ou coroa
                actionButton("goCara", "Cara",
                             icon = icon("fa fa-circle")),
                actionButton("goCoro", "Coroa",
                             icon = icon("fa fa-circle-o")),
                hr(),

                ## Número de lançamentos realizados
                HTML('<FONT size=-1.5>Número de lançamentos:</FONT>'),
                verbatimTextOutput("numx"),

                ## Sequência lançada pelo usuário
                HTML('<FONT size=-1.5>Sequência lançada (1=cara, 0=coroa): </FONT>'),
                verbatimTextOutput("seqx"),

                ## Botões para realizar o teste e recomeçar o jogo
                actionButton(inputId="goProcess",
                             label="Ver Resultado",
                             class="btn btn-info"),
                actionButton(inputId="clear",
                             label="Recomeçar",
                             class="btn btn-warning")
            ),

            mainPanel(
                ## Teste de hipóteses exibido graficamente
                plotOutput("hist")
            )
        )
    )
)
