get_civis_platform_username <- function() {
    # The CIVIS_API_KEY environment variable will be present in Platform environments,
    # but may not be present when the app is run locally.
    has_api_key <- !(Sys.getenv("CIVIS_API_KEY") == "")
    username <- if(has_api_key)
        civis::users_list_me()$username
    else
        'no username available'
}

server <- function(input, output, session) {
    # Allow the app to reconnect automatically after network failures.
    session$allowReconnect("force")

    # You can interact with the Civis API using the "civis" R package:
    # https://civisanalytics.github.io/civis-r/
    # Here, we demo a simple example of getting the username of the current user.
    username <- get_civis_platform_username()

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

    output$iris_datatable <- renderDataTable(iris, options = list(pageLength = 10))

    plot_theme = theme_minimal()

    output$plot_sepal <- renderPlot(
        ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
        geom_point() +
        labs(x = "Sepal Length", y = "Sepal Width") +
        plot_theme
    )

    output$plot_petal <- renderPlot(
        ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) +
        geom_point() +
        labs(x = "Petal Length", y = "Petal Width") +
        plot_theme
    )
}
