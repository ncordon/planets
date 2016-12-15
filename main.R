#!/usr/bin/Rscript    

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
pkgs <- c('Bessel', 'pracma', 'ggplot2')

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

# Leemos los datos de los planetas
planetas <- read.csv(file='../planetas_data.csv', header= T, stringsAsFactors = F)

#Leemos el tiempo solicitándoselo al usuario
t <- input$timeselect
t.ini <- 0

##########################################################################
# Carga de archivos auxiliares
##########################################################################

# Newton-Raphson y Bessel
source(file = "../algorithm.R", local=T)
# Cálculo de características de planeta(órbita, energía, momento angular,...)
source(file = "../planets.R", local=T)


##########################################################################
# Resultados
##########################################################################

planetas.datos <- lapply(1:nrow(planetas), function(i){ planet.info( planetas[i,] ) })

orbitas <- lapply(planetas.datos, function(p){
  data.frame(name = p$name, ordenadas = p$ordenadas, abscisas = p$abscisas)
})

orbitas <- do.call(rbind, orbitas)


graph <- ggplot(data = orbitas, aes(x=abscisas, y=ordenadas, col=name)) +
  geom_point(size=1) +
  xlab("x") + ylab("y") +
  ggtitle("Órbitas de planetas") +
  scale_color_brewer(palette="Paired") +
  labs(col = "Planetas")

graph
#planetas.datos
