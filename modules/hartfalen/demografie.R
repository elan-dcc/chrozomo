hf_dem_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Demografische gegevens", "de hele regio"),
      container(tile(subtitlePanel("Verdeling over SES, eerstelijn (gem over 2016-2020)"),
                     echarts4rOutput(ns("SES_eerste"))),
                tile(subtitlePanel("Verdeling over SES, tweedelijn (gem over 2016-2020)"),
                     echarts4rOutput(ns("SES_tweede"))))
      ,
      
      solotile(tabsetPanel(
        tabPanel("Leeftijdsverdeling", 
                 subtitlePanel("Leeftijdsverdeling verschillende populaties"),
                 echarts4rOutput(ns("leeftijdsverdeling")),
                 explanation("De leeftijd in de ziekenhuizen wijken weinig van elkaar af, maar de populatie bij de regionale husiartsen lijkt ouder.")),
        tabPanel("Ethniciteitenverdeling",
                 subtitlePanel("Verschil aanwezigheid ethniciteiten (%) t.ov. landelijke ziekenhuiscijfers"),
                 echarts4rOutput(ns("ethniciteitenverdeling")),
                 explanation("Regionaal wijken we af van de landelijke cijfers, maar tussen onze regionale huisartsen en ziekenhuis patientenpopulatie met hartfalen zijn de verschillen klein."))
      ))
    )
  )
}

hf_dm_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data.ses <- load_data("data/hartfalen/ses") 
    data.ses$color <- color_five
  
    data.leeftijdsverdeling <- load_data("data/hartfalen/dem_leeftijdsverdeling")
    
    data.ethniciteiten <- load_data("data/hartfalen/dem_verschil_ethniciteiten_tov_landelijke_ziekenhuiscijfers")
    data.ethniciteiten$ethniciteit = stringr::str_wrap(data.ethniciteiten$ethniciteit, 15)
    
    output$SES_eerste <- renderEcharts4r({
        data.ses |>
        e_charts(label) |>
        e_bar(eerste) |>
        e_add_nested("itemStyle", color) |>
        e_title("Verdeling over SES, eerstelijn (gem over 2016-2020)", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Kwintiel", 
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                   ),
                 ) |>
        e_y_axis(name = "Percentage",
                 ) |>
        e_legend(show = FALSE) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%")
    })
    
    output$SES_tweede <- renderEcharts4r({
      data.ses |>
        e_charts(label) |>
        e_bar(tweede) |>
        e_add_nested("itemStyle", color) |>
        e_title("Verdeling over SES, tweedelijn (gem over 2016-2020)", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "Kwintiel", 
                 nameLocation = "middle",
                 nameTextStyle = list(
                   padding = c(20, 0, 0, 0)
                 ),
        ) |>
        e_y_axis(name = "Percentage",
        ) |>
        e_legend(show = FALSE) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%")
    })
    
    output$leeftijdsverdeling <- renderEcharts4r({
      data.leeftijdsverdeling |>
        e_charts(leeftijdsgroep) |>
        e_bar(landelijk_ziekenhuiscijfer, name = "Landelijk ziekenhuiscijfer") |>
        e_bar(regionaal_ziekenhuiscijfer, name = "Regionaal ziekenhuiscijfer") |>
        e_bar(regionaal_huisartsencijfer, name = "Regionaal huisartsencijfer") |>
        e_title("Leeftijdsverdeling verschillende populaties", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = ""
        ) |>
        e_y_axis(name = "Percentage",
        ) |>
        e_legend(show = TRUE, right = 30) |>
        e_hide_grid_lines(which = c("x", "y")) |>
        e_toolbox_feature(
          feature = "saveAsImage",
          title = "Opslaan"
        ) |>
        e_grid(top = "25%")
    })
    
    output$ethniciteitenverdeling <- renderEcharts4r({
      data.ethniciteiten |>
        e_charts(ethniciteit) |>
        e_bar(regionaal_ziekenhuiscijfer, name = "Regionaal ziekenhuiscijfer") |>
        e_bar(regionaal_huisartsencijfer, name = "Regionaal huisartsencijfer") |>
        e_title("Verschil aanwezigheid ethniciteiten (%) t.ov. landelijke ziekenhuiscijfers", show = FALSE) |>
        e_labels(position = "top") |>
        e_tooltip(trigger = "axis") |>
        e_x_axis(name = "", interval = 0, axisLabel = list(rotate = 45)
        ) |>
        e_y_axis(name = "Percentage",
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