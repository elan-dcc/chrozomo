library(data.table)

color_five <- c("#a3a9cc", "#8e8ec0", "#9079b7", "#7b5f89", "#624a6d")
color_genders <- c("#9adbf9", "#f79ad6")
color_regions <- c("#1c9e77", "#d95f02", "#e72a8a")
color_ethnicity <- c("#d95f02", "#7570b3")

color_category <- list("SES" = color_five[1:3],
                     "geslacht" = color_genders,
                     "ethniciteit" = color_ethnicity,
                     "leeftijd" = color_five[1:2])
  
load_data <- function(loc) {
  data <- fread(paste0(loc, ".csv"))
  return(data)
}

container <- function(content, ...){
  div(class = "container", content, ...)
}

tile <- function(content, ...){
  div(class = "tile", content, ...)
}

section <- function(content, ...){
  div(class = "section", content, ...)
}

solotile <- function(content, ...){
  div(class = "solotile", content, ...)
}

menutile <- function(content, ...){
  div(class = "menutile", content, ...)
}

hearttile <- function(content, ...){
  div(class = "hearttile", content, ...)
}

explanation <- function(content, ...){
  p(class = "explanation", content, ...)
}

mainPage <- function (..., title = NULL, theme = NULL, lang = NULL) {
  bootstrapPage(div(class = "main", ...), title = title, 
                theme = theme, lang = lang)
}

titlePanel <- function (title, subtitle = "", windowTitle = title) {0
  if (subtitle != ""){
    tagList(tags$head(tags$title(windowTitle)), h1(title), div(class = "region", subtitle))    
  }
  else{
    tagList(tags$head(tags$title(windowTitle)), h1(title))
  }

}

subtitlePanel <- function (title) {
  h2(title)
}

yearformatter <- list(
  formatter = htmlwidgets::JS(
    'function(value, index){
            return value;
        }'
  )
)

elan_map <- function (e, serie, map = "world", name = NULL, rm_x = TRUE, 
                      rm_y = TRUE, ...) {
  if (missing(e)) {
    stop("must pass e", call. = FALSE)
  }
  if (!missing(serie)) {
    sr <- deparse(substitute(serie))
  }
  else {
    sr <- NULL
  }
  e_map_(e, sr, map, name, rm_x, rm_y, 
         itemStyle = list(borderColor = "#2b2552", areaColor = "#786ebd"),
         emphasis = list(itemStyle = list(areaColor = "#5cb1eb"),
                         label = list(color = "#FFFFFF")
         ),
         select = list(itemStyle = list(areaColor = "#5cb1eb"),
                       label = list(color = "#FFFFFF")
         ), ...)
}

elan_map2 <- function (e, serie, map = "world", name = NULL, rm_x = TRUE, 
                      rm_y = TRUE, ...) {
  if (missing(e)) {
    stop("must pass e", call. = FALSE)
  }
  if (!missing(serie)) {
    sr <- deparse(substitute(serie))
  }
  else {
    sr <- NULL
  }
  e_map_(e, sr, map, name, rm_x, rm_y, 
         itemStyle = list(borderColor = "#FFF", areaColor = "#786ebd"),
         emphasis = list(itemStyle = list(areaColor = "#5cb1eb"),
                         label = list(color = "#2b2552")
         ),
         select = list(itemStyle = list(areaColor = "#5cb1eb"),
                       label = list(color = "#2b2552")
         ), ...)
}

header <- function() {
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/pt-sans.css"),
    tags$link(rel = "shortcut icon", href = "images/favicon_elan.svg")
  )
}

footer <- function() {
  tags$footer(
    includeHTML("includes/footer.html"))
}

loadModules <- function(path = "modules/") {
  files.sources <- list.files(path, full.names = TRUE, recursive = TRUE)
  
  sapply(files.sources, function(file) {
    message(sprintf("Loading module: %s", basename(file)))
    tryCatch({
      source(file)
    }, error = function(e) {
      message(sprintf("Error loading %s: %s", file, e$message))
    })
  })
}