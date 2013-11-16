
library(shiny)

# Define UI for slider demo application
shinyUI(pageWithSidebar(
  
  #  Application title
  headerPanel("Dynamic Programing Flu Season"),
  
  # Sidebar with sliders that demonstrate various available options
  sidebarPanel(
    
    tags$h3("Data Generation"),
            
    sliderInput("N", "Population:", 
                min=200, max=10000, value=600, step=200),
    
    sliderInput("Ip", "Initial proportion Infected:", 
                min=0, max=1, value=.05, step=.01),
     
    sliderInput("np", "Number of time periods:", 
                min=10, max=360, value=90, step=1),
    
    sliderInput("B", "Transmition rate:", 
                min=0, max=1, value=.2, step=.01),
    
    sliderInput("C", "Contact rate:", 
                min=0, max=10, value=1, step=.01),   
    
    sliderInput("V", "Days Ill:", 
                min=1, max=60, value=15, step=1),    
    
    br(),
    h3("Estimation"),

    tags$br(),
    h5("Created by:"),
    tags$a("Econometrics by Simulation", 
           href="http://www.econometricsbysimulation.com"),
    h5("For details on how data is generated"),
    tags$a("Blog Post", 
           href="http://www.econometricsbysimulation.com"),
    h5(textOutput("counter"))
    ),
  
  # Show a table summarizing the values entered
  mainPanel(
    plotOutput("graph1"),
    plotOutput("graph2"),
    tableOutput("datatable")
  )
))
