source("./dependencies.R")
source("./datasets.R")

panel_width <- "33%"
offset_left <- 2
offset_right <- 5

plots_panel_2 <- tabPanel(
  "Graphs 2",
  fluidRow(
    # column(
    #     width = 3,
    #     prettyRadioButtons(
    #         inputId = "graphs_radio_vehicle_type",
    #         label = "Vehicle type:",
    #         choices = AFFECTED_PARTY,
    #         inline = TRUE,
    #         status = "danger",
    #         fill = TRUE
    #     )
    # ),
    column(
      width = 3,
      pickerInput(
        inputId = "graphs_select_boroughs",
        choices = BOROUGHS,
        selected = "ALL"
      )
    )
  ),
  verticalLayout(
    fluid = TRUE,
    fluidRow(
      splitLayout(
        cellWidths = panel_width,
        cellArgs = list(style = "padding: 6px"),
        plotOutput(
          "plot_volume_2"
        ),
        plotOutput(
          "plot_no_collisions_2"
        )
      )
    ),
    fluidRow(
      splitLayout(
        cellWidths = panel_width,
        cellArgs = list(style = "padding: 20px"),
        plotOutput(
          "plot_total_injuries_2"
        ),
        plotOutput(
          "plot_total_deaths_2"
        ),
        plotOutput(
          "plot_total_speed"
        )
      )
    ),
    fluidRow(
      splitLayout(
        cellWidths = panel_width,
        cellArgs = list(style = "padding: 6px"),
        plotOutput(
          "plot_injuries_per_collision_2"
        ),
        plotOutput(
          "plot_death_per_collision_2"
        )
      )
    )
  )
)

get_plots_2 <- function(input, plot_name) {
  
  if (plot_name == "plot_volume_2") {
    
    display_daily_traffic <- daily_traffic %>%
      select(date, total)
    
    if (input$graphs_select_boroughs == "MANHATTAN") {
      display_daily_traffic <- display_daily_traffic %>%
        dplyr::filter(manhattan_traffic_filter)
    }
    else if (input$graphs_select_boroughs == "QUEENS") {
      display_daily_traffic <- display_daily_traffic %>%
        dplyr::filter(queens_traffic_filter)
    }
    else if (input$graphs_select_boroughs == "BROOKLYN") {
      display_daily_traffic <- display_daily_traffic %>%
        dplyr::filter(brooklyn_traffic_filter)
    }
    else if (input$graphs_select_boroughs == "BRONX") {
      display_daily_traffic <- display_daily_traffic %>%
        dplyr::filter(bronx_traffic_filter)
    }
    else if (input$graphs_select_boroughs == "STATEN ISLAND") {
      display_daily_traffic <- display_daily_traffic %>%
        dplyr::filter(staten_island_traffic_filter)
    }
    
    plot_result <- display_daily_traffic %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(volume = sum(total)) %>%
      ggplot(aes(x = date, y = volume)) +
      geom_line() +
      labs(title="Traffic Volume by Date",x="Date",y="Volume")
  }
  else if (plot_name == "plot_total_speed") {
    display_daily_speed <- daily_speed
    
    if (input$graphs_select_boroughs != "ALL") {
      display_daily_speed <- display_daily_speed %>%
        dplyr::filter(borough == input$graphs_select_boroughs)
    }
    
    display_daily_speed <- display_daily_speed %>%
      select(date, avg_speed)
    
    plot_result <- display_daily_speed %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(
        avg_speed = mean(avg_speed)
      ) %>%
      ggplot(aes(x = date, y = avg_speed)) +
      geom_line() +
      labs(title="Average Traffic Speed Across Boroughs by Date",x="Date",y="Average Speed ")
    
  } else {
    
    display_daily_crashes <- daily_crashes
    if (input$graphs_select_boroughs != "ALL") {
      display_daily_crashes <- display_daily_crashes %>%
        dplyr::filter(borough == input$graphs_select_boroughs)
    }
    
    display_daily_crashes <- display_daily_crashes %>%
      select(everything(), -c(avg_lat, avg_lon))
    
    
    if (plot_name == "plot_no_collisions_2") {
      plot_result <- display_daily_crashes %>%
        select(date, total_accidents) %>%
        group_by(date = lubridate::floor_date(date, "month")) %>%
        summarise(
          total_accidents = sum(total_accidents)
        ) %>%
        ggplot(aes(x = date, y = total_accidents)) +
        geom_line() +
        labs(title="Total Number of Accidents by Date",x="Date",y="Number of Accidents")
    }
    
    if (plot_name == "plot_total_injuries_2") {
      plot_result <- display_daily_crashes %>%
        select(date, ends_with("injured")) %>%
        group_by(date = lubridate::floor_date(date, "month")) %>%
        summarise(
          total_injured = sum(
            number_of_persons_injured,
            number_of_pedestrians_injured,
            number_of_cyclist_injured,
            number_of_motorist_injured
          )
        ) %>%
        ggplot(aes(x = date, y = total_injured)) +
        geom_line() +
        labs(title="Total Persons Injured by Date",x="Date",y="Persons Injured")
    }
    
    if (plot_name == "plot_total_deaths_2") {
      plot_result <- display_daily_crashes %>%
        select(date, ends_with("killed")) %>%
        group_by(date = lubridate::floor_date(date, "month")) %>%
        summarise(
          total_killed = sum(
            number_of_persons_killed,
            number_of_pedestrians_killed,
            number_of_cyclist_killed,
            number_of_motorist_killed
          )
        ) %>%
        ggplot(aes(x = date, y = total_killed)) +
        geom_line() +
        labs(title="Total Persons Killed by Date",x="Date",y="Persons Killed")
    }
    
    if (plot_name == "plot_injuries_per_collision_2") {
      plot_result <- display_daily_crashes %>%
        select(date, ends_with("injured"), total_accidents) %>%
        group_by(date = lubridate::floor_date(date, "month")) %>%
        summarise(
          injuries_per_collision = sum(
            number_of_persons_injured,
            number_of_pedestrians_injured,
            number_of_cyclist_injured,
            number_of_motorist_injured
          ) / sum(total_accidents)
        ) %>%
        ggplot(aes(x = date, y = injuries_per_collision)) +
        geom_line() +
        labs(title="Persons Injured per Collision by Date",x="Date",y="Persons Injured per Collision")
    }
    
    if (plot_name == "plot_death_per_collision_2") {
      plot_result <- display_daily_crashes %>%
        select(date, ends_with("killed"), total_accidents) %>%
        group_by(date = lubridate::floor_date(date, "month")) %>%
        summarise(
          deaths_per_collision = sum(
            number_of_persons_killed,
            number_of_pedestrians_killed,
            number_of_cyclist_killed,
            number_of_motorist_killed
          ) / sum(total_accidents)
        ) %>%
        ggplot(aes(x = date, y = deaths_per_collision)) +
        geom_line() +
        labs(title="Persons Killed per Collision by Date",x="Date",y="Persons Killed per Collision")
    }
  }
  
  return(plot_result)
}

