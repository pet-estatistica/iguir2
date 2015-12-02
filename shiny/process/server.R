library(shiny)
library(knitr)

shinyServer(
    function(input, output) {
        output$TABLE <- renderTable(
            get(input$DATASET)
        )
        output$DOWNLOAD_PDF <- downloadHandler(
            filename=function(){
                return("report.pdf")
            },
            content=function(file){
                ## Pega objeto e salva imagem com ele.
                x <- get(isolate(input$DATASET))
                save(x, file="image.RData")
                ## Rnw -> tex -> pdf.
                knit2pdf(input="report.Rnw")
                ## Empurra o arquivo para download.
                file.copy(from="report.pdf",
                          to=file,
                          overwrite=TRUE)
                ## Remove arquivos auxiliares descessários.
                file.remove(list.files(
                    pattern="\\.(log|out|vrb|pdf)$"))
            },
            contentType="application/pdf")
    })
