require(shiny)

densityView <- function(m, s, sample){
    curve(dnorm(x, mean=m, sd=s),
          from=m-4*s, to=m+4*s)
    abline(v=m, lty=1, col=2)
    lines(density(sample), col=2)
}

ecdfView <- function(m, s, sample){
    curve(pnorm(x, mean=m, sd=s),
          from=m-4*s, to=m+4*s)
    abline(v=m, lty=1, col=2)
    lines(ecdf(sample), col=2)
}

qqView <- function(sample){
    qqnorm(sample)
    qqline(sample)
}

## Quantidade de amostras de y.
N <- 500

## Carrega template das aplicações elaboradas pelo projeto iguiR2
source("../template.R")

shinyServer(
    function(input, output){
        ## Cabeçalho IGUIR2
        output$header <- renderPrint({
            template("TEMA")
        })
        output$ui <- renderUI({
            if (is.null(input$dist)){
                return(NULL)
            }
            switch(input$dist,
                   
                   "poisson"={
                       output$plot <- renderPlot({
                           x <- 0:30
                           px <- dpois(x, lambda=input$poissonLambda)
                           plot(x, px, type="h", xlab="x", ylab="Pr(x)")
                       })
                       SAMPLER <- reactive({
                           popMean <- input$poissonLambda
                           popSd <- sqrt(input$poissonLambda)
                           meanSd <- popSd/sqrt(input$n)
                           sampleMean <-
                               replicate(
                                   N,
                                   mean(rpois(
                                       input$n,
                                       lambda=input$poissonLambda)))
                                       return(list(
                                           m=popMean,
                                           s=meanSd,
                                           sample=sampleMean))
                       })
                       output$density <- renderPlot({
                           with(SAMPLER(),
                                densityView(m=m, s=s, sample=sample))
                       })
                       output$ecdf <- renderPlot({
                           with(SAMPLER(),
                                ecdfView(m=m, s=s, sample=sample))
                       })
                       output$qqnorm <- renderPlot({
                           qqView(sample=SAMPLER()$sample)
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
                                        plot(x, px, type="h",
                                             xlab="x", ylab="Pr(x)")
                       })
                       SAMPLER <- reactive({
                           popMean <-
                               input$binomialSize*input$binomialProb
                           popSd <-
                               sqrt(popMean*(1-input$binomialProb))
                           meanSd <- popSd/sqrt(input$n)
                           sampleMean <-
                               replicate(
                                   N,
                                   mean(rbinom(
                                       input$n,
                                       size=input$binomialSize,
                                       prob=input$binomialProb)))
                                       return(list(
                                           m=popMean,
                                           s=meanSd,
                                           sample=sampleMean))
                       })
                       output$density <- renderPlot({
                           with(SAMPLER(),
                                densityView(m=m, s=s, sample=sample))
                       })
                       output$ecdf <- renderPlot({
                           with(SAMPLER(),
                                ecdfView(m=m, s=s, sample=sample))
                       })
                       output$qqnorm <- renderPlot({
                           qqView(sample=SAMPLER()$sample)
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
                       SAMPLER <- reactive({
                           popMean <-
                               input$betaShape1/
                               (input$betaShape1+input$betaShape2)
                           popSd <- sqrt(
                               input$betaShape1*input$betaShape2/(
                                   (input$betaShape1+
                                    input$betaShape2+1)*
                                   (input$betaShape1+
                                    input$betaShape2)**2
                               )
                           )
                           meanSd <- popSd/sqrt(input$n)
                           sampleMean <-
                               replicate(
                                   N,
                                   mean(rbeta(
                                       input$n,
                                       shape1=input$betaShape1,
                                       shape2=input$betaShape2)))
                                       return(list(
                                           m=popMean,
                                           s=meanSd,
                                           sample=sampleMean))
                       })
                       output$density <- renderPlot({
                           with(SAMPLER(),
                                densityView(m=m, s=s, sample=sample))
                       })
                       output$ecdf <- renderPlot({
                           with(SAMPLER(),
                                ecdfView(m=m, s=s, sample=sample))
                       })
                       output$qqnorm <- renderPlot({
                           qqView(sample=SAMPLER()$sample)
                       })
                       wellPanel(
                           sliderInput(inputId="betaShape1",
                                       label="Parâmetro de forma 1",
                                       min=0.01, max=7, value=1, 
                                       step=0.1),
                           sliderInput(inputId="betaShape2",
                                       label="Parâmetro de forma 2",
                                       min=0.01, max=7, value=1,
                                       step=0.1)
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
                       SAMPLER <- reactive({
                           popMean <- input$gammaShape/input$gammaRate
                           popSd <- sqrt(
                               input$gammaShape/(input$gammaRate**2))
                               meanSd <- popSd/sqrt(input$n)
                           sampleMean <-
                               replicate(
                                   N,
                                   mean(rgamma(
                                       input$n,
                                       shape=input$gammaShape,
                                       rate=input$gammaRate)))
                                       return(list(
                                           m=popMean,
                                           s=meanSd,
                                           sample=sampleMean))
                       })
                       output$density <- renderPlot({
                           with(SAMPLER(),
                                densityView(m=m, s=s, sample=sample))
                       })
                       output$ecdf <- renderPlot({
                           with(SAMPLER(),
                                ecdfView(m=m, s=s, sample=sample))
                       })
                       output$qqnorm <- renderPlot({
                           qqView(sample=SAMPLER()$sample)
                       })
                       wellPanel(
                           sliderInput(inputId="gammaShape",
                                       label="Parâmetro de forma",
                                       min=0.01, max=7, value=1,
                                       step=0.1),
                           sliderInput(inputId="gammaRate",
                                       label="Parâmetro de taxa",
                                       min=0.01, max=7, value=1,
                                       step=0.1)
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
                       SAMPLER <- reactive({
                           popMean <- input$normalMean
                           popSd <- input$normalSd
                           meanSd <- popSd/sqrt(input$n)
                           sampleMean <-
                               replicate(
                                   N,
                                   mean(rnorm(
                                       input$n,
                                       mean=input$normalMean,
                                       sd=input$normalSd)))
                                       return(list(
                                           m=popMean,
                                           s=meanSd,
                                           sample=sampleMean))
                       })
                       output$density <- renderPlot({
                           with(SAMPLER(),
                                densityView(m=m, s=s, sample=sample))
                       })
                       output$ecdf <- renderPlot({
                           with(SAMPLER(),
                                ecdfView(m=m, s=s, sample=sample))
                       })
                       output$qqnorm <- renderPlot({
                           qqView(sample=SAMPLER()$sample)
                       })
                       wellPanel(
                           sliderInput(inputId="normalMean",
                                       label="Média da normal",
                                       min=-3, max=3, value=0,
                                       step=0.05),
                           sliderInput(inputId="normalSd",
                                       label="Desvio-padrão da normal",
                                       min=0.1, max=3, value=1,
                                       step=0.05)
                       )
                   }
                   
                   ) ## switch()
        }) ## renderUI

        ## Opções para média amostral
        output$OptsMedia <- renderUI({
            if (input$tab == "Distribuição") {
                return(NULL)
            } else {
                wellPanel(
                    numericInput(
                        inputId="n",
                        label="Tamanho da amostra:",
                        min = 2, max = 1000, value=10),
                    HTML("<label>Tipo de gráfico: </label>"),
                    tabsetPanel(
                        id = "graf",
                        type = "pills",
                        tabPanel("Density"),
                        tabPanel("ECDF"),
                        tabPanel("Q-QNorm")
                    ),
                    helpText("Baseados em 500 amostras")
                )
            }
        })

        ## Gráficos para a distribuição média amostral 
        output$grafsMedia <- renderUI({
            if (is.null(input$graf)) {
                return(NULL)
            } else {
                switch(
                    input$graf,
                    "Density" = plotOutput("density"),
                    "ECDF" = plotOutput("ecdf"),
                    "Q-QNorm" = plotOutput("qqnorm")
                )
            }
        })
        
    }) ## shinyServer()
