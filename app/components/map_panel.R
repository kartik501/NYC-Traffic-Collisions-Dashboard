source("./dependencies.R")
source("./definitions.R")
source("./datasets.R")

# Map panel UI code

panel_name <- "Map"

panel_height <- 20
map_panel_ui <- tabPanel(
    panel_name,
    icon = icon("map-marker-alt"),
    fluidRow(
        leafletOutput(
            "map_output",
            height = 700
        )
    ), # end of map output fluidRow
    absolutePanel(
        id = "map_options_control", class = "panel panel-default custom-panel",
        fixed = TRUE, draggable = TRUE,
        top = 200, left = 50,
        right = "auto", bottom = "auto",
        width = 250, height = "auto",
        tags$h4("New York City Crashes"),
        tags$br(),
        pickerInput(
            inputId = "map_select_boroughs",
            choices = BOROUGHS,
            selected = "ALL"
        ),
        fluidRow(
            column(
                width = 2,
                materialSwitch(
                    inputId = "map_switch_killed_injured",
                    label = "",
                    status = "danger"
                ),
                offset = 1
            ),
            column(
                width = 2,
                textOutput("map_label_boroughs"),
                offset = 1
            )
        ),
        prettyRadioButtons(
            inputId = "map_radio_vehicle_type",
            label = "Vehicle type:",
            choices = AFFECTED_PARTY,
            inline = TRUE,
            status = "danger",
            fill = TRUE
        )
    ), # end of absolute panel panel
    absolutePanel(
        id = "map_time_control", class = "panel panel-default custom-panel",
        fixed = FALSE, draggable = TRUE,
        top = 100, left = 1000,
        right = "auto", bottom = "auto",
        width = 400, height = "auto",
        fluidRow(
            column(
                width = 10,
                sliderInput(
                    inputId = "map_slider_time",
                    label = "Time",
                    value = min(daily_crashes$date),
                    min = min(daily_crashes$date),
                    max = max(daily_crashes$date),
                    step = 1,
                    ticks = FALSE,
                    animate = animationOptions(
                        interval = 300,
                        loop = FALSE,
                        playButton = NULL,
                        pauseButton = NULL
                    )
                ),
                offset = 1
            )
        ),
        # style = "opacity: 0.80"
    ) # end of time slider fluid row
)

# Map panel server code

# TODO: REMOVE THIS
# map_data <- null
leaflet_map <- leaflet(
        height = panel_height,
        options = leafletOptions(
            minZoom = 11,
            maxZoom = 13
        )
    ) %>%
    addTiles() %>%
    addProviderTiles(
        "CartoDB.Positron",
        options = providerTileOptions(
            noWrap = TRUE
        )
    ) %>%
    setView(
        lng = -73.9834,
        lat = 40.7504,
        zoom = 10
    ) 


generate_map <- function(input) {
    display_data <- daily_crashes %>%
        dplyr::filter(
            `date` <= max(
                min(daily_crashes$date),
                as.Date(input$map_slider_time)
            )
        )

    if (input$map_select_boroughs != "ALL") {
        display_data <- display_data %>%
        dplyr::filter(
            borough == input$map_select_boroughs
        )
    }

    if (input$map_radio_vehicle_type == "Cars") {
        display_data <- display_data %>%
            select(
                avg_lat, avg_lon,
                number_of_persons_injured,
                number_of_persons_killed
            )
    }
    if (input$map_radio_vehicle_type == "Pedestrians") {
        display_data <- display_data %>%
            select(
                avg_lat, avg_lon,
                number_of_pedestrians_injured,
                number_of_pedestrians_killed
            )
    }
    if (input$map_radio_vehicle_type == "Cyclist") {
        display_data <- display_data %>%
            select(
                avg_lat, avg_lon,
                number_of_cyclist_injured,
                number_of_cyclist_killed
            )
    }
    if (input$map_radio_vehicle_type == "Motorist") {
        display_data <- display_data %>%
            select(
                avg_lat, avg_lon,
                number_of_motorist_injured,
                number_of_motorist_killed
            )
    }
    if (input$map_radio_vehicle_type == "All") {
        display_data <- display_data %>%
            mutate(
                sum_injured = sum(c(
                    number_of_persons_injured,
                    number_of_pedestrians_injured,
                    number_of_cyclist_injured,
                    number_of_motorist_injured
                )),
                sum_killed = sum(c(
                    number_of_persons_killed,
                    number_of_pedestrians_killed,
                    number_of_cyclist_killed,
                    number_of_motorist_killed
                )),
            ) %>%
            select(
                avg_lat, avg_lon,
                sum_injured,
                sum_killed
            )
    }

    killed_or_injured <- ifelse(
        input$map_switch_killed_injured,
        "killed",
        "injured"
    )

    max_value <- ifelse(
        input$map_switch_killed_injured,
        50,
        100
    )

    display_data <- display_data %>%
        select(avg_lat, avg_lon, value = ends_with(killed_or_injured))

    # print(tail(display_data))
    updated_map <- leaflet_map %>%
        addHeatmap(
            lng = display_data$avg_lon,
            lat = display_data$avg_lat,
            intensity = display_data$value,
            max=max_value,
            radius=25,
            blur=10
        )
    return(updated_map)
}



map_borough_label <- function(input) {
    renderText({
        return(ifelse(
            input$map_switch_killed_injured,
            "Killed",
            "Injured"
        ))
    })
}