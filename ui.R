##########################################################################
# Lista de paquetes a cargar
##########################################################################

### Bessel -> funciones de Bessel
### pracma -> producto vectorial
### ggplot2 -> paquete para gráficas
### shiny -> render web
library('Bessel')
library('pracma')
library('ggplot2')
library('shiny')
#pkgs <- c('Bessel', 'pracma', 'ggplot2', 'shiny')
#sapply(pkgs, require, character.only=TRUE)

shinyUI(fluidPage(
  titlePanel("Órbitas del Sistema Solar") ,

  sidebarLayout(position = "left",
    sidebarPanel(
      h4("Introduce un tiempo inicial para el que conocer las características orbitales \
         de los distintos planetas del Sistema Solar en dicho instante de tiempo..."),
      checkboxGroupInput("planetselect", 
                         label = h3("Planetas a dibujar"), 
                         choices = list("Mercurio"="Mercurio",
                                        "Venus"="Venus",
                                        "Tierra"="Tierra",
                                        "Marte"="Marte",
                                        "Júpiter"="Júpiter",
                                        "Saturno"="Saturno",
                                        "Urano"="Urano",
                                        "Neptuno"="Neptuno"),
                         selected = c("Mercurio", "Venus", "Tierra", "Marte",
                                      "Júpiter", "Saturno", "Urano", "Neptuno")),
      numericInput("timeselect", label="Introduce tiempo en días (t)", value=0) ),
    
    mainPanel(
      fluidRow(
        column(2),
        column(8, plotOutput("graph", width="100%", height="100%",
                             dblclick = "doubleclick",
                             brush = brushOpts(
                               id = "brush",
                               resetOnNew = TRUE
                             )),
               style="height: 40em; width: 60em"),
        column(2)
      ),
      #plotOutput("graph"),
      tableOutput("table")
    ))
))


