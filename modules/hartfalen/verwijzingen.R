hf_ver_ui <- function(id) {
  ns <- NS(id)
  
  mainPage(
    section(
      titlePanel("Procesindicator: Van huisarts naar ziekenhuis: Hartfalendiagnose", "Den Haag en omstreken & Leiden en omstreken"),
      solotile(subtitlePanel("Leeftijdsverdeling verschillende populaties"),
               echarts4rOutput(ns("verwijzingen")),
               explanation("Strikt genomen keken we hier niet naar verwijzingen, maar naar de patiënten die binnen 1 jaar na hun diagnose bij de huisarts dezelfde diagnose hebben gekregen bij het ziekenhuis."))
    )
  )
}

hf_ver_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.ver <- load_data("data/hartfalen/huisarts_naar_ziekenhuis")
    
    output$verwijzingen <- renderEcharts4r({
      data.ver |>
        e_charts(jaar) |>
        e_bar(den_haag_en_omstreken, name = "'s-Gravenhage en omstreken") |>
        e_bar(leiden_en_omstreken, name = "Leiden en omstreken") |>
        e_title("Leeftijdsverdeling verschillende populaties", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Jaar",
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                 ),
                 min = min(data.ver$jaar) - 1,
                 max = max(data.ver$jaar) + 1,
                 axisLabel = yearformatter
        ) |>
        e_y_axis(name = "Euro",
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