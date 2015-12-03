## Caixa de seleção múltipla (rp.checkbox)

require(rpanel)

x <- precip
ht <- hist(x)
nc <- length(ht$counts)

cols <- c(Vermelho="#F81D54", Amarelo="#FF9F1E",
          Azul="#2791E1", Verde="#72F51D")
cols2 <- c(cols, rev(cols))

hist.reactive <- function(input){
    seqcol <- colorRampPalette(cols2[input$colors])
    plot(ht, col=seqcol(nc),
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
    return(input)
}

panel <- rp.control(title="Histograma")
rp.checkbox(panel=panel, variable=colors,
            title="Escolha as cores para interpolar:",
            labels=names(cols2),
            initval=c(TRUE, is.na(cols2)[-1]),
            action=hist.reactive)

