library(shiny)

shinyServer(
    function(input, output) {
        output$PLOT_DENSITY <- renderPlot({
            ## Estimação da densidade.
            aux <- density(precip,
                           width=input$WIDTH,
                           kernel=input$KERNEL)
            plot(aux, main=NA, col=input$CURVE_COLOR)
            ## Indica a banda.
            arrows(input$CENTER-0.5*input$WIDTH, 0,
                   input$CENTER+0.5*input$WIDTH, 0,
                   length=0.1, code=3, angle=90, col=2)
            ## Exibe o ponto sobre a função densidade.
            y0 <- approx(aux$x, aux$y, xout=input$CENTER)
            arrows(input$CENTER, 0,
                   input$CENTER, y0$y,
                   length=0.1, col=2)
            ## Representa a função kernel para 1 observação.
            d <- density(input$CENTER,
                         width=input$WIDTH,
                         kernel=input$KERNEL)
            lines(d$x, d$y/length(precip), col=2)
            ## Inclui as marcas sobre o eixo.
            if (input$DRAW_RUG){
                rug(precip)
            }
        })
    })
