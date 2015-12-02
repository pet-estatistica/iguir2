##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

## Simula o número de trocas ao lançar n vezes uma moeda equilibrada.
moeda <- function(n){
    sum(abs(diff(rbinom(n, 1, 0.5))))
}
## Número de simulações
N <- 1000

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        
        ## Valores reativos que armazenam a sequência descrita pelo
        ## usuário 
        v <- reactiveValues(x = integer(), show = FALSE)

        ## Responde a estímulos no `input$goCara`.
        observeEvent(input$goCara, {
                         v$x <- c(v$x, 1L)
                     })

        ## Responde a estímulos no `input$goCoro`.
        observeEvent(input$goCoro, {
                         v$x <- c(v$x, 0L)
                     })

        ## Responde a estímulos no `input$clear`.
        observeEvent(
            input$clear, {
                v$x <- integer()
                v$show <- FALSE
            })

        ## Responde a estímulos no `input$goProcess` retornando uma
        ## lista de valores a serem usados na construção do gráfico
        process <- eventReactive(
            input$goProcess, {                
                x <- v$x
                ## Exibe gráfico
                v$show <- TRUE
                ## Número de lançamentos.
                n <- length(v$x)
                ## Número de caras.
                k <- sum(v$x)
                ## Número de trocas de face.
                o <- sum(abs(diff(v$x)))
                ## Faz várias execuções do experimento aleatório.
                r <- replicate(N, moeda(n))
                ## P-valor bilateral empírico.
                p <- min(c(2*min(c(sum(r<=o), sum(r>=o)))/N, 1))
                ## Lista com todos os elementos.
                return(list(n=n, k=k, o=o, r=r, p=p, x=x, show=v$show))                
            })

        ## Número de lançamentos realizados
        output$numx <- renderText({
            n <- length(v$x)
            return(n)
        })

        ## Sequência lançada pelo usuário 
        output$seqx <- renderText({
            s <- paste0(v$x, collapse = "")
            return(s)
        })

        ## Gráfico para testar a hipótese
        output$hist <- renderPlot({
            with(process(),{
                if(n < 20){
                }
                if(v$show & n > 19){
                    par(mar = c(5, 4, 1, 2), family = "Palatino",
                        cex = 1.2)
                    bks <- seq(min(c(r,o)), max(c(r, o)) + 1,
                               by = 1) - 0.5
                    ht <- hist(r, breaks = bks, plot = FALSE)
                    plot(ht$mids, ht$density, type = "h", lwd = 2,
                         ylim = c(0, 1.05 * max(ht$density)),
                         xlab = sprintf("Número de trocas em %i lançamentos", n),
                         ylab = "Probabilidade",
                         sub = sprintf("%i simulações", N))
                    grid()
                    segments(ht$mids, 0, ht$mids, ht$density, lwd = 3,
                             col = 1)
                    abline(v = o, col = "blue", lwd = 2)
                    axis(1, o, round(o, 2), col = "blue",
                         col.axis = "blue", cex = 1.5)
                    text(x = o, y = par()$usr[4],
                         label = "Estatística observada",
                         srt = 90, adj = c(1.25,-0.25))
                    mtext(side = 3, line = 0, cex = 1.2,
                          text = sprintf(
                              "Número de caras: %i\t Número de coroas: %i",
                              k, n - k))
                }
            })
        })

        ## Mensagem de aviso caso a sequencia lançada seja menor que 20
        output$bloqueio <- renderUI({
            if(process()$n < 20 & v$show){
                HTML("<center><font style='font-weight: bold; color:red'>Lançe ao menos 20 vezes</font></center><br>")
            } else return()
        })
    })
