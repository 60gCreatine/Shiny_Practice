library(shiny)

# Where data is manipulated and visualizations are prepared
server = function(input, output, session) {}

# Where data is shwon and visualizations are served
ui = fluidPage("Wow Shiny so coolio")

# Launch the codes locally
shinyApp(ui = ui, server = server)
