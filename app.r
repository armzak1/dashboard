library('shiny')
library('shinydashboard')
library('ggplot2')
library('anytime')

df_all <- read.csv('gg_clean.csv')
df_all$created_at <- anytime(df_all$created_at)

source('ui.r', local = TRUE)
source('server.r')

shinyApp(
  ui = ui,
  server = server
)
