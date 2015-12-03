## Caixa de seleção (rp.checkbox)

require(rpanel)

x <- precip
ht <- hist(x)
col <- rep("#3366CC", length(ht$counts))

hist.reactive <- function(input){
    if(input$modal){
        col[which.max(ht$counts)] <- "#142952"
    }
    plot(ht, col=col, main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
    if(input$rg){
        rug(x)
    }
    return(input)
}

panel <- rp.control(title="Histograma")
rp.checkbox(panel=panel, variable=rg,
            title="Marcar sobre eixo com os valores?",
            initval=FALSE,
            action=hist.reactive)
rp.checkbox(panel=panel, variable=modal,
            title="Destacal a classe modal?",
            initval=FALSE,
            action=hist.reactive)
