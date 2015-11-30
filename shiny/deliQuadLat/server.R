##-------------------------------------------
## server.R

## FUNCIONA LOCALMENTE MAS NÃO DÁ CERTO QUANDO MANDA PARA SERVIDORA. ALGO ESQUISITO.

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")
require(lattice)
require(RColorBrewer)

## Função para aleatorizar experimento em quadrado latino.

qldesign <- function(dim){
    ## dim: escalar inteiro que é a dimensão do QL. 
    M <- matrix(1:dim, dim, dim)
    N <- M+(t(M))
    O <- (N%%dim)+1
    lin <- sample(1:dim)
    col <- sample(1:dim)
    M <- O[lin,col]
    D <- expand.grid(lin=gl(dim,1), col=gl(dim,1))
    D$trat <- c(M)
    return(list(M=M, D=D))
}

# da <- qldesign(5)
# 
# # display.brewer.all()
# colr <- brewer.pal(9, "Set1")
# colr <- colorRampPalette(colr, space="rgb")
# 
# levelplot(trat~lin+col, data=da$D, aspect=1,
#           colorkey=FALSE,
#           col.regions=colr,
#           panel=function(x, y, z, ...){
#               panel.levelplot(x=x, y=y, z=z, ...)
#               panel.text(x=x, y=y, labels=LETTERS[z])
#               })

shinyServer(
    function(input, output, clientData, session){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$ui <- renderUI({
            if(input$set){
                textInput(inputId="seed",
                          label="Semente:",
                          value=1234)
            } else {
                return()
                }
            })
        
        do <- reactive({
            if(input$set){
                seed <- input$seed
                set.seed(seed)
            } else {
                seed <- sample(100:999, size=1)
                set.seed(seed)
            }
            da <- qldesign(input$size)
            da$seed <- seed
            return(da=da)
        })
        
        output$plotRes <- renderPlot({
            da <- do()
            colr <- brewer.pal(9, "Set1")
            colr <- colorRampPalette(colr, space="rgb")
            
            levelplot(trat~lin+col, data=da$D, aspect=1,
                      colorkey=FALSE,
                      xlab="Linha", ylab="Coluna",
                      col.regions=colr,
                      panel=function(x, y, z, ...){
                          panel.levelplot(x=x, y=y, z=z, ...)
                          panel.text(x=x, y=y, labels=LETTERS[z])
                      })
            })
        
        output$downloadData <- downloadHandler(
            filename=function(){ 
                paste("dql", input$size, "-", do()$seed,".txt", sep="") 
            },
            content=function(file) {
                write.table(x=do()$D, file=file,
                            quote=FALSE, row.names=FALSE,
                            sep="\t")
            }
        )
    })
