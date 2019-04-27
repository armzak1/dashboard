ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    radioButtons("waitTimeSwitch", label = '',
                 choices = list("Driver" = 1, "Passenger" = 2), 
                 selected = 1, inline=TRUE),
    dateRangeInput('dateRange', label = 'Date Range',
                   start = '2016-02-01', end='2016-02-07',
                   min = min(df_all$created_at), max = max(df_all$created_at)
                   )
  ),
  dashboardBody( # Boxes need to be put in a row (or column)
    fluidPage(
      wellPanel(
        fluidRow( 
          column(width=3,
            mainPanel(
              p('Total Orders', align = 'center'),
              p('1000', align = 'center')
              )
            ),
          column(width=3,
                 mainPanel(
                   p('Canceled Orders', align = 'center'),
                   p('1000', align = 'center')
                 )
            ),
          column(width=3,
                 mainPanel(
                   p('Avg. Wait Time', align = 'center'),
                   p('1000', align = 'center')
                 )
          ),
          column(width=3,
                 mainPanel(
                   p('Total Revenue', align = 'center'),
                   p('1000', align = 'center')
                 )
          )
          
        )
      ),
      hr(),
      wellPanel(
        fluidRow(
          column(3, plotOutput("plot2"), div(style='height:2px;')),
          column(9, plotOutput("plot4"), div(style='height:2px;'))
        ), style='height:250px;'
      ),
      hr(),
      #plotOutput('plot2', height = 250, width = 300),
      hr(),
      #plotOutput('plot3', height = 250, width='100%'),
      hr(),
      plotOutput('plot3', height = 250, width = '100%'),
      hr(),
      plotOutput("plot1", height = 250, width=300)
    ))
)
