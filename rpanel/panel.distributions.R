##----------------------------------------------------------------------
## Definições da sessão.

## Pacote para janelas interativas.
require(rpanel)

##----------------------------------------------------------------------
## Distribuição binomial.

pb <- function(panel){
    with(panel,
         {
             x <- 0:size
             px <- dbinom(x, size=size, prob=prob)
             plot(px~x, type="h", ylim=c(0,max(c(px), 0.5)))
             if(showEX){
                 abline(v=size*prob, col=2)
             }
         })
    panel
}

panel <- rp.control(title="Binomial", size=c(300,100))
rp.slider(panel, size, from=2, to=80, initval=10, resolution=1,
          action=pb, showvalue=TRUE, title="size")
rp.slider(panel, prob, from=0.01, to=0.99, initval=0.5, resolution=0.01,
          action=pb, showvalue=TRUE, title="prob")
rp.checkbox(panel, showEX, action=pb, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição de Poisson.

pp <- function(panel){
    with(panel,
         {
             x <- 0:100
             px <- dpois(x, lambda=lambda)
             plot(px~x, type="h", ylim=c(0,max(c(px),0.5)))
             if(showEX){
                 abline(v=lambda, col=2)
             }
         })
    panel
}

panel <- rp.control(title="Poisson", size=c(300,100))
rp.slider(panel, lambda, from=0.5, to=90, initval=10, resolution=0.25,
          action=pp, showvalue=TRUE, title="lambda")
rp.checkbox(panel, showEX, action=pp, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição binomial negativa.

pbn <- function(panel){
    with(panel,
         {
             x <- 0:size
             px <- dnbinom(x, size=size, prob=prob)
             plot(px~x, type="h", ylim=c(0,max(c(px), 0.5)))
             if(showEX){
                 abline(v=size*(1-prob)/prob, col=2)
             }
         })
    panel
}

panel <- rp.control(title="Binomial negativa", size=c(300,100))
rp.slider(panel, size, from=2, to=80, initval=10, resolution=1,
          action=pbn, showvalue=TRUE, title="size")
rp.slider(panel, prob, from=0.01, to=0.99, initval=0.5, resolution=0.01,
          action=pbn, showvalue=TRUE, title="prob")
rp.checkbox(panel, showEX, action=pbn, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição hipergeométrica.

## m the number of white balls in the urn.
## n the number of black balls in the urn.
## k the number of balls drawn from the urn.
## x the number of white balls drawn without replacement.

ph <- function(panel){
    with(panel,
         {
             x <- max(c(0, k-m)):min(c(k, m))
             ## p(x) = choose(m, x) choose(n, k-x) / choose(m+n, k)
             px <- dhyper(x, m=m, n=n, k=k)
             plot(px~x, type="h", ylim=c(0, max(c(px), 0.5)))
             if(showEX){
                 abline(v=k*m/(m+n), col=2)
             }
         })
    panel
}

panel <- rp.control(title="Hipergeométrica", size=c(300,100))
rp.slider(panel, m, from=5, to=30, initval=10, resolution=1,
          action=ph, showvalue=TRUE, title="Brancas")
rp.slider(panel, n, from=2, to=15, initval=5, resolution=1,
          action=ph, showvalue=TRUE, title="Pretas")
rp.slider(panel, k, from=2, to=15, initval=5, resolution=1,
          action=ph, showvalue=TRUE, title="Retiradas")
rp.checkbox(panel, showEX, action=ph, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição normal.

pn <- function(panel){
    with(panel,
         {
             curve(dnorm(x, mean=mean, sd=sd), -5, 5,
                   ylim=c(0,1))
             if(showEX){
                 abline(v=mean, col=2)
             }
             if(showVX){
                 d <- dnorm(mean+sd, mean, sd)
                 segments(mean-sd, d, mean+sd, d, col=2)
             }
         })
    panel
}

panel <- rp.control(title="Normal", size=c(300,100))
rp.slider(panel, mean, from=-4, to=4, initval=0, resolution=0.1,
          action=pn, showvalue=TRUE, title="mean")
rp.slider(panel, sd, from=0, to=3, initval=1, resolution=0.1,
          action=pn, showvalue=TRUE, title="sd")
rp.checkbox(panel, showEX, action=pn, title="E(X)",
            labels="Mostrar o valor esperado?")
rp.checkbox(panel, showVX, action=pn, title="sd(X)",
            labels="Mostrar o desvio-padrão?")

##----------------------------------------------------------------------
## Distribuição beta.

pbt <- function(panel){
    with(panel,
         {
             curve(dbeta(x, shape1=exp(sh1), shape2=exp(sh2)), 0, 1,
                   ylim=c(0,7))
             if(showEX){
                 abline(v=exp(sh1)/(exp(sh1)+exp(sh2)), col=2)
             }
         })
    panel
}

panel <- rp.control(title="Beta", size=c(300,100))
rp.slider(panel, sh1, from=-5, to=5, initval=0, resolution=0.1,
          action=pbt, showvalue=TRUE, title="log(shape1)")
rp.slider(panel, sh2, from=-5, to=5, initval=0, resolution=0.1,
          action=pbt, showvalue=TRUE, title="log(shape2)")
rp.checkbox(panel, showEX, action=pbt, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição gamma.

pg <- function(panel){
    with(panel,
         {
             curve(dgamma(x, shape=shape, scale=scale), 0, 50,
                   ylim=c(0, 0.25))
             if(showEX){
                 abline(v=shape*scale, col=2)
             }
         })
    panel
}

panel <- rp.control(title="Gamma", size=c(300,100))
rp.slider(panel, shape, from=0.1, to=20, initval=5, resolution=0.1,
          action=pg, showvalue=TRUE, title="shape")
rp.slider(panel, scale, from=0.1, to=10, initval=3, resolution=0.1,
          action=pg, showvalue=TRUE, title="scale")
rp.checkbox(panel, showEX, action=pg, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------
## Distribuição Weibull.

pw <- function(panel){
    with(panel,
         {
             curve(dweibull(x, shape=shape, scale=scale), 0, 50,
                   ylim=c(0, 0.25))
             if(showEX){
                 abline(v=scale*gamma(1+1/shape), col=2)
             }
         })
    panel
}

panel <- rp.control(title="Weibull", size=c(300,100))
rp.slider(panel, shape, from=0.1, to=10, initval=5, resolution=0.1,
          action=pw, showvalue=TRUE, title="shape")
rp.slider(panel, scale, from=0.1, to=30, initval=20, resolution=0.1,
          action=pw, showvalue=TRUE, title="scale")
rp.checkbox(panel, showEX, action=pw, title="E(X)",
            labels="Mostrar o valor esperado?")

##----------------------------------------------------------------------

panel <- rp.control(title="Statistical distributions")
rp.notebook(panel,
            tabs=c(
                "Binomial", "Poisson", "BNeg", "Hiperg",
                "Normal", "Beta", "Gama", "Weibull"),
            width=600, height=400,
            pos=list(row=0, column=0),
            ## background="red",
            ## font="Arial",
            name="main")

##--------------------------------------------
## panel <- rp.control(title="Binomial", size=c(300,100))
rp.slider(panel, size, from=2, to=80, initval=10, resolution=1,
          action=pb, showvalue=TRUE, title="size",
          parentname="Binomial")
rp.slider(panel, prob, from=0.01, to=0.99, initval=0.5, resolution=0.01,
          action=pb, showvalue=TRUE, title="prob",
          parentname="Binomial")
rp.checkbox(panel, showEX, action=pb, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Binomial")

##--------------------------------------------
## panel <- rp.control(title="Poisson", size=c(300,100))
rp.slider(panel, lambda, from=0.5, to=90, initval=10, resolution=0.25,
          action=pp, showvalue=TRUE, title="lambda",
          parentname="Poisson")
rp.checkbox(panel, showEX, action=pp, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Poisson")

##--------------------------------------------
## panel <- rp.control(title="Binomial negativa", size=c(300,100))
rp.slider(panel, size, from=2, to=80, initval=10, resolution=1,
          action=pbn, showvalue=TRUE, title="size", parentname="BNeg")
rp.slider(panel, prob, from=0.01, to=0.99, initval=0.5, resolution=0.01,
          action=pbn, showvalue=TRUE, title="prob", parentname="BNeg")
rp.checkbox(panel, showEX, action=pbn, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="BNeg")

##--------------------------------------------
## panel <- rp.control(title="Hipergeométrica", size=c(300,100))
rp.slider(panel, m, from=5, to=30, initval=10, resolution=1,
          action=ph, showvalue=TRUE, title="Brancas",
          parentname="Hiperg")
rp.slider(panel, n, from=2, to=15, initval=5, resolution=1,
          action=ph, showvalue=TRUE, title="Pretas",
          parentname="Hiperg")
rp.slider(panel, k, from=2, to=15, initval=5, resolution=1,
          action=ph, showvalue=TRUE, title="Retiradas",
          parentname="Hiperg")
rp.checkbox(panel, showEX, action=ph, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Hiperg")

##--------------------------------------------
## panel <- rp.control(title="Normal", size=c(300,100))
rp.slider(panel, mean, from=-4, to=4, initval=0, resolution=0.1,
          action=pn, showvalue=TRUE, title="mean", parentname="Normal")
rp.slider(panel, sd, from=0, to=3, initval=1, resolution=0.1,
          action=pn, showvalue=TRUE, title="sd", parentname="Normal")
rp.checkbox(panel, showEX, action=pn, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Normal")
rp.checkbox(panel, showVX, action=pn, title="sd(X)",
            labels="Mostrar o desvio-padrão?", parentname="Normal")

##--------------------------------------------
## panel <- rp.control(title="Beta", size=c(300,100))
rp.slider(panel, sh1, from=-5, to=5, initval=0, resolution=0.1,
          action=pbt, showvalue=TRUE, title="log(shape1)",
          parentname="Beta")
rp.slider(panel, sh2, from=-5, to=5, initval=0, resolution=0.1,
          action=pbt, showvalue=TRUE, title="log(shape2)",
          parentname="Beta")
rp.checkbox(panel, showEX, action=pbt, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Beta")

##--------------------------------------------
## panel <- rp.control(title="Gamma", size=c(300,100))
rp.slider(panel, shape, from=0.1, to=20, initval=5, resolution=0.1,
          action=pg, showvalue=TRUE, title="shape", parentname="Gama")
rp.slider(panel, scale, from=0.1, to=10, initval=3, resolution=0.1,
          action=pg, showvalue=TRUE, title="scale", parentname="Gama")
rp.checkbox(panel, showEX, action=pg, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Gama")

##--------------------------------------------
## panel <- rp.control(title="Weibull", size=c(300,100))
rp.slider(panel, shape, from=0.1, to=10, initval=5, resolution=0.1,
          action=pw, showvalue=TRUE, title="shape",
          parentname="Weibull")
rp.slider(panel, scale, from=0.1, to=30, initval=20, resolution=0.1,
          action=pw, showvalue=TRUE, title="scale",
          parentname="Weibull")
rp.checkbox(panel, showEX, action=pw, title="E(X)",
            labels="Mostrar o valor esperado?", parentname="Weibull")

##----------------------------------------------------------------------

