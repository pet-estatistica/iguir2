## Botões de incremento (gspimbutton)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)

hist.reactive <- function(...){
    m <- svalue(mar)
    par(mar=c(m, m, 1, 1))
    plot(ht, col="#660066",
         main=NULL, axes=FALSE, ann=FALSE,
         xaxt="n", yaxt="n")
    box(bty="L")
    axis(side=1, cex.axis=svalue(cexaxis))
    axis(side=2, cex.axis=svalue(cexaxis))
    title(ylab="Frequência absoluta",
          xlab="Precipitação",
          line=svalue(line))
}

w <- gwindow("Histograma")
g <- gframe(text="Tamanho do texto dos eixos:", container=w)
mar <- gspinbutton(from=3, to=7, by=0.5, value=5,
                    container=g, handler=hist.reactive)
svalue(mar) <- 5
g <- gframe(text="Tamanho do texto dos eixos:", container=w)
cexaxis <- gspinbutton(from=0.5, to=2, by=0.1, value=1,
                       container=g, handler=hist.reactive)
svalue(cexaxis) <- 1
g <- gframe(text="Distância dos rótulos dos eixos:", container=w)
line <- gspinbutton(from=1, to=4, by=0.1, value=3,
                    container=g, handler=hist.reactive)
svalue(line) <- 3
