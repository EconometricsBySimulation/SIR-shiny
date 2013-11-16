library("shiny")
library("ggplot2")

# Simulation and Shiny Application of Flue Season Dynamics
shinyServer(function(input, output) {
  
  # Hit counter
  output$counter <- 
    renderText({
      if (!file.exists("counter.Rdata")) counter <- 0
      if (file.exists("counter.Rdata")) load(file="counter.Rdata")
      counter <- counter + 1
      
      save(counter, file="counter.Rdata")     
      paste0("Hits: ", counter)
    })
  
  mydata <- reactive({
    # Model Parameters:
    Ip <- input$Ip  # Proportion Infected
    Sp <- 1-Ip      # Proportion Susceptible
    N  <- input$N   # Total Population
    np <- input$np  # Time periods
    
    # Infection Parameters:
    B <- input$B # Transmition rate
    C <- input$C # Contact rate.
    v <- 1/input$V # Recovery rate days
    
    # Model - Dynamic Change
    DS <- function() -B*C*S*I/N
    DI <- function() (B*C*S*I/N) - v*I
    DZ <- function() v*I
    
    # Initial populations:
    Sv <- S <- Sp*N # Sesceptible population
    Iv <- I <- Ip*N # Infected
    Zv <- Z <- 0    # Immune
    
    # Loop through periods
    for (p in 1:np) {
      # Calculate the change values
      ds = DS()
      di = DI()
      dz = DZ()
      
      # Change the total populations
      S = S + ds
      I = I + di
      Z = Z + dz
      
      # Save the changes in vector form
      Sv = c(Sv, S)
      Iv = c(Iv, I)
      Zv = c(Zv, Z)  
    }
    # Turn the results into a table
    long <- data.frame(
      Period=rep((1:length(Sv)),3), 
      Population = c(Sv, Iv, Zv), 
      Indicator=rep(c("Uninfected", "Infected", "Recovered"), 
                    each=length(Sv)))
    wide <- cbind(Sv, Iv, Zv)
      
    list(long=long, wide=wide)
    
    })
  
  output$datatable <- renderTable(mydata()[["wide"]])
    
  output$graph1 <- renderPlot({
    p <- ggplot(mydata()[["long"]], 
         aes(x=Period, y=Population, group=Indicator))    
    p <- p + geom_line(aes(colour = Indicator), size=1.5) + 
         ggtitle("Population Totals")
    print(p)
  })
  
  output$graph2 <- renderPlot({
    data2 <- mydata()[["wide"]]
        
    change <- data2[-1,]-data2[-nrow(data2),]
    
    long <- data.frame(
      Period=rep((1:nrow(change)),3), 
      Population = c(change[,1], change[,2], change[,3]), 
      Indicator=rep(c("Uninfected", "Infected", "Recovered"), 
                    each=nrow(change)))
    
    p <- ggplot(long, 
                aes(x=Period, y=Population, group=Indicator))    
    p <- p + geom_line(aes(colour = Indicator), size=1.5) + 
      ggtitle("Change in Population")
    print(p)
  })
  
  
})
  
