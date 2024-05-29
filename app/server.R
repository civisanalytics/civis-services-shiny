# TODO: Document this file
options(shiny.autoreload = TRUE)

server <- function(input, output, session) {
    session$allowReconnect("force")

    username <- civis::users_list_me()$username
    output$current_user_display <- renderText({
        paste("This is a demo Shiny App currently run by Civis Platform user '",
              username,
              "'.",
              sep='')
    })
    repo_url <- a("civis-services-shiny", href = "https://github.com/civisanalytics/civis-services-shiny", target = "_blank", rel = "noopener noreferrer")
    output$create_instructions <- renderUI({
        tagList("To create your own app, fork the ",
                repo_url,
                " repository and follow the instructions in the readme.")
        })

    output$table <- renderDataTable(iris, options = list(pageLength = 10))

    data <- reactive({iris})
    plot_theme = theme_light()

    output$plot_sepal <- renderPlot(
        ggplot(data(), aes(Sepal.Length, Sepal.Width, color = Species)) +
        geom_point() +
        labs(x = "Sepal Length", y = "Sepal Width") + # , title = paste("Sepal Length vs Sepal Width")) +
        plot_theme
    )

    output$plot_petal <- renderPlot(
        ggplot(data(), aes(Petal.Length, Petal.Width, color = Species)) +
        geom_point() +
        labs(x = "Petal Length", y = "Petal Width") + # , title = paste("Sepal Length vs Sepal Width")) +
        plot_theme
    )
}
