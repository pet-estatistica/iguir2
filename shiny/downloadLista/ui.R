##-------------------------------------------
## ui.R

require(shiny)

choi <- setdiff(x=list.files(pattern="\\.Rnw$"),
                y=c("exercGRR.Rnw", "00template.Rnw"))
choi <- gsub(x=choi, pattern="\\.Rnw$", replacement="")

shinyUI(
    fluidPage(
        ## Cabeçalho IGUIR2
        htmlOutput("header"),

        titlePanel("Baixe sua lista de exercícios"),
        verticalLayout(
            textInput(inputId="GRR",
                      label="Informe seu GRR (8 números):"),
            checkboxGroupInput(inputId="EXER",
                               label="Selecione os exercícios:",
                               choices=choi),
            passwordInput(inputId="PASSWD",
                          label="Digite a senha para incluir gabarito:",
                          value=""),
            downloadButton(outputId="DOWNLOADPDF", label="Download")
        )
    )
)
