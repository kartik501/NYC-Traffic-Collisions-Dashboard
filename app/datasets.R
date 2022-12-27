source("./dependencies.R")


if (!exists("daily_crashes")) {
    daily_crashes <- read_csv("./agg/motor_vehicle_collisions_crashes.csv")
}
if (!exists("daily_speed")) {
    daily_speed <- read_csv("./agg/real-time_traffic_speed_data.csv")
}
if (!exists("daily_traffic")) {
    daily_traffic <- read_csv("./agg/Traffic_Volume_2019_onwards.csv")

    manhattan_traffic_filter <- (
        (daily_traffic$plaza_id == 21 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 24 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 27 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 28 & daily_traffic$direction == "I")
    )

    queens_traffic_filter <- (
        (daily_traffic$plaza_id == 21 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 22 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 23 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 26 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 27 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 29 & daily_traffic$direction == "O")
    )

    brooklyn_traffic_filter <- (
        (daily_traffic$plaza_id == 25 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 28 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 30 & daily_traffic$direction == "O")
    )

    bronx_traffic_filter <- (
        (daily_traffic$plaza_id == 21 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 22 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 23 & daily_traffic$direction == "I") |
        (daily_traffic$plaza_id == 24 & daily_traffic$direction == "O") |
        (daily_traffic$plaza_id == 29 & daily_traffic$direction == "I")
    )

    staten_island_traffic_filter <- (
        (daily_traffic$plaza_id == 30 & daily_traffic$direction == "I")
    )
}


# head(daily_crashes)
# colnames(traffic_volume) <- c(
#     "plaza_id",
#     "date",
#     "hour",
#     "direction",
#     "number_vehicles_ezpass",
#     "number_vehicles_vtoll"
# )

# daily_traffic <- traffic_volume %>%
#     group_by(
#         date = lubridate::floor_date(date, "day"),
#         plaza_id,
#         direction
#     ) %>%
#     summarise(
#         total = sum(number_vehicles_ezpass + number_vehicles_vtoll)
#     ) %>% as_tibble()

# write_csv(daily_traffic, "./data/agg/Traffic_Volume_2019_onwards.csv")
# map_data <- read_csv("./data/motor_vehicle_collisions_crashes.csv")

# map_data <- map_data %>%
#     dplyr::filter(
#         !is.na(borough) | !is.na(zip_code)
#     )

# daily_data <- map_data %>%
#     group_by(
#         date = lubridate::floor_date(crash_date, "day"),
#         borough
#     ) %>%
#     summarize(
#         avg_lat = mean(latitude),
#         avg_lon = mean(longitude),
#         number_of_persons_injured = sum(number_of_persons_injured),
#         number_of_persons_killed = sum(number_of_persons_killed),
#         number_of_pedestrians_injured = sum(number_of_pedestrians_injured),
#         number_of_pedestrians_killed = sum(number_of_pedestrians_killed),
#         number_of_cyclist_injured = sum(number_of_cyclist_injured),
#         number_of_cyclist_killed = sum(number_of_cyclist_killed),
#         number_of_motorist_injured = sum(number_of_motorist_injured),
#         number_of_motorist_killed = sum(number_of_motorist_killed),
#         total_accidents = n()
#     ) %>%
#     as_tibble()

# write_csv(daily_data, "./data/agg/motor_vehicle_collisions_crashes.csv")
# head(daily_crashes)

# daily_speed <- traffic_speeds %>%
#     group_by(
#         date = lubridate::floor_date(data_as_of, "day"),
#         borough
#     ) %>%
#     summarize(
#         avg_speed = mean(speed),
#         avg_time = mean(travel_time)
#     )
# head(daily_speed)
# dim(daily_speed)