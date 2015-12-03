## Múltipla escolha (rp.radiogroup)

require(rpanel)

x <- precip
ht <- hist(x)

hist.reactive <- function(input){
    plot(ht,
         col=input$col,
         main=NULL,
         ylab="Frequência absoluta",
         xlab="Precipitação")
    return(input)
}

choices <- c(Turquesa="#00CC99",
             Azul="#0066FF",
             Rosa="#FF3399",
             Laranja="#FF6600",
             Roxo="#660066",
             "Verde limão"="#99FF33")

panel <- rp.control(title="Histograma")
rp.radiogroup(panel=panel, variable=col,
              title="Escolha a cor para as barras:",
              vals=choices, labels=names(choices),
              action=hist.reactive)
