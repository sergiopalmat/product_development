ui <- dashboardPage(
  skin = "blue",
  title = "Proyecto 1",
  
  dashboardHeader(
    title = span(img(src = "logo-Walmart.png", height = 30)),
    titleWidth = 250
  ),
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("Filtro de Resumen", tabName = "summary", startExpanded = F,
               menuSubItem(icon = NULL, tabName = "standard_deviation", uiOutput("std")),
               menuSubItem(icon = NULL, tabName = "summary_filter_time", uiOutput("time_range_1")),
               menuSubItem(icon = NULL, tabName = "shop_id", uiOutput("exclude_shop_id"))
      ),
      menuItem("Filtro Tendencia", tabName = "timeseries", startExpanded = F,
               menuSubItem(icon = NULL, tabName = "user_id", uiOutput("user_id")),
               menuSubItem(icon = NULL, tabName = "shop_id", uiOutput("shop_id")),
               menuSubItem(icon = NULL, tabName = "payment_method", uiOutput("payment")),
               menuSubItem(icon = NULL, tabName = "other_filter_time", uiOutput("time_range_2"))
      ),
      menuItem("Filtro Estadisticas", tabName = "statistics", startExpanded = F,
               menuSubItem(icon = NULL, tabName = "user_id", uiOutput("user_id2")),
               menuSubItem(icon = NULL, tabName = "shop_id", uiOutput("shop_id2")),
               menuSubItem(icon = NULL, tabName = "shop_id", uiOutput("exclude_shop_id2")),
               menuSubItem(icon = NULL, tabName = "other_filter_time", uiOutput("time_range_3"))
      )
    )
  ),
  
  dashboardBody(
      tags$head(
        tags$link(
          rel = "stylesheet", 
          type = "text/css", 
          href = "radar_style.css"),
        tags$style(HTML('
                                .skin-blue .main-header .logo {
                                background-color: #178abf;
                                }
                                .skin-blue .main-header .logo:hover {
                                background-color: #178abf;
                                }
                                .skin-blue .main-header .navbar {
                                background-color: #178abf;
                                }
                                .content-wrapper, .right-side {
                                background-color: #FFFFFF;
                                }

                                ')),
        tags$script('
                        var dimension = [0, 0];
                        $(document).on("shiny:connected", function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        $(window).resize(function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        ')
      ),
      useShinyjs(),
      introjsUI(),
      

      fluidRow(
        column(
          width = 12,
          align="center",
          bsButton("summary", 
                   label = " Resumen", 
                   icon = icon("buromobelexperte", class = "spinner-box"), 
                   style = "success"),
          bsButton("trend", 
                   label = " Tendencia", 
                   icon = icon("buromobelexperte", class = "spinner-box"), 
                   style = "success"),
          bsButton("statistics", 
                   label = " Estadisticas", 
                   icon = icon("buromobelexperte", class = "spinner-box"), 
                   style = "success")
        )
      ),
      
      fluidPage(id = "resumen_panel",
                tags$head(
                  tags$style("
                  .arrow_box {
                  position: absolute;
                  pointer-events: none;
                  z-index: 100;
                  white-space: nowrap;
                  background: CornflowerBlue;
                  color: white;
                  font-size: 13px;
                  border: 1px solid;
                  border-color: CornflowerBlue;
                  border-radius: 1px;
               }
               .arrow_box:after, .arrow_box:before {
                  right: 100%;
                  top: 50%;
                  border: solid transparent;
                  content: ' ';
                  height: 0;
                  width: 0;
                  position: absolute;
                  pointer-events: none;
               }
               .arrow_box:after {
                  border-color: rgba(136,183,213,0);
                  border-right-color: CornflowerBlue;
                  border-width: 4px;
                  margin-top: -4px;
               }
               .arrow_box:before {
                  border-color: rgba(194,225,245,0);
                  border-right-color: CornflowerBlue;
                  border-width: 10px;
                  margin-top: -10px;
               }")
                ),
                div(
                  style = "position:relative", align="center",
                  plotlyOutput("boxplot_panel", width = "auto", height = "100%"),
                  uiOutput("hover_info")
                )
      ),
      
      fluidPage( div(id = "trend_panel", align="center",
                     plotlyOutput("trend_panel", width = "auto", height = "100%")
                    )
      ),
      
      fluidPage( div(id = "statistics_panel", 
                     column(width = 6,
                            div(style = "overflow-y:scroll; max-height: 50%",
                                dataTableOutput("statistics_table", width = "auto")),
                            fluidRow(infoBoxOutput("report1",width=6), infoBoxOutput("report4",width=6)),
                            fluidRow(infoBoxOutput("report2",width=6), infoBoxOutput("report5",width=6)),
                            fluidRow(infoBoxOutput("report3",width=6), infoBoxOutput("report6",width=6))
                            ),
                     column(width = 6,
                            plotlyOutput("statistics_transaction", width = "auto"),
                            plotlyOutput("statistics_item", width = "auto")
                            )
                     )
      ),

  )
)