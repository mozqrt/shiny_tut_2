# Load packages ----
library(shiny)
library(maps)
library(mapproj)


# Load data ----
counties <- readRDS("data/counties.rds")

# Source helper functions ----
source("helpers.R")

# Define UI----
ui <- fluidPage(
  titlePanel("censusVis"),  
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Create demographic maps with information from the 2010 US Census"),
      
      selectInput("var", 
                  label = h3("Choose a variable to display"), 
                  choices = list("Percent White", "Percent Black",
                                 "Percent Hispanic", "Percent Asian"), 
                  selected = "Percent White"),
      
      sliderInput("slider", label = "Range of interest",
                  min = 0, max = 100, value = c(0, 100))
      
    ),
    
    mainPanel(
      # textOutput("selected_var"),
      # textOutput("min_max"),
      plotOutput("map")
    )
  )
)

# Define server logic ----
server <- function(input, output){
  
  # output$selected_var <- renderText(
    # {paste("You have selected this", input$var)}
  # )
  
  # output$min_max <- renderText({paste("You have chosen a range that goes from", input$slider[1], "to", input$slider[2])})
  
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "orange",
                    "Percent Asian" = "red")
    
    title <- switch(input$var, 
                    "Percent White" = "% White",
                    "Percent Black" = "% Black",
                    "Percent Hispanic" = "% Hispanic",
                    "Percent Asian" = "% Asian")

    percent_map(var=data, color=color, legend.title = title, max = input$slider[2], min = input$slider[1])
  })
}

# Run the app
shinyApp(ui = ui, server = server)