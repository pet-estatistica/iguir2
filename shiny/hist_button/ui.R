##-------------------------------------------
## ui.R

library(shiny)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Histograma"),
        sidebarLayout(
            sidebarPanel(
                actionButton(inputId="acao", label="Nova cor!")
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
