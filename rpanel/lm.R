require(rpanel)
require(plyr)
require(latticeExtra)
## require(car)
require(alr3)
require(wzRfun)

##----------------------------------------------------------------------

url <- "http://westfall.ba.ttu.edu/isqs5349/Rdata/turtles.txt"
tur <- read.table(url, header=TRUE, sep="\t")
str(tur)

xtabs(~gender, tur)

tur$Gender <- factor(tur$gender)

form <- c("null"=.~1,
          "gend"=.~Gender,
          "leng"=.~length,
          "gend+leng"=.~Gender+length,
          "gend*leng"=.~Gender*length)

m1 <- lm(height~Gender*length, data=tur)

p1 <- xyplot(height~length, groups=Gender, data=tur,
             ylab="Altura", xlab="Comprimento")
p1

pred <- ddply(tur, .(Gender), summarise,
             length=seq(min(tur$length), max(tur$length), l=20))

draw.model <- function(panel){
    m3 <- update(m1, as.formula(form[[panel$f]]))
    pred <- cbind(pred, predict(m3, newdata=pred, interval="confidence"))
    p2 <- xyplot(fit~length, groups=Gender, data=pred, type="l",
                 ly=pred$lwr, uy=pred$upr, cty="bands", alpha=0.5,
                 prepanel=prepanel.cbH, panel=panel.superpose,
                 panel.groups=panel.cbH)
    print(p1+as.layer(p2, under=TRUE))
    panel    
}

panel <- rp.control()
rp.listbox(panel, variable=f, vals=names(form), action=draw.model)

##----------------------------------------------------------------------

str(sleep1)
## help(sleep1, h="html")

## Danger Index.
sleep1$D <- factor(sleep1$D)
sleep1$lbw <- log(sleep1$BodyWt)

xyplot(TS~lbw|D, data=sleep1)
xyplot(TS~lbw|D, data=sleep1, type=c("p","r"))

##-----------------------------------------------------------------------------
## Ajuste do modelo.

m1 <- lm(log(TS)~D*lbw, data=sleep1)

## Diagnóstico.
par(mfrow=c(2,2)); plot(m1); layout(1)

##-----------------------------------------------------------------------------
## Estimativas por grupo.

## R² com SQT corrigida para média.
summary(m1)

form <- c("null"=.~1,
          "D"=.~D,
          "lbw"=.~lbw,
          "D+lbw"=.~D+lbw,
          "D*lbw"=.~D*lbw)

pred <- ddply(sleep1, .(D), summarise,
              lbw=seq(min(lbw), max(lbw), l=20)
              ## lbw=extendseq(lbw, l=12)
              )

draw.model <- function(panel){
    m3 <- update(m1, as.formula(form[[panel$f]]))
    pred <- cbind(pred,
                  predict(m3, newdata=pred, interval="confidence"))
    p1 <- xyplot(log(TS)~lbw|D, data=sleep1)
    p2 <- xyplot(fit~lbw|D, data=pred, type="l",
                 ly=pred$lwr, uy=pred$upr, cty="bands", alpha=0.25,
                 prepanel=prepanel.cbH,
                 panel=panel.cbH)
    print(p1+as.layer(p2, under=TRUE))
    panel    
}

panel <- rp.control()
rp.listbox(panel, variable=f, vals=names(form), action=draw.model,
           title="Select a model")
