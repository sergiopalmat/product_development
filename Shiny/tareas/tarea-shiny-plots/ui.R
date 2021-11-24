library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel('Tarea Shiny Plots'),
  h5('Eddson Sierra | Product Development'),
  tabsetPanel(
    column(6,
      h3('Scatter Plot Interactivo'),
      fluidRow(
        plotOutput('plot2',
                   click = 'clk',
                   dblclick = 'dclk',
                   hover = 'mouse_hover',
                   brush = 'mouse_brush'
        ),
        
        actionButton("exclude_reset", "Reset"),
        
      )
    ),
    column(6,
           h3('Tabla DT'),
           DT::dataTableOutput('tabla_dt')
    )
  )
  
  
  
  
))
