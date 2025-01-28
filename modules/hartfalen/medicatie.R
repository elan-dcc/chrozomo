hf_med_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Uitkomstindicator: Medicijnen, eerste en tweede lijn" ," Leiden en omstreken & Den Haag en omstreken"),
      tile(subtitlePanel("Percentage hartfalen patiënten met 3 of meer medicijnen"),
        echarts4rOutput(ns("drie_of_meer")))),
    section(
      titlePanel("Uitkomstindicator: totale zorgkosten, 2020", "'s-Gravenhage en Omstreken"),
      menutile(
        actionButton(ns("o2018"), "2018"),
        actionButton(ns("o2019"), "2019"),
        actionButton(ns("o2020"), "2020")
      ),
      container(
        tile(subtitlePanel("Deel van de hartfalen populatie met medicijnen"),
             echarts4rOutput(ns("left"))),
        tile(textOutput(ns("percentage")),
          hearttile(echarts4rOutput(ns("right"))))
      ),
      menutile(
        selectInput(ns("category"), "Categorie", 
                    choices = c("SES", "geslacht", "ethniciteit", "leeftijd"),
                    selected = "SES")
      ),
      solotile(echarts4rOutput(ns("categorie")))
    )
  )
}

hf_med_server <- function(input, output, session) {
  ns <- session$ns
  
  data.drie_of_meer <- load_data("data/hartfalen/med_3_of_meer")
  
  selected <- reactiveVal(2018)
  
  observeEvent(input$o2018, { selected(2018) })
  observeEvent(input$o2019, { selected(2019) })
  observeEvent(input$o2020, { selected(2020) })
  
  data.med <- load_data("data/hartfalen/med_3_of_meer_ethniciteit")
  data.med$totaal <- data.med$nederlands + data.med$overig
  
  max <- max(data.med$totaal)
  
  data.med.det <- load_data("data/hartfalen/med_3_of_meer_det")
  
  data.med.filter <- reactive({
    filter <- data.med.det[data.med.det$topic == input$category,
                  c("label", "percentage")]
    filter$color <- color_category[[input$category]]
    return(filter)
    })
  
  
  output$drie_of_meer <- renderEcharts4r({
      data.drie_of_meer |>
      e_charts(jaar) |>
      e_bar(eerste_lijn, name = "Eerste lijn") |>
      e_bar(tweede_lijn, name = "Tweede lijn") |>
      e_title("Percentage hartfalen patiënten met 3 of meer medicijnen", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = "Jaar", 
               nameLocation = "middle",
               nameTextStyle = list(
                 padding = c(20, 0, 0, 0)
                 ),
               min = min(data.drie_of_meer$jaar) - 1,
               max = max(data.drie_of_meer$jaar) + 1,
               axisLabel = yearformatter
               ) |>
      e_y_axis(name = "Percentage",
               ) |>
      e_legend(show = TRUE, top = 20) |>
      e_hide_grid_lines(which = c("x", "y")) |>
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Opslaan"
      ) |>
      e_grid(top = "25%")
  })
  
  output$left <- renderEcharts4r({
    data.med[data.med$jaar == selected(),] |>
      e_charts(hoeveelheid) |>
      e_bar(nederlands, stack = "stack", name = "Nederlands") |>
      e_bar(overig, stack = "stack", name = "Overig") |>
      e_title("Deel van de hartfalen populatie met medicijnen", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = ""
      ) |>
      e_y_axis(name = "Personen",
               max = max
      ) |>
      e_legend(show = TRUE, top = 20) |>
      e_hide_grid_lines(which = c("x", "y")) |>
      e_toolbox_feature(
        feature = "saveAsImage",
        title = "Opslaan"
      ) |>
      e_grid(top = "25%")
  })
  
  output$right <- renderEcharts4r({
    data.med[data.med$jaar == selected(),] |>
      e_charts(hoeveelheid) |>
      e_pie(totaal) |>
      e_title("") |>
      e_legend(show = FALSE)
  })
  
  output$percentage <- renderText({
    perc <- data.med[data.med$jaar == selected(),]
    perc <- perc[perc$hoeveelheid == "2_of_minder",]$totaal / sum(perc$totaal) * 100
    paste0(format(round(perc, 2), nsmall = 2), "% gebruikt 2 of minder medicijnen.")
    })
  
  
  output$categorie <- renderEcharts4r({
    data.med.filter() |>
      e_charts(label) |>
      e_bar(percentage) |>
      e_title("zorgkosten voor categorie", show = FALSE) |>
      e_labels(position = "top") |>
      e_tooltip(trigger = "axis") |>
      e_x_axis(name = ""
      ) |>
      e_y_axis(name = "Percentage",
               max = 100
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