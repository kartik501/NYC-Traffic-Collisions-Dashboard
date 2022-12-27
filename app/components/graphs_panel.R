source("./dependencies.R")
source("./components/subcomponents/plots_panel_1.R")
source("./components/subcomponents/plots_panel_2.R")
source("./components/subcomponents/plots_panel_3.R")

panel_name <- "Graphs"
graphs_panel_ui <- tabPanel(
    panel_name,
    icon = icon("fa-light fa-chart-line", verify_fa = FALSE),
    tabsetPanel(
        plots_panel_1,
        plots_panel_2,
        plots_panel_3
    )
)