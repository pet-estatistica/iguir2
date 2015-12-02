library(shiny)

shinyServer(function(input, output, session){
    
    FILEURL <- reactive({
        fileUploaded <- input$THEFILE
        if (is.null(fileUploaded)){
            return(NULL)
        } else {
            return(fileUploaded$datapath)
        }
    })
    
    DATASET <- reactive({
        fileurl <- isolate(FILEURL())
        input$RUN
        if (is.null(fileurl)){
            return(NULL)
        } else {
            dados <- read.table(fileurl,
                                header=input$HEADER,
                                sep=input$SEPARATOR,
                                quote=input$QUOTATION,
                                dec=input$DECIMAL)
            return(dados)
        }
    })

    observe({
        dados <- DATASET()
        if (!is.null(dados)) {
            updateSelectInput(session,
                              inputId="VARIABLE",
                              choices=names(dados),
                              selected=names(dados)[1])
        }
    })
    
    STEM <- reactive({
        dados <- DATASET()
        y <- dados[, input$VARIABLE]
        if (is.numeric(y)) {
            st <- capture.output(stem(y))
            return(st)
        } else  {
            return(NULL)
        }
    })
    output$STEM <- renderPrint({
        cat(STEM(), sep="\n")
    })

    output$DOWNLOADDATA <- downloadHandler(
        filename=function(){
            "stem.txt"
        },
        content=function(file){
            cat(STEM(),
                sep="\n", file=file)
        }
    )

})
