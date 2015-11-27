##-------------------------------------------
## ui.R

library(shiny)

shinyUI(fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

    titlePanel("Histograma"),
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId="sl",
                        label="Sugestão do número de classes:",
                        min=1,
                        max=20,
                        step=1,
                        value=10),
            textInput(inputId="html",
                      label="Especifique cor em formato html:",
                      value="FF0000"),
            checkboxInput(inputId="rg", 
                          label="Colocar rug?",
                          value=FALSE)
        ),
        mainPanel(
            plotOutput("hist.reactive")
        )
    )
))
