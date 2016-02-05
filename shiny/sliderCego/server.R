##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

gradColor <- colorRampPalette(c("red", "yellow", "green"))

server <- function(input, output) {
    ## Cabeçalho IGUIR2
    output$header <- renderPrint({
        template("TEMA")
    })

    ##-------------------------------------------
    ## Paleta de cores para a escala (opcional)
    output$escala <- renderPlot({
        x <- seq(from = 1, to = 9, by = 0.01)
        fx <- rep(1, length(x))
        par(mar = c(0, 0, 0, 0))
        plot(fx ~ x, type = "n",
             ylim = c(-0.15, 1),
             bty = "n",
             axes = FALSE,
             xlab = "",
             ylab = "")
        segments(x, rep(0, length(x)),
                 x, fx,
                 col = gradColor(length(x)),
                 lwd = 3)
        points(input$nota, -0.15, pch = 17, cex = 2)
        abline(v = input$nota)
    }, bg = "transparent")

    ##-------------------------------------------
    ## Valores reativos para salvar as respostas
    v <- reactiveValues(pos = 1,
                        da = list(
                            nome = vector("character", len = 30),
                            prod = vector("character", len = 30),
                            nota = vector("numeric", len = 30)))
    
    ##-------------------------------------------
    ## Salva as respostas 
    observeEvent(input$confirm, {
        if(v$pos == 1) {
            v$da$nome[1] <- input$avaliador
            v$da$prod[1] <- input$produto
            v$da$nota[1] <- input$nota
        } else {
            v$da$nome[v$pos] <- input$avaliador
            v$da$prod[v$pos] <- input$produto
            v$da$nota[v$pos] <- input$nota
        }
        v$pos <- v$pos + 1
    })

    ##-------------------------------------------
    ## Atribui NA a nota confirmada se `input$undo`
    observeEvent(input$undo, {
        if(v$pos != 1) {
            v$pos <- v$pos - 1
            v$da$nota[v$pos] <- NA
        }
    })

    ##-------------------------------------------
    ## Exibe as respostas
    output$resp <- renderPrint({
        as.data.frame(v$da)
    })

    ##-------------------------------------------
    ## Cria os botões apenas para valores válidos
    output$buttons <- renderUI({
        if (v$pos > 0 & v$pos < 31) {
            tagList(
                column(width = 6, offset = 1,
                       actionButton("confirm", "Confirmar Nota",
                                    icon = icon("fa fa-check"))
                       ),
                column(width = 5,
                       actionButton("undo", "Desfazer",
                                    icon = icon("fa fa-undo"))
                       )
                )
        } else {
            HTML("Obrigado pelas avaliações!")
        }
    })
}

