# Oleksiy Anokhin 
# August 17, 2018

# DC Crimes 

# Server code
server <- function(input, output, session) {  
  

  
  filtered_crimes <- reactive({
    
    if(input$methodInput %in% methods)
      this_method <- input$methodInput
    else this_method <- methods
    if(input$shiftInput %in% shifts)
      this_shift <- input$shiftInput
    else this_shift <- shifts
    if(input$offenceInput %in% offenses)
      this_offense <- input$offenceInput
    else this_offense <- offenses
    
    
    
    # for all 5
    
    crimes <- filter(crimes, 
                     tolower(Method) %in% tolower(this_method),
                     tolower(Shift) %in% tolower(this_shift),
                     tolower(Offense) %in% tolower(this_offense)) #,
                     # District == input$districtInput)#,
                     # `Report date` >= input$dateRange[1] & `Report date` <= input$dateRange[2])
    
    
  })
  
  output$map <- renderLeaflet({
    leaflet(crimes) %>% 
      addTiles(group = "Toner Lite") %>%
      # addProviderTiles(providers$Stamen.TonerLite) %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = "OpenStreetMap.BlackAndWhite") %>%
      addProviderTiles(providers$Esri, group = "Esri") %>%
      setView(-77.0369, 38.9072, zoom = 12) %>%
      addLayersControl(baseGroups = c("Toner Lite", "OpenStreetMap.BlackAndWhite", "Esri"),
      options = layersControlOptions(collapsed = FALSE)
      )
  })  
  
  
  observe({
    
    my_popup <- paste0("<br><strong>Report date: </strong>", 
                       filtered_crimes()$`Report date`,
                       "<br><strong>Offense: </strong>", 
                       filtered_crimes()$Offense,
                       "<br><strong>Shift: </strong>", 
                       filtered_crimes()$Shift,
                       "<br><strong>Method: </strong>", 
                       filtered_crimes()$Method,
                       "<br><strong>Block: </strong>", 
                       filtered_crimes()$Block,
                       "<br><strong>District: </strong>", 
                       filtered_crimes()$District,
                       "<br><strong>Census tract: </strong>", 
                       filtered_crimes()$`Census tract`,
                       "<br><strong>Voting precinct: </strong>", 
                       filtered_crimes()$`Voting precinct`)

    leafletProxy("map", data = filtered_crimes()) %>%
      clearMarkers() %>%
      clearMarkerClusters() %>%
      addMarkers(~Lon, ~Lat, popup = ~my_popup, clusterOptions = markerClusterOptions())
  })
  
  output$heatmap <- renderLeaflet({
    leaflet(crimes) %>% 
      addTiles(group = "Toner Lite") %>%
      # addProviderTiles(providers$Stamen.TonerLite) %>%
      addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
      addProviderTiles(providers$OpenStreetMap.BlackAndWhite, group = "OpenStreetMap.BlackAndWhite") %>%
      addProviderTiles(providers$Esri, group = "Esri") %>%
      setView(-77.0369, 38.9072, zoom = 12) %>%
      addLayersControl(baseGroups = c("Toner Lite", "OpenStreetMap.BlackAndWhite", "Esri"),
                       options = layersControlOptions(collapsed = FALSE)
      )
    
  })  
  
# Heatmap code
  selectedCrimes1 <- reactive({
    filter(crimes,
           Offense == input$offenceInput1,
           Shift == input$shiftInput1,
           Method == input$methodInput1)#,
           #District == input$districtInput1)
  })
  
  observe({  
    leafletProxy("heatmap", data = selectedCrimes1()) %>%
      clearHeatmap() %>%
      addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense, 
                 blur = 20, max = 0.05, radius = 15)
  })

  # Barchart code!!!!!!!!
  
  selectedCrimes2 <- reactive({
      filter(crimes3, variable == input$dataInput) # IS IT REALLY DATA INPUT
  })
  
  output$plot <- renderPlot({
    ggplot(selectedCrimes2(), aes(x = value, fill = value)) + 
      geom_bar(stat = "count", color = "black", alpha = 0.8) +
      scale_color_fivethirtyeight() +
      theme_fivethirtyeight() +
      labs(x = "Offense", 
           y = "Number of offences") +
      theme(# axis.line.x = element_line(size = .5, colour = "black"),
            axis.title = element_text(size = 18),
            legend.position = "right",
            legend.direction = "vertical",
            legend.box = "vertical",
            legend.text = element_text(size = 16),
            legend.title=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank()) 

               # geom_bar(stat = "count") + 
               # theme(axis.title = element_blank()) +
               # theme_classic() +
               # theme(legend.title=element_blank(), 
               #       axis.title=element_blank(),
               #       axis.ticks=element_blank()) + 
               # scale_fill_brewer(palette="Paired")) %>% config(displayModeBar = F)
  }) 
  
  selectedCrimes3 <- reactive({
    filter(crimes5, variable == input$dataInput2) # IS IT REALLY DATA INPUT
  })
  
  output$plot <- renderPlot({
    ggplot(selectedCrimes3(), aes(x = value, fill = value)) + 
      #geom_histogram(binwidth = 1, color = "black", alpha = 0.8)
      geom_bar(stat = "count", color = "black", alpha = 0.8)
  }) 
  
  # output$heatmap <- renderLeaflet({
  #   leaflet(crimes) %>%
  #     addProviderTiles(providers$Stamen.TonerLite) %>%
  #     setView(-77.0369, 38.9072, zoom = 12)
  # 
  # })
  # 
  # observe({
  #   leafletProxy("heatmap", data = filtered_crimes()) %>%
  #     clearHeatmap() %>%
  #     addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense,
  #                blur = 20, max = 0.05, radius = 15)
  # })
  # 
  
  
  # # 1. Select offense
  # selectedOffense <- reactive({
  #   filter(crimes, Offense == input$offenceInput) 
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedOffense()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  # 
  # # 2. Select shift of offense
  # selectedShift <- reactive({
  #   filter(crimes, Shift == input$shiftInput) 
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedShift()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  # 
  # # 3. Select method of offense
  # selectedMethod <- reactive({
  #   filter(crimes, Method == input$methodInput) 
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedMethod()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  # 
  # # 4. Select district
  # selectedDistrict <- reactive({
  #   filter(crimes, District == input$districtInput) 
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedDistrict()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  
  # 5. Selected date
  # selectedDate <- reactive({
  #   filter(crimes, `Report date` >= input$dateRange[1] & `Report date` <= input$dateRange[2])
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedDate()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  
  # Selected census tract
  # selectedCensus <- reactive({
  #   if (is.na(input$censusInput)) pInputvalue <- 0 else pInputvalue <- input$censusInput
  #   crimes[!is.na(crimes$`Census tract`) & crimes$`Census tract` == pInputvalue, ]
  # })
  # 
  # observe({  
  #   leafletProxy("map", data = selectedCensus()) %>%
  #     clearMarkers() %>%
  #     addMarkers(~Lon, ~Lat)
  # })
  
  # output$heatmap <- renderLeaflet({
  #   leaflet(crimes) %>% 
  #     addProviderTiles(providers$Stamen.TonerLite) %>%
  #     setView(-77.0369, 38.9072, zoom = 12)
  #   
  # }) 
  # 
  # THIS IS HEATMAP SERVER CODE
  #--------------------------------------------------------------------------------
  
  
  # output$heatmap <- renderLeaflet({
  #   leaflet(crimes) %>% 
  #     addProviderTiles(providers$Stamen.TonerLite) %>%
  #     setView(-77.0369, 38.9072, zoom = 12)
  #   
  # })  
  # 
  # observe({
  #   leafletProxy("heatmap", data = filtered_crimes()) %>%
  #     clearHeatmap() %>%
  #          addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense,
  #                     blur = 20, max = 0.05, radius = 15)
  # })
  # 
  # 
  # # 2. Select shift of offense
  # selectedShift1 <- reactive({
  #   filter(crimes, Shift == input$shiftInput1) 
  # })
  # 
  # observe({  
  #   leafletProxy("heatmap", data = selectedShift1()) %>%
  #     clearHeatmap() %>%
  #     addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense,
  #                blur = 20, max = 0.05, radius = 15)
  # })
  # 
  # # 3. Select method of offense
  # selectedMethod1 <- reactive({
  #   filter(crimes, Method == input$methodInput1) 
  # })
  # 
  # observe({  
  #   leafletProxy("heatmap", data = selectedMethod1()) %>%
  #     clearHeatmap() %>%
  #     addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense,
  #                blur = 20, max = 0.05, radius = 15)
  # })
  # 
  # # 4. Select district
  # selectedDistrict1 <- reactive({
  #   filter(crimes, District == input$districtInput1) 
  # })
  # 
  # observe({  
  #   leafletProxy("heatmap", data = selectedDistrict1()) %>%
  #     clearHeatmap() %>%
  #     addHeatmap(lng = ~Lon, lat = ~Lat, intensity = ~Offense,
  #                blur = 20, max = 0.05, radius = 15)
  # })
  
  # THIS IS TABLE SERVER CODE
  #-------------------------------------------------------------------------------
  
  output$table <- DT::renderDataTable({
    data <- crimes2
  })
  
  
}