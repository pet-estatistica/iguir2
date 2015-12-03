require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

##-----------------------------------------------------------------------------

## format(da$nome, width=max(nchar(da$nome)))
cform <- function(x){
    if(is.numeric(x)){
        x <- round(x, digits=2)
    }
    format(as.character(x), width=max(nchar(x)))
}

## Gerando dados.
da <- data.frame(grr=sample(100:200, size=7))
da$nome <- sample(colors(), size=length(da$grr))
da$nota <- NA
da <- da[order(da$grr),]

txt <- apply(sapply(da[,1:2], cform), 1, paste, collapse=" ")
w <- gwindow("Lançar notas", visible=FALSE, width=400)
g <- gpanedgroup(horizontal=FALSE, container=w)
glabel(text="Busque pelo GRR:", container=g)
grr <- gedit(text="", initial.msg="1234",
             container=g)
grr[] <- da$grr
glabel(text="Atribua nota:", container=g)
nota <- gedit(text="", initial.msg="Nota", container=g,
              enabled=FALSE)
enabled(nota) <- FALSE
glabel(text="Alunos sem nota:", container=g)
outp <- gtext(text=txt[is.na(da$nota)],
              container=g)
size(outp) <- c(300,100)
enabled(outp) <- FALSE
visible(w) <- TRUE
addHandlerKeystroke(obj=grr,
                    handler=function(h, ...){
                        enabled(outp) <- TRUE
                        i <- grepl(pattern=paste0("^", svalue(grr)),
                                  x=da$grr)
                        svalue(outp) <- txt[i & is.na(da$nota)]
                        if(sum(i)==1){
                            enabled(nota) <- TRUE
                        } else {
                            enabled(nota) <- FALSE
                        }
                    })
addHandlerChanged(nota,
                  function(h, ...){
                      blockHandler(grr)
                      i <- grep(pattern=paste0("^", svalue(grr)),
                                x=da$grr)
                      y <- eval(expr=parse(text=svalue(nota)))
                      da[i,]$nota <<- as.numeric(y)
                      txt[i] <<- paste(txt[i], y)
                      enabled(nota) <- FALSE
                      enabled(outp) <- FALSE
                      svalue(nota) <- ""
                      unblockHandler(grr)
                      svalue(grr) <- ""
                      svalue(outp) <- txt
                  })

da

## apropos("^g", mode="function")
## grep(x=ls("package:gWidgets"), pattern="^g", value=TRUE)

## eval(expr=parse(text="2+4"))
