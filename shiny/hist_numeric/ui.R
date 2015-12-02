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
                numericInput(inputId="cexaxis", 
                             label="Tamanho do texto dos eixos:",
                             value=1, min=0.5, max=2, step=0.1),
                numericInput(inputId="line", 
                             label="Distância dos rótulos dos eixos:",
                             value=3, min=1, max=4, step=0.1),
                numericInput(inputId="mar", 
                             label="Tamanho do texto dos eixos:",
                             value=5, min=3, max=7, step=0.5)
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
