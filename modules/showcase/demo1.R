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
    history <- list()
    
    data.demo1.max_level <- ncol(data.demo1) - 1

    plot_data <- function(
    chart_data, chart_title, chart_level, chart_value) {
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
      if (chart_level >= 2){
        chart <- chart |>
          e_title("Terug", triggerEvent = TRUE) |>
          e_on(
            query = "title",
            # Set input values
            handler = paste0(
              "function(params){
              Shiny.setInputValue(
                '", id, "-input_level',
                {level: ", chart_level - 1 ,",
                value: params.name},
                {priority: 'event'}
                 );
               }"
            ),
            event = "click"
          )
      }
      # dive deeper into bar chart
      if (chart_level < data.demo1.max_level) {
        chart <- chart |>
          e_on(
            query = "series.bar",
            handler =
              paste0(
                "function(params){
                Shiny.setInputValue(
                '", id, "-input_level',
                {level: ", chart_level + 1, ",
                value: params.name },
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

        level <- input$input_level$level
        
        # adapt history
        if (level > length(history)) { # we're going deeper
          value <- input$input_level$value
          history <<- append(history, list(list(level = level - 1, value = value)))
        }
        else { # we're going up!
          history[[level]] <<- NULL
        }
        
        condition <- TRUE # to start without filtering
        # make the conditional statement
        for (entry in history) {
          # Get the column name for the given level
          column_name <- names(data.demo1)[entry$level]
          
          # Update the condition by checking the value in the column
          condition <- condition & (data.demo1[[column_name]] == entry$value)
        }
        
        #subset
        data <- data.demo1[condition]
        
      }
      else {
        level <- 1
        data <- data.demo1
      }

      data <- data[, .(waarde = sum(waarde)), by = eval(names(data)[level])]
      setnames(data, names(data.demo1)[level], "level")
 
      # assigning colours      
      switch(level, 
             `2` = {
               data$color <- color_category["geslacht"]
             },
            `1` = {
               data$color <- color_regions[1:2]  
             },
             `3` = {
               data$color <- c("#e72a8a", "#7570b3")
             },
             {
               data$color <- color_regions[1:2]
             }
      )
      
      # titles
      title <- list(
        `1` = "Regio", 
        `2` = "Geslacht",
        `3` = "Leeftijd"
        )
      
      plot_data(
        chart_data = data,
        chart_title = title[[level]],
        chart_level = level
      )
    })
    })
}