##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")
require(latticeExtra)

rm(list=ls())

N <- 500
n <- c(1,2,3,5,10,20)
da <- data.frame(tam=rep(n, each=N))

panel.dens <- function(x, ...){
    panel.densityplot(x, ...)
    m <- mean(x)
    s <- sd(x)
    panel.mathdensity(dmath=dnorm, col="blue",
                      args=list(mean=m, sd=s)) 
}

panel.fa <- function(x, ...){
    panel.ecdfplot(x, ...)
    m <- mean(x)
    s <- sd(x)
    xx <- seq(min(x), max(x), length.out=20)
    panel.lines(xx, pnorm(xx, m, s), col="blue")
}

# y <- runif(1000)
# ecdfplot(~y,
#          data=da, as.table=TRUE,
#          xlab=expression(bar(X)),
#          ylab="Frequêcia acumulada",
#          panel=panel.fa)

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$distBarX <- renderPlot({
            ## Define a distribuiação de probabilidade de X.
            barX <- switch(input$distX,
                          UD5=function(ni){
                              mean(sample(1:5, size=ni, replace=TRUE))
                          },
                          U01=function(ni){
                              mean(runif(ni, min=0, max=1))
                          },
                          N01=function(ni){
                              mean(rnorm(ni, mean=0, sd=1))
                          },
                          E1=function(ni){
                              mean(rexp(ni, rate=1))
                          },
                          Poi5=function(ni){
                              mean(rpois(ni, lambda=5))
                          },
                          BetaA=function(ni){
                              mean(rbeta(ni, shape1=0.5, shape2=0.5))
                          }
            )
            ## Obtém a distribuição de bar(X).
            da$barx <- 
                do.call(c, lapply(as.list(n),
                                  function(ni){
                                      replicate(N, {
                                          barX(ni)
                                      })
                                  }))
            ## Define parâmetros gráficos.
            trellis.par.set(list(
                grid.pars=list(fontfamily="palatino"),
                strip.background=list(col="gray70"),
                plot.line=list(col=1),
                plot.symbol=list(col=1))
            )
            ## Representa a distribuição de probabilidades.
            p <- switch(input$plotType,
                        dens=densityplot(~barx|factor(tam),
                                         data=da, as.table=TRUE,
                                         xlab=expression(bar(X)),
                                         ylab="Densidade",
                                         panel=panel.dens),
                        ecdf=ecdfplot(~barx|factor(tam),
                                      data=da, as.table=TRUE,
                                      xlab=expression(bar(X)),
                                      ylab="Frequêcia acumulada",
                                      panel=panel.fa)
            )
            return(print(p))
        })
    })
