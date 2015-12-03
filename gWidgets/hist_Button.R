## Botão de ação (gbutton)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)

hist.reactive <- function(...){
    col <- sample(colors(), size=1)
    plot(ht, main=NULL,
         ylab="Frequência absoluta", xlab="Precipitação",
         col=col, sub=col)
}

w <- gwindow("Histograma")
gbutton(text="Nova cor!", container=w, handler=hist.reactive)
