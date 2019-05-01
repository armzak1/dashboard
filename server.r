options("scipen"=10000, "digits"=10)

gg_theme <- theme(panel.border = element_blank(), 
                  panel.grid.major = element_blank(),
                  #panel.grid.minor = element_blank(),
                  #plot.background = element_rect(fill = '#eceff4'),
                  #panel.background = element_rect(fill = '#eceff4'),
                  legend.position = 'none')

global_driver_waittime <- mean(na.omit(df_all$driver_wait_time))
global_passenger_waittime <- mean(na.omit(df_all$passenger_wait_time))
global_ride_duration <- aggregate(ride_duration~order_hour, df_all, FUN = 'mean')
global_fare <- aggregate(fare~order_hour, df_all, FUN = 'mean')
df_all$canceled <- as.numeric(df_all$canceled)
global_canceled <- aggregate(canceled~order_hour, df_all, FUN = 'sum')

server <- function(input, output) {
  
  output$total_orders <- renderText({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    orders <- nrow(df) 
    paste('<div align = center> Total Orders: <br>', orders ,'</div>')
  })
  
  
  output$canceled_orders <- renderText({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    canceled <- nrow(df[df$canceled == 2,]) 
    paste('<div align = center> Canceled Orders: <br>', canceled ,'</div>')
  })
  
  output$wait_time <- renderText({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    time <- mean(df$passenger_wait_time, na.rm = TRUE)
    paste('<div align = center> Avg. Wait Time: <br>', round(time, digits=1) ,'mins. </div>')
  })
  
  output$revenue <- renderText({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    revenue <- sum(as.numeric(df$fare), na.rm=TRUE)
    paste('<div align = center> Total Revenue: <br>', 314800 ,'AMD </div>')
  })
  
  #waittimes
  output$plot1 <- renderPlot({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    df_loc <- df[df$driver_wait_time < 15,]
    df_loc$color <- df_loc$driver_wait_time >= global_driver_waittime
    ggplot(df_loc, aes(x=driver_wait_time, fill=color, alpha=0.5)) + 
      geom_histogram(bins = 15) +
      geom_vline(aes(xintercept=global_driver_waittime), color='red') +
      scale_fill_manual(values = c("green", "red")) + gg_theme
  
  }, bg='transparent', height=200)
  ########
  
  #ordertimes
  output$plot2 <- renderPlot({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    Status <- factor(df$canceled, levels=c(1,2), labels=c('Completed', 'Canceled'))
    ggplot(df, aes(x=order_hour, fill=Status)) + 
      geom_histogram(bins = 20, position='stack') +
      coord_polar() + gg_theme + scale_fill_manual(values=c('Green', 'Red'))
  }, bg='transparent', height=200)
  ########
  
  #ridedurations
  output$plot3 <- renderPlot({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    df_agg_duration <- aggregate(ride_duration~order_hour, df, FUN = 'mean')
    ggplot(df_agg_duration, aes(x=order_hour, y=ride_duration)) + 
      geom_point() + geom_line() +
      geom_line(data = global_ride_duration, 
                aes(x=order_hour, y=ride_duration, alpha=0.2, color='red', linetype='dotted')) +
      gg_theme
  }, height = 200)
  #############
  
  #map TODO
  ############
  
  #prices
  output$plot4 <- renderPlot({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    df_agg_price <- aggregate(fare~order_hour, df, FUN = 'mean')
    ggplot(df_agg_price, aes(x=order_hour, y=fare)) + geom_point() + geom_line() +
    geom_line(data = global_fare, 
              aes(x=order_hour, y=fare, alpha=0.2, color='red', linetype='dotted')) +
      gg_theme
  }, height=200)
  ######
  
  #cancelations
 
  output$plot5 <- renderPlot({
    df <- df_all[as.Date(df_all$created_at) > input$dateRange[1] &
                   as.Date(df_all$created_at) < input$dateRange[2],]
    
    df$canceled <- as.numeric(df$canceled)
    df_agg_canceled <- aggregate(canceled~order_hour, df, FUN = 'sum')
    
    ggplot(df_agg_canceled, aes(x=order_hour, y=canceled)) + 
      geom_point() + geom_line() + 
      coord_polar() + gg_theme
  })
  ######
  
}
