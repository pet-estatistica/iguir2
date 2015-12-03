library(shiny)

n <- length(list.files("www", pattern="\\.png$"))

shinyUI(
    fluidPage(
        titlePanel("Amostrador independente"),
        sidebarLayout(
            sidebarPanel(
                sliderInput(inputId="NUMBER",
                            label="Deslize:",
                            min=1, max=n, step=1, value=1,
                            animate=list(interval=1000))
            ),
            mainPanel(
                uiOutput("GIF")
            )
        )
    ))
