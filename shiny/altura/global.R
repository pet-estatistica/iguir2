##-------------------------------------------
## global.R

## Pacotes necessários
library(irtoys)

##================================================================
## Conjunto de dados para calibracao
altura <- read.fwf("altura211.dat", widths = c(3, 4, rep(1, 14)),
                   header = FALSE, dec = ',')
colnames(altura) <- c('id', 'altura', paste('i', 1:14, sep = ""))
altura.itens <- altura[, 3:16] ## apenas as colunas de respostas

##================================================================
## Modelo para os thetas
## Modelo unidimensional logistico de dois parametros
## a_j = parametro de discriminacao do item
## b_j = parametro de dificuldade do item
altura.par <- est(altura.itens, model = "2PL",
                  engine = "ltm", nqp = 21)
## estimativa da habilidade
## theta_i = habilidade de cada pessoa
altura.sco <- eap(altura.itens, altura.par$est, qu = normal.qu())

##================================================================
## Modelo para a altura
x <- altura.sco[,1] # theta estimado de cada pessoa
y <- altura$altura  # altura de cada pessoa
model <- lm(y ~ x)

##================================================================
## Perguntas realizadas
pergunta <- c("1. Na cama você frequentemente sente frio nos pés ?",
              "2. Você frequentemente desce as escadas de dois em dois degraus ?",
              "3. Você acha que se daria bem em um time de basquete ?",
              "4. Como policial você impressionaria muito ?",
              "5. Na maioria dos carros você se sente confortável ?",
              "6. Você literalmente olho para seus colegas de cima para baixo ?",
              "7. Você é capaz de pegar um objeto no alto de um armário sem usar escada ?",
              "8. Você abaixa quando vai passar por uma porta ?",
              "9. Você consegue guardar a bagagem no porta malas de um avião ?",
              "10. Você regula o banco de carro para trás ?",
              "11. Normalmente, quando você está andando de carona lhe oferecem o banco da frente ?",
              "12. Quando você e várias outras pessoas vão tirar fotos, formando-se três fileiras, onde ninguém fica abaixado, você costuma ficar atrás ?",
              "13. Você tem dificuldade para se acomodar no ônibus ?",
              "14. Em uma fila, por ordem de tamanho, você é sempre colocado atrás ?")

##======================================================================
## Função para curva estimada
curve.pred <- function(ans){
    aluno <- ans
    theta.aluno <- eap(aluno, altura.par$est, qu = normal.qu())
    newdata <- data.frame(x = theta.aluno[,1])
    altura.pred <- predict(object = model, newdata = newdata,
                           interval = "prediction")
    par(col.main = "darkblue", mar = c(5, 0, 2, 0),
        bg = "white", family = "Palatino")
    curve(dnorm(x, mean = altura.pred[1],
                sd = sqrt(anova(model)$"Mean Sq"[2])),
          from = altura.pred[1] - 4 * sqrt(anova(model)$"Mean Sq"[2]),
          to = altura.pred[1] + 4 * sqrt(anova(model)$"Mean Sq"[2]),
          ylab = "",
          xlab = "Altura",
          axes = FALSE, frame = TRUE)
    x <- seq(altura.pred[2], altura.pred[3], length = 40)
    fx <- dnorm(x, mean = altura.pred[1],
                 sd = sqrt(anova(model)$"Mean Sq"[2]))
    polygon(c(x, rev(x)),
            c(fx, rep(0, length(fx))),
            col="gray70")
    lines(rep(altura.pred[1], 2),
          c(0, max(fx)), col = "darkblue")
    lines(rep(altura.pred[2], 2),
          c(0, dnorm(altura.pred[2], mean = altura.pred[1],
                     sd = sqrt(anova(model)$"Mean Sq"[2]))),
          lty = 2, col = "darkblue")
    lines(rep(altura.pred[3], 2),
          c(0, dnorm(altura.pred[3], mean = altura.pred[1],
                     sd = sqrt(anova(model)$"Mean Sq"[2]))),
          lty = 2, col = "darkblue")
    par(col.axis = "darkblue")
    axis(1, altura.pred, labels=round(altura.pred, 2), col = "darkblue", cex.axis = 2)
}
