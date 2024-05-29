ui <- fluidPage(
  headerPanel("Demo Shiny App"),

  mainPanel(
    textOutput("current_user_display"),
    uiOutput("create_instructions"),

    titlePanel('The Iris Dataset'),
    fluidRow(column(12,
      dataTableOutput("iris_datatable")
    )),

    titlePanel('Sepal Length vs Sepal Width'),
    plotOutput('plot_sepal'),

    titlePanel('Petal Length vs Petal Width'),
    plotOutput('plot_petal'),
  )
)
