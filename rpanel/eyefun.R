##----------------------------------------------------------------------
## Função que a partir de uma expressão do modelo cria deslizadores para
## estudo do comportamento da função com relação a alterações nos
## valores dos parâmetros.

##----------------------------------------------------------------------
## Definições da sessão.

require(rpanel)

##----------------------------------------------------------------------
## Função.

eyefun <- function(model,
                   start,
                   xlim=c(0,1),
                   ylim=c(0,1),
                   length.out=101,
                   ...){
    ## PORÇÃO DE PROTEÇÕES DA FUNÇÃO.
    ## Nome da variável dependente.
    ## all.vars(model[[2]])
    vardep <-  "y"
    ## Nome da variável independente, testa se é apenas uma.
    varindep <- "x"
    if (length(varindep)!=1){
        stop("just one independent variable is expected!")
    }
    ## Nome dos parâmetros.
    parnames <- intersect(all.vars(model[[3]]), names(start))
    ## Testa se os nomes dos parâmetros seguem o padrão th1, th2, ...
    test.start.names <- length(
        grep("^th[1-5]$", parnames))==length(parnames)
    if (!test.start.names){
        stop(paste("in start and model formula parameter names",
                   "should follow the pattern: th1, th2, ..., th5!"))
    }
    ## Função que converte uma formula em uma função que retorna valores
    ## da função testa e adequa os nomes dos elementos dos vetores
    ## dentro da lista start.
    startnames <- sapply(start,
                         function(x){
                             !(!is.null(names(x)) &
                                all(names(x)%in%c("init","from","to")))
                         })
    if (any(startnames)){
        message(paste("at least one start element is not named.",
                      "Using the current order to name it as init,",
                      "from and to."))
        for(j in which(startnames)){
            names(start[[j]]) <- c("init","from","to")
        }
    }
    ## PORÇÃO DE FUNÇÕES INTERNAS.
    ## Função que converte uma fórmula da nls() em uma função para
    ## predição.
    form2func <- function(formu){
        arg1 <- all.vars(formu)
        arg2 <- vector("list", length(arg1))
        names(arg2) <- arg1
        Args <- do.call("alist", arg2)
        fmodele <- as.function(c(Args, formu))
        return(fmodele)
    }
    fmodele <- form2func(model[[3]])
    ## Função que é controlada e passar a curva por meio dos pontos.
    nlr.draw <- function(panel){
        vindepseq <- seq(xlim[1], xlim[2], length.out=length.out)
        listparvar <- c(list(vindepseq), panel[parnames])
        names(listparvar)[1] <- varindep
        fx <- do.call("fmodele", listparvar)
        plot(vindepseq, fx, col=1, lty=1,
             xlim=xlim, ylim=ylim, type="l",
             ...)
        panel
    }
    ## PORÇÃO COM OS CONTROLADORES.
    action <- nlr.draw
    ## Abre o painel e as caixas de seleção.
    nlr.panel <- rp.control(title="Ajuste",
                            size=c(200, 200), model=model)
    ## Abre os deslizadores para controlar o valor dos parâmetros.
    if (any(names(start)=="th1")){
        rp.slider(panel=nlr.panel, var=th1,
                  from=start[["th1"]]["from"],
                  to=start[["th1"]]["to"],
                  initval=start[["th1"]]["init"],
                  showvalue=TRUE, action=action)
    }
    if (any(names(start)=="th2")){
        rp.slider(panel=nlr.panel, var=th2,
                  from=start[["th2"]]["from"],
                  to=start[["th2"]]["to"],
                  initval=start[["th2"]]["init"],
                  showvalue=TRUE, action=action)
    }
    if (any(names(start)=="th3")){
        rp.slider(panel=nlr.panel, var=th3,
                  from=start[["th3"]]["from"],
                  to=start[["th3"]]["to"],
                  initval=start[["th3"]]["init"],
                  showvalue=TRUE, action=action)
    }
    if (any(names(start)=="th4")){
        rp.slider(panel=nlr.panel, var=th4,
                  from=start[["th4"]]["from"],
                  to=start[["th4"]]["to"],
                  initval=start[["th4"]]["init"],
                  showvalue=TRUE, action=action)
    }
    if (any(names(start)=="th5")){
        rp.slider(panel=nlr.panel, var=th5,
                  from=start[["th5"]]["from"],
                  to=start[["th5"]]["to"],
                  initval=start[["th5"]]["init"],
                  showvalue=TRUE, action=action)
    }
    invisible()
}

##----------------------------------------------------------------------
## Usos da função.

## Essa função foi feita a muito e para simplificar você pode só deve
## usar y e x para indicar as variáveis dependente e independente. Os
## parâmentros devem ser indicados por th seguido de um número de 1 à
## 5. Modelos com mais de 5 parâmentros precisam que a função seja
## modificada.

## Equação da reta: A+B*x.
model <- y~th1+th2*x
start <- list(th1=c(init=0.2, from=0, to=0.5),
             th2=c(init=0.6, from=0.4, to=0.8))

eyefun(model, start)

## Modelo beta generalizado.
model <- y~th1*(x-th2)^th3*(th4-x)^th5
start <- list(th1=c(1,0,3),
              th2=c(0,0,3),
              th3=c(1,0,3),
              th4=c(1,0,1),
              th5=c(1,0,3))

eyefun(model, start)

##----------------------------------------------------------------------
