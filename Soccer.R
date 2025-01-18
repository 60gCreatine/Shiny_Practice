library(shiny)
library(tidyverse)
# Basic UI og Server
df <- readRDS("dataforvideo.rds")

ui <- fluidPage(
  tabsetPanel(
    tabPanel("Spiller",
             selectInput("sp",
                         "Vælg num variabel",
                         choices = c("age","bmi"),
                         selected = "age"
                         ),
                 # Her kommer plottet
             
    tabPanel("Skud",
            ),
    tabPanel("Kategoriske var",
            ),
    tabPanel("Fodboldbanen",
            ),
  )
)
)
server <- function(input,output){
  
  
}


library(shiny)

ui <- fluidPage(

)

server <- function(input, output, session) {
  renderPlot({
    ggplot()
  })
}

shinyApp(ui = ui, server = server)
