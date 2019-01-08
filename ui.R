# Oleksiy Anokhin 
# August 17, 2018

# DC Crimes 

# Ui code

fluidPage(
  theme = shinytheme("united"),
  titlePanel(h1("Crimes in Washington DC in 2017", align = "center")#,
    #br()
  ),
  sidebarLayout(
    sidebarPanel(
      div(
        align='center',
        p(
          "This dashboard visualizes crimes in Washington DC in 2017.", tags$br(), tags$br(),
        
        
          "The Metropolitan Police Department provides citywide crime statistics, which reflect official Index crime tools as 
          reported to the FBI's Uniform Crime Reporting (UCR) program. These numbers may differ from the preliminary monthly statistics 
          presented elsewhere on opendata.dc.gov for a variety of reasons, including late reporting, reclassification of some offenses, 
          and discovery that some offenses were unfounded.", tags$br(), tags$br(),
          
          tags$a(href="wwww.opendata.dc.gov", "Data is publicly available on Open Data DC!"), tags$br(), 
          "Please check it and to explore it yourself.", tags$br(), tags$br(), 
          
          "For ideas and feedback please contact Oleksiy Anokhin", tags$br(), tags$br(), 
          
          tags$a(img(src='Twitter.png', align = "center"), href="https://twitter.com/OleksiyAnokhin"),
          tags$a(img(src='Linkedin.png', align = "left"), href="https://www.linkedin.com/in/oleksiyanokhin/"),
          tags$a(img(src='Github.png', align = "right"), href="https://github.com/OleksiyAnokhin"),
          tags$br(),
          
          "Please use filters and make your own analysis, exploring the DC crime patterns. The data consists of 33074 incidents.", 
          tags$br(), tags$br()
        )
        ),
      conditionalPanel(
        "input.tabs === 'Map'",
        selectInput("offenceInput", "Type of offence",
                       choices = c("Choose type of offense", 
                                   "Arson",
                                   "Assault w/dangerous weapon",
                                   "Burglary",
                                   "Homicide",
                                   "Motor vehicle theft",
                                   "Robbery", 
                                   "Sex abuse",
                                   "Theft f/auto",
                                   "Theft/other"),
                       selected = "Choose type of offense"),
           selectInput("shiftInput", "Shift of offence",
                       choices = c("Choose shift of offense", 
                                   "Day",
                                   "Evening",
                                   "Midnight"),
                       selected = "Choose type of offense"),
           selectInput("methodInput", "Method of offence",
                       choices = c("Choose method of offense", 
                                   "Gun",
                                   "Knife",
                                   "Others"),
                       selected = "Choose method of offense"),
           selectInput("districtInput", "District",
                       choices = c("Choose district", 
                                   "1",
                                   "2",
                                   "3",
                                   "4",
                                   "5",
                                   "6",
                                   "7"),
                       selected = "Choose district"),
           dateRangeInput('dateRange',
                          label = 'Date',
                          start = as.Date('2017-01-01') , end = as.Date('2017-01-01'))
      ),
      conditionalPanel(
        "input.tabs === 'Heatmap'",
        selectInput("offenceInput1", "Type of offence",
                    choices = c("Choose type of offense", 
                                "Arson",
                                "Assault w/dangerous weapon",
                                "Burglary",
                                "Homicide",
                                "Motor vehicle theft",
                                "Robbery", 
                                "Sex abuse",
                                "Theft f/auto",
                                "Theft/other"),
                    selected = "Choose type of offense"),
        selectInput("shiftInput1", "Shift of offence",
                    choices = c("Choose shift of offense", 
                                "Day",
                                "Evening",
                                "Midnight"),
                    selected = "Choose type of offense"),
        selectInput("methodInput1", "Method of offence",
                    choices = c("Choose method of offense", 
                                "Gun",
                                "Knife",
                                "Others"),
                    selected = "Choose method of offense"),
        selectInput("districtInput1", "District",
                    choices = c("Choose district", 
                                "1",
                                "2",
                                "3",
                                "4",
                                "5",
                                "6",
                                "7"),
                    selected = "Choose district"),
        dateRangeInput('dateRange',
                       label = 'Date',
                       start = as.Date('2017-01-01') , end = as.Date('2017-01-01'))
      
      ),
      
      conditionalPanel(
          "input.tabs === 'Chart'",
          selectInput(
            "dataInput",
            "Filter offenses by:",
            choices = c(
              "Offense",
              "Shift",
              "Method"),
            selected = "Filter offenses by:"), # this will not work now, because there is no such thing in the df
          selectInput(
            "dataInput2",
            "Filter offenses by time period:",
            choices = c(
              "Month",
              "Day",
              "Hour"),
            selected = "Filter offenses by time period:") # this will not work now, because there is no such thing in the df
        # selectInput("offenceInput2", "Type of offence",
        #             choices = c("Choose type of offense", 
        #                         "Arson",
        #                         "Assault w/dangerous weapon",
        #                         "Burglary",
        #                         "Homicide",
        #                         "Motor vehicle theft",
        #                         "Robbery", 
        #                         "Sex abuse",
        #                         "Theft f/auto",
        #                         "Theft/other"),
        #             selected = "Choose type of offense"),
        # selectInput("shiftInput2", "Shift of offence",
        #             choices = c("Choose shift of offense", 
        #                         "Day",
        #                         "Evening",
        #                         "Midnight"),
        #             selected = "Choose type of offense"),
        # selectInput("methodInput2", "Method of offence",
        #             choices = c("Choose method of offense", 
        #                         "Gun",
        #                         "Knife",
        #                         "Others"),
        #             selected = "Choose method of offense"),
        # selectInput("districtInput2", "District",
        #             choices = c("Choose district", 
        #                         "1",
        #                         "2",
        #                         "3",
        #                         "4",
        #                         "5",
        #                         "6",
        #                         "7"),
        #             selected = "Choose district"),
        # dateRangeInput('dateRange2',
        #                label = 'Date',
        #                start = as.Date('2017-01-01') , end = as.Date('2017-01-01'))
        # 
      ),
      conditionalPanel(
        "input.tabs === 'Detailed Information'"#,
        #h1("Table Inputs Go here")
      )
        ),
    mainPanel(
      # Output
      tabsetPanel(
        type = "tabs",
        id = "tabs",
        tabPanel("Map", leafletOutput(outputId = 'map', height = 950)
        ),
        
        tabPanel("Heatmap", leafletOutput(outputId = 'heatmap', height = 1000)
        ),
        
        tabPanel("Chart", plotOutput("plot", height = 850)
          #plotOutput("plot", height = 850)
        ),
        tabPanel(
          "Detailed Information",
          DT::dataTableOutput("table", width = 900)
        )
      )
    )
    )
)


