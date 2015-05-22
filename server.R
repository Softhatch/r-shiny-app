library(leaflet)
library(ggplot2)
library(maps)
source("dbhelper.R")

shinyServer(function(input, output, session) {
  
  #create a leaflet map
  map <- createLeafletMap(session, 'map')
  
  #draw circles on the map
  drawJobsBubbles <- function(skill){
    map$clearShapes()
    cities <- getDataBySkill(skill)
    
    if (nrow(cities) == 0)
      return()
    
    map$addCircle(cities$latitude, cities$longitude, sqrt(cities$total_jobs)*10000/pi, cities$id,
                  list(
                    weight=1.2,
                    fill=TRUE,
                    color='#E558DE'
                  ))
  }
  
  #draw circles on the map
  drawJobsPerCapitaBubbles <- function(skill){
    map$clearShapes()
    cities <- getDataBySkill(skill)
    population <- getTotalPopBySkill(skill)
    if (nrow(cities) == 0)
      return()
    
    map$addCircle(cities$latitude, cities$longitude, (sqrt(cities$total_jobs/population$sum_pop)*10000000/pi), cities$id,
                  list(
                    weight=1.2,
                    fill=TRUE,
                    color='#41A4EC'
                  ))
  }
  
  #due to a bug the following line is needed to draw on map
  session$onFlushed(once=TRUE, function() {
    observe({
      if(input$radio == 1)
        drawJobsBubbles(input$skills)
      else
        drawJobsPerCapitaBubbles(input$skills)
    })
  })
  
  maincityData <- reactive({
    getTotalPopByMainCityAndSkill(input$cities, input$skills)
  })
  
  #render text for total population of sourranding area
  output$totalPop <- renderText({
    if (nrow(maincityData()) == 0)
      return(NULL)
    paste(maincityData()$sum_pop)
  })
  
  #render text for total jobs sourranding area
  output$totalJobs <- renderText({
    if (nrow(maincityData()) == 0)
      return(NULL)
    paste(maincityData()$total_jobs)
  })
  
  #render selected skill
  output$selectedSkill <- renderText({
    paste(input$skills)
  })
  
  #render selected city
  output$selectedCity <- renderText({
    paste(input$cities)
  })
  
  #render selected skill
  output$countCities <- renderText({
    if (nrow(maincityData()) == 0)
      return(NULL)
    paste(maincityData()$num_cities)
  })
  
  #render score
  output$score <- renderText({
    if (nrow(maincityData()) == 0)
      return(NULL)
    paste(round((maincityData()$num_cities/maincityData()$sum_pop)*10^4, digits=3))
  })
  
  
  #render selected city
  output$citiesOfCity <- renderText({
    paste('Statistics of cities in ',
          input$cities,
          sep='')
  })
  
  #render main text
  output$mainTitle <- renderText({
    paste( input$cities,
           ' - ',
           input$skills,
           sep='')
  })
  
  #put the talble out
  output$data <- renderTable({
    
    result <- getDataByCity(input$cities, input$skills)
    
    if (nrow(result) == 0)
      return(NULL)
    
    data.frame(
      City = paste(result$city),
      Population = paste(result$population_2013),
      Jobs = paste(result$num_rel_jobs)
    )
    
  }, include.rownames = FALSE)
})

