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
      checkboxInput("sunselect", label = "Sol", value = TRUE),
      numericInput("timeselect", label="Introduce tiempo en días (t)", value=0) ),
    
    mainPanel(
      fluidRow(
        column(8, #plotOutput("graph", width="100%", height="100%",
                  #           dblclick = "doubleclick",
                  #           brush = brushOpts(
                  #             id = "brush",
               #             resetOnNew = TRUE )),
               plotlyOutput("graph"),
               style="height: 35em; width: 55em"),
        column(4)
      ))),
  fluidRow(
    column(10, tableOutput("table"))
  )
))


