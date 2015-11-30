##-------------------------------------------
## ui.R

library(shiny)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Seja rápido!"),
        sidebarLayout(
            sidebarPanel(
                h5("Qual o resultado da soma?"),
                textOutput("expr"),
                uiOutput("uiRadio"),
                actionButton(inputId="goButton", label="Novo!"),
                hr(),
                actionButton(inputId="goResults", label="Resultados!")
            ),
            mainPanel(
                verbatimTextOutput("result"),
                plotOutput("plotRes")
            )
        )
    )
)
