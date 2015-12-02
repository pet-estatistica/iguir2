##-------------------------------------------
## ui.R

library(shiny)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Delineamento Quadrado Latino"),
        sidebarLayout(
            sidebarPanel(
                numericInput(inputId="size",
                             label="Tamanho do Quadrado Latino:",
                             min=4, max=20,
                             step=1, value=5),
                checkboxInput(inputId="set", label="Fixar semente."),
                uiOutput("ui"),
                downloadButton("downloadData", "Download")
            ),
            mainPanel(
                plotOutput("plotRes")
            )
        )
    )
)
