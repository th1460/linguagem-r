library(shiny)

source("dataStocks.R")

carbonUiShell <- function(prefix, name, href = "javascript:void 0") {
    
    dep_ui_shell <- htmltools::htmlDependency(
        name = "ui-shell",
        version = "1.0.0",
        src = list(href = "https://1.www.s81c.com/common"),
        script = list(type = "module", src = "carbon/web-components/tag/latest/ui-shell.min.js"),
        stylesheet = list(href = "carbon-for-ibm-dotcom/tag/v1/latest/plex.css")
    )
    
    ui_shell <- htmltools::tag("bx-header",
                               list(`aria-label` = paste(prefix, name),
                                    htmltools::tag("bx-header-name",
                                                   list(href = href,
                                                        prefix = prefix, name))))
    
    htmltools::attachDependencies(ui_shell, dep_ui_shell)
    
}

carbonGrid <- function(x) {
    
    htmltools::htmlDependency(name = "grid",
                              version = "1.0.0", 
                              src = list(href = "https://1.www.s81c.com/common/carbon-for-ibm-dotcom/tag/v1/latest"),
                              stylesheet = list(href = "grid.css"))
    
}

carbonDatePicker <- function(id, label_from, label_to, placeholder) {
    
    dep_date_picker <- htmltools::htmlDependency(
        name = "date_picker",
        version = "1.0.0",
        src = list(href = "https://1.www.s81c.com/common"),
        script = list(type = "module", src = "carbon/web-components/tag/latest/date-picker.min.js"),
        stylesheet = list(href = "carbon-for-ibm-dotcom/tag/v1/latest/plex.css")
    )
    
    date_picker <- htmltools::tag("bx-date-picker", 
                                  list(id = id,
                                       tagList(
                                           htmltools::tag("bx-date-picker-input",
                                                          list(kind = "from",
                                                               `label-text` = label_from,
                                                               placeholder = placeholder)),
                                           htmltools::tag("bx-date-picker-input",
                                                          list(kind = "to",
                                                               `label-text` = label_to,
                                                               placeholder = placeholder))
                                           
                                       )))
    
    htmltools::attachDependencies(date_picker, dep_date_picker)
    
}

carbonDropdown <- function(id, value, label, options) {
    
    dep_dropdown <- htmltools::htmlDependency(
        name = "dropdown",
        version = "1.0.0",
        src = list(href = "https://1.www.s81c.com/common"),
        script = list(type = "module", src = "carbon/web-components/tag/latest/dropdown.min.js"),
        stylesheet = list(href = "carbon-for-ibm-dotcom/tag/v1/latest/plex.css")
    )
    
    dropdown <- htmltools::tag("bx-dropdown", 
                               list(id = id, value = "", `label-text` = label))
    
    for(i in seq(length(options))) {
        
        dropdown <- 
            dropdown |> 
            htmltools::tagAppendChild(tag("bx-dropdown-item", list(value = options[i], names(options[i]))))
        
    }
    
    htmltools::attachDependencies(dropdown, dep_dropdown)
    
}

ui <- function(requests) {
    
    tagList(carbonGrid(),
            carbonUiShell("Stock Price", "App"),
            tags$div(class = "bx--grid",
                     tags$div(class = "bx--row", style = "margin-top: 5rem",
                              tags$div(class =  "bx--col",
                                       carbonDropdown("code", "","Stock Code", c("PETR4" = "PETR4.SA", 
                                                                                 "IRDM11" = "IRDM11.SA", 
                                                                                 "BBAS3" = "BBAS3.SA",
                                                                                 "ITSA4" = "ITSA4.SA",
                                                                                 "VALE3" = "VALE3.SA",
                                                                                 "IBMB34" = "IBMB34.SA")),
                                       carbonDatePicker("date", "From", "To", "mm/dd/yyyy"),
                                       tags$script(HTML('document.getElementById("code").addEventListener("bx-dropdown-selected", (e) => {Shiny.setInputValue("code", e.detail.item.value)});')),
                                       tags$script(HTML('document.getElementById("date").addEventListener("bx-date-picker-changed", (e) => {Shiny.setInputValue("date", e.detail.selectedDates)});')),
                              ),
                              tags$div(class =  "bx--col",
                                       plotly::plotlyOutput("plot")
                              )
                     )
            )
    )
}

server <- function(input, output, session) {
    
    data_stock <- reactive({
        
        validate(
            need(input$code, "Please type a stock code!"),
            need(input$date[1], "Please choose a start date!"),
            need(input$date[2], "Please choose a end date!"))
        
        dataStocks(input$code, as.Date(input$date[1]), as.Date(input$date[2]))
    })
    
    output$plot <- plotly::renderPlotly({
        plotly::plot_ly(data_stock(), 
                        x = ~Date, 
                        y = ~Adjusted, 
                        mode = "lines",
                        type = "scatter") |> 
            plotly::rangeslider()
    })
    
}

shinyApp(ui, server)