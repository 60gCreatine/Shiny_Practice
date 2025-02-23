library(shiny)
library(tidyverse)
library(ggsoccer)
  # https://github.com/Torvaney/ggsoccer
# Basic UI og Server
df <- readRDS("dataforvideo.rds")
shots <- data.frame(x = c(90, 85, 82, 78, 83, 74, 94, 91),
                    y = c(43, 40, 52, 56, 44, 71, 60, 54))

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
                  plotOutput("spplot")
    ),
    tabPanel("Skud",
             selectInput("sk",
                         "Vælg num variabel",
                         choices = c("myang","mdist"),
                         selected = "myang"
                        ),
                  plotOutput("skplot")
            ),
    tabPanel("Kategoriske var",
             selectInput("skat",
                         "Vælg variabel",
                         choices = c("position","team.name"),
                         selected = "position"
                        ),
                  plotOutput("skatplot")
            ),
    tabPanel("Fodboldbanen",
             selectInput("player",
                         "Spillerrelateret variabel",
                         choices = c("shotpositions","passes"),
                         selected = "shotpositions"
             ),
             plotOutput("soccerplot")
            ),
  )
)

server <- function(input, output, session) {
  output$spplot <- renderPlot({
    xval=input$sp
    ggplot(df,aes_string(x=xval))+geom_histogram()
  })
  output$skplot <- renderPlot({
    xval=input$sk
    ggplot(df,aes_string(x=xval))+geom_histogram()
  })
  output$skatplot <- renderPlot({
    xval=input$skat
    cval="isGoal"
    ggplot(df,aes_string(x=xval,color=cval))+geom_bar()+
      #theme(axis.text.x = element_text(angle=90))+
      coord_flip()
  })
  output$soccerplot <- renderPlot({
    ggplot(shots) +
      annotate_pitch(colour = "white",
                     dimensions = pitch_wyscout,
                     fill   = "springgreen4",
                     limits = FALSE) +
      geom_point(aes(x = x, y = y),
                 colour = "yellow",
                 size = 4) +
      theme_pitch() +
      theme(panel.background = element_rect(fill = "springgreen4")) +
      coord_flip(xlim = c(49, 101)) +
      scale_y_reverse() +
      ggtitle("Simple shotmap",
              "ggsoccer example")
  })
  
}






shinyApp(ui = ui, server = server)

