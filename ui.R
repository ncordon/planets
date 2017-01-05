##########################################################################
# Lista de paquetes a cargar
##########################################################################

### Bessel -> funciones de Bessel
### pracma -> producto vectorial
### ggplot2 -> paquete para gráficas
### shiny -> render web
### plotly -> paquete para gráficas 3D
library('Bessel')
library('pracma')
library('ggplot2')
library('shiny')
library('plotly')

shinyUI(fluidPage(
  titlePanel("Órbitas del Sistema Solar") ,

  sidebarLayout(position = "left",
    sidebarPanel(
      checkboxGroupInput("planetselect", 
                         label = h4("Planetas a dibujar"), 
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
        column(8, plotlyOutput("graph", width="100%", height="100%"),
               style="height: 30em; width: 40em"),
        column(4)
      ))),
  fluidRow(
    column(12, tableOutput("table"), style="font-size:95%")     
  )
))


