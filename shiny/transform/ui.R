##-------------------------------------------
## ui.R

##=============================================================================
## Interface para exibição do gráfico de dispersão das variáveis dist e
## speed do conjunto data(cars), aplicando transformações nas variáveis
## e ajustando uma regressão linear simples. São abordados os seguintes
## widgets:
##    * Listbox
##    * Checkbox
##=============================================================================

library(shiny)

trans <- c("Identidade", "Quadrado", "RaizQuadrada", "Log10")

## Criando a Interface
shinyUI(fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

  titlePanel("Transformação de Variáveis"),
  sidebarLayout(
    sidebarPanel(width = 4,
      selectInput("tx", "Transformação em X", trans, 
                  multiple=TRUE, selectize=FALSE,
                  selected = "Identidade"),
      selectInput("ty", "Transformação em Y", trans, 
                  multiple=TRUE, selectize=FALSE,
                  selected = "Identidade"),
      checkboxInput(inputId="reg", 
                    label="Ajuste de Regressão Linear",
                    value=FALSE)
    ),
    mainPanel(width = 8,
      plotOutput("transformation")
    )
  )
))
