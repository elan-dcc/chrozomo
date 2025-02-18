hf_lab_ui <- function(id) {
  ns <- NS(id)
  
  mainPage(
    section(
      titlePanel("Uitkomstindicator: NTPR", "'s-Gravenhage en omstreken"),
      solotile(subtitlePanel("Percentage van de gediagnosticeerde populatie met een gemeten NTPR-waarde"),
        echarts4rOutput(ns("NTPR")))
    )
  )
}

hf_lab_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.lab <- load_data("data/hartfalen/labwaarden")
    
    output$NTPR <- renderEcharts4r({
      data.lab |>
        e_charts(jaar) |>
        e_line(NTPR) |>
        e_title("Percentage van de gediagnosticeerde populatie met een gemeten NTPR-waarde", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Jaar",
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                 ),
                 min = min(data.lab$jaar),
                 max = max(data.lab$jaar),
                 axisLabel = yearformatter,
                 interval = 1
        ) |>
        e_y_axis(name = "Percentage"
        ) |>
        e_legend(show = FALSE) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%")
    })
  })
}