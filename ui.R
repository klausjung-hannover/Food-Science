
library(shiny)
library (shinydashboard)



ui = 
  
  dashboardPage(
    dashboardHeader(title= h3("Heat conservation food cans"), titleWidth = 500,
                    tags$li(class="dropdown",
                            tags$style(".main-header {max-height: 55x}"),
                            tags$style(".main-header .logo {height: 60px;}"),
                            tags$style(".sidebar-toggle {height: 5px; padding-top: 5px !important;}"),
                            tags$style(".navbar {min-height:10px !important}") 
                            
                            
                      )
                    ),
    dashboardSidebar(
      sidebarMenu(id="tabs",
        br(),
        menuItem("Costumer complain", tabName = "complain", icon = icon("angry")),
        br(),
        menuItem("Heating protocol", tabName = "protocol", icon = icon("thermometer-quarter"))
  
      )
    ),
    dashboardBody(
      tabItems(
        
        tabItem(tabName="complain",
                h3 ("Core-temperature of food can"),
                br(), br(), br(),
                tags$img(src="beschwerde.png"),
                #actionButton ("Prev", "Prev"),
                actionButton("Next", "Next")
              ),
        
        tabItem(tabName="protocol",
               
                h3("Please choose a heating treatment for a fully preserved food can"),
                br(),
                textOutput ("instruction"),
                br(),
                br(),
   
            fluidRow (
              column (6,
                      plotOutput("Temperatureprotocol")),
              column (5, box (sliderInput ("temp.max", "Maximum core temperature in food", value= 100, min=65, max=140, step=0.5)
                    
                  
                ,
                #sliderInput ("temp.max", "Maximaltemperatur im Kern der Konserve", value= 100, min=65, max=140, step=0.5),
                sliderInput ("dauer100", "Min above 100C:", value= 0, min=1, max=20))
                              ),
              
              column (5, box( textOutput("ftext"), textOutput ("fwert"))
                      #infoBoxOutput ("fbox")
                      )
              ),
            
            fluidRow (
              
              br(),
              br(),
              column (6,box(radioButtons("ask", label =h4("Which kind of food can is achieved according to the f-value?"),  selected= 0, inline=F, choices =c("unselect"="","short durability food can (6 month)"= "Kesselkonserve", "middle-term durability food can (6-12 month)"="3/4 Konserve", "fully preserved food can (4 years at 25C)"="Vollkonserve", "tropical food can (4 years at 40C)"="Tropenkonserve")), width=8)
                      ),
              column (8, box( textOutput ("correct"), textOutput ("textf"), textOutput("itext")))
              
              )
                
              
       ,
     
      br(), br(),
      
     
      
      tags$head(tags$style("#instruction{color: black;font-size: 20px;font-style: plain;}")),
      tags$head(tags$style("#ftext{color: black;font-size: 22px;font-style: plain;}")),
      tags$head(tags$style("#fwert{color: red;font-size: 25px;font-style: plain;}")),
      tags$head(tags$style("#correct{color: green;font-size: 18px;font-style: plain;}")),
      tags$head(tags$style("#ftext{color: black;font-size: 18px;font-style: plain;}")),
      tags$head(tags$style("#itext{color: darkorange;font-size: 18px;font-style: plain;}")),
      tags$head(tags$style("#textf{color: red;font-size: 18px;font-style: plain; }")),
      tags$head(
        tags$style(
          HTML(".shiny-notification {
           position:fixed;
           top: calc(25%);
           left: calc(75%);
           }
           "
          )
        ))
      
      
     ))))
  

