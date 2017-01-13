##########################################################################
# Lista de paquetes a cargar
##########################################################################

### Bessel -> funciones de Bessel
### pracma -> producto vectorial
### ggplot2 -> paquete para gráficas
### shiny -> render web
### plotly -> paquete para gráficas 3D
### shinythemes -> para poder usar theme united
library('Bessel')
library('pracma')
library('ggplot2')
library('shiny')
library('plotly')
library('shinythemes')

shinyUI(fluidPage(
  theme = shinytheme("united"),
  titlePanel("Órbitas del Sistema Solar") ,
  sidebarLayout(position = "left",
                sidebarPanel(width = 3,
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
        column(10, plotlyOutput("graph", width="100%", height="100%"),
               style="height: 35em; width: 55em"),
        column(2)
      ))),
  fluidRow(
    column(12, tableOutput("table"), style="font-size:95%")     
  )
))


