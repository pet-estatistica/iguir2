## Caixa de seleção (gcheckbox)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)
col <- rep("#3366CC", length(ht$counts))

hist.reactive <- function(...){
    if(svalue(modal)){
        col[which.max(ht$counts)] <- "#142952"
    }
    plot(ht, col=col, main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
    if(svalue(rg)){
        rug(x)
    }
}

w <- gwindow("Histograma")
rg <- gcheckbox(text="Marcar sobre eixo com os valores?",
                checked=FALSE, container=w, handler=hist.reactive)
modal <- gcheckbox(text="Destacal a classe modal?",
                   checked=FALSE, container=w, handler=hist.reactive)
