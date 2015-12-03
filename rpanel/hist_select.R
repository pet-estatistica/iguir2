## Caixa de seleção (rp.listbox)

require(rpanel)

nclass <- c("Sturges", "Scott", "Freedman-Diaconis")
obj <- c("precip","rivers","islands")

hist.reactive <- function(input){
    L <- switch(input$obj,
                precip=list(x=precip,
                    xlab="Precipitação anual média (polegadas)"),
                rivers=list(x=rivers,
                    xlab="Comprimento dos rios (milhas)"),
                islands=list(x=islands,
                    xlab="Área de ilhas (1000 milhas quadradas)"))
    hist(L$x,
         breaks=input$nclass,
         col="#8F0047",
         main=NULL,
         ylab="Frequência absoluta",
         xlab=L$xlab)
    rug(L$x)
    return(input)
}

panel <- rp.control(title="Histograma")
rp.combo(panel=panel, variable=obj,
         prompt="Escolha o conjunto de dados:",
         vals=obj, initval=obj[1],
         action=hist.reactive)
rp.combo(panel=panel, variable=nclass,
         prompt="Escolha a regra para número de classes:",
         vals=nclass, initval=nclass[1],
         action=hist.reactive)

panel <- rp.control(title="Histograma")
rp.listbox(panel=panel, variable=obj,
           title="Escolha o conjunto de dados:",
           vals=obj, initval=obj[1],
           action=hist.reactive)
rp.listbox(panel=panel, variable=nclass,
           title="Escolha a regra para número de classes:",
           vals=nclass, initval=nclass[1],
           action=hist.reactive)
