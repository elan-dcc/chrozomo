demo3_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Demo 3"),
      solotile(
        echarts4rOutput(ns("demo1")),
        explanation("Deze staafgrafiek biedt je de mogelijkheid om dieper in de data te duiken. Klik op een staaf voor meer gedetailleerde informatie. 
                    Het eerste niveau toont de regio, het tweede niveau het geslacht, en het dered niveau de leeftijdsgroep. 
                    Klik op 'terug' om een niveau omhoog te gaan.")
        )
    )

  )
}

demo3_server <- function(id) {
  moduleServer(id, function(input, output, session) {

    output$demo1 <- renderEcharts4r({
      df <- data.frame(
        grp = rep(c(2020, 2021, 2022), each = 3),
        labels = rep(LETTERS[1:3], 3),
        values = round(runif(9, 1, 5), 1)
      )
      
      df |>
        group_by(grp) |>
        e_charts(labels, timeline = TRUE) |> 
        e_pie(values, radius = c("50%", "70%")) |>
        e_labels(formatter = '{b}: {@carb}') 
    })
    })
}