#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
   df2 <- read_csv("green_room.csv")
    
    p <- reactive({
        df2 %>% 
            group_by(cert) %>% 
            tally()
    })
    
    ne <- reactive({
            df2 %>% 
            group_by(neighborhood) %>% 
            tally() %>% 
            arrange(desc(n))
    })
    
    j <- reactive({
        df2 %>% 
            group_by(house) %>% 
            tally() %>% 
            arrange(desc(n))
    })
    ##gets house for plot
    funct <- reactive({
        
            df2 %>% 
                filter(house == input$hus)
    })
    
    buls <- reactive({
        
        df2 %>% 
            filter(house == input$hus, building == input$bs)
    })
    
    ##home page, mostly word content and things 

    
    ##campus page, introduces the campus content and things 
    output$camp_bar <- renderPlot({
        df2 %>% 
            group_by(cert) %>% 
            tally() %>% 
            ggplot( aes(x = reorder(cert,n), n, fill=fct_relevel(cert,"Gold","Silver","Green"))) +
            geom_bar(stat = "identity") +
            theme_bw() +
            theme(legend.position = "none", axis.ticks.x = element_blank()) + 
            labs(x = "Certificate Type", y = "Number of Certificates", fill = "") + 
            scale_fill_manual(, values = c("Gold" = "#ffd700", "Green" = "#78a22f", "Silver" = "#c0c0c0")) +
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black"))
    })
    
    output$pie <- renderPlot({
    ###nice looking pie chart
    blank_theme <- theme_minimal()+
        theme(
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            panel.border = element_blank(),
        )
    
    df2 %>% 
        group_by(cert) %>% 
        tally() %>%   
        ggplot(aes(x="", y=n, fill=cert))+
        geom_bar(width = 1, stat = "identity") + 
        coord_polar("y", start=0) + 
        blank_theme +
        theme(axis.text.x=element_blank(), legend.position = "none",
              element_line(color = NULL)) + 
        labs(title = "")+
        scale_fill_manual(values = c("Gold" = "#ffd700", "Silver" = "#c0c0c0","Green" = "#78a22f")) +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
     })
    
    output$map <- renderLeaflet({
        leaflet() %>% 
            addProviderTiles("CartoDB.VoyagerNoLabels") %>% 
            setView(lng = -71.121710, lat = 42.375084, zoom = 14) %>% 
            addCircleMarkers(lng = loc[1:12,]$long, lat = loc[1:12,]$lat, label = loc[1:12,]$House, radius = 5) %>%
            addMarkers(lng = loc[13:16,]$long, lat = loc[13:16,]$lat, label = loc[13:16,]$House)
    })
    
    output$cam <- renderTable({
            df2 %>% 
                group_by(cert) %>% 
                tally() %>% 
                arrange(desc(n)) %>%
                as_tibble() %>% 
                rename(Type = cert, Total = n)
        })
    
    ##house neighborhood page, introduces the content and things 
    output$h_ne_html <- renderUI({
        "Hear me roar"
        
    })
    
    output$h <- renderPlot({
        df2 %>% 
            group_by(house,cert) %>% 
            tally() %>% 
            ggplot(aes(reorder(house,n),n,fill=fct_relevel(cert,c("Gold","Silver","Green")))) +
            geom_bar(stat="identity") +
            theme_bw() +
            theme(axis.text.x = element_text(angle = 90)) + 
            labs(x = " ",y = "Number of Certificates", fill = "") + 
            scale_fill_manual(values = c("Gold" = "#ffd700", "Silver" = "#c0c0c0","Green" = "#78a22f")) +
            geom_text(aes(label = n), position = position_stack(vjust = 0.5)) +
            coord_flip() +
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black"))
    })
    
    output$ne <- renderPlot({
        df2 %>% 
            group_by(neighborhood,cert) %>% 
            tally() %>% 
            ggplot(aes(reorder(neighborhood,n),n,fill=fct_relevel(cert,c("Gold","Silver","Green")))) +
            geom_bar(stat="identity") +
            theme_bw() +
            theme(axis.text.x = element_text(angle = 90)) + 
            labs(x = " ",y = "Number of Certificates", fill = "") + 
            scale_fill_manual(values = c("Gold" = "#ffd700", "Silver" = "#c0c0c0","Green" = "#78a22f")) +
            geom_text(aes(label = n), position = position_stack(vjust = 0.5)) +
            coord_flip() +
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black"))
    })
    
    output$housss <- renderTable({
            df2 %>% 
                group_by(house) %>% 
                tally() %>% 
                arrange(desc(n)) %>% 
                as_tibble() %>% 
                rename(House = house, Total = n)
            
        })
    
    output$neisss <- renderTable({
            df2 %>% 
                group_by(neighborhood) %>% 
                tally() %>% 
                arrange(desc(n)) %>%
                as_tibble() %>% 
                rename(Neighborhood = neighborhood, Total = n)
            
        })
    
    output$build <- renderPlot({
        funct() %>% 
            group_by(cert, building) %>% 
            count(cert) %>% 
            ggplot(aes(x = cert, n, fill=fct_relevel(cert,"Gold","Silver","Green"))) +
            geom_bar(stat = "identity") + 
            facet_wrap(~ building) +
            theme_bw() +
            theme(legend.position = "none", axis.ticks.x = element_blank(), axis.text.x = element_blank() ) + 
            labs(x = "Certificate Type", y = "Number of Certificates", fill = "") + 
            scale_fill_manual( values = c("Gold" = "#ffd700", "Green" = "#78a22f", "Silver" = "#c0c0c0"))+
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black"))
    })
    
    output$floor <- renderPlot({
        buls() %>% 
            group_by(cert, floor) %>% 
            count(cert) %>% 
            ggplot(aes(x = cert, n, fill=fct_relevel(cert,"Gold","Silver","Green"))) +
            geom_bar(stat = "identity") + 
            facet_wrap(~ floor) +
            theme_bw() +
            theme(legend.position = "none", axis.ticks.x = element_blank(), axis.text.x = element_blank() ) + 
            labs(x = "Certificate Type", y = "Number of Certificates", fill = "") + 
            scale_fill_manual( values = c("Gold" = "#ffd700", "Green" = "#78a22f", "Silver" = "#c0c0c0")) +
            theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_line(colour = "black"))
    })
    
    output$intra <- renderTable({
        funct() %>% 
            group_by(cert) %>% 
            tally() %>% 
            arrange(desc(n)) %>%
            as_tibble() %>% 
            rename(Type = cert, HouseTotal = n)
    })
    
    output$int <- renderTable({
        buls() %>% 
            group_by(cert) %>% 
            tally() %>% 
            arrange(desc(n)) %>%
            as_tibble()%>% 
            rename(Type = cert, BuildingTotal = n)
    })
    
    output$table <- DT::renderDataTable(
        DT::datatable({
            df2
        })
    )
    
    output$act <- DT::renderDataTable(
      DT::datatable({
        read_csv("survey_data.csv")
      })
    )
})
