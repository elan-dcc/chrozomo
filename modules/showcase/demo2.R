demo2_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      titlePanel("Demo 2"),
      container(
        tile(echarts4rOutput(ns("demo1"))),
        tile(subtitlePanel(textOutput(ns("title_demo2"))),
          echarts4rOutput(ns("demo2")))
        )    
    )

  )
}

demo2_server <- function(id) {
  moduleServer(id, function(input, output, session) {
  
    output$demo1 <- renderEcharts4r({
      sankey <- data.frame(
        source = c("a", "b", "a" ),
        target = c("b", "c", "c" ),
        value = c(10, 10, 5),
        stringsAsFactors = FALSE
      )
      
      sankey |> 
        e_charts() |> 
        e_sankey(source, target, value) |>
        e_on(
          query = "series",
          handler =
            paste0(
              "function(params){
              Shiny.setInputValue(
                '", id, "-input_param',
                params.name,
                {priority: 'event'}
                 );
               }"
            ),
          event = "click"
        )
    })
    
    process_input <- function(){
      if ( !is.null(input$input_param) ){
        source <- input$input_param
        
        switch(source,
               "a" = {source <- c("a > b", "a > c")},
               "b" = {source <- c("a > b", "c > b")},
               "c" = {source <- c("a > c", "b > c")},
               {source <- c(source)}
               )
      }
      
      else { # default
        source <- c("a")
      }
      return(source)
    }
    
    output$demo2 <- renderEcharts4r({
      source <- process_input()
      words <- data.frame(
       source = rep(c("a > b", "b > c", "a > c"), each = 26),
       words = rep(c("appel", "banaan", "mandarijn", "druif", "peer", "kiwi", 
                     "sinaasappel", "kumquat", "lychee", "aalbes", "blauwe bes",
                     "aardbei", "granaatappel", "ananas", "guave", "jackfruit", 
                     "dadel", "citroen", "limoen", "watermeloen", "cantaloupe",
                     "framboos", "kruisbes", "kweepeer", "braam", "lijsterbes"), 3),
       freq = sample(99, 26 * 3, TRUE)
      )
      
      data <- words[source %in% source]

      data |> 
        e_color_range(freq, color) |> 
        e_charts() |> 
        e_cloud(words, freq, color, shape = "cardioid", sizeRange = c(30, 50))
    })
    
    output$title_demo2 <- renderText({
      paste("Wordcloud voor:", input$input_param)
    })
    
  
    })
}