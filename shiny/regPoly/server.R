##-------------------------------------------
## server.R

library(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

apropos("^update[A-Z]", ignore.case=FALSE)

get("cars")

shinyServer(function(input, output, session){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
    observe({
        da <- get(input$DATASET)    
        updateSelectInput(session,
                          inputId="Y",
                          choices=names(da),
                          selected=names(da)[1])
        updateSelectInput(session,
                          inputId="X",
                          choices=names(da),
                          selected=names(da)[2])
    })
    REATIVA <- reactive({
        DADOS <- get(input$DATASET)    
        DADOS <- DADOS[, c(input$X, input$Y)]
        names(DADOS) <- c("x", "y")
        if (input$TRANSFORM){
            DADOS$y <- do.call(input$TRANSFUN, list(DADOS$y))
        }
        MODELO <- lm(y~poly(x, degree=input$DEGREE, raw=TRUE),
                     data=DADOS)
        return(list(DADOS=DADOS, MODELO=MODELO))
    })
    output$AJUSTE <- renderPlot({
        da <- REATIVA()$DADOS
        m0 <- REATIVA()$MODELO
        pred <- data.frame(x=seq(min(da[,"x"]), max(da[,"x"]), l=50))
        a <- predict(m0, newdata=pred, interval="confidence")
        pred <- cbind(pred, a)
        plot(da[,"y"]~da[,"x"], xlab="x", ylab="y")
        matlines(x=pred[,1], pred[,2:4], lty=c(1,2,2), col=1)
    }, width=600, height=600)
    output$ANOVA_SUMMARY <- renderPrint({
        m0 <- REATIVA()$MODELO
        cat("------------------------------------------------------------",
            capture.output(anova(m0))[-(7:8)],
            "------------------------------------------------------------",
            capture.output(summary(m0))[-c(1:9)],
            "------------------------------------------------------------",
            sep="\n")
    })
    output$RESIDUOS <- renderPlot({
        par(mfrow=c(2,2))
        plot(REATIVA()$MODELO)
        layout(1)
    }, width=600, height=600)
#     output$INFLUENCE <- renderDataTable({
#         im <- influence.measures(REATIVA()$MODELO)
#         colnames(im$infmat)[1:2] <- c("db.b0", "db.b1")
#         formatC(x=round(im$infmat, digits=2),
#                 digits=2, format="f")
#     })
    output$INFLUENCE <- renderTable({
        im <- influence.measures(REATIVA()$MODELO)
        colnames(im$infmat)[1:2] <- c("db.b0", "db.b1")
        im$infmat
    }, digits=4)
})
