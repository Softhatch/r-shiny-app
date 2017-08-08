library(leaflet)

cities <- c( 
  "Los Angeles, CA", 
  "San Jose, CA", 
  "San Francisco, CA",
  "New York City, NY" ,
  "Seattle, WA" ,
  "Chicago, IL",
  "San Diego, CA" ,
  "Houston, TX",
  "Dallas, TX",
  "Phoenix, AZ",
  "Philadelphia, PA",
  "Columbus, OH",
  "Boston, MA",
  "Austin, TX"
)

skills <- c(
  "Java",
  "Ruby",
  "C++",
  "PHP",
  "Python",
  "iOS",
  "Android",
  ".NET", 
  "NoSQL",
  "MySQL",
  "Javascript")

shinyUI(
  navbarPage( "Tech Cities", theme = "bootstrap.css", 
              tabPanel("Map",
                       #add styles.css file to head
                       tags$head(tags$link(rel='stylesheet', type='text/css', href='styles.css')),
                       
                       #add leafletmap
                       leafletMap("map", width = "100%", height = 400,
                                  initialTileLayer = "//{s}.tiles.mapbox.com/v4/mapbox.streets/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoic29mdGhhdGNoIiwiYSI6ImNqNjM3dGVzNjFkc3QzMm4wOG9obTkxdmcifQ.CKVTb3xRlg07SogfbSnhgA",
                                  initialTileLayerAttribution = HTML('Maps by <a href="http://www.mapbox.com/">Mapbox</a>'),
                                  options=list(
                                    center = c(37.45, -93.85),
                                    zoom = 4,
                                    maxBounds = list(list(17, -180), list(59, 180))
                                  )
                       ),
                       
                       #add main title
                       fluidRow(
                         column(6,
                                h2(id="mainTitle", class='shiny-text-output')
                         )
                       ),
                       
                       hr(),
                       
                       #add the data display
                       fluidRow(
                         column(3,
                                radioButtons('radio','The map takes into account', 
                                             choices = list("Skills only" = 1, "Skills per capita" = 2),
                                             selected = 1),
                                selectInput('cities', 'Choose a city: ', cities, selected="los_angeles"),
                                selectInput('skills', 'Choose a skill: ', skills, selected="java")
                         ),
                         column(5,
                                tags$div(class="panel panel-info",
                                         tags$div(class="panel-heading", 
                                                  tags$h2(class="panel-title","Per Capita Score")
                                                  ),
                                         tags$div(class="panel-body", 
                                                  tags$h2(id="score",class='shiny-text-output')
                                         )         
                                ),
                                tags$div(class="panel panel-info",
                                         tags$div(class="panel-heading", 
                                                  tags$h2(class="panel-title","Facts")
                                         ),
                                         tags$div(class="panel-body", 
                                                  tags$h4("Total Population:",
                                                          span(id="totalPop", class='shiny-text-output')
                                                          ),
                                                  tags$h4("No. jobs that mention ",
                                                          span(id="selectedSkill", class='shiny-text-output'),
                                                          ":",
                                                          span(id="totalJobs", class='shiny-text-output')
                                                          ),
                                                  tags$h4("No. of cities in ",
                                                          span(id="selectedCity", class='shiny-text-output'),
                                                          ":",
                                                          span(id="countCities", class='shiny-text-output')
                                                          )
                                         )         
                                )
                         ),
                         column(4,
                                h2(id="citiesOfCity", class='shiny-text-output'),
                                tableOutput('data')
                         )
                       )
              ),
              tabPanel("Info",
                       fluidRow(id="info",
                         column(10,offset=1,
                           tags$div(class="panel panel-info", 
                                    tags$div(class="panel-heading", 
                                             tags$h2(class="panel-title","Thank you for visiting!")
                                    ),
                                    tags$div(class="panel-body", 
                                             tags$h3("The information used in this website is acquired from Census.gov and several resources.")
                                    )        
                           )
                         )
                         )
                       )
  )
)










