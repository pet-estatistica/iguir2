##-------------------------------------------
## ui.R

require(shiny)

txt <- 
"Você consegue criar uma sequência de caras e coroas tão aleatória e com as
mesmas características propabilísticas de uma moeda equilibrada? Que tal
testarmos essa hipótese?"

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        headerPanel("Introdução aos testes de hipótese"),
        h4("Você consegue imitar uma moeda?"),
        p(txt),
        hr(),
        
        sidebarPanel(
            helpText("Clique nos botões para declarar cara ou coroa."),
            actionButton("goCara", "Cara"),
            actionButton("goCoro", "Coroa"),
            h6("Número de lançamentos feitos:"),
            verbatimTextOutput("nlanc"),
            actionButton("goProcess", "Aplicar teste de hipótese!"),
            actionButton("clear", "Recomeçar"),
            h6("Sequência das faces observadas (1=cara, 0=coroa):"),
            verbatimTextOutput("seqx"),
            checkboxInput(
                "teorico", "Valores teóricos: Binomial(n-1, p=0.5)")
        ),

        
        mainPanel(
            plotOutput("hist", width=500, height=500)
        )
    ))
