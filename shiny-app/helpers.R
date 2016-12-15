##########################################################################
# Fucnión de cálculo de datos característicos de planeta:
#     Posición, distancia al sol, momento angular, area de órbita, energía
##########################################################################

planet.info <- function(planet, t){
  name <- planet$name
  a <- planet$a
  epsilon <- planet$epsilon
  period <- planet$period
  mu <- 4*pi^2/period^2 * a^3
  t.ini <- 0
  
  
  # Aproximamos una solución de la ecuación implícita, tanto por Newton-Raphson, como por Bessel
  posicion <- function(u){
    a*c(cos(u) - epsilon, sqrt(1-epsilon^2)*sin(u))
  }
  result.nr <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
  result.bessel <- bessel.method(a, epsilon, period, t, t.ini, tolerance)
  posicion.nr <- posicion(result.nr)
  posicion.bessel <- posicion(result.bessel)

  
  # Extraemos n.points puntos equidistantes en el intervalo para pintar
  positions <- lapply(0:n.points, function(x){
    t <- t.ini + x*(period - t.ini)/n.points
    u <- newton.raphson(a, epsilon, period, t, t.ini, tolerance)
    posicion(u)
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
       posicion.nr = posicion.nr,
       posicion.bessel = posicion.bessel,
       distancia.sol = sqrt(sum(posicion.nr^2)),
       velocidad = velocidad,
       momento.angular = momento.angular,
       area = 1/2 * sqrt(sum(momento.angular^2)) * (t-t.ini),
       energia.calculada = sum(velocidad^2)/2 - mu/sqrt( sum(posicion.nr^2) ),
       energia.teorica = -mu/(2*a),
       abscisas = pos.x,
       ordenadas = pos.y)     
}
