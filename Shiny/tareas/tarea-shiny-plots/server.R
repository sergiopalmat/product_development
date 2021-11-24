
library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output) {
    
    # Almacenar que filas deben excluirse
    vals = reactiveValues(
      keeprows = rep(TRUE, nrow(mtcars))
    )
    
    vals2 = reactiveValues(
      keeprows2 = rep(TRUE, nrow(mtcars))
    )
    
    vals3 = reactiveValues(
      keeprows3 = rep(TRUE, nrow(mtcars))
    )
    
    vals4 = reactiveValues(
      keeprows4 = rep(TRUE, nrow(mtcars))
    )
    
    output$plot2 = renderPlot({
      keep = mtcars[vals$keeprows, , drop = FALSE]
                    
      # seleccionado por hover                    
      exclude = mtcars[!vals$keeprows, , drop = FALSE]
      
      # seleccionado por el click
      exclude_clk = mtcars[!vals2$keeprows2, , drop = FALSE]
      
      # seleccionado por el doble click
      exclude_dclk = mtcars[!vals3$keeprows3, , drop = FALSE]
      
      #seleccionado por brush
      exclude_brush = mtcars[!vals4$keeprows4, , drop = FALSE]
      
      ggplot(keep, aes(wt, mpg)) + geom_point(size = 8, color="black") + 
        geom_point(data = exclude, shape = 21, color = "gray", fill="gray", size = 8)+
        geom_point(data = exclude_clk, shape = 21, color = "green", fill="green", size = 8)+
        geom_point(data = exclude_dclk, shape = 21, color = "black", fill="black", size = 8)+
        geom_point(data = exclude_brush, shape = 21, color = "green", fill="green", size = 8)+
        theme_classic()
    })
    
    
    output$tabla_dt = DT::renderDataTable({mtcars})
    
  observeEvent(input$mouse_hover,{
    res_hover = nearPoints(mtcars, input$mouse_hover, allRows = TRUE, maxpoints = 1)
    vals$keeprows = xor(vals$keeprows, res_hover$selected_)
  })
  
  observeEvent(input$clk,{
    res_clk = nearPoints(mtcars, input$clk, allRows = TRUE, maxpoints = 1)
    res_clk_tb = nearPoints(mtcars, input$clk, maxpoints = 1)
    vals2$keeprows2 = xor(vals2$keeprows2, res_clk$selected_)
    output$tabla_dt = DT::renderDataTable({res_clk_tb})
  })
  
  observeEvent(input$dclk,{
    res_dclk = nearPoints(mtcars, input$dclk, allRows = TRUE, maxpoints = 1)
    vals3$keeprows3 = xor(vals3$keeprows3, res_dclk$selected_)
  })
  
  observeEvent(input$mouse_brush,{
    res_brush = brushedPoints(mtcars, input$mouse_brush, allRows = TRUE)
    res_brush_tbl = brushedPoints(mtcars, input$mouse_brush)
    vals4$keeprows4 = xor(vals4$keeprows4, res_brush$selected_)
    output$tabla_dt = DT::renderDataTable({res_brush_tbl })
  })
  
  # Reset
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow(mtcars))
    vals2$keeprows2 <- rep(TRUE, nrow(mtcars))
    vals3$keeprows3 <- rep(TRUE, nrow(mtcars))
    vals4$keeprows4 <- rep(TRUE, nrow(mtcars))
    output$tabla_dt = DT::renderDataTable({mtcars})
  })
  
  
})
