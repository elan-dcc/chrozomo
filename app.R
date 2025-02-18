#' Chrozomo
#' Date: 28-01-2025
#' @author Lisette de Schipper
#' Description: Chronische Zorg Monitor

# install.packages("shinydashboard")
# install.packages("echarts4r")
# install.packages("sf")

library(shinydashboard)
library(echarts4r) # charts
library(sf) # shapefiles
library(data.table)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("helpers/utils.R")

loadModules()

ui <- fluidPage(
  header(),
  navbarPage("",
             id = "tabs",
             tabPanel("Chrozomo", icon = icon("home"),
                      index_ui("index")),
             navbarMenu("Hartfalen",
                        tabPanel("Demografie", hf_dem_ui("demografie")),
                        tabPanel("Prevalentie", hf_prev_ui("prevalentie")),
                        tabPanel("Verwijzingen", hf_ver_ui("verwijzingen")),
                        tabPanel("Zorgkosten", hf_kost_ui("zorgkosten")),
                        tabPanel("Medicatie", hf_med_ui("medicatie")),
                        tabPanel("Sterfte", hf_sterf_ui("sterfte")),
                        tabPanel("ACP", hf_acp_ui("acp")),
                        tabPanel("Labwaarden", hf_lab_ui("labwaarden"))),
             navbarMenu("Showcase",
                        tabPanel("Interactieve staafgrafiek", demo1_ui("demo1")),
                        tabPanel("Interactie tussen grafieken", demo2_ui("demo2")),
                        tabPanel("Tijdlijn donut", demo3_ui("demo3"))
                        )
             ),
  # Image to show until user reaches the bottom
    arrow(),
  footer()
  )

server <- function(input, output, session) {
  index_server("index")
  hf_dm_server("demografie")
  hf_prev_server("prevalentie")
  hf_ver_server("verwijzingen")
  hf_kost_server("zorgkosten")
  hf_med_server("medicatie")
  hf_sterf_server("sterfte")
  hf_acp_server("acp")
  hf_lab_server("labwaarden")
  demo1_server("demo1")
  demo2_server("demo2")
  demo3_server("demo3")
}

shinyApp(ui, server)