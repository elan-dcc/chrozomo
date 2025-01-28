hf_kost_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Uitkomstindicator: totale zorgkosten", "'s-Gravenhage"),
      tile(subtitlePanel("Zorgkosten eerste en tweede lijn"),
           echarts4rOutput(ns("zorgkosten")))
    ),
    section(
    titlePanel("Uitkomstindicator: totale zorgkosten, 2020", "'s-Gravenhage en Omstreken"),
    menutile(
      selectInput(ns("category"), "Categorie", 
                  choices = c("SES", "geslacht", "ethniciteit", "leeftijd"),
                  selected = "SES")),
    container(
      tile(subtitlePanel("Gemiddelde eerste lijn"),
           echarts4rOutput(ns("left"))),
      tile(subtitlePanel("Gemiddelde tweede lijn"),
        echarts4rOutput(ns("right"))),
      explanation("Hier is duidelijk te zien dat de kosten per patiënt in de eerstelijnszorg hoger lijken dan in de tweedelijnszorg. Dit komt waarschijnlijk doordat hartfalenpatiënten in de eerstelijnszorg niet goed in beeld zijn.")
      )               
    )
  )
}

hf_kost_server <- function(input, output, session) {
  ns <- session$ns
  
  data.kost <- load_data("data/hartfalen/zorgkosten")
  
  data.kost.det <- load_data("data/hartfalen/zorgkosten_details")
  
  max <- max(max(data.kost.det$eerste_lijn), max(data.kost.det$tweede_lijn) )

  data.kost.filter <- reactive({
    filter <- data.kost.det[data.kost.det$topic == input$category,
                  c("label", "eerste_lijn", "tweede_lijn")]
    filter$color <- color_category[[input$category]]
    return(filter)

  })
  

  output$zorgkosten <- renderEcharts4r({
      data.kost |>
      e_charts(jaar) |>
      e_line(eerste_lijn, name = "Eerste lijn") |>
      e_line(tweede_lijn, name = "Tweede lijn") |>
      e_title("Zorgkosten eerste en tweede lijn", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = "Jaar", 
               nameLocation = "middle",
               nameTextStyle = list(
                 padding = c(20, 0, 0, 0)
                 ),
               min = min(data.kost$jaar) - 1,
               max = max(data.kost$jaar) + 1,
               axisLabel = yearformatter
               ) |>
      e_y_axis(name = "Percentage",
               ) |>
      e_legend(show = TRUE, , top = 20) |>
      e_hide_grid_lines(which = c("x", "y")) |>
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Opslaan"
      ) |>
      e_grid(top = "25%")
  })
  
  output$left <- renderEcharts4r({
    data.kost.filter() |>
      e_charts(label) |>
      e_bar(eerste_lijn) |>
      e_title("Gemiddelde eerste lijn", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = ""
      ) |>
      e_y_axis(name = "Euro",
               max = max
      ) |>
      e_legend(show = FALSE) |>
      e_hide_grid_lines(which = c("x", "y")) |>
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Opslaan"
      ) |>
      e_grid(top = "25%") |>
      e_add_nested("itemStyle", color)
  })
  
  output$right <- renderEcharts4r({
    data.kost.filter() |>
      e_charts(label) |>
      e_bar(tweede_lijn) |>
      e_title("Gemiddelde tweede lijn", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = ""
      ) |>
      e_y_axis(name = "Euro",
               max = max
      ) |>
      e_legend(show = FALSE) |>
      e_hide_grid_lines(which = c("x", "y")) |>
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Opslaan"
      ) |>
      e_grid(top = "25%") |>
      e_add_nested("itemStyle", color)
  })

}