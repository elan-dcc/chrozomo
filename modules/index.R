index_ui <- function(id) {
  ns <- NS(id)

  mainPage(
    section(
      div(class = "splash",
          h1("Gezondheid in beeld: Chrozomo"),
          p("Welkom bij het prototype van een dashboard dat de kloof tussen de eerste- en tweedelijnszorg overbrugt. Dit platform biedt een unieke blik op indicatoren van chronische zorg, met als doel betere samenwerking en inzicht in de regio.")
          ),
      div(class = "splash_info",
        container(
                  tile(echarts4rOutput(ns("map"))),
                  tile(
                    h2("Next-level monitoren"),
                    p("Dit dashboard is ontwikkeld op basis van data die disciplines en zorglijnen overstijgt, en biedt de mogelijkheid om de gezondheid van de regio integraal te monitoren. Het is tot stand gekomen binnen het Extramuraal LUMC Academisch Netwerk (ELAN), dat een verbindende rol speelt tussen diverse databronnen en onderzoeksgebieden. Innovatie en samenwerking staan hierbij centraal om inzichten effectief om te zetten in actie.
                      "),
                    a("Lees meer over ELAN",
                      target = "_blank",
                      href = "https://elan-dcc.github.io/about_elan/")
                  )
        )
      ),
      div(class = "splash",
          h2("De KPIs"),
          p("Dit dashboard is het resultaat van een intensieve samenwerking tussen domeinexperts en data scientists. De geselecteerde KPI’s worden voortdurend aangescherpt, de visualisaties geoptimaliseerd en de databronnen uitgebreid. Dit is een continu proces, gericht op het verbeteren van de toegankelijkheid, bruikbaarheid en impact van de inzichten."),
          a("Lees meer over de data",
            target = "_blank",
            href = "https://elan-dcc.github.io/about_data/")
      )
      )
    )
}

index_server <- function(input, output, session) {
  ns <- session$ns
  
  data.elan.map <- jsonlite::read_json("data/elan.json")
  data.elan <- as.data.frame(load_data("data/elan_classification"))
  
  output$map <- renderEcharts4r({
    data.elan |>
      e_charts(name) |>
      e_map_register("ELAN", data.elan.map) |>
      elan_map(category, map = "ELAN")
  })
}