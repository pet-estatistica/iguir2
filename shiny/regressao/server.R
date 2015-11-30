##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        
        ## Objetos para armazenar as coordenadas
        val <- reactiveValues(x = NULL, y = NULL, z = FALSE) 

        ## Salva a posição dos dois pontos
        observe({
            if (is.null(input$plot_click)){
                return()
            }
            isolate({
                val$x <- c(val$x, input$plot_click$x)
                val$y <- c(val$y, input$plot_click$y)
            })
        })

        ## Limpa os objetos reativos estimulado pelo `input$clear`
        observe({
            if (input$clear > 0){
                val$x <- NULL
                val$y <- NULL
                val$z <- FALSE
            }
        })

        ## Habilita exibição estimulado pelo `input$result` 
        observe({
            if (input$result > 0){
                val$z <- TRUE
            }
        })

        ## Limpa o gráfico quando se troca de area em `input$area`
        observeEvent(input$area, {
            val$x <- NULL
            val$y <- NULL
            val$z <- FALSE
        })

        ## Escolha do intervalo de confiança exibido
        output$interval <- renderUI({
            if(val$z) {
                radioButtons("inter", "Intervalo de confiança",
                             c("Para a média" = "confidence",
                               "Para os dados" = "prediction"))
            }
        })
        
        ## Gráfico de dispersão
        output$plot <- renderPlot({
            ## Conjunto de dados pré-definido
            da <- switch(
                input$area,
                "Mercado Imobiliário" = da1,
                "Meteorologia" = da2,
                "Segurança Veicular" = da3,
                "Relação Salarial" = da4,
                "Mercado Automobilístico" = da5
            )

            ## Labels definidos para cada conjunto
            opt <- switch(
                input$area,
                "Mercado Imobiliário" =
                             list(ylab = "Preço de Venda Imovéis em log(R$)", 
                                  xlab = "Área dos Imóveis em log(m²)",
                                  main = "Preço de Imovéis em Curitiba-PR"),
                
                "Meteorologia" =
                    list(ylab = "Temperatura Máxima em °C",
                         xlab = "Velocidade Média do Vento em km/h", 
                         main = "Temperatura Máxima em Nova York"),
                
                "Segurança Veicular" = list(
                               ylab = "Distância Percorrida em metros",
                               xlab = "Velocidade do Veículo em km/h", 
                               main = "Distância Para a Frenagem de um Veículo"),
                
                "Relação Salarial" = list(
                             ylab = "Renda Familiar Per Capita Média em R$",
                             xlab = "Média de Anos Estudados de Pessoas a Partir de 25 anos", 
                             main = "Renda Familiar per capita de Curitiba em 2000"),
                
                "Mercado Automobilístico" = list(
                             ylab = "Preço dos Veículos em 1.000 R$", 
                             xlab = "Quilometragem do Veículo em 1.000 Km",
                             main = "Preço de Carros Renault Duster")
            )

            ## Gráfico de dispesão com linhas em azul nas extremidades
            ## dos dados
            par(mar = c(4, 4, 1, 2), family = "Palatino")
            plot(y ~ x, data = da, type = "n", main = opt$main,
                 xlab = opt$xlab, ylab = opt$ylab,
                 ylim = extendrange(da$y, f = 0.1)); grid()
            points(y ~ x, data = da, pch = 19,
                   col = rgb(0.5, 0.5, 0.5, 0.5))
            abline(v = extendrange(da$x, f = 0.015), 
                   col = rgb(0, 0, 1, 0.15),
                   lwd = 10)

            
            if(length(val$x) > 0){
                points(x = val$x[1:2],
                       y = val$y[1:2],
                       pch = 19,
                       col = "red",
                       cex = 1.2)
                segments(val$x[1], val$y[1],
                         val$x[2], val$y[2],
                         lwd = 2, col = "red")
            }

            if(val$z){
                rg <- extendrange(da$x, f = 0.2)
                pred <- expand.grid(
                    x = seq(rg[1], rg[2], length.out = 50))
                
                model <- lm(y ~ x, data = da)
                aux1 <- predict(model, newdata = pred,
                                interval = input$inter)
                pred1 <- cbind(pred, aux1)
                
                lines(fit ~ x, data = pred1, col = "blue", lwd = 2)
                lines(lwr ~ x, data = pred1, lty=3, col = "blue")
                lines(upr ~ x, data = pred1, lty = 3, col = "blue")
                with(pred1,
                     polygon(c(x, rev(x)), c(lwr, rev(upr)),
                             col=rgb(0.1, 0.1, 0.1, 0.2), border = NA)
                     )
            }
        }, height = 500)
    }
)
