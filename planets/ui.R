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

  sidebarLayout(#position = "right",
    sidebarPanel(
      h3(strong("Mecánica Celeste")),
      h4(em("Introduce un tiempo inicial para el que conocer las características orbitales \
         de los distintos planetas del Sistema Solar en dicho instante de tiempo")),
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
      numericInput("timeselect", label="Introduce tiempo en días", value=0) ),
    
    mainPanel(
      plotOutput("graph"),
      tableOutput("table")
    ))
))


