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
                textInput(inputId="main", 
                          label="Texto para o título:",
                          value=""),
                textInput(inputId="sub", 
                          label="Texto para o subtítulo:",
                          value="")
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
