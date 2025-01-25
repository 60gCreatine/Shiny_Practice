library(shiny)
library(tidyverse)
# Basic UI og Server
df <- readRDS("dataforvideo.rds")

library(skimr)
  dfvars=skim(df)
  # Giver information om selve dataframen
  dfvarsed=dfvars %>% select(c("skim_type","skim_variable"))
  # Giver nere specifikt overblik over variabler i df
  
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Spiller",
             selectInput("sp",
                         "Vælg num variabel",
                         choices = c("age","bmi"),
                         selected = "age"
                         ),
                 # Her kommer plottet
                  plotOutput("spplot")
             
    ),
    tabPanel("Skud",
            ),
    tabPanel("Kategoriske var",
            ),
    tabPanel("Fodboldbanen",
            ),
  )
)

server <- function(input, output, session) {
  output$spplot <- renderPlot({
    xval=input$sp
    ggplot(df,aes_string(x=xval))+geom_histogram()
  })
}

shinyApp(ui = ui, server = server)
