## Múltipla escolha (gradio)

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

x <- precip
ht <- hist(x)

choices <- c(Turquesa="#00CC99",
             Azul="#0066FF",
             Rosa="#FF3399",
             Laranja="#FF6600",
             Roxo="#660066",
             "Verde limão"="#99FF33")

hist.reactive <- function(...){
    plot(ht,
         col=choices[svalue(col)],
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
}

w <- gwindow("Histograma")
g <- gframe(text="Escolha a cor para as barras:", container=w)
col <- gradio(items=names(choices),
              selected=1,
              container=g, handler=hist.reactive)
