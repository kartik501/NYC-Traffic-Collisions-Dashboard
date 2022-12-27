source("./dependencies.R")
source("./datasets.R")

panel_width <- "33%"
offset_left <- 2
offset_right <- 5

plots_panel_3 <- tabPanel(
  "Graphs 3",
  fluidRow(
    column(
      width = 3,
      pickerInput(
        inputId = "graphs_select_vehicle_type",
        choices = AFFECTED_PARTY,
        selected = "ALL"
      )
    )
  ),
  verticalLayout(
    fluid = TRUE,
    fluidRow(
      plotOutput(
        "plot_no_collisions_3"
      )
    ),
    fluidRow(
      splitLayout(
        cellWidths = panel_width,
        cellArgs = list(style = "padding: 20px"),
        plotOutput(
          "plot_total_injuries_3"
        ),
        plotOutput(
          "plot_total_deaths_3"
        )
      )
    ),
    fluidRow(
      splitLayout(
        cellWidths = panel_width,
        cellArgs = list(style = "padding: 6px"),
        plotOutput(
          "plot_injuries_per_collision_3"
        ),
        plotOutput(
          "plot_death_per_collision_3"
        )
      )
    )
  )
)

get_plots_3 <- function(input, plot_name) {
  
  display_daily_crashes <- daily_crashes
  
  if (input$graphs_select_vehicle_type != "Cars") {
    display_daily_crashes <- display_daily_crashes %>%
      select(
        date,
        injured = number_of_persons_injured,
        killed = number_of_persons_killed,
        total_accidents
      )
  }
  else if (input$graphs_select_vehicle_type != "Pedestrians") {
    display_daily_crashes <- display_daily_crashes %>%
      select(
        date,
        injured = number_of_pedestrians_injured,
        killed = number_of_pedestrians_killed,
        total_accidents
      )
  }
  else if (input$graphs_select_vehicle_type != "Cyclist") {
    display_daily_crashes <- display_daily_crashes %>%
      select(
        date,
        injured = number_of_cyclist_injured,
        killed = number_of_cyclist_killed,
        total_accidents
      )
  }
  else if (input$graphs_select_vehicle_type != "Motorists") {
    display_daily_crashes <- display_daily_crashes %>%
      select(
        date,
        injured = number_of_motorist_injured,
        killed = number_of_motorist_killed,
        total_accidents
      )
  } else{
    display_daily_crashes <- display_daily_crashes %>%
      mutate(
        injured = number_of_persons_injured +
          number_of_pedestrians_injured +
          number_of_cyclist_injured +
          number_of_motorist_injured,
        killed = number_of_persons_killed +
          number_of_pedestrians_killed +
          number_of_cyclist_killed +
          number_of_motorist_killed,
      ) %>%
      select(date, injured, killed, total_accidents)
  }
  
  if (plot_name == "plot_no_collisions_3") {
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
  
  if (plot_name == "plot_total_injuries_3") {
    plot_result <- display_daily_crashes %>%
      select(date, ends_with("injured")) %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(
        total_injured = sum(injured)
      ) %>%
      ggplot(aes(x = date, y = total_injured)) +
      geom_line() +
      labs(title="Total Persons Injured by Date",x="Date",y="Persons Injured")
  }
  
  if (plot_name == "plot_total_deaths_3") {
    plot_result <- display_daily_crashes %>%
      select(date, ends_with("killed")) %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(
        total_killed = sum(killed)
      ) %>%
      ggplot(aes(x = date, y = total_killed)) +
      geom_line() +
      labs(title="Total Persons Killed by Date",x="Date",y="Persons Killed")
  }
  
  if (plot_name == "plot_injuries_per_collision_3") {
    plot_result <- display_daily_crashes %>%
      select(date, ends_with("injured"), total_accidents) %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(
        injuries_per_collision = sum(injured) / sum(total_accidents)
      ) %>%
      ggplot(aes(x = date, y = injuries_per_collision)) +
      geom_line() +
      labs(title="Persons Injured per Collision by Date",x="Date",y="Persons Injured per Collision")
  }
  
  if (plot_name == "plot_death_per_collision_3") {
    plot_result <- display_daily_crashes %>%
      select(date, ends_with("killed"), total_accidents) %>%
      group_by(date = lubridate::floor_date(date, "month")) %>%
      summarise(
        deaths_per_collision = sum(killed) / sum(total_accidents)
      ) %>%
      ggplot(aes(x = date, y = deaths_per_collision)) +
      geom_line() +
      labs(title="Persons Killed per Collision by Date",x="Date",y="Persons Killed per Collision")
  }
  
  
  return(plot_result)
}

