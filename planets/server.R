# Limpieza del entorno
rm(list = ls())
# Precisión de 22 dígitos
options(digits=22)
# Tolerancia para los algoritmos
tolerance <- 1e-12
# Número de puntos a graficar para cada planeta
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
library('data.table')
#pkgs <- c('Bessel', 'pracma', 'ggplot2', 'shiny')
#sapply(pkgs, require, character.only=TRUE)


##########################################################################
# Lectura de datos
##########################################################################

# Datos de los planetas
planetas <- data.frame(
  name = c("Mercurio", "Venus", "Tierra", "Marte", "Júpiter", "Saturno", "Urano", "Neptuno"),
  period = c(87.07, 224.7, 365.26, 686.98, 4332.6, 10759, 30687, 60784),
  a = c(0.387, 0.723, 1, 1.524, 5.203, 9.546, 19.20, 30.09),
  epsilon = c(0.206, 0.007, 0.0017, 0.093, 0.048, 0.056, 0.047, 0.009))


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
  output$table <- renderTable({
    t <- as.numeric(input$timeselect)
    selected <- input$planetselect
    validate( need( length(selected) > 0, "Selecciona algún planeta") )

    make.format <- function(...){ paste(sapply(..., format, digits=4), collapse=", ") }
    sel.planets <- planetas[ planetas$name %in% selected, ]
    planet.data <- lapply(1:nrow(sel.planets), function(i){ planet.info( sel.planets[i,], t ) })

    results <- lapply(planet.data, function(p){
      lapply(list(p$name, p$posicion.nr, p$posicion.bessel,
                 p$distancia.sol, p$velocidad, p$momento.angular,
                 p$area, p$energia.calculada, p$energia.teorica),
             make.format)
    })

    results <- data.frame(do.call(rbind, results))
    colnames(results) <- c("Planeta", "Posición Newton-Raphson", "Posición Bessel",
                           "Distancia Sol", "Vector velocidad", "Momento angular",
                           "Área", "Energía calculada", "Energía teórica")
 
    results
  })

  output$graph <- renderPlot({
    #Leemos el tiempo solicitándoselo al usuario
    t <- as.numeric(input$timeselect)
    # validate( need( t < 0, "Introduzca tiempo mayor que 0") )
    selected <- input$planetselect
    validate( need( length(selected) > 0, "Selecciona algún planeta") )

    sel.planets <- planetas[ planetas$name %in% selected, ]
    planet.data <- lapply(1:nrow(sel.planets), function(i){ planet.info( sel.planets[i,], t ) })

    orbits <- lapply(planet.data, function(p){
      data.frame(name = p$name, ordenadas = p$ordenadas, abscisas = p$abscisas)
    })
    current <- lapply(planet.data, function(p){
      data.frame(abscisas = p$posicion.nr[1], ordenadas = p$posicion.nr[2])
    })

    orbits <- data.frame(do.call(rbind, orbits), point.size=1)
    current <- data.frame(do.call(rbind, current), point.size=3)

    graph <- ggplot()  +
      geom_path(data = orbits, size=1, aes(x=abscisas, y=ordenadas, col=name)) +
      xlab("x") + ylab("y") +
      scale_color_brewer(palette="Paired") +
      labs(col = "Planetas") +
      geom_point(data = current, size=2, aes(x=abscisas, y=ordenadas), col="black")

    graph
  })
}
