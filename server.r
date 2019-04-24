options("scipen"=10000, "digits"=10)

gg_theme <- theme(panel.border = element_blank(), 
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  plot.background = element_rect(fill = '#eceff4'),
                  panel.background = element_rect(fill = '#eceff4'),
                  legend.position = 'none')

global_driver_waittime <- mean(na.omit(df_all$driver_wait_time))
global_passenger_waittime <- mean(na.omit(df_all$passenger_wait_time))
global_ride_duration <- aggregate(ride_duration~order_hour, df_all, FUN = 'mean')
global_fare <- aggregate(fare~order_hour, df_all, FUN = 'mean')
df_all$canceled <- as.numeric(df_all$canceled)
global_canceled <- aggregate(canceled~order_hour, df_all, FUN = 'sum')

server <- function(input, output) {
  df <- df_all
  
  
  #waittimes
  output$plot1 <- renderPlot({
    if(input$waitTimeSwitch == 1)
    {
      df_loc <- df[df$driver_wait_time < 15,]
      df_loc$color <- df_loc$driver_wait_time >= global_driver_waittime
      ggplot(df_loc, aes(x=driver_wait_time, fill=color)) + 
        geom_histogram(bins = 15) +
        geom_vline(aes(xintercept=global_driver_waittime), color='red') +
        scale_fill_manual(values = c("green", "red")) + gg_theme
        
    }
    else
    {  
      df_loc <- df[df$passenger_wait_time < 15,]
      df_loc$color <- df_loc$passenger_wait_time >= global_passenger_waittime
      ggplot(df_loc, aes(x=passenger_wait_time, fill=color)) + 
        geom_histogram(bins = 15) +
        geom_vline(aes(xintercept=global_passenger_waittime), color='red') +
        scale_fill_manual(values = c("green", "red")) + gg_theme
    }
  }, bg='transparent')
  ########
  
  #ordertimes
  output$plot2 <- renderPlot({
    ggplot(df, aes(x=order_hour)) + geom_histogram(bins = 20) + coord_polar() + gg_theme
  }, bg='transparent')
  ########
  
  #ridedurations
  df_agg_duration <- aggregate(ride_duration~order_hour, df, FUN = 'mean')
  output$plot3 <- renderPlot({
    ggplot(df_agg_duration, aes(x=order_hour, y=ride_duration)) + 
      geom_point() + geom_line() + gg_theme
  })
  #############
  
  #map TODO
  ############
  
  #prices
  df_agg_price <- aggregate(fare~order_hour, df, FUN = 'mean')
  output$plot4 <- renderPlot({
    ggplot(df_agg_price, aes(x=order_hour, y=fare)) + geom_point() + geom_line() + gg_theme
  })
  ######
  
  #cancelations
  df$canceled <- as.numeric(df$canceled)
  df_agg_canceled <- aggregate(canceled~order_hour, df, FUN = 'sum')
  output$plot5 <- renderPlot({
    ggplot(df_agg_canceled, aes(x=order_hour, y=canceled)) + 
      geom_point() + geom_line() + coord_polar() + gg_theme
  })
  ######
  
}
