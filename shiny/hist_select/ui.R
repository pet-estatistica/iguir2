##-------------------------------------------
## ui.R

library(shiny)

nclass <- c("Sturges", "Scott", "Freedman-Diaconis")
obj <- c("precip","rivers","islands")

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Histograma"),
        sidebarLayout(
            sidebarPanel(
                selectInput(inputId="obj", 
                            label="Escolha o conjunto de dados:",
                            choices=obj),
                selectInput(inputId="nclass", 
                            label="Escolha a regra para número de classes:",
                            choices=nclass)
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
