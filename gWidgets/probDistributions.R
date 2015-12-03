require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

##----------------------------------------------------------------------

selDist.pdf <- function(...){
    switch(svalue(dist),
           "Normal"=norm.pdf(),
           "Exponencial"=exp.pdf(),
           "Poisson"=pois.pdf()
           )
}
dists <- c("Normal", "Exponencial", "Poisson")

##----------------------------------------------------------------------
## Abre outra janela.

norm.pdf <- function(){
    f <- function(...){
        curve(dnorm(x, mean=svalue(m), sd=svalue(s)),
              from=-4, to=4, ylim=c(0,0.6),
              xlab="x", ylab="f(x)")
    }
    w2 <- gwindow(title="Distribuição Normal",
                  width=500, parent=w1)
    g <- ggroup(container=w2, horizontal=FALSE)
    glabel(text="Média", container=g)
    m <- gslider(from=-1, to=1, by=0.1, value=0, handler=f, container=g)
    glabel(text="Variância", container=g)
    s <- gslider(from=0.1, to=2, by=0.1, value=1, handler=f,
                 container=g)
    gbutton(text="Fechar", container=g,
            handler=function(...){
                dispose(w2)
            })
}

exp.pdf <- function(){
    f <- function(...){
        curve(dexp(x, rate=svalue(r)),
              from=0, to=5, ylim=c(0,1.6),
              xlab="x", ylab="f(x)")
    }
    w2 <- gwindow(title="Distribuição exponencial",
                  width=500, parent=w1)
    g <- ggroup(container=w2, horizontal=FALSE)
    glabel(text="Taxa", container=g)
    r <- gslider(from=0, to=5, by=0.1, value=1, handler=f, container=g)
    gbutton(text="Fechar", container=g,
            handler=function(...){
                dispose(w2)
            })
}

pois.pdf <- function(){
    f <- function(...){
        x <- 0:30
        px <- dpois(x, lambda=svalue(l))
        plot(px~x, type="h", ylim=c(0,0.25),
             xlab="x", ylab="p(x)")
        points(x=x, y=px, pch=19, cex=0.8)
    }
    w2 <- gwindow(title="Distribuição de Poisson",
                  width=500, parent=w1)
    g <- ggroup(container=w2, horizontal=FALSE)
    glabel(text="Média", container=g)
    l <- gslider(from=0, to=20, by=0.5, value=5, handler=f, container=g)
    gbutton(text="Fechar", container=g,
            handler=function(...){
                dispose(w2)
            })
}

w1 <- gwindow(title="Distribuições de probabilidade",
              width=300)
g1 <- gframe(text="Escolha a distribuição.", container=w1)
dist <- gradio(items=dists, selected=0L, container=g1,
               handler=selDist.pdf)
