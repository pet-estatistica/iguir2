##-------------------------------------------
## server.R

require(shiny)
## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$ui <- renderUI({
            if(is.null(input$dist)){
                return()}
            switch(input$dist,
                   "poisson"={
                       output$plot <- renderPlot({
                           x <- 0:30
                           px <- dpois(x, lambda=input$poissonLambda)
                           plot(x, px, type="h", xlab="x", ylab="Pr(x)")
                       })
                       wellPanel(
                           sliderInput(inputId="poissonLambda",
                                       label="Média da Poisson",
                                       min=0.1, max=20, value=10)
                           )
                   },
                   
                   "binomial"={
                       output$plot <- renderPlot({
                           x <- 0:input$binomialSize
                           px <- dbinom(x, size=input$binomialSize,
                                        prob=input$binomialProb)
                           plot(x, px, type="h", xlab="x", ylab="Pr(x)")
                       })
                       wellPanel(
                           sliderInput(inputId="binomialSize",
                                       "Número de ensaios",
                                       min=0, max=30, value=10, step=1),
                           sliderInput(inputId="binomialProb",
                                       label="Probabilidade de sucesso",
                                       min=0.02, max=0.98,
                                       value=0.5, step=0.02)
                           
                       )
                   },

                   "beta"={
                       output$plot <- renderPlot({
                           curve(dbeta(x,
                                       shape1=input$betaShape1,
                                       shape2=input$betaShape2),
                                 from=0, to=1,
                                 xlab="x", ylab="f(x)")
                       })
                       wellPanel(
                           sliderInput(inputId="betaShape1",
                                       label="Parâmetro de forma 1",
                                       min=0.01, max=7, value=1, step=0.1),
                           sliderInput(inputId="betaShape2",
                                       label="Parâmetro de forma 2",
                                       min=0.01, max=7, value=1, step=0.1)
                       )
                   },
                   
                   "gamma"={
                       output$plot <- renderPlot({
                           curve(dgamma(x,
                                       shape=input$gammaShape,
                                       rate=input$gammaRate),
                                 from=0, to=20,
                                 xlab="x", ylab="f(x)")
                       })
                       wellPanel(
                           sliderInput(inputId="gammaShape",
                                       label="Parâmetro de forma",
                                       min=0.01, max=7, value=1, step=0.1),
                           sliderInput(inputId="gammaRate",
                                       label="Parâmetro de taxa",
                                       min=0.01, max=7, value=1, step=0.1)
                       )
                   },
                   
                   "normal"={
                       output$plot <- renderPlot({
                           curve(dnorm(x,
                                       mean=input$normalMean,
                                       sd=input$normalSd),
                                 from=-3, to=3,
                                 xlab="x", ylab="f(x)")
                       })
                       wellPanel(
                           sliderInput(inputId="normalMean",
                                       label="Média da normal",
                                       min=-3, max=3, value=0, step=0.05),
                           sliderInput(inputId="normalSd",
                                       label="Desvio-padrão da normal",
                                       min=0.1, max=3, value=1, step=0.05)
                           )
                   }
            )
        })
    })
