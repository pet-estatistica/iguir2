require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

##----------------------------------------------------------------------

## Vetor vazio.
x <- integer()

## Simula o número de trocas ao lançar n vezes uma moeda equilibrada.
moeda <- function(n){
    sum(abs(diff(rbinom(n, 1, 0.5))))
}

seqnlanc <- function(...){
    ## seqx <- paste(x, collapse="")
    ## seqx <- rev(paste(
    ##     strwrap(x=paste(x, collapse=" "), width=20), "\n"))
    seqx <- rev(gsub(x=strwrap(x=paste(x, collapse=" "), width=20),
                     pattern="\\D", replacement=""))
    nx <- length(x)
    fmt <- sprintf("Número de lançamentos: %i", nx)
    return(list(seqx=seqx, nx=nx, fmt=fmt))
}

cara <- function(...){
    x <<- c(x, 1L)
    svalue(nlanc) <- seqnlanc()$fmt
    svalue(seqx) <- seqnlanc()$seqx
}
coro <- function(...){
    x <<- c(x, 0L)
    svalue(nlanc) <- seqnlanc()$fmt
    svalue(seqx) <- seqnlanc()$seqx
}

simul <- function(...){
    ## Número de simulações.
    N <- svalue(nsimul)
    ## Número de lançamentos.
    n <- length(x)
    ## Número de caras.
    k <- sum(x)
    ## Número de trocas de face.
    o <- sum(abs(diff(x)))
    ## Faz várias execuções do experimento aleatório.
    r <- replicate(N, moeda(n))
    ## P-valor bilateral empírico.
    p <- min(c(2*min(c(sum(r<=o), sum(r>=o)))/N, 1))
    ## Lista com todos os elementos.
    return(list(n=n, k=k, o=o, r=r, p=p, x=x, N=N))
}

plotresults <- function(...){
    with(simul(),{
        if(n<=20){
            ## stop("Pro favor, lance no mínimo 30 vezes.")
            gmessage(message="Lance pelo menos 20 vezes.",
                     title="Atenção!")
            ## stopifnot(n>10)
        } else {
            par(mar=c(5,4,3,2), family="Palatino")
            switch(ifelse(svalue(showhow)=="123", "triple", "single"),
                   "triple"=layout(matrix(c(1,2,1,3), 2, 2)),
                   "single"=layout(1))
            bks <- seq(min(c(r,o)), max(c(r,o))+1, by=1)-0.5
            ht <- hist(r, breaks=bks, plot=FALSE)
            if(svalue(teorico)){
                px <- dbinom(x=ht$mids, size=n-1, prob=0.5)
                sfun0  <- stepfun(ht$mids, cumsum(c(0,px)), f=0)
            }
            if(svalue(showhow)%in%c("1","123")){
                plot(ht$mids, ht$density, type="h", lwd=2,
                     ylim=c(0, 1.05*max(ht$density)),
                     xlab=sprintf(
                         "Número de trocas em %i lançamentos", n),
                     ylab="Probabilidade",
                     sub=sprintf("%i simulações", N))
                if(svalue(teorico)){
                    points(ht$mids+0.1, px, type="h", col="blue", lwd=2)
                    pb <- 2*pbinom(q=min(c(o, n-o-1)), size=n-1, p=0.5)
                    mtext(side=3, line=0, col="blue",
                          text=sprintf(
                              "P-valor bilateral teórico: %0.4f", pb))
                }
                abline(v=o, col=2)
                text(x=o, y=par()$usr[4],
                     label="Estatística observada",
                     srt=90, adj=c(1.25,-0.25))
                mtext(side=3, line=1,
                      text=sprintf(
                          "P-valor bilateral empírico: %0.4f", p))
                mtext(side=3, line=2,
                      text=sprintf(
                          "Trocas observadas: %i\t Número de caras: %i",
                          o, k))
            }
            if(svalue(showhow)%in%c("2","123")){
                plot(cumsum(x)/seq_along(x), type="l", ylim=c(0,1),
                     ylab="Frequência de face cara",
                     xlab="Número do lançamento")
                abline(h=0.5, lty=2)
            }
            if(svalue(showhow)%in%c("3","123")){
                plot(ecdf(r), verticals=FALSE, cex=NA,
                     main=NULL, xlim=range(bks),
                     xlab=sprintf(
                         "Número de trocas em %i lançamentos", n),
                     ylab="Probabilidade acumulada",
                     sub=sprintf("%i simulações", N))
                if(svalue(teorico)){
                    plot(x=sfun0, xval=ht$mids, verticals=FALSE,
                         add=TRUE, col="blue")
                }
                ## abline(h=seq(0.05, 0.95, by=0.05),
                ##        lty=2, col="gray50")
                abline(v=o, col=2)
                text(x=o, y=par()$usr[4],
                     label="Estatística observada",
                     srt=90, adj=c(1.25,-0.25))
            }
        }
    })
}

##-----------------------------------------------------------------------------
## Construção da interface.

w <- gwindow(title="Lançar moedas", visible=FALSE)
g <- ggroup(horizontal=FALSE, container=w)
lyt <- glayout(container=g, spacing=2)
lyt[1,1] <- (caraB <-
    gbutton(text="Cara",
            handler=cara,
            container=lyt))
lyt[1,2] <- (coroB <-
    gbutton(text="Coroa",
            handler=coro,
            container=lyt))
lyt[2,1:2, expand=TRUE] <- (nlanc <-
    glabel(text="Número de lançamentos:",
           container=lyt))
glabel(text="Sequência de valores:",
       container=g)
seqx <- gtext(text="", container=g,
              width=200, height=120)
a <- gexpandgroup(text="Avançado", container=g,
                  horizontal=FALSE)
teorico <- gcheckbox(text="Mostrar distribuição teórica.",
                     checked=FALSE, action=plotresults,
                     container=a)
glabel(text="Número de simulações:", container=a)
nsimul <- gradio(items=c(100,500,1000,5000,10000),
                 horizontal=TRUE, selected=4,
                 action=simul, container=a)
glabel(text="Disposição e gráficos:", container=a)
showhow <- gradio(items=c("1","2","3","123"),
                  horizontal=TRUE, selected=4,
                  action=plotresults, container=a)
lyu <- glayout(container=g, spacing=2)
lyu[1,1, expand=TRUE] <- (results <-
    gbutton(text="Processar!",
            handler=plotresults, container=lyu))
lyu[2,1, expand=TRUE] <- (new <-
    gbutton(text="Limpar e recomeçar!", container=lyu,
            handler=function(...){
                x <<- integer()
                svalue(nlanc) <- "Número de lançamentos:"
                svalue(seqx) <- ""
            }))
visible(w) <- TRUE

##----------------------------------------------------------------------
