library(markdown)

# http://www.w3schools.com/cssref/tryit.asp?filename=trycss_line-height

shinyUI(
    fluidPage(
    titlePanel("Título da aplicação"),
    navlistPanel(
        tabPanel(title="A",
                 includeText("include.txt")),
        tabPanel(title="B",
                 pre(includeText("include.txt"))),
        tabPanel(title="C",
                 includeHTML("include.html")),
        tabPanel(title="D",
                 includeMarkdown("include.md")),
        tabPanel(title="E",
                 verticalLayout(
                     selectInput(inputId="COLOR", label="Cor:",
                                 choices=c("red", "blue", "green")),
                     selectInput(inputId="FONT", label="Fonte:",
                                 choices=c("verdana", "times",
                                           "ubuntu")),
                     sliderInput(inputId="HEIGHT", label="Espaçamento:",
                                 min=0.25, max=50, value=1, step=0.25),
                     htmlOutput("TEXT")
                 ))
    )
))
