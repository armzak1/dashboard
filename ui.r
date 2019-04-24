ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    radioButtons("waitTimeSwitch", label = '',
                 choices = list("Driver" = 1, "Passenger" = 2), 
                 selected = 1, inline=TRUE),
    dateRangeInput('dateRange', label = 'Date Range',
                   start = '2016-02-01', end='2016-04-01',
                   min = min(df_all$created_at), max = max(df_all$created_at)
                   )
  ),
  dashboardBody( # Boxes need to be put in a row (or column)
    fluidPage(
      textOutput('arman'),
      plotOutput("plot1", height = 250, width=300),
      hr(),
      hr(),
      plotOutput('plot2', height = 250, width = 300),
      hr(),
      plotOutput('plot3', height = 250, width=300),
      hr(),
      plotOutput('plot4', height = 250, width = 300),
      hr(),
      plotOutput('plot5', height = 250, width = 300)
    ))
)
