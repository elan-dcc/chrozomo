hf_sterf_ui <- function(id) {
  ns <- NS(id)
  
  mainPage(
    section(
      titlePanel("Uitkomstindicator: Sterftecijfers"),
      solotile(subtitlePanel("Sterfte binnen 1 jaar na diagnose"),
        echarts4rOutput(ns("sterfte")),
        explanation("De gestreepte lijnen geven de eerstelijnszorg weer en de doorgetrokken lijnen de tweedelijnszorg. Groen staat voor 's-Gravenhage en omstreken, rood voor Leiden en omstreken. Tussen 2017 en 2020 overleden gemiddeld meer mensen in de tweede lijn in 's-Gravenhage en omstreken. Bij de eerste lijn is het beeld complexer. Wel blijkt dat in 's-Gravenhage en omstreken consistent meer mensen in de tweede lijn overlijden dan in de eerste lijn, terwijl dit patroon niet geldt voor Leiden en omstreken."))
    )
  )
}

hf_sterf_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.sterfte <- load_data("data/hartfalen/sterfte")
    
    output$sterfte <- renderEcharts4r({
      data.sterfte |>
        e_charts(jaar) |>
        e_line(eerste_sgra, name = "Eerste lijn, 's-Gravenhage en omstreken", lineStyle = list(type = "dashed")) |>
        e_line(tweede_sgra, name = "Tweede lijn, '-Gravenhage en omstreken") |>
        e_line(eerste_leiden, name = "Eerste lijn, Leiden en omstreken", lineStyle = list(type = "dashed")) |>
        e_line(tweede_leiden, name = "Tweede lijn, Leiden en omstreken") |>
        e_title("Sterfte binnen 1 jaar na diagnose", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Jaar",
                 nameLocation = "middle",
                 min = min(data.sterfte$jaar),
                 max = max(data.sterfte$jaar),
                 axisLabel = yearformatter,
                 interval = 1
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