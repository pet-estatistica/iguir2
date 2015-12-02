##-------------------------------------------
## ui.R

library(shiny)

text <- "<div style=\"text-align:justify;
padding-left: 20px; padding-right: 20px\">
<p> Este aplicativo exemplifica de forma simples um ramo da Estatística
em que a localização espacial das observações é de suma importância, a 
Estatística Espacial.
</p>
<p>
O jogo consiste no objetivo de preencher o espaço ao lado com 20 pontos
de forma aletória. 
</p></div>
"

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),
        
        titlePanel("Pontos aleatórios"),

        sidebarLayout(
            sidebarPanel(
                ## Texto de apoio
                HTML(text),

                hr(),

                HTML('<FONT size=-1.5>Número de pontos:</FONT>'),
                verbatimTextOutput("npontos"),
                
                ## Botões para executar o teste e recomeçar o jogo
                actionButton(
                    inputId="result",
                    label="Ver Resultado",
                    class="btn btn-info"),
                actionButton(
                    inputId="clear",
                    label="Recomeçar",
                    class="btn btn-warning"),

                hr(),

                ## Seção de exemplos
                uiOutput("examples")

            ),
            
            mainPanel(
                plotOutput("plot1",
                           click = "plot_click")
            )
        )   
    )
)

