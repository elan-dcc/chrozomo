demo1_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Demo 1"),
      solotile(
        echarts4rOutput(ns("demo1")),
        explanation("Deze staafgrafiek biedt je de mogelijkheid om dieper in de data te duiken. Klik op een staaf voor meer gedetailleerde informatie. 
                    Het eerste niveau toont de regio, het tweede niveau het geslacht, en het dered niveau de leeftijdsgroep. 
                    Klik op 'terug' om een niveau omhoog te gaan.")
        )
    )

  )
}

demo1_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.demo1 <- load_data("data/demo1") 
    
    data.demo1.max_level <- names(data.demo1)[grepl( "level" , names(data.demo1))]
    data.demo1.max_level <- max(as.numeric(gsub('level', '', data.demo1.max_level)))

    plot_data <- function(
    chart_data, chart_title, chart_level) {
      
      int_chart_level <- as.numeric(gsub('level', '', chart_level))

      chart <- chart_data |>
        e_charts(level) |>
        e_bar(waarde) |>
        e_title(chart_title, show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "",
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                 ),
        ) |>
        e_y_axis(name = "Waarde",
        ) |>
        e_legend(show = FALSE) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%") |>
        e_add_nested("itemStyle", color)
      
      # offer option to go one level up
      if (int_chart_level >= 2){
        chart <- chart |>
          e_title("Terug", triggerEvent = TRUE) |>
          e_on(
            query = "title",
            # Set input values
            handler = paste0(
              "function(params){
              Shiny.setInputValue(
                '", id, "-input_level',
                'level", as.character(int_chart_level - 1) ,"',
                {priority: 'event'}
                 );
               }"
            ),
            event = "click"
          )
      }
      # dive deeper into bar chart
      if (int_chart_level < data.demo1.max_level) {
        chart <- chart |>
          e_on(
            query = "series.bar",
            handler =
              paste0(
                "function(params){
              Shiny.setInputValue(
                '", id, "-input_level',
                'level", as.character(int_chart_level + 1), "',
                {priority: 'event'}
                 );
               }"
              ),
            event = "click"
          )
      }
      
      return(chart)
    }
  
    output$demo1 <- renderEcharts4r({
      if ( !is.null(input$input_level) ){
        level <- input$input_level
      }
      else {
        level <- "level1"
      }
      
      data <- data.demo1[, .(waarde = sum(waarde)), by = level]
      setnames(data, level, "level")
      
      # assigning colours      
      switch(level, 
             level2 = {
               data$color <- color_category["geslacht"]
             },
             level1 = {
               data$color <- color_regions[1:2]  
             },
             level3 = {
               data$color <- c("#e72a8a", "#7570b3")
             },
             {
               data$color <- color_regions[1:2]
             }
      )
      
      # titles
      title <- list(
        level1 = "Regio", 
        level2 = "Geslacht",
        level3 = "Leeftijd"
        )
      
      plot_data(
        chart_data = data,
        chart_title = title[[level]],
        chart_level = level
      )
    })
    })
}