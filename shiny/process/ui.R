library(shiny)

shinyUI(
    fluidPage(
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
