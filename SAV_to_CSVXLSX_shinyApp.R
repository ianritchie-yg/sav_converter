library(shiny)
library(haven)
library(writexl)

# Define UI for application
ui <- fluidPage(
    titlePanel("SPSS to CSV/XLSX Converter"),
    sidebarLayout(
        sidebarPanel(
            fileInput('file1', 'Choose SPSS File (.sav)', accept = c('.sav')),
            downloadButton('downloadCSV', 'Download CSV'),
            downloadButton('downloadXLSX', 'Download XLSX')
        ),
        mainPanel(
           tableOutput('table')
        )
    )
)

# Define server logic
server <- function(input, output) {
    
    # Reactive value to store the dataset
    dataset <- reactive({
        file <- input$file1
        if (is.null(file)) return(NULL)
        read_sav(file$datapath)
    })

    # Show the dataset in a table
    output$table <- renderTable({
        data <- dataset()
        if (is.null(data)) return(NULL)
        head(data)
    })

    # Download handler for CSV
    output$downloadCSV <- downloadHandler(
        filename = function() {
            paste0(tools::file_path_sans_ext(input$file1$name), ".csv")
        },
        content = function(file) {
            write.csv(dataset(), file, row.names = FALSE)
        }
    )

    # Download handler for XLSX
    output$downloadXLSX <- downloadHandler(
        filename = function() {
            paste0(tools::file_path_sans_ext(input$file1$name), ".xlsx")
        },
        content = function(file) {
            write_xlsx(dataset(), file)
        }
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
