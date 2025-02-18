hf_acp_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Uitkomstindicator: Advance Care Planning, eerste lijn"),
      container(tile(echarts4rOutput(ns("map"))),
                tile(subtitlePanel("Advanced Care Planning in het afgelopen jaar"),
                  echarts4rOutput(ns("acp"))))
    )
  )
}

hf_acp_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.acp <- load_data("data/hartfalen/acp") 
    
    data.elan.map <- jsonlite::read_json("data/elan.json")
    data.elan <- as.data.frame(load_data("data/elan_classification"))
    
    output$map <- renderEcharts4r({
      data.elan |>
        e_charts(name) |>
        e_map_register("ELAN", data.elan.map) |>
        elan_map2(category, map = "ELAN") |>
        e_visual_map(category, type = "piecewise", right = 0, 
                     pieces = list(
                       list(lte = 1, color = color_regions[1], label = "regio A"),
                       list(gt = 1, lte = 2, color = color_regions[2], label = "regio B"),
                       list(gt = 2, lte = 3, color = color_regions[3], label = "regio C"),
                       list(gt = 3, color = "grey", label = "No data")
                     ),
                     inRange = list(color = c(color_regions, "grey"))) |>
        e_add_nested('extra', AANT_INW) |> 
        e_tooltip(
          formatter = htmlwidgets::JS(
            'function(params){
          return "<span>" + params.data.extra.AANT_INW.toLocaleString() + " inwoners</span>";
        }'
          )
        )
    })
    
    output$acp <- renderEcharts4r({
      data.acp |>
        e_charts(jaar) |>
        e_line(region_A, name = "regio A") |>
        e_line(region_B, name = "regio B") |>
        e_line(region_C, name = "regio C") |>
        e_mark_area(
          data = list(
            list(
              xAxis = 2020, name = "Covid-19",
              itemStyle = list(color = "pink", opacity = 0.1, z = -999)
            ),
            list(xAxis = 2021)
          ),
        ) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Jaar", 
                 nameLocation = "middle",
                 min = min(data.acp$jaar) - 1,
                 max = max(data.acp$jaar) + 1,
                 axisLabel = yearformatter
        ) |>
        e_y_axis(name = "Percentage\n personen",
        ) |>
        e_legend(show = TRUE) |>
        e_hide_grid_lines(which = c("y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%") |>
        e_color(color_regions)
    })
  })
}