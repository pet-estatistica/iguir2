##----------------------------------------------------------------------
## Metropolis Random Walk.

## Ilustrando o procedimento (com um exemplo bem simples). Obter
## realizações de uma distribuição Normal(0, 1) X~f. Definir a
## distribuição candidata Y~g como sendo a uniforme(-delta, delta) que é
## simétrica.

## Avalia a densidade da distribuição alvo.
f <- function(x, mu=0, sigma=1) dnorm(x, mu, sigma)

## Simula números aleatórios canditatos.
g <- function(delta, xi){
    ## delta e xi: escalares parâmetros da distribuição candidata.
    ## A distribuição candidata é a uniforme.
    ## Retorna uma realização da distribuição candidata.
    runif(1, xi-delta, xi+delta)      
}

curve(f(x, 0, 1), -4, 4)
curve(dunif(x, 0-2, 0+2), add=TRUE, col=2)

## Vetor com elementos n elementos.
n <- 10
x <- vector(mode="numeric", length=n)
i <- 2

## 1. Definir um valor inicial dentro do suporte da distribuição alvo
## X.
x[i-1] <- 0.5

## 2. Gerar um número da distribuição candidata Y.
y <- g(delta=1, xi=x[i-1]); y

## 3. Calcular a quantidade r = (f(y)/f(x_{i-1}))
r <- (f(y)/f(x[i-1])); r

## 4. Gerar um número aleatório da distribuição uniforme.
u <- runif(1); u

## 5. Se u<r, aceitar o canditado, se não, rejeitar e repetir o último
## número gerado.
if (u<r){
    x[i] <- y
    print("u<r, então novo valor y na cadeia.")
} else {
    x[i] <- x[i-1]
    print("u>=r, então último valor da cadeia repetido.")
}

## 6. Repetir os passos de 2-6.
i <- i+1

##----------------------------------------------------------------------

rwsampler <- function(nsim, x1,
                      delta, mu, sigma,
                      plot=FALSE,
                      go=c("click", "console", "none")){
    out <- vector(mode="numeric", length=nsim)
    out[1] <- x1
    for(i in 2:nsim){
        ## Realização da distribuição alvo.
        if(plot & go[1]=="click"){
            can <- locator(n=1)$x
        } else {
            can <- g(delta, xi=out[i-1])
        }
        dn1 <- dnorm(can, mu, sigma)
        dn0 <- dnorm(out[i-1], mu, sigma)
        ratio <- dn1/dn0
        u <- runif(1)
        if(u<ratio) out[i] <- can else out[i] <- out[i-1]
        if(plot & nsim<=20){
            par(mfrow=c(1,2))
            curve(dnorm(x, mu, sigma), mu-4*sigma, mu+4*sigma,
                  ylab="densidade")
            curve(dunif(x, out[i-1]-delta, out[i-1]+delta),
                  add=TRUE, lty=2)
            du <- dunif(can, out[i-1]-delta, out[i-1]+delta)
            ## segments(can, du, can, 0, col=4)
            segments(can, dn1, can, 0, col=2);
            segments(out[i-1], dn0, out[i-1], 0, col=4);
            cex <- 2.5; col="yellow"
            points(can, dn1, pch=19, cex=cex, col="green");
            points(out[i-1], dn0, pch=19, cex=cex, col=col);            
            ## points(can, dn1, pch="N");
            ## points(out[i-1], dn0, pch="n");
            text(can, dn1, expression(f[X]));
            text(out[i-1], dn0, expression(f[X]));
            ex <- substitute(frac(f[X](x[i]),
                                  f[X](x[i-1]))*" = "*
                             frac(dn1, dn0)==ratio,
                             list(dn1=dn1, dn0=dn0, ratio=ratio))
            r <- substitute("u = "~u<ratio,
                            list(ratio=ratio, u=u))
            mtext(ex, side=3, line=1, adj=0)
            mtext(r, side=3, line=2, adj=1)
            mtext(sprintf("então %s",
                          ifelse(u<ratio, "aceita", "rejeita")),
                  side=3, line=1, adj=1)
            plot(out[1:i], xlim=c(0, nsim+1), ylim=c(-4,4), type="o",
                 ylab=expression(x[i]), xlab=expression(i))
            switch(go[1],
                   click=locator(n=1),
                   console=readline(prompt="Press [enter] to continue"),
                   sleep=Sys.sleep(0.5),
                   none=NULL)
        }
    }
    return(out)
}

##----------------------------------------------------------------------
## Usando.

mu <- 0; sigma <- 1

## x <- rwsampler(nsim=10, x1=-1, delta=2,
##                mu, sigma, plot=TRUE, go="click")

x <- rwsampler(nsim=20, x1=-1, delta=2,
               mu, sigma, plot=TRUE, go="none")

library(animation)

saveHTML(rwsampler(nsim=20, x1=-1, delta=2,
                   mu, sigma, plot=TRUE, go="none"),
         img.name="rw",
         imgdir="rw",
         interval=0.5,
         htmlfile="rw.html",
         ani.width=800, ani.height=400,
         verbose=FALSE,
         autoplay=TRUE,
         autobrowse=FALSE)

saveGIF(rwsampler(nsim=20, x1=-1, delta=2,
                  mu, sigma, plot=TRUE, go="none"),
        img.name="rw",
        interval=0.5,
        movie.name="rw.gif",
        ani.width=800, ani.height=400,
        verbose=FALSE, autobrowse=FALSE)

## Apagar diretórios e arquivos.
file.remove(c("rw.gif", "rw.html"))
system("rm -r css js rw")

##----------------------------------------------------------------------
## Com muitos valores.

mu <- 0; sigma <- 1
x <- rwsampler(nsim=5000, x1=0, delta=5, mu, sigma, go="none")

par(mfrow=c(2,2))
plot(x, type="l")        ## Traço da cadeia completa.
plot(x[1:100], type="l") ## Traço do começo da cadeia.
acf(x)                   ## Mostra que a cadeia não é independente.
plot(ecdf(x))            ## Acumulada teórica vs empírica.
curve(pnorm(x), add=TRUE, col=2); layout(1)

##----------------------------------------------------------------------
## Simular de uma mistura de normais. Normais com variância 1 e mistura
## 1:1.

k <- 0.5
curve(k*dnorm(x, 0, 1)+(1-k)*dnorm(x, 7, 1), -3, 10)
curve(0.1*dunif(x), add=TRUE, col=2, n=1024)

rwsamplerMistura <- function(nsim, x1, delta,
                             plot=FALSE,
                             go=c("click","enter","none")){
    out <- vector(mode="numeric", length=nsim)
    out[1] <- x1
    for(i in 2:nsim){
        ## Realização da distribuição alvo.
        if (plot & go[1]=="click"){
            can <- locator(n=1)$x
        } else {
            can <- g(delta, xi=out[i-1])
        }
        dn1 <- k*dnorm(can, 0, 1)+(1-k)*dnorm(can, 7, 1)
        dn0 <- k*dnorm(out[i-1], 0, 1)+(1-k)*dnorm(out[i-1], 7, 1)
        ratio <- dn1/dn0
        u <- runif(1)
        if(u<ratio) out[i] <- can else out[i] <- out[i-1]
        if(plot & nsim<=50){
            par(mfrow=c(1,2))
            curve(k*dnorm(x, 0, 1)+(1-k)*dnorm(x, 7, 1), -3, 10,
                  ylab="densidade")
            curve(0.3*dunif(x, out[i-1]-delta, out[i-1]+delta),
                  add=TRUE, lty=2)
            du <- dunif(can, out[i-1]-delta, out[i-1]+delta)
            ## segments(can, du, can, 0, col=4)
            segments(can, dn1, can, 0, col=2);
            segments(out[i-1], dn0, out[i-1], 0, col=4);
            cex <- 2.5; col="yellow"
            points(can, dn1, pch=19, cex=cex, col="green");
            points(out[i-1], dn0, pch=19, cex=cex, col=col);            
            ## points(can, dn1, pch="N");
            ## points(out[i-1], dn0, pch="n");
            text(can, dn1, expression(f[X]));
            text(out[i-1], dn0, expression(f[X]));
            ex <- substitute(frac(f[X](x[i]),
                                  f[X](x[i-1]))*" = "*
                             frac(dn1, dn0)==ratio,
                             list(dn1=dn1, dn0=dn0, ratio=ratio))
            r <- substitute("u = "~u<ratio,
                            list(ratio=ratio, u=u))
            mtext(ex, side=3, line=1, adj=0)
            mtext(r, side=3, line=2, adj=1)
            mtext(sprintf("então %s",
                          ifelse(u<ratio, "aceita", "rejeita")),
                  side=3, line=1, adj=1)
            plot(out[1:i], xlim=c(0, nsim+1), ylim=c(-3,10), type="o",
                 ylab=expression(x[i]), xlab=expression(i))
            switch(go[1],
                   click=locator(n=1),
                   console=readline(prompt="Press [enter] to continue"),
                   sleep=Sys.sleep(0.5),
                   none=NULL)
        }
    }
    return(out)
}

##----------------------------------------------------------------------
## Usando.

x <- rwsamplerMistura(nsim=20, x1=1, delta=4, plot=TRUE, go="sleep")

saveHTML(rwsamplerMistura(nsim=50, x1=runif(1, 0, 7), delta=4,
                          plot=TRUE, go="none"),
         img.name="rwm",
         imgdir="rwm",
         interval=0.5,
         htmlfile="rwm.html",
         ani.width=800, ani.height=400,
         verbose=FALSE,
         autoplay=TRUE,
         autobrowse=FALSE)

saveGIF(rwsamplerMistura(nsim=50, x1=runif(1, 0, 7), delta=4,
                         plot=TRUE, go="none"),
        img.name="rwm",
        interval=0.5,
        movie.name="rwm.gif",
        ani.width=800, ani.height=400,
        verbose=FALSE, autobrowse=FALSE)

## Apagar diretórios e arquivos.
file.remove(c("rwm.gif", "rwm.html"))
system("rm -r css js rwm")

##----------------------------------------------------------------------
## Muitos valores.

## Janela estreita.
set.seed(123)
x <- rwsamplerMistura(nsim=20000, x1=1, delta=0.9, plot=FALSE)

par(mfrow=c(2,2))
plot(x, type="l")        ## Traço da cadeia completa.
plot(x[1:100], type="l") ## Traço do começo da cadeia.
acf(x)                   ## Mostra que a cadeia não é independente.
plot(ecdf(x))            ## Acumulada teórica vs empírica.
curve(k*pnorm(x, 0, 1)+(1-k)*pnorm(x, 7, 1), add=TRUE, col=2); layout(1)

prop.table(table(x<3.5))

## Janela larga.
set.seed(123)
x <- rwsamplerMistura(nsim=20000, x1=1, delta=4, plot=FALSE)

par(mfrow=c(2,2))
plot(x, type="l")        ## Traço da cadeia completa.
plot(x[1:100], type="l") ## Traço do começo da cadeia.
acf(x)                   ## Mostra que a cadeia não é independente.
plot(ecdf(x))            ## Acumulada teórica vs empírica.
curve(k*pnorm(x, 0, 1)+(1-k)*pnorm(x, 7, 1), add=TRUE, col=2); layout(1)

prop.table(table(x<3.5))

##----------------------------------------------------------------------
