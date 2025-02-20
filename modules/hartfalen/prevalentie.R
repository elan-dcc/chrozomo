hf_prev_ui <- function(id) {
  ns <- NS(id)
  
  mainPage(
    section(
      titlePanel("Procesindicator: Prevalentie hartfalen","'s-Gravenhage en omstreken & Leiden en omstreken"),
      solotile(
        subtitlePanel("Prevalentie"),
        echarts4rOutput(ns("prevalentie")))
    )
  )
}

hf_prev_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.prev <- load_data("data/hartfalen/prevalentie")
    
    output$prevalentie <- renderEcharts4r({
      data.prev |>
        e_charts(jaar) |>
        e_line(eerste_lijn, name = "Eerste lijn") |>
        e_line(tweede_lijn, name = "Tweede lijn") |>
        e_line(incidentie_2024_hartstichting, name = "Incidentie 2024 (hartstichting.nl)") |>
        e_title("Prevalentie", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Jaar",
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                 ),
                 min = min(data.prev$jaar),
                 max = max(data.prev$jaar),
                 axisLabel = yearformatter
        ) |>
        e_y_axis(name = "Percentage"
        ) |>
        e_legend(show = TRUE, right = 30) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%")
    })
  })
}