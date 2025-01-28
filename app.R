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

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("helpers/utils.R")

loadModules()

ui <- fluidPage(
  header(),
  navbarPage("",
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
                        tabPanel("Labwaarden", hf_lab_ui("labwaarden")))),
  footer()
  )

server <- function(input, output, session) {
  callModule(index_server, "index")
  callModule(hf_dm_server, "demografie")
  callModule(hf_prev_server, "prevalentie")
  callModule(hf_ver_server, "verwijzingen")
  callModule(hf_kost_server, "zorgkosten")
  callModule(hf_med_server, "medicatie")
  callModule(hf_sterf_server, "sterfte")
  callModule(hf_acp_server, "acp")
  callModule(hf_lab_server, "labwaarden")
}

shinyApp(ui, server)