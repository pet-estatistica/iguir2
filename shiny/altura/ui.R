##-------------------------------------------
## ui.R

library(shiny)

shinyUI(
    fluidPage(
        htmlOutput("header"),

        titlePanel("Estimando Alturas"),

        sidebarLayout(
            sidebarPanel(
                ## Exibe as perguntas
                uiOutput("uiRadio"),
                
                ## Transição entre perguntas
                uiOutput("go"),
                
                br(),
                
                ## Ver resultado e recomeçar
                uiOutput("uiResult")),

            mainPanel(
                ## Gráfico normal de probabilidade para a altura do
                ## participante 
                plotOutput("plotRes")
            )
        )
    )
)
