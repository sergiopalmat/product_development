server <- function(input, output, session) {
  
  observe({
    query <- parseQueryString(session$clientData$url_search)
    std_param <- query[["std"]]
    rslidermin_param <- query[["rslidermin"]]
    rslidermax_param <- query[["rslidermax"]]
    exclude_param <- query[["excl"]]
    
    tuser_param <- query[["tuser"]]
    tstore_param <- query[["tstore"]]
    pay_param <- query[["pay"]]
    ttslidermin_param <- query[["ttslidermin"]]
    ttslidermax_param <- query[["ttslidermax"]]
    
    euser_param <- query[["euser"]]
    estore_param <- query[["estore"]]
    exstore_param <- query[["exstore"]]
    etslidermin_param <- query[["etslidermin"]]
    etslidermax_param <- query[["etslidermax"]]
    
    if(!is.null(std_param)){
      updateSelectInput(session, 'std_filter', selected = std_param)
    }
    if(!is.null(rslidermin_param) && !is.null(rslidermax_param)){
      updateSliderInput(session, 'time_slider_1', value = c(as.Date(rslidermin_param), as.Date(rslidermax_param)))
    }
    if(!is.null(exclude_param)){
      updateTextInput(session, 'excluir_id_tienda_input', value = exclude_param)
    }
    
    if(!is.null(tuser_param)){
      updateTextInput(session, 'user_id_input', value = tuser_param)
    }
    if(!is.null(tstore_param)){
      updateTextInput(session, 'shop_id_input', value = tstore_param)
    }
    if(!is.null(pay_param)){
      updateSelectInput(session, 'payment_input', selected = pay_param)
    }
    if(!is.null(ttslidermin_param) && !is.null(ttslidermax_param)){
      updateSliderInput(session, 'time_slider_2', value = c(as.Date(ttslidermin_param), as.Date(ttslidermax_param)))
    }
    
    if(!is.null(euser_param)){
      updateTextInput(session, 'user_id_input2', value = euser_param)
    }
    if(!is.null(estore_param)){
      updateTextInput(session, 'shop_id_input2', value = estore_param)
    }
    if(!is.null(exstore_param)){
      updateSelectInput(session, 'excluir_id_tienda_input2', selected = exstore_param)
    }
    if(!is.null(etslidermin_param) && !is.null(etslidermax_param)){
      updateSliderInput(session, 'time_slider_3', value = c(as.Date(etslidermin_param), as.Date(etslidermax_param)))
    }
    
  })
  
  output$std = renderUI(
    selectInput(inputId = "std_filter", label = "Filtro std",
                choices = c("Todos", 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4))
  )
  output$time_range_1 = renderUI(
    sliderInput(
      inputId = "time_slider_1",
      label = "",
      min = min(raw_df$created_at_date),
      max = max(raw_df$created_at_date),
      value = c(min(raw_df$created_at_date), max(raw_df$created_at_date)),
      step = 1
    )
  )
  
  output$exclude_shop_id = renderUI(
    textInput(inputId = "excluir_id_tienda_input", label = "Excluir tienda",
              value = "", width = "100%")
  )
  
  # Tendencia
  output$user_id = renderUI(
    textInput(inputId = "user_id_input", label = "Usuario",
              value = "", width = "100%")
  )
  
  output$shop_id = renderUI(
    textInput(inputId = "shop_id_input", label = "Tienda",
              value = "83", width = "100%")
  )
  
  output$payment = renderUI(
    selectInput(inputId = "payment_input", label = "Filtro Pago",
                choices = c("Todos", unique(raw_df$payment_method)))
  )
  
  output$time_range_2 = renderUI(
    sliderInput(
      inputId = "time_slider_2",
      label = "Time Filter",
      min = min(raw_df$created_at_date),
      max = max(raw_df$created_at_date),
      value = c(min(raw_df$created_at_date), max(raw_df$created_at_date)),
      step = 1,
      timeFormat = '%Y-%m-%d'
    )
  )
  
  # Estadisticas
  output$user_id2 = renderUI(
    textInput(inputId = "user_id_input2", label = "Usuario",
              value = "", width = "100%")
  )
  
  output$shop_id2 = renderUI(
    textInput(inputId = "shop_id_input2", label = "Tienda",
              value = "83", width = "100%")
  )
  
  output$exclude_shop_id2 = renderUI(
    textInput(inputId = "excluir_id_tienda_input2", label = "Excluir Tienda",
              value = "", width = "100%")
  )
  
  output$payment2 = renderUI(
    selectInput(inputId = "payment_input2", label = "Filtro Pago",
                choices = c("Todos", unique(raw_df$payment_method)))
  )
  
  output$time_range_3 = renderUI(
    sliderInput(
      inputId = "time_slider_3",
      label = "Time Filter",
      min = min(raw_df$created_at_date),
      max = max(raw_df$created_at_date),
      value = c(min(raw_df$created_at_date), max(raw_df$created_at_date)),
      step = 1,
      timeFormat = '%Y-%m-%d'
    )
  )
  
  # Resumen Box Plot
  summary_dataset <- reactive({ execute_safely(
    filter_dataset_summary(raw_df, input$std_filter, input$time_slider_1, input$excluir_id_tienda_input)
    )
  })
  
  output$boxplot_panel <- renderPlotly({
    plot_ly(summary_dataset(), 
            type = "box", 
            x = ~created_at_date, y = ~order_amount, 
            text = paste0("<b> orden: </b>", summary_dataset()$order_id, "<br/>",
                          "<b> tienda: </b>", summary_dataset()$shop_id, "<br/>",
                          "<b> usuario: </b>", summary_dataset()$user_id, "<br/>",
                          "<b> total articulos: </b>", summary_dataset()$total_items, "<br/>",
                          "<b> metodo pago: </b>", summary_dataset()$payment_method, "<br/>",
                          "<b> creacion: </b>", summary_dataset()$created_at, "<br/>"
                          ),
            hoverinfo = "y", width = 0.8*as.numeric(input$dimension[1]), height = 0.8*as.numeric(input$dimension[2])) %>%
      layout(title = 'Resumen de Transacciones', plot_bgcolor = "#e5ecf6", xaxis = list(title = 'Time'), 
             yaxis = list(title = 'Monto')) %>%
      onRender(addHoverBehavior)
  })
  
  output$hover_info <- renderUI({
    if(isTRUE(input[["hovering"]])){
      style <- paste0("left: ", input[["left_px"]] + 0.025*as.numeric(input$dimension[1]), "px;",
                      "top: ", input[["top_px"]] - 60, "px;") 
      div(
        class = "arrow_box", style = style,
        p(HTML(input$dtext, 
               "<b> value: </b>", formatC(input$dy)), 
          style="margin: 0; padding: 2px; line-height: 16px;")
      )
    }
  })
  
  # Series de tiempo
  trend_dataset <- reactive({ execute_safely(
    filter_dataset_trend(raw_df,input$user_id_input, input$shop_id_input, input$payment_input, input$time_slider_2)
    )
  })
  
  output$trend_panel <- renderPlotly({
    ggplotly(ggplot(trend_dataset(),
                    aes(x = created_at_date, y = total_items, color = user_id:shop_id, size = order_amount,
                        extra1 = payment_method, extra2 = created_at_time)) + 
               geom_point(alpha = 0.3) + 
               scale_size_continuous(range=c(1,log(max(trend_dataset()$order_amount, base = 2)))) +
               theme(legend.position = "none",
                     panel.background = element_rect(fill = "#e5ecf6", color = "white")) +
               labs(x = "Hora",
                    y = "Total de articulos por Transaccion",
                    title = "Transacciones de Cliente, Tienda, Precio, Monto y Hora")
               , width = 0.8*as.numeric(input$dimension[1]), height = 0.8*as.numeric(input$dimension[2])
             )
  })
  
  # Estadisticas
  statistics_dataset <- reactive({ execute_safely(
    filter_dataset_statistics(raw_df,input$user_id_input2, input$shop_id_input2, input$excluir_id_tienda_input2, "Todos", input$time_slider_3)
    )
  })
  
  output$statistics_transaction <- renderPlotly({
    df <- statistics_dataset() %>% group_by(shop_id, user_id, created_at_date) %>%
      summarize(mean_amount = mean(order_amount))
    
    ggplotly(ggplot(df, aes(x = created_at_date, y = mean_amount)) +
                geom_line(size = 1) + 
                theme(legend.position = "none",
                      panel.background = element_rect(fill = "#e5ecf6", color = "white")) +
                labs(x = "Hora",
                     y = "Valor Transaccion",
                     title = "Serie de Tiempo Valor Transaccion"),
             width = 0.4*as.numeric(input$dimension[1]), height = 0.4*as.numeric(input$dimension[2])
             )
  })
  
  output$statistics_item <- renderPlotly({
    df <- statistics_dataset() %>% group_by(shop_id, user_id, created_at_date) %>%
      summarize(mean_amount = mean(price_per_item))
    
    ggplotly(ggplot(df, aes(x = created_at_date, y = mean_amount)) +
               geom_line(size = 1) + 
               theme(legend.position = "none",
                     panel.background = element_rect(fill = "#e5ecf6", color = "white")) +
               labs(x = "Hora",
                    y = "Valor por articulo",
                    title = "Serie de tiempo por valor de articulo"),
             width = 0.4*as.numeric(input$dimension[1]), height = 0.4*as.numeric(input$dimension[2])
             )
  })
  
  output$statistics_table <- renderDataTable(data.table(statistics_dataset()), options = list(pageLength = 10))
  
  # Metricas por transaccion
  output$report1 <- renderInfoBox(infoBox("Maximo Orden",
                                          max(statistics_dataset()$order_amount),
                                          width = 3, icon = icon("area-chart")))
  output$report2 <- renderInfoBox(infoBox("Promedio Orden",
                                          round(mean(statistics_dataset()$order_amount),3),
                                          width = 3, icon = icon("area-chart")))
  output$report3 <- renderInfoBox(infoBox("Media Orden",
                                          median(statistics_dataset()$order_amount),
                                          width = 3, icon = icon("area-chart")))
  # Metricas por Item
  output$report4 <- renderInfoBox(infoBox("Maximo Item",
                                          max(statistics_dataset()$price_per_item),
                                          width = 3))
  output$report5 <- renderInfoBox(infoBox("Promedio Item",
                                          round(mean(statistics_dataset()$price_per_item),3),
                                          width = 3))
  output$report6 <- renderInfoBox(infoBox("Media Item",
                                          median(statistics_dataset()$price_per_item),
                                          width = 3))
  

  observeEvent("", {
    show("resumen_panel")
    hide("trend_panel")
    hide("statistics_panel")
  }, once = TRUE)
  observeEvent(input$summary, {
    show("resumen_panel")
    hide("trend_panel")
    hide("statistics_panel")
  })
  observeEvent(input$trend, {
    hide("resumen_panel")
    show("trend_panel")
    hide("statistics_panel")
  })
  observeEvent(input$statistics, {
    hide("resumen_panel")
    hide("trend_panel")
    show("statistics_panel")
  })
}