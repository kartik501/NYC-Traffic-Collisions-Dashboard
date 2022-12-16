source("./dependencies.R")
source("./components/map_panel.R")

server <- function(input, output) {
    output$map_output <- renderLeaflet({
        generate_map(input)
    })

    output$plot_volume_1 <- renderPlot(plot_volume_1)
    output$plot_no_collisions_1 <- renderPlot(plot_no_collisions_1)
    output$plot_total_injuries_1 <- renderPlot(plot_total_injuries_1)
    output$plot_total_deaths_1 <- renderPlot(plot_total_deaths_1)
    output$plot_injuries_per_collision_1 <- renderPlot(plot_injuries_per_collision_1)
    output$plot_death_per_collision_1 <- renderPlot(plot_death_per_collision_1)



    # Graphs panel 2
    output$plot_volume_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_volume_2")
    })
    output$plot_no_collisions_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_no_collisions_2")
    })
    output$plot_total_injuries_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_total_injuries_2")
    })
    output$plot_total_deaths_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_total_deaths_2")
    })
    output$plot_total_speed <- renderPlot({
        get_plots_2(input, plot_name = "plot_total_speed")
    })
    output$plot_injuries_per_collision_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_injuries_per_collision_2")
    })
    output$plot_death_per_collision_2 <- renderPlot({
        get_plots_2(input, plot_name = "plot_death_per_collision_2")
    })


    # Graphs panel 3
    output$plot_no_collisions_3 <- renderPlot({
        get_plots_3(input, plot_name = "plot_no_collisions_3")
    })
    output$plot_total_injuries_3 <- renderPlot({
        get_plots_3(input, plot_name = "plot_total_injuries_3")
    })
    output$plot_total_deaths_3 <- renderPlot({
        get_plots_3(input, plot_name = "plot_total_deaths_3")
    })
    output$plot_injuries_per_collision_3 <- renderPlot({
        get_plots_3(input, plot_name = "plot_injuries_per_collision_3")
    })
    output$plot_death_per_collision_3 <- renderPlot({
        get_plots_3(input, plot_name = "plot_death_per_collision_3")
    })

    

    output$map_label_boroughs <- map_borough_label(input)
}