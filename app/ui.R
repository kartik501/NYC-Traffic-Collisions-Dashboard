repository_url <- "https://github.com/TZstatsADS/fall2022-project2-group4/tree/master" # nolint
source("./dependencies.R")
source("./components/main_panel.R")
source("./components/map_panel.R")
source("./components/graphs_panel.R")

ui <- fluidPage(
  theme = shinytheme("simplex"),
  title = "NYC Vehicle Collision Analysis from 2019 to Present", # TODO: change this name
  navbarPage(
    a(
      href = repository_url,
      "NYC Vehicle Collision Analysis from 2019 to Present"
    ),
    map_panel_ui,
    graphs_panel_ui,
    # main_panel_ui,
  ),
  includeCSS("./css/panel_styles.css")
)