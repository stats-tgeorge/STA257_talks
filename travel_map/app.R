# app.R
library(shiny)
library(leaflet)

# Branding colors
cc_purple <- "#523178"

stops <- data.frame(
  lat = c(
    51.4980, 51.5194, 51.5246, 51.4783, 51.5014, 51.5136,
    51.8074, 51.9986, 52.2043, 55.9440, 55.9225, 55.9477,
    53.3413, 53.3080, 53.3438, 54.6087, 55.2408
  ),
  lng = c(
    -0.1180, -0.1270, -0.1339, -0.2844, -0.1419, -0.1366,
    -0.3757, -0.7405, 0.1149, -3.1890, -3.2795, -3.1890,
    -6.2869, -6.2246, -6.2546, -5.9106, -6.5116
  ),
  name = c(
    "Florence Nightingale Museum",
    "British Museum",
    "UCL Archives",
    "National Archives, Kew",
    "Office of National Statistics",
    "John Snow Pub",
    "Rothamsted Research",
    "Bletchley Park",
    "University of Cambridge",
    "University of Edinburgh Archives",
    "Edinburgh Napier University",
    "National Museum of Scotland",
    "Guinness Storehouse",
    "University College Dublin",
    "Trinity College Dublin",
    "Titanic Museum, Belfast",
    "Giant's Causeway"
  ),
  day = c(
    "Day 6", "Day 3", "Day 4", "Day 3", "Day 2", "Day 6",
    "Day 11", "Day 8", "Day 9", "Day 15", "Day 14", "Day 16",
    "Day 18", "Day 19", "Day 18", "Day 20", "Day 20"
  ),
  stringsAsFactors = FALSE
)

# Create label for hover
stops$label <- paste0("<b>", stops$name, "</b><br>", stops$day)

ui <- fluidPage(
  tags$head(
    tags$style(HTML(glue::glue("
      body {{ font-family: 'Farnham', Georgia, serif; }}
      .leaflet-container {{ border:4px solid {cc_purple}; }}
      .footer-logo {{ position: fixed; left: 10px; right: 10px; opacity: .8; }}
    ")))
  ),
  titlePanel(tags$h1(style = glue::glue("History of Stats Trip Map"), style = glue::glue("color:{cc_purple};"))),
  leafletOutput("map", height = "700px"),
  tags$div(
    tags$img(src = "cornell_logo.jpg",
             height="50px", class="footer-logo", alt="Cornell College Logo")
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(stops) |>
      addProviderTiles(providers$CartoDB.Positron) |>
      addCircleMarkers(
        lng = ~lng, lat = ~lat,
        radius = 6, color = cc_purple, fill = TRUE, fillOpacity = 0.8,
        label = lapply(stops$label, HTML),
        labelOptions = labelOptions(direction="auto", textsize="13px")
      ) |>
      setView(lng = -3.5, lat = 54.5, zoom = 5.5)
  })
}

shinyApp(ui, server)
