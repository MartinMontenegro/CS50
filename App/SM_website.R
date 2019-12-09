
#install.packages("shiny")
#install.packages("shinythemes")
#install.packages("readr")
#install.packages("DT")

library(shiny)
library(shinythemes)
library(readr)
library(DT)


#######################
# Load data
setwd("/Users/martin/Documents/PAE")
db <- read_csv("Medical_Facilities.csv")
#View(db)

setwd("/Users/martin/Documents/PAE/App")

#runExample("01_hello")

#trend_description <- read_csv("data/trend_description.csv")

######
ui <- fluidPage(theme = shinytheme("lumen"),
                
                titlePanel("Smart Columbus Data - Medical Facilities"),
                
                sidebarLayout(
                  
                  mainPanel(
                    br(),
                    br(),
                    img(src = "SMRT_web.jpg", height = 200, width = 600),
                    #plotOutput(outputId = "lineplot", height = "300px"),
                    helpText("To view the Smart Columbus open data portal click below."),
                    tags$a(href = "https://www.smartcolumbusos.com/", "Open Data Portal", target = "_blank", color = "blue"), 
                  
                    br(),
                    br(),
                    p("This app is an interactive tool to view through the medical facilities data
                      of Columbus, Ohio. In consecutive interations, I plan to add more databases and
                      more interesting visualizations for the data."),
                    p("Using R will allow me to implement powerful statistical analysis techniques 
                      (supposing I find more suitable databases in the data portal). With some luck,
                      the city of Columbus will add this app to its open data portal to make data easier
                      to browse without the need to download the raw databases and use addtional software."),
                    DT::dataTableOutput('table'),
                    br(),
                    br(),
                    textOutput("selectedType"),
                    br(),
                    DT::dataTableOutput("selectedData"),
                    br(),
                    br(),
                    img(src = "columbusskyline.png", height = 150, width = 900),
                    
                    ),
                
                  
                  sidebarPanel(
                    
                    h3("Browse through different medical facilities listed
                             in the city of Columbus!"),
                    
                    helpText("Select a type of medical facility to view
                             a list of facilities pertaining to this type
                             in the city of Columbus."),
                    
                    selectInput(inputId = "type", label = strong("Medical Facilities"),
                                choices = unique(db$type),
                                selected = "Medical - Physician"),
                    
                    textInput(inputId = "search",
                              label = "Search:",
                              value = "Try searching by name or type")
                    )
                  )
                )

# Define server function to make the site interactive
server <- function(input, output) {
  
  output$table <- DT::renderDataTable({ 
    as.data.frame(table(db$type))
  })
  
  output$selectedType <- renderText({ 
    paste("You have selected ", input$type)
  })
  
  
  output$selectedData <- DT::renderDataTable({ 
    db[db$type %in% input$type,]
  })
  
}

# Create Shiny app
shinyApp(ui = ui, server = server)





