## Entrada numérica (rp.numeric)

require(rpanel)

x <- precip
ht <- hist(x)

hist.reactive <- function(input){
    m <- input$mar
    par(mar=c(m, m, 1, 1))
    plot(ht, col="#660066",
         main=NULL, axes=FALSE, ann=FALSE,
         xaxt="n", yaxt="n")
    box(bty="L")
    axis(side=1, cex.axis=input$cexaxis)
    axis(side=2, cex.axis=input$cexaxis)
    title(ylab="Frequência absoluta",
          xlab="Precipitação",
          line=input$line)
    return(input)
}

panel <- rp.control(title="Histograma")
rp.doublebutton(panel=panel, variable=mar,
                title="Tamanho das margens:",
                initval=5, range=c(3, 7), step=0.5,
                action=hist.reactive)
rp.doublebutton(panel=panel, variable=cexaxis,
                title="Tamanho do texto dos eixos:",
                initval=1, range=c(0.5, 2), step=0.1,
                action=hist.reactive)
rp.doublebutton(panel=panel, variable=line,
                title="Distância dos rótulos dos eixos:",
                initval=3, range=c(1, 4), step=0.1,
                action=hist.reactive)
