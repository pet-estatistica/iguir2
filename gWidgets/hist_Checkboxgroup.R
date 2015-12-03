## Caixas de seleção múltipla (gcheckboxgroup)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)
nc <- length(ht$counts)

cols <- c(Vermelho="#F81D54", Amarelo="#FF9F1E", Azul="#2791E1", Verde="#72F51D")
cols2 <- c(cols, rev(cols))

hist.reactive <- function(...){
    seqcol <- colorRampPalette(cols2[svalue(colors)])
    plot(ht, col=seqcol(nc),
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
}

w <- gwindow("Histograma")
g <- gframe(text="Escolha as cores para interpolar:", container=w)
colors <- gcheckboxgroup(items=names(cols2),
                         checked=c(TRUE, is.na(cols2)[-1]),
                         container=g, handler=hist.reactive)
