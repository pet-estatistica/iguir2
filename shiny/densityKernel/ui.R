##-------------------------------------------
## ui.R

library(shiny)

kernels <- eval(formals(density.default)$kernel)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Gráfico de densidade Kernel"),
        sidebarLayout(
            sidebarPanel(
                radioButtons(inputId="KERNEL",
                             label="Escolha a função kernel:",
                             choices=kernels,
                             selected=sample(x=kernels, size=1)),
                checkboxInput(inputId="DRAW_RUG",
                              label="Colocar o 'rug':",
                              value=TRUE),
                textInput(inputId="CURVE_COLOR",
                          label="Cor da linha:",
                          value="black"),
                sliderInput(inputId="WIDTH",
                            label="Largura de banda:",
                            min=5, max=70, value=10, step=1),
                sliderInput(inputId="CENTER",
                            label="Valor de referência:",
                            min=7, max=67, value=30, step=1)
            ),
            mainPanel(
                plotOutput("PLOT_DENSITY")
            )
        )
    ))
