##-------------------------------------------
## ui.R

library(shiny)

ui <- fluidPage(
	## Cabeçalho IGUIR2
    htmlOutput("header"),

    includeCSS("invisible_slider.css"),
    
    sidebarLayout(
        sidebarPanel(
            h4("Escala de avaliação"),

            hr(),
            
            textInput("avaliador", "Seu Nome", ""),

            selectInput("produto", "Produto Avaliado",
                        choices = paste0("arvore", 0:10)),

            hr(),
            
            plotOutput("escala", height = "50px"),

            sliderInput("nota", "",
                        min = 1, max = 9, value = 5, step = 0.01,
                        ticks = FALSE),

            hr(),
            
            uiOutput("buttons"),

            hr()
        ),

        mainPanel(
            verbatimTextOutput("resp")
        )
    )
)
