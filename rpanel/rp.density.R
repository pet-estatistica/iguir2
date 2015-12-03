require(rpanel)

rp.density <- function(x){
    draw.density <- function(panel){
        ## Plot density curve and add the rugs.
        n <- length(na.omit(panel$x))
        aux <- density(panel$x, width=panel$width, kernel=panel$kernel)
        plot(aux, main=NA)
        rug(panel$x)
        ## The interval.
        arrows(panel$xc-0.5*panel$width, 0,
               panel$xc+0.5*panel$width, 0,
               length=0.1, code=3, angle=90, col=2)
        ## Line at center.
        yc <- approx(aux$x, aux$y, xout=panel$xc)
        arrows(panel$xc, 0, panel$xc, yc$y, length=0.1, col=2)
        ## Density for a single point.
        d <- density(panel$xc, width=panel$width,
                     kernel=panel$kernel, n=128)
        lines(d$x, d$y/n, col=2)
        switch(panel$points,
               "points"={
                   i <- findInterval(panel$x, vec=d$x[c(1,128)])
                   ## i <- findInterval(panel$x, vec=range(d$x))
                   xin <- panel$x[i==1L]
                   yin <- approx(d$x, d$y/n, xout=xin)
                   points(yin$x, yin$y, pch=19, cex=0.5, col=2)
               },
               "segments"={
                   i <- findInterval(panel$x, vec=d$x[c(1,128)])
                   xin <- panel$x[i==1L]
                   yin <- approx(d$x, d$y/n, xout=xin)
                   segments(yin$x, 0, yin$x, yin$y, col=2)
               },
               "none"={
                   NULL
               }
               )
        panel
    }
    ## Initialization.
    init <- density(x)
    init$er <- extendrange(x, f=0.1)
    init$kernels <- eval(formals(density.default)$kernel)
    init$w <- 4*init$bw ## For gaussian.
    ## Panels.
    panel <- rp.control(x=x)
    rp.slider(panel, variable=width,
              from=init$w*0.05, to=init$w*3, initval=init$w,
              showvalue=TRUE, action=draw.density, title="Width")
    rp.slider(panel, variable=xc,
              from=init$er[1], to=init$er[2],
              initval=mean(x, na.rm=TRUE),
              showvalue=TRUE, action=draw.density, title="Center")
    rp.radiogroup(panel, variable=kernel, vals=init$kernels,
                  action=draw.density, title="Kernel function")
    rp.radiogroup(panel, variable=points,
                  vals=c("points","segments","none"),
                  action=draw.density, title="Density on points")
    rp.do(panel, action=draw.density)
}

x <- rnorm(30)

x11()
rp.density(precip)

