library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel('Tarea Shiny Plots'),
  h5('Eddson Sierra | Product Development'),
  tabsetPanel(
    column(6,
      h3('Scatter Plot Interactivo'),
      fluidRow(
        plotOutput('plot_clk',
                   click = 'clk',
                   dblclick = 'dclk',
                   hover = 'mouse_hover',
                   brush = 'mouse_brush'
        ),
        
        h6('Tabla para verificar hover'),
        tableOutput('tbl_hov'),
        
        h6('Tabla para verificar click'),
        tableOutput('tbl_clk'),
        
        h6('Tabla para verificar doble click'),
        tableOutput('tbl_dclk'),
        
        h6('Tabla para verificar brush'),
        tableOutput('tbl_brush')
      )
    ),
    column(6,
           h3('Tabla con DT (mtcars)'),
           DT::dataTableOutput('tabla_dt')
    )
  )
  
  
  
  
))
