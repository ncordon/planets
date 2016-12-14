shinyUI(fluidPage(
  titlePanel(h1(strong("Órbitas del Sistema Solar"))),

  sidebarLayout(#position = "right",
    sidebarPanel(
      h3(strong("Mecánica Celeste")),
      h4(em("Introduce un tiempo inicial para el que conocer las características orbitales \
         de los distintos planetas del Sistema Solar en dicho instante de tiempo")),
      fluidRow(
        column(4,img(src = "GNU.png", width=200)),
        column(7,
      p("This program is free software: you can redistribute it and/or modify\
         it under the terms of the GNU General Public License as published by\
         the Free Software Foundation, either version 3 of the License, or\
         (at your option) any later version.\

         This program is distributed in the hope that it will be useful,\
         but WITHOUT ANY WARRANTY; without even the implied warranty of\
         MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\
         GNU General Public License for more details.\

         You should have received a copy of the GNU General Public License\
         along with this program.  If not, see <http://www.gnu.org/licenses/>.")))
    ),
    mainPanel(
      fluidRow(
        column(3, checkboxGroupInput("input-planets", 
                                     label = h3("Planetas a dibujar"), 
                                     choices = list("Mercurio"=1,
                                                    "Venus"=2,
                                                    "Tierra"=3,
                                                    "Marte"=4,
                                                    "Júpiter"=5,
                                                    "Saturno"=6,
                                                    "Urano"=7,
                                                    "Neptuno"=8),

                                     selected = 1:8)),
        column(3, numericInput("tiempo-input", label="Introduce tiempo en días", value=0))),
      br(),
      img(src = "plot.png")
    ))
))


