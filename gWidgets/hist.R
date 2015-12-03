##-----------------------------------------------------------------------------
## Definições da sessão.

## require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")
## options(guiToolkit="RGtk2")

## Vetor de valores para o qual será feito o histograma.
x <- precip

##-----------------------------------------------------------------------------
## Caso 1: cores são especificadas por meio de trinca RGB.

## Função reativa. Sem argumentos!
hist.reactive <- function(...){
    hist(x,
         col=rgb(
             red=svalue(sr),
             green=svalue(sg),
             blue=svalue(sb)),
         breaks=svalue(sl),
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
    if(svalue(rg)){
        rug(x)
    }
}

##--------------------------------------------
w <- gwindow("Histograma")
tbl <- glayout(container=w)
##--------------------------------------------
tbl[1, 1] <- "Escolha a cor em RGB"
tbl[2, 1] <- (sr <-
    gspinbutton(from=0, to=1, by=0.05, value=0.5,
                container=tbl, handler=hist.reactive))
tbl[3, 1] <- (sg <-
    gspinbutton(from=0, to=1, by=0.05, value=0.5,
                container=tbl, handler=hist.reactive))
tbl[4, 1] <- (sb <-
    gspinbutton(from=0, to=1, by=0.05, value=0.5,
                container=tbl, handler=hist.reactive))
##--------------------------------------------
tbl[5, 1] <- "Sugestão do número de classes"
tbl[6, 1, expand=TRUE] <- (sl <-
    gslider(from=1, to=100, by=1, value=10,
            container=tbl, handler=hist.reactive))
##--------------------------------------------
tbl[7, 1, expand=TRUE] <- (rg <-
    gcheckbox("Colocar rug?",
              container=tbl, handler=hist.reactive))

##-----------------------------------------------------------------------------
## Caso 2: cores são especificadas em formato html (hexadecimal).

## Função reativa. Sem argumentos!
hist.reactive <- function(...){
    hist(x,
         col=paste0("#", svalue(shtml)),
         breaks=svalue(sl))
    if(svalue(rg)){
        rug(x)
    }
}

##--------------------------------------------
w <- gwindow("Histograma")
tbl <- glayout(container=w)
##--------------------------------------------
tbl[1,1] <- "Especifique cor em formato html:"
tbl[1,2, expand=TRUE] <- (shtml <-
    gedit(text="FF0000",
          initial.msg="FF00CC",
          coerce.with="as.character", width=6,
          container=tbl, handler=hist.reactive))
addhandlerchanged(shtml, handler=hist.reactive)
##--------------------------------------------
tbl[3,1] <- "Sugestão do número de classes"
tbl[4, 1, expand=TRUE] <- (sl <-
    gslider(from=1, to=20, by=1, value=10,
            container=tbl, handler=hist.reactive))
##--------------------------------------------
tbl[5, 1, expand=TRUE] <- (rg <-
    gcheckbox("Colocar rug?",
        container=tbl, handler=hist.reactive))

##-----------------------------------------------------------------------------
## Caso 3: cores são escolhidas em uma lista de cores disponíveis.

## Função reativa. Sem argumentos!
hist.reactive <- function(...){
    hist(x,
         col=svalue(scolors),
         breaks=svalue(sl))
    if(svalue(rg)){
        rug(x)
    }
}

##--------------------------------------------
w <- gwindow("Histograma")
tbl <- glayout(container=w)
##--------------------------------------------
tbl[1,1] <- "Escolha uma das cores disponíveis:"
tbl[1,2, expand=TRUE] <- (scolors <-
    gcombobox(items=colors(),
          selected="red",
          coerce.with="as.character",
          container=tbl, handler=hist.reactive))
## addhandlerchanged(shtml, handler=hist.reactive)
##--------------------------------------------
tbl[3,1] <- "Sugestão do número de classes"
tbl[4, 1, expand=TRUE] <- (sl <-
    gslider(from=1, to=100, by=1, value=10,
            container=tbl, handler=hist.reactive))
##--------------------------------------------
tbl[5, 1, expand=TRUE] <- (rg <-
    gcheckbox("Colocar rug?",
        container=tbl, handler=hist.reactive))

##-----------------------------------------------------------------------------
