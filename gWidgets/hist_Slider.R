## Deslizador (gslider)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip

## Extremos com amplitude estendida em 5%.
a <- extendrange(x, f=0.05)

hist.reactive <- function(...){
    bks <- seq(a[1], a[2], length.out=svalue(nclass)+1)
    hist(x,
         breaks=bks,
         main=NULL,
         col="#008A8A",
         ylab="Frequência absoluta",
         xlab="Precipitação")
}

w <- gwindow("Histograma")
g <- gframe(text="Escolha o número de classes:", container=w)
nclass <- gslider(from=1, to=30, by=1, value=10,
                  container=g, handler=hist.reactive)
