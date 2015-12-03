##----------------------------------------------------------------------
## Definições da sessão.

sourceUrl <- 
    "https://raw.githubusercontent.com/walmes/wzRfun/master/R/rp.nls.R"

## source(sourceUrl)
download.file(url=sourceUrl,
              dest="rp.nls.R")
source("rp.nls.R")

library(rpanel)
library(latticeExtra)

##----------------------------------------------------------------------
## Regressão linear simples.

rp.nls(model=dist~b0+b1*speed,
       data=cars,
       start=list(
           b0=c(init=0, from=-20, to=20),
           b1=c(init=2, from=0, to=10)),
       assignTo="cars.fit")

cars.fit

##----------------------------------------------------------------------
## Um exemplo mais interessante.

xyplot(rate~conc, groups=state, data=Puromycin)

rp.nls(model=rate~Int+(Top-Int)*conc/(Half+conc),
       data=Puromycin,
       start=list(
           Int=c(init=50, from=20, to=70),
           Top=c(init=150, from=100, to=200),
           Half=c(init=0.1, from=0, to=0.6)),
       subset="state",
       assignTo="Puro.fit",
       startCurve=list(col=3, lty=3, lwd=1),
       fittedCurve=list(col=4, lty=1, lwd=1.5),
       extraplot=function(Int, Top, Half){
           abline(h=c(Int, Top), v=Half, col=2, lty=2)
       },
       finalplot=function(Int, Top, Half){
           abline(h=c(Int, Top), v=Half, col=3, lty=1)
       },
       xlab="Concentration",
       ylab="Rate",
       xlim=c(0, 1.2),
       ylim=c(40, 220))

length(Puro.fit)
sapply(Puro.fit, coef)
sapply(Puro.fit, logLik)
sapply(Puro.fit, deviance)

##======================================================================
## MAIS CASOS.

##----------------------------------------------------------------------
## 1. Ajuste de curvas de retenção de água do solo.

cra <- read.table("http://www.leg.ufpr.br/~walmes/data/cra_manejo.txt",
                  header=TRUE, sep="\t")

cra$tens[cra$tens==0] <- 0.1
cras <- subset(cra, condi=="LVA3,5")
cras <- aggregate(umid~posi+prof+tens, data=cras, FUN=mean)
cras$caso <- with(cras, interaction(posi, prof))
cras$ltens <- log(cras$tens)

xyplot(umid~ltens|posi, groups=prof, data=cras, type=c("p","a"))

## modelo: van Genuchten com retrição de Mualem.
## x: representado por ltens (log da tensão matricial, psi).
## y: representado por umid, conteúdo de água do solo (%).
## th1: assíntota inferior, mínimo da função, quando x -> +infinito.
## th2: assíntota superior, máximo da função, quando x -> -infinito.
## th3: locação, translada o ponto de inflexão.
## th4: forma, altera a taxa ao redor da inflexão.

model <- umid~Ur+(Us-Ur)/(1+exp(n*(al+ltens)))^(1-1/n)
start <- list(Ur=c(init=0.2, from=0, to=0.5),
              Us=c(init=0.6, from=0.4, to=0.8),
              al=c(1, -2, 4),
              n=c(1.5, 1, 4))

rp.nls(model=model, data=cras,
       start=start, subset="caso",
       assignTo="cra.fit")

sapply(cra.fit, coef)
lapply(cra.fit, summary)

##----------------------------------------------------------------------
## 2. Curva de produção em função da desfolha do algodão.

cap <- read.table("http://www.leg.ufpr.br/~walmes/data/algodão.txt",
                  header=TRUE, sep="\t", encoding="latin1")

cap$desf <- cap$desf/100
cap <- subset(cap, select=c(estag, desf, pcapu))
cap$estag <- factor(cap$estag, labels=c("vegetativo","botão floral",
                                 "florescimento","maçã","capulho"))
str(cap)

xyplot(pcapu~desf|estag, data=cap, layout=c(5,1),
       xlab="Nível de desfolha artificial", ylab="Peso de capulhos")

## modelo: potência.
## x: representado por desf (nível de desfolha artifical).
## y: representado por pcapu (peso de capulhos), produto do algodão.
## th1: intercepto, valor da função quando x=0 (situação ótima).
## th2: diferença no valor da função para x=0 e x=1 (situação extrema).
## th3: forma, indica como a função decresce, se th3=0 então função
## linear.

model <- pcapu~f0-delta*desf^exp(curv)
start <- list(f0=c(30,25,35), delta=c(8,0,16), curv=c(0,-2,4))

rp.nls(model=model, data=cap,
       start=start, subset="estag",
       assignTo="cap.fit")

model <- pcapu~f0-f1*desf^((log(5)-log(f1))/log(xde))
start <- list(f0=c(30,25,35), f1=c(8,0,16), xde=c(0.5,0,1))

x11()
rp.nls(model=model, data=cap,
       start=start, subset="estag",
       assignTo="cap.fit",
       extraplot=function(f0,f1,xde){
           abline(v=xde, h=c(f0, f0-f1), lty=2, col=2)
       })

length(cap.fit)
sapply(cap.fit, coef)
lapply(cap.fit, summary)

##----------------------------------------------------------------------
## 3. Curva de produção em função do nível de potássio no solo.

soja <- read.table("http://www.leg.ufpr.br/~walmes/data/soja.txt",
                   header=TRUE, sep="\t", encoding="latin1", dec=",")

soja$agua <- factor(soja$agua)
str(soja)

xyplot(rengrao~potassio|agua, data=soja)

## modelo: linear-plato.
## x: representado por potássio, conteúdo de potássio do solo.
## y: representado por rengrao, redimento de grãos por parcela.
## f0: intercepto, valor da função quando x=0.
## tx: taxa de incremento no rendimento por unidade de x.
## brk: valor acima do qual a função é constante.

model <- rengrao~f0+tx*potassio*(potassio<brk)+tx*brk*(potassio>=brk)
start <- list(f0=c(15,5,25), tx=c(0.2,0,1), brk=c(50,0,180))

rp.nls(model=model, data=soja,
       start=start, subset="agua",
       assignTo="pot.fit")

sapply(pot.fit, coef)

##----------------------------------------------------------------------
## 4. Curva de lactação.

lac <- read.table(
    "http://www.leg.ufpr.br/~walmes/data/saxton_lactacao1.txt",
    header=TRUE, sep="\t", encoding="latin1")

lac$vaca <- factor(lac$vaca)
str(lac)

xyplot(leite~dia|vaca, data=lac)

## modelo: de Wood (nucleo da densidade gama).
## x: representado por dia, dia após parto.
## y: representado por leite, quantidade produzida.
## th1: escala, desprovido de interpretação direta.
## th2: forma, desprovido de interpretação direta.
## th3: forma, desprovido de interpretação direta.

model <- leite~th1*dia^th2*exp(-th3*dia)
start <- list(th1=c(15,10,20), th2=c(0.2,0.05,0.5),
              th3=c(0.0025,0.0010,0.0080))

rp.nls(model=model, data=lac,
       start=start, subset="vaca",
       assignTo="lac.fit", xlim=c(0,310))

sapply(lac.fit, coef)

##----------------------------------------------------------------------
## 5. Curvas de crescimento em placa de petri.

cre <- read.table(
    "http://www.leg.ufpr.br/~walmes/data/cresmicelial.txt",
    header=TRUE, sep="\t", encoding="latin1")

cre$isolado <- factor(cre$isolado)
cre$mmdia <- sqrt(cre$mmdia)
str(cre)

xyplot(mmdia~temp|isolado, data=cre)

## modelo: quadrático na forma canônica.
## x: representado por temp, temperatura da câmara de crescimento.
## y: representado por mmdia, taxa média de crescimento.
## thy: valor da função no ponto de máximo.
## thc: curvatura ou grau de especificidade à condição ótima.
## thx: ponto de máximo, temperatura de crescimento mais rápido.

model <- mmdia~thy+thc*(temp-thx)^2
start <- list(thy=c(4,0,7), thc=c(-0.05,0,-0.5), thx=c(23,18,30))

rp.nls(model=model, data=cre,
       start=start, subset="isolado",
       assignTo="mic.fit",
       extraplot=function(thy, thx, thc){
           abline(v=thx, h=thy, lty=2, col=2)
       },
       xlim=c(17,31), ylim=c(0,6))

t(sapply(mic.fit, coef))

##----------------------------------------------------------------------
## 6. Curva de secagem do solo em microondas.

sec <- read.table("http://www.leg.ufpr.br/~walmes/data/emr11.txt",
                  header=TRUE, sep="\t", encoding="latin1")
str(sec)

xyplot(umrel~tempo|nome, data=sec)

## modelo: logístico.
## x: representado por tempo, período da amostra dentro do microondas.
## y: representado por umrel, umidade relativa o conteúdo total de água.
## th1: assíntota superior.
## th2: tempo para evaporar metade do conteúdo total de água.
## th3: proporcional à taxa máxima do processo.

model <- umrel~th1/(1+exp(-(tempo-th2)/th3))
start <- list(th1=c(1,0.8,1.2), th2=c(15,0,40), th3=c(8,2,14))

rp.nls(model=model, data=sec,
       start=start, subset="nome",
       assignTo="sec.fit",
       extraplot=function(th1, th2, th3){
           abline(v=th2, h=th1/(1:2), lty=2, col=2)
       })

sapply(sec.fit, coef)
lapply(sec.fit, summary)

##----------------------------------------------------------------------
## Informações da sessão.

Sys.time()
sessionInfo()

##----------------------------------------------------------------------
