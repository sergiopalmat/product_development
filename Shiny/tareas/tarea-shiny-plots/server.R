
library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
  
    #Scatter Plot
    output$plot_clk = renderPlot({
      plot(x = mtcars$wt,
           y = mtcars$mpg,
           xlab = 'wt',
           ylab = 'Millas por galón')
    })
  
  observeEvent(input$mouse_hover,
    {
      output$print_clk = renderPrint({'hover'})
      output$plot_clk = renderPlot({
        plot(x = mtcars$wt,
             y = mtcars$mpg,
             xlab = 'wt',
             ylab = 'Millas por galón')
      })
    }
  )
    
  #Render Print para verificar
  #output$print_clk = renderText({
  #  getStatus
  #})
  
  #selección con hover
  output$tbl_hov =  renderTable({
    nearPoints(mtcars, input$mouse_hover, xvar='wt',yvar='mpg',maxpoints = 1)
  })
  
  #selección con click
  output$tbl_clk =  renderTable({
    nearPoints(mtcars, input$clk, xvar='wt',yvar='mpg',maxpoints = 1)
  })
  
  #selección con doble click
  output$tbl_dclk =  renderTable({
    nearPoints(mtcars, input$dclk, xvar='wt',yvar='mpg')
  })
  
  #selección con brush
  output$tbl_brush =  renderTable({
    brushedPoints(mtcars, input$mouse_brush, xvar='wt',yvar='mpg')
  })
  
  #Tabla con DT (mtcars)
  output$tabla_dt = DT::renderDataTable({
    if(!is.null(input$mouse_brush)){
      #mostrar los puntos seleccionados con brush
      brushedPoints(mtcars, input$mouse_brush, xvar='wt',yvar='mpg') %>%
        DT::datatable(rownames = FALSE)
    } 
    else{
      if(!is.null(input$clk)){
        #mostrar un punto seleccionado con click
        nearPoints(mtcars, input$clk,xvar='wt',yvar='mpg')%>%
          DT::datatable(rownames = FALSE)
      } 
      else{
        #estado inicial: mostrar todos los elementos
        mtcars %>% DT::datatable(rownames = FALSE)
      } 
    }
  })
  
})
