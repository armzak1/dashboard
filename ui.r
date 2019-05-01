ui <- dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(),
  dashboardBody( # Boxes need to be put in a row (or column)
    fluidRow(
      column(9, 
             dateRangeInput('dateRange', label = 'Date Range',
                            start = '2016-02-01', end='2016-02-03',
                            min = min(df_all$created_at), max = max(df_all$created_at)
             )),
      column(3, switchInput('arman'), style='align:right;')
      
    ),
    fluidPage(
      wellPanel(
        fluidRow( 
          column(width=3,
            mainPanel(
              #p('Total Orders', align = 'center'),
              htmlOutput('total_orders')
              )
            ),
          column(width=3,
                 mainPanel(
                   htmlOutput('canceled_orders')
                   
                 )
            ),
          column(width=3,
                 mainPanel(
                   htmlOutput('wait_time')
                   
                 )
          ),
          column(width=3,
                 mainPanel(              
                   htmlOutput('revenue')

                 )
          )
          
        )
      ),
      hr(),
      
      wellPanel(
        fluidRow(
          column(3, plotOutput("plot2")),
          column(9, plotOutput("plot4"))
        ), style='height:250px; margin-bottom:20px;'
      ),
      wellPanel(
        fluidRow(
          column(3, plotOutput("plot1")),
          column(9, plotOutput("plot3"))
        ), style='height:250px; padding:-100px;'
      )
    ))
)
