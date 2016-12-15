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
pkgs <- c('Bessel', 'pracma', 'ggplot2', 'shiny')

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages()[,1] ]

  if ( length(to.install) > 0 ){
    install.packages( to.install, dependencies = TRUE )
  }
  
  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()


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
source(file = "./algorithm.R")
# Cálculo de características de planeta(órbita, energía, momento angular,...)
source(file="helpers.R", local=T)


function(input, output){ 
  output$graph <- renderPlot({
    #Leemos el tiempo solicitándoselo al usuario
    t <- as.numeric(input$timeselect)
    validate(need(t>0, "Introduzca tiempo mayor que 0"))

    ##########################################################################
    # Resultados
    ##########################################################################    
    planetas.datos <- lapply(1:nrow(planetas), function(i){ planet.info( planetas[i,], t ) })

    orbitas <- lapply(planetas.datos, function(p){
      data.frame(name = p$name, ordenadas = p$ordenadas, abscisas = p$abscisas)
    })
    current <- lapply(planetas.datos, function(p){
      data.frame(name = "Posicion(t)", abscisas = p$posicion.nr[1], ordenadas = p$posicion.nr[2])
    })

    orbitas <- data.frame(do.call(rbind, orbitas), point.size=1)
    current <- data.frame(do.call(rbind, current), point.size=3)

    graph <- ggplot()  +
      geom_path(data = orbitas, size=1, aes(x=abscisas, y=ordenadas, col=name)) +
      xlab("x") + ylab("y") +
      scale_color_brewer(palette="Paired") +
      labs(col = "Planetas") +
      geom_point(data = current, size=2, aes(x=abscisas, y=ordenadas), col="black")

    graph
  })
}
