library(shiny)
library(shinythemes)

source("dataStocks.R")

start_value <- Sys.Date() - 31
end_value <- Sys.Date()

ui <- fluidPage(
    theme = shinytheme("sandstone"),
    navbarPage("STOCK PRICE"),
    sidebarLayout(
        sidebarPanel(
            textInput("code", "Stock code", value = "PETR4.SA"),
            dateRangeInput("date", "Date", 
                           start = start_value,
                           end = end_value)
        ),
        
        mainPanel(
            plotly::plotlyOutput("plot")
        )
    )
    
)

server <- function(input, output, session) {
    
    data_stock <- reactive({
        
        validate(
            need(input$code, "Please type a stock code!"),
            need(input$date[1], "Please choose a start date!"),
            need(input$date[2], "Please choose a end date!"))
        
        dataStocks(input$code, input$date[1], input$date[2])
    })
    
    output$plot <- plotly::renderPlotly({
        plotly::plot_ly(data_stock(), 
                        x = ~Date, 
                        y = ~Adjusted, 
                        color = "orange",
                        mode = "lines",
                        type = "scatter") |> 
            plotly::rangeslider()
    })
    
}

shinyApp(ui, server)
