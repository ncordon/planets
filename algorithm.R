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
