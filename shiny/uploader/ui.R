library(shiny)

## Path do arquivo css.
css <- ifelse(Sys.info()["nodename"]=="academia",
              yes="../palatino.css",
              no="/home/walmes/Dropbox/shiny/palatino.css")

shinyUI(
    fluidPage(
        includeCSS(css),
        ## Cabeçalho IGUIR2
        htmlOutput("header"),
        titlePanel("Suba o seu arquivo"),
        sidebarLayout(
            sidebarPanel(
                helpText("Forceça apenas os 8 digitos, ex: 20129999."),
                textInput(inputId="grr", label="Forneça o seu GRR:", value=""),
                radioButtons(inputId="turma", label="Turma:",
                             choices=c("ce083-2015-01",
                                       "ce063-2015-01",
                                       "ce213-2015-01")),
                radioButtons(inputId="trab", label="Trabalho número:",
                             choices=c(as.character(1:5))),
                fileInput(inputId="file", label="Selecione o arquivo",
                          accept=c("application/x-rar-compressed",
                                   "application/octet-stream",
                                   "application/zip",
                                   "application/octet-stream")),
                submitButton("Upload")
            ),
            mainPanel(
                tabsetPanel(
                    id='result',
                    tabPanel(title='Mais recentes',
                             htmlOutput('table')
                    ),
                    tabPanel(title='Todos',
                             textOutput('contents'),
                             htmlOutput('html')
                    )
                )
            )
        )
    )
)


