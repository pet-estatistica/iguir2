require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

## library(RGtk2)
## library(gWidgets)
## library(gWidgetsRGtk2)
## options(guiToolkit="RGtk2")

##-----------------------------------------------------------------------------

## Faz polígono para destacar região de não rejeição de H0.
pol <- function(m1, s, lim,
                col=rgb(0.5,0.5,0.5,0.5), border=NA, ...){
    xx <- seq(lim[1], lim[2],
              length.out=floor(100*diff(lim)/diff(par()$usr[1:2])))
    yy <- dnorm(xx, m1, s)
    xx <- c(lim[1], xx, lim[2])
    yy <- c(0, yy, 0)
    polygon(x=xx, y=yy, col=col, border=border, ...)
}

## Faz o polígono nas caudas, regiões de rejeição de H0.
cau <- function(m0, s, lim, ...){
    parlim <- par()$usr[1:2]
    reglim <- lim
    ## Left.
    lim <- c(parlim[1], reglim[1])
    pol(m0, s, lim, ...)
    ## Right.
    lim <- c(reglim[2], parlim[2])
    pol(m0, s, lim, ...)
}

## Calcula o poder do teste.
power <- function(m1, s, z){
    p <- pnorm(z, m1, s)
    diff(p)
}
power <- Vectorize(FUN=power, vectorize.args="m1")

## Faz a figura.

## dofig <- function(m0=0, m=0.5, s=1, n=10, alpha=0.9, delta=2,
##                   xlim=m0+c(-1,1)*delta*s,
##                   fillcenter=rgb(0.5,0.5,0.5,0.5),
##                   filltails=rgb(0.95,0.15,0.15,0.75)){
dofig <- function(...){
    m0 <- svalue(m0)
    m <- svalue(m)
    s <- svalue(s)
    n <- svalue(n)
    alpha <- svalue(alpha)
    ## delta <- svalue(delta)
    xlim <- m0+c(-1,1)*svalue(r)
    fillcenter <- rgb(0.5,0.5,0.5,0.5)
    filltails <- rgb(0.95,0.15,0.15,0.75)
    ## m0 <- 0; m <- 0.5; s <- 1; n <- 20; alpha <- 0.8; delta <- 2
    ## fillcenter <- rgb(0.5,0.5,0.5,0.5)
    ## filltails <- rgb(0.95,0.15,0.15,0.75)
    sm <- s/sqrt(n)
    p <- c(0, alpha)+(1-alpha)/2
    z <- qnorm(p, mean=m0, sd=sm)
    ## xlim <- m0+c(-1,1)*delta*s
    mvals <- seq(xlim[1], xlim[2], length.out=100)
    pwvals <- 1-power(mvals, s=sm, z=z)
    par(mfrow=c(2,1), mar=c(3,4.4,2,2.5))
    curve(dnorm(x, m0, sm), xlim[1], xlim[2],
          ## xaxt="n", yaxt="n",
          xlab=NA, ylab=NA)
    axis(side=1, at=c(m0, m),
         labels=expression(mu[0], mu),
         tick=FALSE, line=1.25)
    cau(m0, sm, lim=z, col=filltails)
    pol(m=m, s=sm, lim=z)
    curve(dnorm(x, m, sm), add=TRUE, lty=2)
    segments(x0=m0, x1=m0,
             y0=0, y1=dnorm(m0, m0, sm))
    segments(x0=m, x1=m,
             y0=0, y1=dnorm(m, m, sm),
             lty=2)
    title(main=expression(H[0]*":"~mu==mu[0]))
    legend(y=sum(c(0,1.15)*par()$usr[3:4]),
           x=sum(c(0.1,0.79)*par()$usr[1:2]),
           xpd=TRUE, bty="n", fill=fillcenter,
           legend=sprintf("%0.4f", power(m1=m, s=sm, z=z)))
    plot(pwvals~mvals, ylim=c(0,1), type="l",
         xaxt="n", yaxt="n",
         xlab=NA, ylab=NA)
    pw <- 1-power(m, s=sm, z=z)
    abline(v=0, h=1-alpha, lty=3)
    abline(v=m, h=pw, lty=2)
    axis(side=1, at=c(m0, m),
         labels=expression(mu[0], mu), tick=TRUE)
    axis(side=2, at=pw,
         labels=sprintf("%0.4f", pw), las=2)
    axis(side=4)
}

##-----------------------------------------------------------------------------

w <- gwindow(title="Poder do teste", visible=FALSE)
g <- gpanedgroup(horizontal=FALSE, container=w)
##--------------------------------------------
gfa <- gframe(text="Nível de significância do teste:", container=g)
alpha <- gspinbutton(from=0.8, to=0.99, by=0.01,
                     handler=dofig,
                     container=gfa)
svalue(alpha) <- 0.9
##--------------------------------------------
gfn <- gframe(text="Tamanho da amostra de X (n):", container=g)
n <- gspinbutton(from=3, to=50, by=1,
                 handler=dofig,
                 container=gfn)
svalue(n) <- 10
##--------------------------------------------
gfm0 <- gframe(text="Média de X sob H0 (mu0):", container=g)
m0 <- gspinbutton(from=-2, to=2, by=0.1,
                  handler=dofig,
                  container=gfm0)
svalue(m0) <- 0
##--------------------------------------------
gfs <- gframe(text="Desvio-padrão de X (s):", container=g)
s <- gslider(from=0.1, to=6, by=0.05,
             handler=dofig,
             container=gfs)
svalue(s) <- 1
##--------------------------------------------
gfm <- gframe(text="Média de X (mu):", container=g)
m <- gslider(from=svalue(m0)-10*svalue(s)/sqrt(svalue(n)),
             to=svalue(m0)+10*svalue(s)/sqrt(svalue(n)),
             length.out=50,
             handler=dofig,
             container=gfm)
svalue(m) <- svalue(m0)
##--------------------------------------------
gfr <- gframe(text="Fator de amplitude de eixo:", container=g)
r <- gedit(text=5, coerce.with=as.numeric,
           handler=dofig,
           container=gfr)
svalue(r) <- 5
##--------------------------------------------
visible(w) <- TRUE


