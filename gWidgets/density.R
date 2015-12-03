##----------------------------------------------------------------------
## Definições da sessão.

require(gWidgetstcltk)
options(guiToolkit="tcltk")
## options(guiToolkit="RGtk2")

## Vetor de valores para o qual será feito o histograma.
x <- precip

##-------------------------------------------
## Função reativa. Sem argumentos!

density.reactive <- function(...){
    dn <- density(x,
                  kernel=svalue(sk),
                  width=svalue(sw))
    plot(dn, main=NA, xlab="Precipitação", ylab="Densidade")
    if (svalue(rg)){
        rug(x)
    }
}

##-------------------------------------------
## Interface.

w <- gwindow("Densidade empírica")
tbl <- glayout(container=w)
kf <- eval(formals(density.default)$kernel) ## Funções kernel.
tbl[1, 1] <- "Escolha uma função kernel:"
tbl[2, 1, expand=TRUE] <- (
    sk <- gcombobox(items=kf,
                    ## selected="gaussian",
                    coerce.with="as.character",
                    container=tbl, handler=density.reactive))
dn <- density(x, kernel="gaussian")
dn$w <- (dn$bw*4)*c(0.5, 3, 1)
tbl[3, 1] <- "Largura de banda"
tbl[4, 1, expand=TRUE] <- (
    sw <- gslider(from=dn$w[1], to=dn$w[2],
                  by=diff(dn$w[-3])/100, value=dn$w[3],
                  container=tbl, handler=density.reactive))
tbl[5, 1, expand=TRUE] <- (
    rg <- gcheckbox("Colocar rug?",
                    container=tbl, handler=density.reactive))

##----------------------------------------------------------------------
