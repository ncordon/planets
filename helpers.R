##########################################################################
# Función de cálculo de datos característicos de planeta:
#     Posición, distancia al sol, momento angular, area de órbita, energía
##########################################################################

planet.info <- function(planet, t){
  name <- planet$name
  a <- planet$a
  epsilon <- planet$epsilon
  period <- planet$period
  mu <- 4*pi^2/period^2 * a^3
  t.ini <- 0
  upper.omega <- planet$upper.omega
  omega <- planet$omega - upper.omega
  fi <- planet$fi
  
  # Dejamos t en el intervalo [0, periodo]
  t <- t %% period
  
  # Calculo de matrices de rotación
  rot.fi    <- matrix( c(1, 0, 0,
                         0, cos(fi), -sin(fi),
                         0, sin(fi),  cos(fi)),
                      ncol=3, byrow=T )
  rot.omega <- matrix( c(cos(omega),-sin(omega), 0,
                         sin(omega), cos(omega), 0,
                         0, 0, 1),
                      ncol=3, byrow=T )
  rot.upper.omega <- matrix( c(cos(upper.omega), -sin(upper.omega), 0,
                               sin(upper.omega),  cos(upper.omega), 0,
                               0, 0, 1),
                            ncol=3, byrow=T )

  rotate <- function(x){ rot.upper.omega %*% rot.fi %*% rot.omega %*% x }

  # Aproximamos una solución de la ecuación implícita, tanto por Newton-Raphson, como por Bessel
  posicion <- function(u){
    pos.2D <- a*c(cos(u) - epsilon, sqrt(1-epsilon^2)*sin(u), 0)
    rotate(pos.2D)
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
  pos.z <- sapply(positions, "[", 3)

  ##########################################################################
  # Devolvemos los resultados para la Tierra
  ##########################################################################

  u.diff <- 2*pi/(period*(1-epsilon * cos(result.nr)))
  velocidad <- rotate( a*c(-sin(result.nr) * u.diff, sqrt(1-epsilon^2) * cos(result.nr) * u.diff, 0))
  momento.angular = as.vector(cross( posicion.nr, velocidad ))

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
       ordenadas = pos.y,
       alturas = pos.z)     
}
