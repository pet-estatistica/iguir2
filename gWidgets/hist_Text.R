## Entrada de texto (gedit)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)

hist.reactive <- function(...){
    plot(ht, col="#006666",
         ylab="Frequência absoluta",
         xlab="Precipitação",
         main=svalue(main),
         sub=svalue(sub))
}

w <- gwindow("Histograma")
g <- gframe(text="Texto para o título:", container=w)
main <- gedit(text=NULL,
              initial.msg="Insira e pressione Enter",
              coerce.with="as.character",
              container=g, handler=hist.reactive)
g <- gframe(text="Texto para o subtítulo:", container=w)
sub <- gedit(text=NULL,
             initial.msg="Insira e pressione Enter",
             coerce.with="as.character",
             container=g, handler=hist.reactive)
