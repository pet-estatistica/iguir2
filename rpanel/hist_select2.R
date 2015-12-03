## Caixas de seleção (rp.listbox e rp.radiogroup)

require(rpanel)

fml <- names(X11Fonts())
fnt <- c("plain"=1, "bold"=2, "italic"=3, "bold-italic"=4)

x <- precip
ht <- hist(x)

hist.reactive <- function(input){
    f <- as.integer(input$fnt)
    plot(ht,
         family=input$fml,
         font=as.integer(input$fnt),
         col="#FF9200",
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
         return(input)
}

panel <- rp.control(title="Histograma")
rp.listbox(panel=panel, variable=fml,
           title="Escolha o tipo de fonte:",
           vals=fml, initval=fml[1],
           action=hist.reactive)
rp.radiogroup(panel=panel, variable=fnt,
           title="Escolha o estilo de fonte:",
           vals=fnt, initval=fnt[1],
           labels=names(fnt),
           action=hist.reactive)
