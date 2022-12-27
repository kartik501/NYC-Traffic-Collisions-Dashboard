source("./dependencies.R")

panel_name <- "Data"
data_panel_ui <- tabPanel(
    panel_name,
    fluidRow(
        dataTableOutput("dataset_table")
    ),
)