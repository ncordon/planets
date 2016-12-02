#!/usr/bin/Rscript    

# Limpieza del entorno
rm(list = ls())


##########################################################################
# Lista de paquetes a cargar
##########################################################################

pkgs <- c('Rmpfr','Bessel', 'pracma')

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
# Parámetros
##########################################################################
cat("Introduce el tiempo para el que calcular la posición: ")
input<-file('stdin', 'r')
t <- as.numeric(readLines(input, n=1))


# Leemos los datos de los planetas
planetas <- read.csv2(file='./planetas_data.csv', header= T)

#t <- 29
t.ini <- 0
a <- 1
epsilon <- 0.017
period <- 365.26
tolerance <- 1e-12
mu <- 4*pi^2/period^2 * a^3



##########################################################################
# Método de Newton de Raphson
##########################################################################
newton.raphson <- function(a, epsilon, period, t, t.ini, tolerance){  
  ji <- 2*pi*(t-t.ini)/period

  phi <- function(u){
    (epsilon*(sin(u)-u*cos(u))+ji)/(1-epsilon*cos(u))

  }

  # Tomamos u_0 = pi
  u <- pi
  phi.u <- phi(u)
  
  while(abs(phi.u - u) > tolerance){
    u <- phi.u
    phi.u <- phi(u)
  }
  
  u
}

##########################################################################
# Método de Newton de Bessel
##########################################################################

bessel.method <- function(a, epsilon, period, t, t.ini, tolerance){
  ji <- 2*pi*(t-t.ini)/period

  series.term <- function(n){
    2/n*besselJ(n*epsilon, n)*sin(n*ji)
  }
  
  u <- ji + series.term(1)
  bessel.u <- u + series.term(2)
  n <- 3
  
  while(abs(bessel.u - u) > tolerance){
    u <- bessel.u
    bessel.u <- bessel.u + series.term(n)
    n <- n+1
  } 

  bessel.u
}


# Obtenemos la posición para la entrada requerida
result.nr <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
result.bessel <- bessel.method(a, epsilon, period, t, t.ini, tolerance)
posicion.nr <- a*c(cos(result.nr) - epsilon, sqrt(1-epsilon^2)*sin(result.nr))


# Comprobación de que los resultados con Bessel y Newton Raphson son iguales
(result.nr - result.bessel) < 1e-10

##########################################################################
#Pintamos gráfica para la Tierra
##########################################################################
n.points <- 100

# Extraemos n.points equidistantes en el intervalo para pintar
positions <- lapply(0:n.points, function(x){
  t <- t.ini + x*(period - t.ini)/n.points
  u <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
  c(a*c(cos(u) - epsilon, sqrt(1-epsilon^2)*sin(u)))
})


pos.x <- sapply(positions, "[", 1)
pos.y <- sapply(positions, "[", 2)
plot(pos.x, pos.y)


##########################################################################
# Devolvemos los resultados para la Tierra
##########################################################################
cat("Devolviendo resultados para la Tierra:\n")

u.diff <- 2*pi/(period*(1-epsilon * cos(result.nr)))
velocidad <- a*c(-sin(result.nr) * u.diff, sqrt(1-epsilon^2) * cos(result.nr) * u.diff)
momento.angular = as.vector(cross( c(posicion.nr, 0), c(velocidad, 0) ))

list(posicion = posicion.nr,
     distancia.Sol = sqrt(sum(posicion.nr^2)),
     velocidad = velocidad,
     momento.angular = momento.angular,
     area = 1/2 * sqrt(sum(momento.angular^2)) * (t-t.ini),
     energia.calculada = sum(velocidad^2)/2 - mu/sqrt( sum(posicion.nr^2) ),
     energia.teorica = -mu/(2*a))
 
