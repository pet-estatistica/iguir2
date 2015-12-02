library(shiny)

ds <- c("swiss", "cars", "longley", "iris", "rock")

shinyUI(fluidPage(
    titlePanel("Regressão Polinomial"),
    p("CE 064 - Ferramentas para documentos dinâmicos reproduzíveis - 2015/2"),
    hr(),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId="DATASET",
                        label="Escolha o conjunto de dados:",
                        choices=ds,
                        selected="swiss"),
            selectInput(inputId="Y",
                        label="Variável dependente:",
                        choices=names(swiss),
                        selected=names(swiss)[1]),
            selectInput(inputId="X",
                        label="Variável independente:",
                        choices=names(swiss),
                        selected=names(swiss)[2]),
            numericInput(inputId="DEGREE",
                         label="Grau do polinômio:",
                         min=1, max=5, value=1, step=1),
            checkboxInput(inputId="TRANSFORM",
                          label="Transformar Y?"),
            conditionalPanel("input.TRANSFORM",
                             radioButtons(inputId="TRANSFUN",
                                          label="Escolha a transformação:",
                                          choices=c("sqrt", "log"),
                                          selected="sqrt"))
        ),
        mainPanel(
            tabsetPanel(
                tabPanel(title="Ajuste...",
                         h3("Valores observados e modelo ajustado"),
                         plotOutput("AJUSTE")),
                tabPanel(title="Estimativas...",
                         h3("Medidas de ajuste e estimativas dos parâmetros"),
                         verbatimTextOutput("ANOVA_SUMMARY")),
                tabPanel(title="Resíduos...",
                         h3("Gráficos para diagnóstico do ajuste"),
                         plotOutput("RESIDUOS")),
                tabPanel(title="Influência...",
                         h3("Medidas de influência"),
                         # dataTableOutput("INFLUENCE")
                         tableOutput("INFLUENCE")
                         ))
        )
    )
))
