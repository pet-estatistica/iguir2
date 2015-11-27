##-------------------------------------------
## ui.R

library(shiny)

shinyUI(fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

    titlePanel("Histograma"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId="cls",
                        label="Número de classes:",
                        min=1, max=20, step=1, value=10),
            sliderInput(inputId="sr", label="R:",
                        min=0, max=1, step=0.05, value=0.5),
            sliderInput(inputId="sg", label="G:",
                        min=0, max=1, step=0.05, value=0.5),
            sliderInput(inputId="sb", label="B:",
                        min=0, max=1, step=0.05, value=0.5),
            checkboxInput(inputId="rg", 
                          label="Colocar rug?",
                          value=FALSE)
        ),
        mainPanel(
            plotOutput("hist.reactive")
        )
    )
))
