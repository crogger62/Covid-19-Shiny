#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(COVID19)

# Define UI for application that draws a histogram
ui <- fluidPage(

    selectInput("country", label = "Country", multiple = TRUE, choices = unique(covid19()$administrative_area_level_1), selected = "Bulgaria"),
    selectInput("type", label = "type", choices = c("confirmed", "tests", "recovered", "deaths")),
    selectInput("level", label = "Granularity", choices = c("Country" = 1, "Region" = 2, "City" = 3), selected = 1),
    dateRangeInput("date", label = "Date", start = "2020-01-01"),
    
    plotlyOutput("covid19plot")
    
)

# Define server logic required to draw a histogram
# Define server logic
server <- function(input, output) {
    
    output$covid19plot <- renderPlotly({
        if(!is.null(input$country)){
            x <- covid19(country = input$country, level = input$level, start = input$date[1], end = input$date[2])
            color <- paste0("administrative_area_level_", input$level)
            plot_ly(x = x[["date"]], y = x[[input$type]], color = x[[color]])
        }
    })
    
}
# Run the application 
shinyApp(ui = ui, server = server)
