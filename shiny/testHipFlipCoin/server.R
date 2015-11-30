##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

rm(list=ls())

## Simula o número de trocas ao lançar n vezes uma moeda equilibrada.
moeda <- function(n){
    sum(abs(diff(rbinom(n, 1, 0.5))))
}

## Vetor vazio.
N <- 1000

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })

        ## Cria valores para reagirem à estímulos dos buttons
        v <- reactiveValues(x = integer())
        
        ## Responde a estímulos no `input$goCara`.
        observeEvent(input$goCara, {
            v$x <- c(v$x, 1L)
        })
        
        ## Responde a estímulos no `input$goCoro`.
        observeEvent(input$goCoro, {
                         v$x <- c(v$x, 0L)
                     })

        ## Responde a estímulos no `input$goCoro`.
        observeEvent(input$clear, {
            v$x <- integer()
        })
        
        ## x começa com dois elementos. Descontá-los.
        output$nlanc <- renderText({
            return(length(v$x))
        })
        
        process <- eventReactive(input$goProcess, {
            with(reactiveValuesToList(v), {
                x <- x
                ## Número de lançamentos.
                n <- length(x)
                ## Número de caras.
                k <- sum(x)
                ## Número de trocas de face.
                o <- sum(abs(diff(x)))
                ## Faz várias execuções do experimento aleatório.
                r <- replicate(N, moeda(n))
                ## P-valor bilateral empírico.
                p <- min(c(2*min(c(sum(r<=o), sum(r>=o)))/N, 1))
                ## Lista com todos os elementos.
                list(n=n, k=k, o=o, r=r, p=p, x=x)
            })
        })
        
        output$seqx <- renderText({
            s <- paste0(process()$x, collapse="")
            return(s)
        })
        
        output$hist <- renderPlot({
            with(process(),{
                if(n<=15){
                    stop("Pro favor, lance no mínimo 15 vezes.")
                }
                par(mar=c(5,4,3,2), family="Palatino")
                layout(matrix(c(1,2,1,3), 2, 2))
                bks <- seq(min(c(r,o)), max(c(r,o))+1, by=1)-0.5
                ht <- hist(r, breaks=bks, plot=FALSE)
                plot(ht$mids, ht$density, type="h", lwd=2,
                     ylim=c(0, 1.05*max(ht$density)),
                     xlab=sprintf("Número de trocas em %i lançamentos", n),
                     ylab="Probabilidade",
                     sub=sprintf("%i simulações", N))
                if(input$teorico){
                    px <- dbinom(x=ht$mids, size=n-1, prob=0.5)
                    points(ht$mids+0.1, px, type="h", col="blue")
                    pb <- 2*pbinom(q=min(c(o, n-o-1)), size=n-1, p=0.5)
                    mtext(side=3, line=0, col="blue",
                          text=sprintf("P-valor bilateral teórico: %0.4f", pb))
                }
                abline(v=o, col=2)
                text(x=o, y=par()$usr[4],
                     label="Estatística observada",
                     srt=90, adj=c(1.25,-0.25))
                mtext(side=3, line=1,
                      text=sprintf("P-valor bilateral empírico: %0.4f", p))
                mtext(side=3, line=2,
                      text=sprintf(
                          "Trocas observadas: %i\t Número de caras: %i",
                          o, k))
                plot(cumsum(x)/seq_along(x), type="l", ylim=c(0,1),
                     ylab="Frequência de face cara",
                     xlab="Número do lançamento")
                abline(h=0.5, lty=2)
                plot(ecdf(r), verticals=TRUE, cex=NA,
                     main=NULL, xlim=range(bks),
                     xlab=sprintf("Número de trocas em %i lançamentos", n),
                     ylab="Probabilidade acumulada",
                     sub=sprintf("%i simulações", N))
                abline(h=seq(0.05, 0.95, by=0.05), lty=2, col="gray50")
                abline(v=o, col=2)
                text(x=o, y=par()$usr[4],
                     label="Estatística observada",
                     srt=90, adj=c(1.25,-0.25))
            })
        })
    })
