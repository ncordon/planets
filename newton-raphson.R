#!/usr/bin/Rscript    

# Limpieza del entorno
rm(list = ls())

# Precisión de cálculo para Rmpfr
# prec <- 120

##########################################################################
# Lista de paquetes a cargar
##########################################################################

pkgs <- c('Rmpfr','Bessel')

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
# Parámetros que se le requieren al usuario
##########################################################################
cat("Introduce el tiempo para el que calcular la posición: ")
input<-file('stdin', 'r')
t <- as.numeric(readLines(input, n=1))

#t <- 0
t.ini <- 0
a <- 1
epsilon <- 0.017
period <- 365.26
tolerance <- 1e-10




newton.raphson <- function(a, epsilon, period, t, t.ini, tolerance){  
  ji <- 2*pi*(t-t.ini)/period

  phi <- function(u){
    (epsilon*(sin(u)-u*cos(u))+ji)/(1+epsilon*cos(u))

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


# Prueba de que la función implementada funciona
result <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
posicion <- a*c(cos(result) - epsilon, sqrt(1-epsilon^2)*sin(result))

 
# Parámetros para pintar
n.points <- 100

# Extraemos n.points equidistantes en el intervalo para pintar
positions <- lapply(0:n.points, function(x){
  t <- t.ini + x*(period - t.ini)/n.points
  u <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
  c(a*c(cos(u) - epsilon, sqrt(1-epsilon^2)*sin(u)))
})


pos.x <- sapply(positions, "[", 1)
pos.x <- sapply(pos.x, asNumeric)
pos.y <- sapply(positions, "[", 2)
pos.y <- sapply(pos.y, asNumeric)
plot(pos.x, pos.y)

# Devolvemos la posición
posicion
