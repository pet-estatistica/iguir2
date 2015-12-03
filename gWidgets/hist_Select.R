## Caixas de seleção (gcombobox)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

Nclass <- c("Sturges", "Scott", "Freedman-Diaconis")
Obj <- c("precip","rivers","islands")

hist.reactive <- function(...){
    L <- switch(svalue(obj),
                precip=list(x=precip, xlab="Precipitação anual média (polegadas)"),
                rivers=list(x=rivers, xlab="Comprimento dos rios (milhas)"),
                islands=list(x=islands, xlab="Área de ilhas (1000 milhas quadradas)"))
    hist(L$x,
         breaks=svalue(nclass),
         col="#8F0047",
         main=NULL,
         ylab="Frequência absoluta",
         xlab=L$xlab)
    rug(L$x)
}

w <- gwindow("Histograma")
glabel(text="Escolha o conjunto de dados:", container=w)
obj <- gcombobox(items=Obj, selected=1, container=w,
                 handler=hist.reactive)
glabel(text="Escolha a regra para número de classes:", container=w)
nclass <- gcombobox(items=Nclass, selected=1, container=w,
                    handler=hist.reactive)

w <- gwindow("Histograma")
g <- gframe(text="Escolha o conjunto de dados:", container=w)
obj <- gcombobox(items=Obj, selected=1, container=g,
                 handler=hist.reactive)
g <- gframe(text="Escolha a regra para número de classes:", container=w)
nclass <- gcombobox(items=Nclass, selected=1, container=g,
                    handler=hist.reactive)
