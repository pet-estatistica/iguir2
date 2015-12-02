library(shiny)

apropos("Layout$", ignore.case=FALSE)
apropos("^fluid", ignore.case=FALSE)
apropos("Panel$", ignore.case=FALSE)

##----------------------------------------------------------------------
## sidebarLayout() com tabsetPanel().

# shinyUI(
#     fluidPage(
#         titlePanel("Título da aplicação"),
#         sidebarLayout(
#             sidebarPanel(
#                 sliderInput(inputId="A",
#                             label="Elemento A",
#                             min=0, max=1, step=0.1, value=0.5),
#                 radioButtons(inputId="B",
#                              label="Elemento B",
#                              choices=1:4),
#                 textInput(inputId="C",
#                           label="Elemento C",
#                           value="Um texto qualquer")
#             ),
#             mainPanel(
#                 tabsetPanel(
#                     tabPanel(title="Aba I",
#                              checkboxGroupInput(inputId="D",
#                                                 label="Elemento D",
#                                                 choices=1:5)),
#                     tabPanel(title="Aba II",
#                              dateRangeInput(inputId="E",
#                                             label="Elemento E")),
#                     position="right"
#                 )
#             )
#         )
#     ))

##----------------------------------------------------------------------
## splitLayout(), flowLayout() e fluidRow().

# shinyUI(
#     fluidPage(
#         titlePanel("Título da aplicação"),
#         splitLayout(
#             cellWidths=c("20%", "30%", "50%"),
#             # style="border: 1px solid silver;",
#             sliderInput(inputId="A",
#                         label="Elemento A",
#                         min=0, max=1, step=0.1, value=0.5),
#             radioButtons(inputId="B",
#                          label="Elemento B",
#                          choices=1:4),
#             textInput(inputId="C",
#                       label="Elemento C",
#                       value="Um texto qualquer")
#         ),
#         flowLayout(
#             numericInput(inputId="D",
#                          label="Número de cervejas", value=5),
#             selectInput(inputId="E",
#                         label="Qual cerveja?",
#                         choices=c("Skol", "Antartica", "Brahma")),
#             sliderInput(inputId="F",
#                         label="Que temperatura?",
#                         min=-6, max=5, value=0, step=0.5)
#         ),
#         fluidRow(
#             column(width=3,
#                    sliderInput(inputId="G",
#                                label="Tamanho da amostra",
#                                min=5, max=100, value=30, step=5),
#                    checkboxInput(inputId="H",
#                                  label="Com reposição?")
#             ),
#             column(width=4, offset=1,
#                    sliderInput(inputId="I", label="Média",
#                                10, 20, 15, 0.1),
#                    sliderInput(inputId="J", label="Variância",
#                                1, 7, 2, 0.1)
#             ),
#             column(width=2,
#                    textInput(inputId="L", label="Nome"),
#                    textInput(inputId="K", label="Email")
#             )
#         )
#     ))

##----------------------------------------------------------------------
## verticalLayout() e navlistPanel().

shinyUI(
    fluidPage(
        titlePanel("Título da aplicação"),
        verticalLayout(
            navlistPanel(
                tabPanel(title="Primeiro",
                         sliderInput(inputId="A",
                                     label="Elemento A",
                                     min=0, max=1, step=0.1, value=0.5),
                         radioButtons(inputId="B",
                                      label="Elemento B",
                                      choices=1:4)),
                tabPanel(title="Segundo",
                         textInput(inputId="C",
                                   label="Elemento C",
                                   value="Um texto qualquer"),
                         numericInput(inputId="D",
                                      label="Número de cervejas",
                                      value=5),
                         selectInput(inputId="E",
                                     label="Qual cerveja?",
                                     choices=c("Skol", "Antartica",
                                               "Brahma")),
                         sliderInput(inputId="F",
                                     label="Que temperatura?",
                                     min=-6, max=5, value=0, step=0.5)),
                tabPanel(title="Terceiro",
                         sliderInput(inputId="G",
                                     label="Tamanho da amostra",
                                     min=5, max=100, value=30, step=5),
                         checkboxInput(inputId="H",
                                       label="Com reposição?"),
                         sliderInput(inputId="I", label="Média",
                                     10, 20, 15, 0.1),
                         sliderInput(inputId="J", label="Variância",
                                     1, 7, 2, 0.1),
                         textInput(inputId="L", label="Nome"),
                         textInput(inputId="K", label="Email"))
            )
        )
    ))

##----------------------------------------------------------------------
## wellPanel() e tagList().
