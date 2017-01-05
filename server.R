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
library('Bessel')
library('pracma')
library('ggplot2')
library('shiny')
library('plotly')

##########################################################################
# Lectura de datos
##########################################################################

# Datos de los planetas
planetas <- data.frame(
  name = c("Mercurio", "Venus", "Tierra", "Marte", "Júpiter", "Saturno", "Urano", "Neptuno"),
  period = c(87.97, 224.7, 365.26, 686.98, 4332.6, 10759, 30687, 60784),
  a = c(0.387, 0.723, 1, 1.524, 5.203, 9.546, 19.20, 30.09),
  epsilon = c(0.206, 0.007, 0.0017, 0.093, 0.048, 0.056, 0.047, 0.009),
  fi = pi/180 * c(7, 3.59, 0, 1.85, 1.31, 2.5, 0.77, 1.78),
  omega = pi/180 * c(75.9, 130.15, 101.22, 334.22, 12.72, 91.09, 169.05, 43.83),
  perihelio = pi/180 * c(47.14, 75.78, 0, 48.78, 99.44, 112.79, 73.48, 130.68)
)


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
    sel.planets <- planetas[ planetas$name %in% selected, ]
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
      paste( format(unlist(...), digits=4), collapse=", ")
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
    sun <- data.frame(abscisas=0, ordenadas=0, alturas=0)

    datos <- rbind(orbits, current)

    # Dibuja gráfico con planetas
    plot_ly() %>% 
    add_trace(data = datos,
            x = ~ordenadas,
            y = ~abscisas,
            z = ~alturas,
            type = 'scatter3d',
            mode = 'markers',
            color = ~name,
            size = ~point.size,
            marker = list(sizeref = 0.5))
    ## %>%
    ##   add_trace(data=current,
    ##         x = ~ordenadas,
    ##         y = ~abscisas,
    ##         z = ~alturas,
    ##         type = 'scatter3d',
    ##         mode = 'markers',
    ##         marker = list(size = 2))
    
    ## if(input$sunselect){
    ##   graph <- graph + geom_point(data = sun, size=6, aes(x=abscisas, y=ordenadas), col="gold1") 
    ## }

    
    ## ## graph <- graph + 
    ## ##   geom_path(data = orbits, size=2, aes(x=abscisas, y=ordenadas, col=name)) +
    ## ##   scale_x_continuous(name = "x", labels = function(x){ as.character(round(x,4)) }) +
    ## ##   scale_y_continuous(name = "y", labels = function(y){ as.character(round(y,4)) }) +
    ## ##   scale_color_brewer(palette="Paired") +
    ## ##   geom_point(data = current, size=4, aes(x=abscisas, y=ordenadas), col="black") +
    ## ##   coord_cartesian(xlim = graph.axis$x, ylim = graph.axis$y) +
    ## ##   theme(legend.text = element_text(size=14),
    ## ##         legend.title = element_blank(),
    ## ##         axis.text = element_text(size=14),
    ## ##         axis.title = element_text(size=14))
    
    #graph
  })  
}
