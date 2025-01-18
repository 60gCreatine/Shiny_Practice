library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Set the main title of the application
  titlePanel("Tic Tac Toe"),
  fluidRow(
    column(12, align = "center",
           # Display instructions for players
           h4("Player 1: X, Player 2: O"),
           # Render the game board dynamically
           uiOutput("board"),
           # Add a reset button for restarting the game
           actionButton("reset", "Reset Game"),
           br(),
           # Display the winner or current player
           textOutput("winner")
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Reactive value to store game state
  game <- reactiveValues(
    board = matrix("", nrow = 3, ncol = 3), # Initialize a blank 3x3 game board
    current_player = "X", # Start with Player X
    winner = "" # No winner initially
  )
  
  # Function to check for a winner
  check_winner <- function(board) {
    for (i in 1:3) {
      # Check rows and columns for a winner
      if (all(board[i, ] == board[i, 1]) && board[i, 1] != "") return(board[i, 1])
      if (all(board[, i] == board[1, i]) && board[1, i] != "") return(board[1, i])
    }
    # Check diagonals for a winner
    if (all(diag(board) == board[1, 1]) && board[1, 1] != "") return(board[1, 1])
    if (all(diag(t(board)) == board[1, 3]) && board[1, 3] != "") return(board[1, 3])
    
    # Check if the board is full and declare a draw
    if (all(board != "")) return("Draw")
    
    return("") # No winner yet
  }
  
  # Render the game board
  output$board <- renderUI({
    board <- game$board # Get the current state of the board
    buttons <- lapply(1:3, function(i) { # Loop over rows
      lapply(1:3, function(j) { # Loop over columns
        # Create a button for each cell in the grid
        actionButton(inputId = paste0("cell_", i, "_", j),
                     label = board[i, j],
                     style = "width: 60px; height: 60px; font-size: 20px;")
      })
    })
    # Arrange buttons into rows and columns
    do.call(fluidRow, lapply(1:3, function(i) {
      column(12, align = "center", do.call(tagList, buttons[[i]]))
    }))
  })
  
  # Observe button clicks
  observe({
    for (i in 1:3) {
      for (j in 1:3) {
        # Use `local` to ensure proper scoping of `i` and `j`
        local({
          row <- i
          col <- j
          observeEvent(input[[paste0("cell_", row, "_", col)]], {
            # Only allow a move if the cell is empty and there's no winner
            if (game$board[row, col] == "" && game$winner == "") {
              game$board[row, col] <- game$current_player # Update the cell with the current player's symbol
              game$winner <- check_winner(game$board) # Check if there's a winner
              # Switch to the other player
              game$current_player <- ifelse(game$current_player == "X", "O", "X")
              print(paste("Button", row, col, "clicked. Board updated."))
            }
          })
        })
      }
    }
  })
  
  # Display the winner or the current player
  output$winner <- renderText({
    if (game$winner != "") {
      if (game$winner == "Draw") {
        "It's a Draw!" # Display draw message
      } else {
        paste("Winner:", game$winner) # Display the winner
      }
    } else {
      paste("Current Player:", game$current_player) # Display the current player
    }
  })
  
  # Reset the game
  observeEvent(input$reset, {
    game$board <- matrix("", nrow = 3, ncol = 3) # Clear the board
    game$current_player <- "X" # Reset to Player X
    game$winner <- "" # Clear the winner
  })
}

# Run the application
shinyApp(ui = ui, server = server)
