##########################################################################
# Lista de paquetes a cargar
##########################################################################

### Bessel -> funciones de Bessel
### pracma -> producto vectorial
### ggplot2 -> paquete para gráficas
### shiny -> render web
pkgs <- c('Bessel', 'pracma', 'ggplot2', 'shiny')

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages()[,1] ]

  if ( length(to.install) > 0 ){
    install.packages( to.install, dependencies = TRUE )
  }
  
  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()



shinyUI(fluidPage(
  titlePanel("Órbitas del Sistema Solar") ,

  sidebarLayout(#position = "right",
    sidebarPanel(
      h3(strong("Mecánica Celeste")),
      h4(em("Introduce un tiempo inicial para el que conocer las características orbitales \
         de los distintos planetas del Sistema Solar en dicho instante de tiempo"))),
    mainPanel(
      fluidRow(
        column(3, checkboxGroupInput("planetselect", 
                                     label = h3("Planetas a dibujar"), 
                                     choices = list("Mercurio"=1,
                                                    "Venus"=2,
                                                    "Tierra"=3,
                                                    "Marte"=4,
                                                    "Júpiter"=5,
                                                    "Saturno"=6,
                                                    "Urano"=7,
                                                    "Neptuno"=8),

                                     selected = 1:8)),
        column(3, numericInput("timeselect", label="Introduce tiempo en días", value=0))),
      br(),
      plotOutput("graph"),
      textOutput("text1")
    ))
))


