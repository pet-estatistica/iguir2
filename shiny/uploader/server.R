library(shiny)

require(xtable)

## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

rm(list=ls())

# getwd()
# setwd("/home/walmes/Dropbox/shiny/uploader")

## Cria o diretório caso ainda não exista.
if(!any(list.files(include.dirs=TRUE)=="files")){
    dir.create(path="files")
}

## Interface para subir o arquivo.
shinyServer(function(input, output){
    ## Cabeçalho IGUIR2
    output$header <- renderPrint({
        template("TEMA")
    })
    do <- reactive({
        inFile <- input$file
        if(is.null(input$file)){
            cat(list.files(path="./files"), sep="\n")
        } else {
            grrok <- grepl(pattern="^\\d{8}$", x=input$grr)
            if(!grrok) stop("GRR deve ter 8 digitos numéricos.")
            fext <- gsub(pattern="^.*(\\.\\w+)$",
                         x=basename(inFile$name),
                         replacement="\\1")
            zipok <- grepl(pattern="\\.(rar|zip)$", x=fext)
            if(!zipok) stop("Arquivo deve ser zip ou rar.")
            url <- inFile$datapath
            file.copy(from=url,
                      to=paste0(getwd(),
                                "/files/",
                                input$turma, "_",
                                input$grr, "_",
                                input$trab, fext))
        }
        lf <- list.files(path="./files")
        if (length(lf)>0){
            setwd("./files")
            dtinfo <- file.info(list.files(), extra_cols=FALSE)
            setwd("..")
            dtinfo <- dtinfo[order(dtinfo$ctime, decreasing=TRUE), c("size","ctime")]
            dtinfo <- cbind("Arquivo"=rownames(dtinfo), dtinfo)
            rownames(dtinfo) <- NULL
            colnames(dtinfo) <- c("Arquivo", "Tamanho", "Criação")
            if(nrow(dtinfo)==1){
                dtinfo <- dtinfo[c(1,1),]
                a <- as.data.frame(sapply(dtinfo, as.character))
                a <- a[-1,]
                rownames(a) <- NULL
            } else {
                a <- as.data.frame(sapply(dtinfo, as.character))
                rownames(a) <- NULL
            }
            
            return(list(
                df2=a[1:min(c(5, nrow(a))),],
                df3=a,
                empty=NULL))
        }
    })
    
    ## Output em tabela.
    output$table <- renderTable({
        do()$df2
    })
    
    ## Output em html.
    output$table <- renderPrint({
        a <- do()$df2
        if (is.data.frame(a)){
            print(xtable(a, align=c("rlrr")), type="html")
        }
    })
    
    ## Output em 'asis'.
    output$contents <- renderPrint({
        do()$empty
        cat(paste("Um total de", length(list.files(path="./files")), "arquivos."))
    })
    
    #         cat(list.files(path="./files"), sep="\n")
    
    ## Output em 'html'.
    output$html <- renderPrint({
        do()$empty ## Para ficar reativo.
        a <- do()$df3
        if (is.data.frame(a)){
            print(xtable(a, align=c("rlrr")), type="html")
        }
    })
})
