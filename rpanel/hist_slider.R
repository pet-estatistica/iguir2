## Deslizador (rp.slider)

require(rpanel)

x <- precip

## Extremos com amplitude estendida em 5%.
a <- extendrange(x, f=0.05)

hist.reactive <- function(input){
    bks <- seq(a[1], a[2], length.out=input$nclass+1)
    hist(x,
         breaks=bks,
         main=NULL,
         col="#008A8A",
         ylab="Frequência absoluta",
         xlab="Precipitação")
    return(input)
}

panel <- rp.control(title="Histograma")
rp.slider(panel=panel, variable=nclass,
          title="Escolha o número de classes:",
          from=1, to=30, resolution=1, initval=10,
          action=hist.reactive)
