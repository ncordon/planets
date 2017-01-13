# Limpieza del entorno
rm(list = ls())
# Precisión de 22 dígitos
options(digits=22)
# Tolerancia para los algoritmos
tolerance <- 1e-12
# Precisión con la que graficar la órbita de cada planeta
n.points <- 100


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

##########################################################################
# Lectura de datos
##########################################################################

# Datos de los planetas

source(file = "./data.R", local=T)

##########################################################################
# Carga de archivos auxiliares
##########################################################################

# Newton-Raphson y Bessel
source(file = "./algorithm.R", local=T)
# Cálculo de características de planeta(órbita, energía, momento angular,...)
source(file="helpers.R", local=T)


##########################################################################
# Resultados
##########################################################################    
function(input, output){
  # Planetas seleccionados
  sel.planets <- reactive({
    selected <- input$planetselect
    # Comprueba que la entrada es no vacía
    req(selected)
    sel.planets <- planets[ planets$name %in% selected, ]
    planet.data <- lapply(1:nrow(sel.planets), function(i){
      planet.info( sel.planets[i,], sel.time() )
    }) 
    
    planet.data
  })


  # Tiempo seleccionado
  sel.time <- reactive({
    t <- as.numeric(input$timeselect)
    # Si t no tiene un valor válido, se interrumpe la ejecuciób
    req(t)

    t
  })

  
  # Tabla de resultados
  output$table <- renderTable({
    planet.data <- sel.planets()
    
    make.format <- function(...){
      paste( format(unlist(...), digits=3), collapse=", ")
    }

    results <- lapply(planet.data, function(p){
      lapply(list(p$name, p$posicion.nr, p$posicion.bessel,
                 p$distancia.sol, p$velocidad, p$momento.angular,
                 p$area, p$energia.calculada, p$energia.teorica),
             make.format)
    })

    results <- data.frame(do.call(rbind, results))
    colnames(results) <- c("Planeta", "x(t) Newton-Raphson", "x(t) Bessel",
                           "Distancia Sol", "x'(t)", "Momento angular",
                           "Área barrida", "Energía calculada", "Energía teórica")
 
    results
  })
  
  # Gráfico de resultados
  output$graph <- renderPlotly({
    planet.data <- sel.planets()

    orbits <- lapply(planet.data, function(p){
      data.frame(name = p$name,
                 ordenadas = p$ordenadas,
                 abscisas = p$abscisas,
                 alturas = p$alturas)
    })
    current <- lapply(planet.data, function(p){
      data.frame(name = p$name,
                 ordenadas = p$posicion.nr[2],
                 abscisas = p$posicion.nr[1],
                 alturas = p$posicion.nr[3])
    })

    orbits <- data.frame(do.call(rbind, orbits), point.size=1)
    current <- data.frame(do.call(rbind, current), point.size=2)
    sun <- data.frame(name="Sol", abscisas=0, ordenadas=0, alturas=0)

    # Dibuja gráfico con planetas
    graph <- plot_ly() %>%      
      add_trace(
        data = rbind(orbits, current),
        x = ~ordenadas,
        y = ~abscisas,
        z = ~alturas,
        type = 'scatter3d',
        mode = 'markers',
        color = ~name,
        colors = "Set1",
        size = ~point.size,
        marker = list(opacity=1)) %>%
      add_trace(
        data = sun,
        x = ~ordenadas,
        y = ~abscisas,
        z = ~alturas,
        type = 'scatter3d',
        mode = 'markers',
        color = ~name,
        marker = list(color="gold", opacity=1)) %>%  
      layout(
        scene = list(
          xaxis = list(title = ""), 
          yaxis = list(title = ""), 
          zaxis = list(title = "", range= list(-30,30))))
    graph
  })
}
