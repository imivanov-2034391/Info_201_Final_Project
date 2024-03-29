# INFO 201 Final Project -- Final Deliverable
# Section BH-5
# Group member: Sera Lee, Lele Zhang, Ivette Ivanov, Sohyun Han


# Load libraries
library(ggplot2)
library(plotly)
library(dplyr)
library(bslib)
library(shiny)

# Load data
combined_df <- read.csv("Comprehensive Physical Health and Occupational Statistics Dataset.csv")


server <- function(input, output){
  
  
  # Interactive Page 1
  
  output$phy_occ_plot <- renderPlotly({
    
    filtered_df <- combined_df %>% filter(Occupation %in% input$user_selection)
    filtered_60_df <- combined_df %>% filter(Physical.Activity.Level > 60)
    
    if (input$phy_occ_plot_60) { # display physical activity level > 60 
      my_plot <- ggplot(filtered_60_df) +
        geom_point(mapping = aes(
          x = Physical.Activity.Level,
          y = Occupation,
          color = Occupation
        ))
      
    } else { # display all physical activity level
      my_plot <- ggplot(filtered_df) +
        geom_point(mapping = aes(
          x = Physical.Activity.Level,
          y = Occupation,
          color = Occupation
        ))
    }
    
    return(ggplotly(my_plot))
  })
  
  
  # Interactive Page 2
  
  output$sle_occ_plot <- renderPlotly({
    
  filtered_df <- combined_df %>% group_by(Occupation) %>% 
    summarise(ave_sleep = mean(Quality.of.Sleep, na.rm = TRUE))
    
    if (input$sle_occ_plot_type == "Best Quality of Sleep") {
      filtered_df <- filtered_df %>% arrange(ave_sleep) %>% slice(1:3)

      my_plot <- ggplot(filtered_df) +
        geom_col(mapping = aes(x = Occupation, y = ave_sleep, fill = Occupation)) + 
        labs(title = "Best Sleep Quality Occupations", 
             x = "Occupation", y = "Average Quality of Sleep")
      
    } else if (input$sle_occ_plot_type == "Worst Quality of Sleep") {
      filtered_df <- filtered_df %>% arrange(desc(ave_sleep)) %>% slice(1:3)
      
      my_plot <- ggplot(filtered_df) +
        geom_col(mapping = aes(x = Occupation, y = ave_sleep, fill = Occupation)) + 
        labs(title = "Worst Sleep Quality Occupations", 
             x = "Occupation", y = "Average Quality of Sleep")
      
    } else if (input$sle_occ_plot_type == "Overall Quality of Sleep") {

      my_plot <- ggplot(filtered_df) +
        geom_col(mapping = aes(x = Occupation, y = ave_sleep, fill = Occupation)) + 
        labs(title = "Sleep Quality Occupations Overview", 
             x = "Occupation", y = "Average Quality of Sleep")
    }
    
    return(ggplotly(my_plot))
  }) 
  
  
  # Interactive Page 3 - Salary and Health
  
  output$sal_phy_plot <- renderPlotly({
    
    health_df <- combined_df %>% arrange(A_MEAN)
    
    if(input$viz_3inputid2 == "Average Annual Salary"){
      if (input$viz_3inputid == "Heart Rate") {
        my_plot3 <- plot_ly(data = health_df, x = ~Heart.Rate, y = ~A_MEAN, type = 'scatter',
                            marker = list(color = "#fd7f6f")) %>%
          layout(title = paste("Heart Rate"),
                 xaxis = list(title = "Heart Rate"),
                 yaxis = list(title = "Average Annual Salary (in U.S. dollars)"))  
      } else if (input$viz_3inputid == "Blood Pressure") {
        my_plot3 <- plot_ly(data = health_df, x = ~A_MEAN, y = ~Blood.Pressure, type = 'scatter', 
                            marker = list(color = "#7eb0d5")) %>%
          layout(title = paste("Blood Pressure"),
                 xaxis = list(title = "Average Annual Salary (in U.S. dollars)"),      
                 yaxis = list(title = "Blood Pressure"))
      } else if (input$viz_3inputid == "Daily Steps") {
        my_plot3 <- plot_ly(data = health_df, x = ~Daily.Steps, y = ~A_MEAN, type = 'scatter', 
                            marker = list(color = "#b2e061")) %>%
          layout(title = paste("Daily Steps"),
                 xaxis = list(title = "Daily Steps"),
                 yaxis = list(title = "Average Annual Salary (in U.S. dollars)"))
      } else if (input$viz_3inputid == "Physical Activity Level") {
        my_plot3 <- plot_ly(data = health_df, x = ~Physical.Activity.Level, y = ~A_MEAN, type = 'scatter', 
                            marker = list(color = '#53BBBC')) %>%
          layout(title = paste("Physical Activity Level"),
                 xaxis = list(title = "Physical Activity Level"),
                 yaxis = list(title = "Average Annual Salary (in U.S. dollars)"))
      }
    } else if (input$viz_3inputid2== "Average Hourly Wage"){
      if (input$viz_3inputid == "Heart Rate") {
        my_plot3 <- plot_ly(data = health_df, x = ~Heart.Rate, y = ~H_MEAN, type = 'scatter',
                            marker = list(color = "#ea5545")) %>%
          layout(title = paste("Heart Rate"),
                 xaxis = list(title = "Heart Rate"),
                 yaxis = list(title = "Average Hourly Wage (in U.S. Dollars)"))  
      } else if (input$viz_3inputid == "Blood Pressure") {
        my_plot3 <- plot_ly(data = health_df, x = ~H_MEAN, y = ~Blood.Pressure, type = 'scatter', 
                            marker = list(color = "#0d88e6")) %>%
          layout(title = paste("Blood Pressure"),
                 xaxis = list(title = "Average Hourly Wage (in U.S. Dollars)"),      
                 yaxis = list(title = "Blood Pressure"))
      } else if (input$viz_3inputid == "Daily Steps") {
        my_plot3 <- plot_ly(data = health_df, x = ~Daily.Steps, y = ~H_MEAN, type = 'scatter', 
                            marker = list(color = "#5ad45a")) %>%
          layout(title = paste("Daily Steps"),
                 xaxis = list(title = "Daily Steps"),
                 yaxis = list(title = "Average Hourly Wage (in U.S. Dollars)"))
      } else if (input$viz_3inputid == "Physical Activity Level") {
        my_plot3 <- plot_ly(data = health_df, x = ~Physical.Activity.Level, y = ~H_MEAN, type = 'scatter', 
                            marker = list(color = "#00bfa0")) %>%
          layout(title = paste("Physical Activity Level"),
                 xaxis = list(title = "Physical Activity Level"),
                 yaxis = list(title = "Average Hourly Wage (in U.S. Dollars)"))
      }
    }
  })
  
  

}
