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
                sliderInput(inputId="nclass",
                            label="Número de classes:",
                            min=1,
                            max=30,
                            step=1,
                            value=10)
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
