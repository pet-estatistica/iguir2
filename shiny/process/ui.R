##-------------------------------------------
## ui.R

library(shiny)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Download do relatório"),
        sidebarLayout(
            sidebarPanel(
                selectInput(inputId="DATASET",
                            label="Escolha o conjunto de dados:",
                            choices=c("cars", "mtcars", "iris")),
                downloadButton(outputId="DOWNLOAD_PDF",
                               label="Download")
            ),
            mainPanel(
                tableOutput("TABLE")
            )
        )
    ))
