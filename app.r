library('shiny')
library('shinydashboard')
library('ggplot2')
library('anytime')
library('plotly')

df_all <- read.csv('gg_clean.csv')
df_all$created_at <- anytime(df_all$created_at)
df_all$kpi <- df_all$fare / df_all$ride_duration

source('ui.r', local = TRUE)
source('server.r')

shinyApp(
  ui = ui,
  server = server
)

