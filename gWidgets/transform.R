##======================================================================
## Interface para exibição do gráfico de dispersão das variáveis dist e
## speed do conjunto data(cars), aplicando transformações nas variáveis
## e ajustando uma regressão linear simples. São abordados os seguintes
## widgets:
##    * Listbox
##    * Checkbox
##======================================================================

##======================================================================
## Definições da sessão.

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

## Variáveis e tranformações consideradas na aplicação
x <- cars$speed
y <- cars$dist
trans <- c("Identidade", "Quadrado", "RaizQuadrada", "Log10")

##----------------------------------------------------------------------
## Função reativa.

transformation <- function(...) {
    ## Transformando as variáveis
    tx <- svalue(tx)
    ty <- svalue(ty)
    x <- switch(tx,
                Identidade = x,
                Quadrado = x^2,
                RaizQuadrada = sqrt(x),
                Log10 = log10(x)
                )
    y <- switch(ty,
                Identidade = y,
                Quadrado = y^2,
                RaizQuadrada = sqrt(y),
                Log10 = log10(y)
                )
    ## Protegendo a função devido a primeira seleção
    if(is.null(x)){ x <- cars$speed; tx <- "Identidade"}
    if(is.null(y)){ y <- cars$dist; ty <- "Identidade"}
    ## Exibindo graficamente
    plot(y ~ x, pch=20, main = "Gráfico de Dispersão",
         xlab = paste(tx, "de X", sep=" "),
         ylab = paste(ty, "de Y", sep=" "))
    m0 <- lm(y ~ x)
    r <- summary(m0)$r.squared
    c <- round(cor(x, y), 3)
    msg <- sprintf("R²: %0.3f \nCor: %0.3f", r, c)
    if(svalue(reg)){
        abline(coef(m0), col=4)
        mtext(text = msg, side=3, cex=0.9, col=4,
              adj=0.05, line=-2)
    }
}

##----------------------------------------------------------------------
## Criando a interface.

win <- gwindow("Transformação de Variáveis")

tx <- gtable(trans, cont=win, height=100,
             handler = transformation)
names(tx) <- "Tranformação em X"

ty <- gtable(trans, cont=win, height=100,
             handler = transformation)
names(ty) <- "Tranformação em Y"

reg <- gcheckbox("Ajuste Regressão Linear", cont=win,
                 handler = transformation)

##----------------------------------------------------------------------
