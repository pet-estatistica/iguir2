##-------------------------------------------
## server.R

## FUNCIONA LOCALMENTE MAS NÃO DÁ CERTO QUANDO MANDA PARA SERVIDORA. ALGO ESQUISITO.

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

## Número de alternativas.
nalter <- 4

## Hora do acesso.
tm0 <- Sys.time()
tm <- tm0

## Remove arquivo de log para criar um novo.
file.remove("log")
cat("expr; timeDes; correctAnswer; userAnswer", sep="\n", file="log")

shinyServer(
    function(input, output, clientData, session){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        
        ## Responde a estímulos no `input$goButton`.
        do <- reactive({
            input$goButton
            smpl <- sample(0:9, size=2)
            expr <- paste0(smpl[1], " + ", smpl[2], " = ")
            erros <- sample(c(-1,1), size=nalter-1, replace=TRUE)*sample(1:5, size=nalter-1)
            answers <- sum(smpl)+c(0, erros)
            ran <- sample(1:nalter)
            return(list(expr=expr, choi=answers[ran], correct=answers[1])
            )
        })
        
        ## Apresenta a expressão.
        output$expr <- renderText(do()$expr)
        
        ## Gera o `radioInput()`. Estímulo do `input$goButton` pelo `do()$choi`.
        output$uiRadio <- renderUI({
            return(
                radioButtons(inputId="radio", 
                             label="",
                             choices=do()$choi,
                             selected=NA,
                             inline=FALSE)
            )
        })
        
        ## Executado toda vez que clica no `input$radio`. 
        ## Não responde ao `input$goButton` porque se usou isolate(do()$...).
        results <- reactive({
            tm <<- c(Sys.time(), tm) ## Informação do instante.
            ## Diferença de tempo só deve aparecer depois de escolher resposta.
            d <- 0
            if(!is.null(input$radio)){
                d <- as.numeric(diff(tm[2:1])) ## Diferença entre ações.
            }
            iscerto <- isolate(do()$correct)==as.integer(isolate(input$radio))
            td <- sprintf("Tempo de decisão: %0.3f", d)
            rc <- paste("Resposta correta: ", ifelse(iscerto, "SIM", "NÃO"))
            return(list(td=td,
                        rc=rc,
                        d=d,
                        expr=isolate(do()$expr),
                        corAns=isolate(do()$correct),
                        userAns=input$radio
                        )
            )
        })
        
        ## Vínculado ao `input$radio`.
        output$result <- renderPrint({
            ## Print para usuário.
            cat(results()$td, "\n", results()$rc, sep="")
            ## cat(results()$rc)
        })
        
        ## Executado toda vez que clica no botão `input$goButton`.
        ## Não depende do `input$radio` por causa do isolate(results()$...).
        observe({
            input$goButton
            cat(paste(
                isolate(results()$expr),    ## Expressão.
                isolate(results()$d),       ## Tempo para decisão.
                isolate(results()$corAns),  ## Resposta correta.
                isolate(results()$userAns), ## Resposta marcada.
                sep="; "),
                sep="\n",
                file="log",
                append=TRUE)
        })
        
        ## Sensível ao `input$goResults` apenas.
        output$plotRes <- renderPlot({
            input$goResults
            da <- read.table(file="log", sep=";", header=TRUE)
            if(nrow(da)>1){
                da <- na.omit(da)
                n <- nrow(da)
                y <- as.integer(da$userAnswer==da$correctAnswer)
                x <- da$time
                plot(density(x),
                     xlab="Tempo para decisão (s)",
                     ylab="Densidade",
                     main=NA,
                     sub=NA)
                yr <- 0.05*diff(range(par()$usr[3:4]))
                points(x, y*yr, col=y+1)
                m <- mean(x, na.rm=TRUE)
                p <- sum(y)/nrow(da)
                abline(v=m, lty=2)
                mtext(side=3, line=2,
                      text=sprintf("Tempo médio de decisão: %0.3f segundos", m))
                mtext(side=3, line=1,
                      text=sprintf("Proporção de acertos: %0.2f%s", 100*p, "%"))
            }
        })
    })
