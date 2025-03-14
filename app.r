library(shiny)
library(jsonlite)

# Load game data
game_list_url <- "https://api.steampowered.com/ISteamApps/GetAppList/v2/"
game_data <- fromJSON(game_list_url)

# Convert to DataFrame
game_df <- as.data.frame(game_data$applist$apps)

# Define UI
ui <- fluidPage(
  titlePanel("🎮 Steam Game Search"),
  
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        inputId = "game",
        label = "Choose a game:",
        choices = NULL,  # Will be updated dynamically
        multiple = FALSE,
        options = list(maxOptions = 10)  # Only show a few at a time
      )
    ),
    mainPanel(
      textOutput("selected_game")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  # Update selectize input with server-side loading
  updateSelectizeInput(session, "game", choices = game_df$name, server = TRUE)
  
  # Display selected game
  output$selected_game <- renderText({
    req(input$game)  # Ensure input is not null
    paste("You selected:", input$game)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
