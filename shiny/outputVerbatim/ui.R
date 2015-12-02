##-------------------------------------------
## ui.R

require(shiny)

choi <- names(swiss)[-1]

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Regressão múltipla"),
        sidebarPanel(
            checkboxGroupInput(inputId="variables",
                               label="Selecione as variáveis independentes:",
                               choices=choi,
                               selected=choi[1:2])
        ),
        mainPanel(
            verbatimTextOutput("summaryLm")
        )
    )
)