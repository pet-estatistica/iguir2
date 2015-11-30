##-------------------------------------------
## ui.R

library(shiny)

choi <- c("Construção e ajuste"="grepl",
          "Procura e substituição"="gsub")

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Construidor de expressões regulares"),
        sidebarPanel(
            radioButtons(inputId="regexjob",
                        label="Uso de expressão regular",
                        choices=choi),
            uiOutput("ui")
        ),
        mainPanel(
            textOutput("text")
        )
    )
)