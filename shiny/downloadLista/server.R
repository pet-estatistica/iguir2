##-------------------------------------------
## server.R

require(xtable)
require(knitr)
require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output, session){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        geraPDF <-
            reactive({
                ## Pega GRR
                grr <- input$GRR
                set.seed(grr)

                ## Embaralha a ordem dos exercícios.
                exer <- sample(input$EXER)
                validExer <- length(exer)>0
                if (!validExer){
                    stop("Nenhum exercício selecionado.")
                }

                validGrr <- grepl(x=grr, pattern="^\\d{8}$")
                if (!validGrr){
                    stop("GRR deve ter 8 digitos numéricos.")
                }

                arqbase <- paste0(exer, ".Rnw")
                arqresu <- "exercGRR.Rnw"

                ## Lê as linhas.
                if (length(arqbase)>1){
                    ex <- sapply(arqbase, FUN=readLines)
                    ex <- lapply(ex, FUN=append, values=rep("", 3))
                    rl0 <- do.call(c, ex)
                    rl0 <- unlist(ex)
                    names(rl0) <- NULL
                } else {
                    rl0 <- readLines(arqbase)
                }

                ## Troca a ocorrência de GRR pelo valor passado.
                rl1 <- gsub(pattern="[_]GRR[_]", replacement=grr, x=rl0)

                ## Arquivo texto de uma linha que só contém o GRR.
                cat(paste0("\\", "def", "\\", "grr{", grr, "}"),
                    file="grr")

                ## No caso de ter senha.
                if (input$PASSWD=="senha"){
                    cat(paste0("\\", "showanswers"), file="grr",
                        append=TRUE)
                }

                ## Escreve em arquivo de texto.
                writeLines(text=rl1, con=arqresu)
                ## Converte de Rnw para tex.
                knit(arqresu, encoding="utf-8")
                ## PDF
                cmd <- sprintf("pdflatex -jobname=grr%s lista.tex", grr)
                ## Rodar 3 vezes por causa do \label{} e \ref{}
                ## system(cmd); system(cmd); system(cmd)
                system(cmd)
                ## Remove objetos auxiliares.
                cat(paste(grr, Sys.time()),
                    file="log", append=TRUE, sep="\n")
            })
        
        output$DOWNLOADPDF <-
            downloadHandler(
                filename=function(){
                    sprintf("grr%s.pdf", input$GRR)
                },
                content=function(file){
                    ## Ao clicar no botão, arquivos são criados.
                    geraPDF()
                    file.copy(from=sprintf("grr%s.pdf", input$GRR),
                              to=file,
                              overwrite=TRUE)
                    file.remove(
                        list.files(pattern="\\.(log|out|vrb|pdf|aux)$"))
                },
                contentType="application/pdf")
    })
