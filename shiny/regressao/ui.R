##-------------------------------------------
## ui.R

library(shiny)

text <- "<div style=\"text-align:justify;
padding-left: 20px; padding-right: 20px\">
<p> Este aplicativo exemplifica uma das técnicas mais utilizadas em
Estatística, a regressão linear simples.
</p>
<p>
O jogo consiste no objetivo traçar um reta, clicando em dois pontos
(um em cada extremidade em azul), que passe o mais perto possível de
todos os pontos. São apresentados exemplos de 5 áreas diferentes onde
esta técnica pode ser aplicada.
</p></div>
"

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Regressão Simples"),
        
        sidebarLayout(
            sidebarPanel(
                ## Texto de apoio
                HTML(text),

                hr(),
                
                ## Grandes áreas paara escolha
                selectInput(
                    "area", "Áreas",
                    c("Mercado Imobiliário", 
                      "Meteorologia",
                      "Segurança Veicular", 
                      "Relação Salarial",
                      "Mercado Automobilístico"),
                    multiple = FALSE,
                    selectize = FALSE,
                    selected = "Financeiro"),

                hr(),
                
                ## Botões para visualizar o modelo e recomeçar o jogo
                actionButton(inputId = "result",
                             label = "Ver Resultado",
                             class = "btn btn-info"),
                actionButton(inputId = "clear",
                             label = "Recomeçar",
                             class = "btn btn-warning"),

                hr(),
                
                ## Escolha do tipo de intervalo de confiança
                uiOutput("interval")
            ),
            
            mainPanel(
                plotOutput("plot", click = "plot_click")
            )
        )
    )
)
