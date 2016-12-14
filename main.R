#!/usr/bin/Rscript    

# Limpieza del entorno
rm(list = ls())


##########################################################################
# Lista de paquetes a cargar
##########################################################################

pkgs <- c('Rmpfr','Bessel', 'pracma', 'ggplot2')

options(digits=22)

load.my.packages <- function(){
  to.install <- pkgs[ ! pkgs %in% installed.packages()[,1] ]

  if ( length(to.install) > 0 ){
    install.packages( to.install, dependencies = TRUE )
  }
  
  sapply(pkgs, require, character.only=TRUE)
}

load.my.packages()

##########################################################################
# Carga de algoritmos
##########################################################################
source(file = "algorithm.R")

##########################################################################
# Lectura de datos
##########################################################################
cat("Introduce el tiempo para el que calcular la posición: ")
#input<-file('stdin', 'r')
#t <- as.numeric(readLines(input, n=1))


# Leemos los datos de los planetas
planetas <- read.csv(file='./planetas_data.csv', header= T, stringsAsFactors = F)
t <- 29
t.ini <- 0
tolerance <- 1e-12
n.points <- 100

# Obtenemos la posición para la entrada requerida
# result.bessel <- bessel.method(a, epsilon, period, t, t.ini, tolerance)


# Comprobación de que los resultados con Bessel y Newton Raphson son iguales
(result.nr - result.bessel) < 1e-10


result <- 
lapply(1:nrow(planetas), function(i){
  p <- planetas[i,]
  name <- p$nombre
  a <- p$a
  epsilon <- p$epsilon
  period <- p$periodo
  mu <- 4*pi^2/period^2 * a^3

  result.nr <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
  posicion.nr <- a*c(cos(result.nr) - epsilon, sqrt(1-epsilon^2)*sin(result.nr))
  
  # Extraemos n.points equidistantes en el intervalo para pintar
  positions <- lapply(0:n.points, function(x){
    t <- t.ini + x*(period - t.ini)/n.points
    u <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
    c(a*c(cos(u) - epsilon, sqrt(1-epsilon^2)*sin(u)))
  })


  pos.x <- sapply(positions, "[", 1)
  pos.y <- sapply(positions, "[", 2) 


  ##########################################################################
  # Devolvemos los resultados para la Tierra
  ##########################################################################

  u.diff <- 2*pi/(period*(1-epsilon * cos(result.nr)))
  velocidad <- a*c(-sin(result.nr) * u.diff, sqrt(1-epsilon^2) * cos(result.nr) * u.diff)
  momento.angular = as.vector(cross( c(posicion.nr, 0), c(velocidad, 0) ))

  list(name = name,
     posicion = posicion.nr,
     distancia.Sol = sqrt(sum(posicion.nr^2)),
     velocidad = velocidad,
     momento.angular = momento.angular,
     area = 1/2 * sqrt(sum(momento.angular^2)) * (t-t.ini),
     energia.calculada = sum(velocidad^2)/2 - mu/sqrt( sum(posicion.nr^2) ),
     energia.teorica = -mu/(2*a),
     abscisas = pos.x,
     ordenadas = pos.y)     
})

positions <- lapply(result, function(p){
  data.frame(name = p$name, ordenadas = p$ordenadas, abscisas = p$abscisas)
})

positions <- do.call(rbind, positions)


ggplot(data = positions, aes(x=abscisas, y=ordenadas, col=name)) + geom_point()
