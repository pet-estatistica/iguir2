## Botão de ação (rp.button)

require(rpanel)

x <- precip
ht <- hist(x)

hist.reactive <- function(input){
    col <- sample(colors(), size=1)
    plot(ht, main=NULL,
         ylab="Frequência absoluta", xlab="Precipitação",
         col=col, sub=col)
    return(input)
}

panel <- rp.control(title="Histograma")
rp.button(panel=panel, 
          title="Nova cor!",
          action=hist.reactive)

