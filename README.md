Explorando Interfaces Gráficas com o R
======================================

Eduardo E. Ribeiro Jr, PET-Estatística UFPR    
[Prof. Walmes M. Zeviani](http://www.leg.ufpr.br/~walmes/), LEG UFPR

O R é um programa para computação estatística e gráficos ... TODO

Nesse Curso consideramos pacotes do R para produzir ... TODO

O pacote [`animation`] serve para gerar animações em diversos formatos,
como *gif* e animações em *javascript* dentro de páginas web. O [`rgl`]
permite explorar o espaço tridimensional .. O pacote [`googleVis`] faz
gráficos da galeria Google Charts a partir de objetos do R. Com os
pacotes [`rpanel`] e [`gWdigets`] é possível fazer interfaces gráficas e
até mini aplicativos baseados em Tcl/Tk ou Gtk+. Por fim, o pacote
[`shiny`] possibilita construir aplicações Web com o R baseadas em
*javascript*.

O que todos esses pacotes têm em comum é permitir uma visualização
dinâmica e/ou interativas. Com eles podemos produzir gráficos que exibem
uma sequência de estados - como os gifs - com os quais podemos
rotacionar - rgl - TODO

Tais recursos interativos são usados para ensino de estatística e
exibição de dados ... TODO

Os arquivos `Rmd` precisam ser compilados com `markdown::render()` ou
`markdown::run()`.

As aplicações Shiny estão ativas no servidor RStudio/Shiny do LEG/PET:
<http://shiny.leg.ufpr.br/iguir/>.

****
## Organização do repositório

TODO

****
## Como citar esse material

TODO

<!------------------------------------------------------------------ -->

[`animation`]: http://yihui.name/animation/
[`rgl`]: http://rgl.neoscientists.org/about.shtml
[`googleVis`]: https://cran.r-project.org/web/packages/googleVis/index.html
[`rpanel`]: https://cran.r-project.org/web/packages/rpanel/index.html
[`gWdigets`]: https://cran.r-project.org/web/packages/gWidgets/index.html
[`shiny`]: http://shiny.rstudio.com/
