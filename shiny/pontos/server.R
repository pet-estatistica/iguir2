##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")
library(sp)
library(geoR)

## Armazena o poligono do estado do Paraná
parana <- SpatialPolygons(list(Polygons(list(Polygon(
    geoR::parana$borders)), "x")))

shinyServer(
    function(input, output) {
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        
        ## Valores reativos que armazenam a posição dos pontos
        ## realizados pelo usuário
        val <- reactiveValues(x = NULL, y = NULL, z = FALSE,
                              option = "") 
        
        ## Salva a posição dos pontos
        observe({
            if (is.null(input$plot_click)){
                return()
            }
            isolate({
                val$x <- c(val$x, input$plot_click$x)
                val$y <- c(val$y, input$plot_click$y)
            })
        })

        ## Exibe o número de pontos no quadro
        output$npontos <- renderText({
            if(!val$z)  length(val$x)
            else NULL
        })
        
        ## Limpa os objetos reativos estimulado pelo `input$clear`
        observe({
            if (input$clear > 0){
                val$x <- NULL
                val$y <- NULL
                val$z <- FALSE
                val$option <- ""
            }
        })

        ## Habilita exibição se houver mais de 19 pontos e se clicado em
        ## `input$result` 
        observeEvent(input$result, {
            if (length(val$x) > 19){
                val$z <- TRUE
            }
        })

        ## Armazena as opções escolhidas na seção de exemplos
        observe({
            if(length(input$example) != 0){
                if(input$example == "Aleatório"){
                    val$option <- "aleatorio"
                }
                if(input$example == "Regular alinhado"){
                    val$option <- "regular.a"
                }
                if(input$example == "Regular desalinhado"){
                    val$option <- "regular.d"
                }
                if(input$example == "Clusterizado"){
                    val$option <- "cluster"
                }
            }
        })

        ## Realiza o teste via simulação
        simula <- eventReactive(
            input$result, {
                if(length(val$x) > 19){
                    n <- length(val$x)
                    
                    r <- replicate(100, {
                        M <- cbind(x = runif(n), y = runif(n))
                        D <- c(dist(M))
                        D
                    })
                    return(list(n = n, r = r))
                }
            })

        ## Exibibe as opções de exemplo, após mais de 19 cliques
        output$examples <- renderUI({
            if(val$z & length(val$x) > 19){
                radioButtons(inputId = "example", 
                             label = "Disposição de pontos",
                             choices = c("Aleatório",
                                         "Regular alinhado",
                                         "Regular desalinhado",
                                         "Clusterizado"),
                             selected = "", inline = FALSE)
            }
        })

        ## Gráficos: i) do teste de hipóteses ii) dos exemplos com o
        ## mapa do Paraná 
        output$plot1 <- renderPlot({
            if(val$z & length(val$x) > 19){
                if(val$option == ""){
                    with(simula(), {
                        par(mar = c(0, 0, 0, 0), family = "Palatino")
                        plot(x = NULL, y = NULL,
                             xlim = range(r), ylim = c(0, 1),
                             axes = F, frame = T, xlab = "", ylab = "")
                        box(lwd = 2)
                        apply(r, 2, function(x) lines(ecdf(x), pch = NA))
                        
                        dw.ac <- c(dist(cbind(val$x, val$y)))
                        lines(ecdf(dw.ac), col = 2, lwd = 2, pch = NA)
                    })
                }
                if(val$option == "aleatorio"){
                    par(mar = c(0, 0, 0, 0), family = "Palatino")
                    plot(parana, lwd = 3)
                    points(spsample(parana, n = 50, "random"),
                           pch = 19)
                }
                if(val$option == "regular.a"){
                    par(mar = c(0, 0, 0, 0), family = "Palatino")
                    plot(parana, lwd = 3)
                    points(spsample(parana, n = 50, "regular"),
                           pch = 19)
                    
                }
                if(val$option == "regular.d"){
                    par(mar = c(0, 0, 0, 0), family = "Palatino")
                    plot(parana, lwd = 3)
                    points(spsample(parana, n = 50, "nonaligned"),
                           pch = 19)
                }
                if(val$option == "cluster"){
                    par(mar = c(0, 0, 0, 0), family = "Palatino")
                    plot(parana, lwd = 3)
                    points(spsample(parana, n = 50, "clustered",
                                    nclusters = 10), pch = 19)
                }
            } else {
                par(mar = c(0, 0, 0, 0))
                plot(x = c(0,1), y = c(0, 1), type = "n",
                     xlim = c(0, 1), ylim = c(0, 1),
                     xlab = "", ylab = "", main = "",
                     axes = FALSE, frame = TRUE) 
                box(lwd = 2)
                
                points(x = val$x, y = val$y, pch = 19)
            }
        })
    }
)

