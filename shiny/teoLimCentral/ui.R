##-------------------------------------------
## ui.R

require(shiny)

distX <- c("Uniforme discreta (5)"="UD5",
           "Uniforme Contínua (0,1)"="U01",
           "Exponencial (1)"="E1",
           "Poisson (5)"="Poi5",
           "Normal (0,1)"="N01",
           "Beta (0.5, 0.5)"="BetaA")
plotType <- c("Densidade empírica"="dens",
              "Frequência acumulada"="ecdf")

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        headerPanel("Distribuição amostral da média"),
        h4("Explore a convergência da distribuição amostral da média com as opções abaixo."),
        hr(),
        sidebarPanel(
            radioButtons(inputId="distX",
                         label="Distribuição de X:",
                         choices=distX),
            radioButtons(inputId="plotType",
                         label="Representação da distribuição amostral:",
                         choices=plotType)
        ),
        mainPanel(
            plotOutput("distBarX", width=500, height=400)
        )
    ))
