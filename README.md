<img src="http://200.17.213.89/~iguir/iguir2.svg"
width=100px align="right" display="block">

Explorando Interfaces Gráficas com o R
======================================

[Eduardo E. Ribeiro Jr](https://gitlab.c3sl.ufpr.br/u/eerj12), PET-Estatística UFPR  
[Prof. Walmes M. Zeviani](http://www.leg.ufpr.br/~walmes/), LEG UFPR

Projeto desenvolvido no serviço [GitLab do C3SL] (Centro de Computação
Científica e Software Livre) e mantido também como repositório da
organização [PET Estatística no GitHub]. Todas as contribuições para o
projeto são bem vindas.

- [Motivação](#motivacao)
- [Como visualizar o material](#como-visualizar-o-material)
- [Organização do repositório](#organizacao-do-repositorio)


****

## Motivação ##

O R é um programa para computação estatística e gráficos muito utilizado
por estatísticos e cientistas de dados, possivelmente o mais
utilizado. Seu uso é essencialmente via _CLI (Command Line Interface)_,
com resultados textuais exibidos em um _console_ e gráficos em uma
janela do sistema operacional. Porém, utilizado desta forma, o programa
desencoraja usuários não acostumados com programação e os que tem
familiaridade ainda obtém resultados estáticos.

Nesse material consideramos ferramentas em R para produzir resultados de
forma interativa ou não-estática. Estes resultados se caracterizam pela
interação proporcionada ao usuário, quando o objetivo é a criação de
interfaces com _widgets_ (controladores como botões, deslizadores etc.)
e pelo dinamismo dos gráficos, quando o objetivo é apenas
visualização. Em nossas experiências o uso potencial destas ferramentas
de dá como:

 * **Instrumento de ensino:** Muitos conceitos e resultados em
   Estatística, são apresentados nos cursos de graduação e pós-graduação
   a partir de axiomas e teoremas, porém muitos deles também podem ser
   visualizados de forma gráfica o que acelera a compreensão e
   assimilação do conteúdo;

 * **Construção de aplicativos:** A elaboração de mini-aplicativos
   principalmente para coleta de dados torna o trabalho, inerente a um
   experimento planejado, menos árduo no sentido de que não se é mais
   necessário a transferência dos resultados do papel para o computador;

 * **Exibição de relatórios:** Relatórios técnicos em Estatística ainda
   tem a característica estática, geralmente os resultados obtidos são
   apresentados no formato PDF. Porém com as ferramentas apresentadas
   podemos exibir nossos resultados de forma _web_ interativa, onde o
   leitor pode até trocar os valores que são utilizados para gerar os
   resultados e ter uma visão mais ampla do trabalho.

 * **Interfaces para pacotes:** Muitas bibliotecas do R, chamadas de
   pacotes já utilizam os recursos gráficos para criar interfaces
   interativas. No contexto de pacotes R essas interfaces objetivam
   principalmente a explicação funções exibindo, interativamente, a
   influências dos argumentos da função sobre os resultados.

Este repositório explora sete pacotes R, que possibilitam alguma forma
de interação com o usuário. Os pacotes abordados que se encaixam na
geração de gráficos dinâmicos são: [`animation`] que serve para gerar
animações em diversos formatos, como *gif* e animações em *javascript*
dentro de páginas web; [`rgl`] que permite explorar o espaço
tridimensional também com a possibilidade de geração de _gifs_ e páginas
_web_ com _WebGL_; [`googleVis`] proporcionando a elaboração de gráficos
da galeria Google Charts a partir de objetos do R;e [`rCharts`] pacote
ainda em desenvolvimento que possibilita criar, customizar e publicar
visualizações interativas _JavaScript_ com o R, utilizando a sintaxe
_lattice_. Para criação de interfaces com _widgets_ consideramos os
pacotes [`rpanel`] e [`gWdigets`], com eles é possível fazer interfaces
gráficas e até mini aplicativos baseados em Tcl/Tk ou Gtk+. Por fim,
nesta categoria, o pacote [`shiny`] que possibilita construir aplicações
Web com o R baseadas em *javascript* também ganha destaca no nosso
material.

## Como visualizar o material ##

Primeiramente certifique-se que todos as bibliotecas abordadas estão
instaladas no seu computador:

```r
## Verificando e instalando, se necessário, todos os pacotes abordados

## CRAN
pkg <- c("animation", "googleVis", "gWidgets", "rgl", "rpanel", "shiny")
sapply(pkg, FUN = function(x) {
    if (!require(x, quietly = TRUE, character.only = TRUE))
        install.packages(x, dep = TRUE, repos = repos, lib = lib)
    else TRUE
})

## GITHUB
if (!require("rCharts", quietly = TRUE, character.only = TRUE))
    devtools::install_git("rCharts", "ramnathv")
```

Para este projeto foram elaborados vários exemplos que podem ser
explorados a partir de seu código-fonte em R. Porém como opção de
apresentação das biliotecas exploradas, elaboramos também galerias de
exemplos, escritas em [RMarkDown]. Estas galerias devem ser compiladas
para que se possa visualizar seu resultado em formato HTML. Abaixo
temos os códigos em R para compilar e visualizar os materiais:

```r
## Lista o estado do diretório iguir2
files0 <- list.files(recursive = TRUE)
dirs0 <- list.dirs(recursive = TRUE)

## Encontra todos os arquivos RMarkdown do diretório
rmdAll <- list.files(pattern = "*.Rmd$", recursive = TRUE)

## Separa os que Rmd Shiny, que devem ser executados com run
rmdShiny <- grepl("^shiny", rmdAll)
rmdFiles <- rmdAll[!rmdShiny]
rmdShiny <- rmdAll[rmdShiny]

## Compila os arquivos Rmd e abre no navegador padrão
library(rmarkdown)

sapply(rmdFiles, FUN = function(x) {
    path <- render(x, quiet = TRUE)
    browseURL(path)
})

## Para as aplicações Rmd shiny deve-se compilá-las uma a uma, pois elas
## utilizam na sessão R. Certifique-se de parar o processo atual para
## executar a próxima aplicação
run(rmdShiny[1])
run(rmdShiny[2])
run(rmdShiny[3])
browserURL("http://shiny.leg.ufpr.br/iguir/") ## online

## Abrindo o pdf no visualizador padrão. Agora os links funcionam :)
file <- "./slides/slides.pdf"
switch(.Platform$OS.type,
       "windows" = shell.exec(file),
       "unix" = system(paste(getOption("pdfviewer"), file)))

## Limpa o diretório. Para compilar as galerias de exemplos muitos
## arquivos adicionais são criados (principalmente no animation). Veja
## os objetos *Creates.
files1 <- list.files(recursive = TRUE)
dirs1 <- list.dirs(recursive = TRUE)

filesCreates <- setdiff(files1, files0)
dirsCreates <- setdiff(dirs1, dirs0)
file.remove(filesCreates, dirsCreates)
```

Executando o cógido descrito vc terá todos os arquivos gerados e poderá
usufruir dos _links_ incluídos na apresentação PDF elaborada.

Obs.: As aplicações Shiny produzidas para este projeto estão ativas no
servidor RStudio/Shiny do LEG/PET: <http://shiny.leg.ufpr.br/iguir/>.

****

## Organização do repositório ##

Como organização do material produzido adotamos no repositório um
diretório dedicado a cada pacote abordado. Cada repositório tem suas
particularidades devido às particularidades dos pacotes, porém, com
exceção do `shiny/`, temos uma galeria com exemplos para toda biblioteca
cujo nomeamos de `package.Rmd`, este arquivo `.Rmd` deve ser compilado
conforme procedimento descrito anteriormente. Também dedicamos um
diretório para a criação dos slides utilizados em cursos, os slides
são elaborados em LaTeX e cada pacote ganhou um arquivo para que a
elaboração pudesse ser realizada de forma paralela.

A estrutura geral dos diretórios dentro deste repositório é representada
pelo diagrama abaixo.

```
.
├── README.md              ## Visão geral do projeto
├── plano.org              ## Plano de trabalho adotado
├── galery.css             ## Arquivo de estilo das galerias
├── animation
│   ├── animation.Rmd      ## Galeria de exemplos
│   ├── anima.R            ## Animações elaboradas
│   └── ...
├── googleVis
│   └── googleVis.Rmd      ## Galeria de exemplos
├── gWidgets
│   ├── gWidgets.Rmd       ## Galeria de exemplos
│   ├── gifs
│   │   ├── interface.gif  ## Gif das interfaces elaboradas
│   │   └── ...
│   ├── interfaces.R       ## Interfaces elaboradas
│   └── ...
├── rCharts
│   ├── rCharts.Rmd        ## Galeria de exemplos
│   └── pajero-dakar.csv   ## Dataset utilizado
├── rgl
│   ├── rgl.Rmd            ## Galeria de exemplos
│   └── setup.R            ## Necessário geração do arquivo com _WebGL_
├── rpanel
│   ├── rpanel.Rmd         ## Galeria de exemplos
│   ├── gifs
│   │   ├── interface.gif  ## Gif das interfaces elaboradas
│   │   └── ...
│   ├── interfaces.R       ## Interfaces elaboradas
│   └── ...
├── shiny
│   ├── shiny-pres.Rmd     ## Apresentação detalhada do pacote
│   ├── images             ## Imagens utilizadas na apresentação
│   │   ├── figures.svg
│   │   └── ...
│   ├── aplicação          ## Arquivos necessários para a aplicação shiny
│   │   ├── ui.R 
│   │   ├── server.R 
│   │   └── aux_files.[dat, Rnw, md, ...]
│   ├── insertTemplate     ## Shell script para inserção do cabeçalho iguir2
│   ├── shinyApp           ## Shell script para criação automática de apps
│   └── template.R         ## Cabeçalho das interfaces
└── slides
    ├── images
    │   ├── files.[png, jpg, gif]
    │   └── ...
    ├── secoes.tex         ## Seções dos slides 
    ├── slides.tex         ## Agregação das seções em arquivo único
    ├── slides.pdf         ## Resultado da compilação dos slides
    └── tikz
        ├── imagem.pgf     ## Código da imagem em Tikz
        ├── imagem.pdf     ## Compilação do Tikz
        └── ...

49 directories, 300 files
```

<!------------------------------------------------------------------ -->

[GitLab do C3SL]: https://gitlab.c3sl.ufpr.br/pet-estatistica/iguir2
[PET Estatística no GitHub]: https://github.com/pet-estatistica/iguir2
[`animation`]: http://yihui.name/animation/
[`rgl`]: http://rgl.neoscientists.org/about.shtml
[`googleVis`]: https://cran.r-project.org/web/packages/googleVis/index.html
[`rpanel`]: https://cran.r-project.org/web/packages/rpanel/index.html
[`gWdigets`]: https://cran.r-project.org/web/packages/gWidgets/index.html
[`shiny`]: http://shiny.rstudio.com/
[`rCharts`]: http://ramnathv.github.io/rCharts/
[RMarkDown]: http://rmarkdown.rstudio.com/
