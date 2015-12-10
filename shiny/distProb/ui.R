require(shiny)

choi <- c("Poisson"="poisson",
          "Binomial"="binomial",
          "Beta"="beta",
          "Gamma"="gamma",
          "Normal"="normal")

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Distribuições de probabilidade"),
        sidebarPanel(
            selectInput(inputId="dist",
                        label="Distribuição",
                        choices=choi),
            uiOutput("ui"),
            
            uiOutput("OptsMedia")
        ),
        mainPanel(
            tabsetPanel(
                id = "tab", 
                tabPanel("Distribuição", 
                         plotOutput("plot")),
                tabPanel("Distribuição Amostral da Média",
                         uiOutput("grafsMedia")
                         )
            )
        )
    )
)