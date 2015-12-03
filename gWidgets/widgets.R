## Coleção de widgets.

require(gWidgets)
require(gWidgetstcltk)
options(guiToolkit="tcltk")

w <- gwindow(title="Coleção de widgets", width=600, height=500, visible=FALSE)
gg <- gpanedgroup(horizontal=TRUE, container=w)
gg1 <- ggroup(horizontal=FALSE, container=gg)
gg2 <- ggroup(horizontal=FALSE, container=gg)
svalue(gg) <- 0.5

gg1 <- gpanedgroup(horizontal=FALSE, container=gg1)
gg2 <- gpanedgroup(horizontal=FALSE, container=gg2)

gf <- gframe(text="gbutton", container=gg1)
gbutton(text="Ok!", container=gf)

gf <- gframe(text="gspinbutton", container=gg1)
gspinbutton(from=0, to=10, by=1, value=4, container=gf)

gf <- gframe(text="gslider", container=gg1)
gslider(from=0, to=10, by=1, value=4, container=gf)

gf <- gframe(text="gedit", container=gg1)
gedit(initial.msg="Mensagem inicial", container=gf)

gf <- gframe(text="gtext", container=gg1)
gtext(text="Texto inicial editável", container=gf)

gf <- gframe(text="gcheckbox", container=gg2)
gcheckbox(text="Marcar", checked=TRUE, container=gf)

gf <- gframe(text="gcheckboxgroup", container=gg2)
gcheckboxgroup(items=c("Item 1", "Item 2", "Item 3"),
               checked=c(TRUE,FALSE,TRUE),
               container=gf)

gf <- gframe(text="gradio", container=gg2)
gradio(items=c("Opção 1","Opção 2","Opção 3"),
       selected=1, container=gf)

gf <- gframe(text="gcombobox", container=gg2)
gcombobox(items=c("Opção 1","Opção 2","Opção 3"),
          selected=1, container=gf, editable=TRUE)

gf <- gframe(text="gdroplist", container=gg2)
gdroplist(items=c("Opção 1","Opção 2","Opção 3"),
          selected=1, container=gf, editable=TRUE)

gf <- gframe(text="gtable", container=gg2)
gtable(items=c("Opção 1","Opção 2","Opção 3"),
       selected=1, container=gf)

visible(w) <- TRUE

## help(gslider, h="html")
