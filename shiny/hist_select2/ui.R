##-------------------------------------------
## ui.R

library(shiny)

fml <- names(X11Fonts())
fnt <- c("plain"=1, "bold"=2, "italic"=3, "bold-italic"=4)

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Histograma"),
        sidebarLayout(
            sidebarPanel(
                radioButtons(inputId="fml", 
                             label="Escolha a fonte:",
                             choices=fml, selected="serif"),
                radioButtons(inputId="fnt", 
                             label="Escolha a fonte:",
                             choices=fnt, selected=1)
            ),
            mainPanel(
                plotOutput("hist.reactive")
            )
        )
    )
)
