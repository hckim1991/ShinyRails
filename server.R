
function(input, output) {
  #Intro section: Rail carloads. vs. ISM plot
  output$CarloadISM = renderPlot(
    carloads_ISM[-1, ] %>% #Skip 1st row since March 2017 has incomplete data. 
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Total, group = 1), color = 'red', size = 1.5) +
      #axis transformation
      geom_line(aes(y = (Last - min(Last)) * scale_ci + translation_ci, group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation
        sec.axis = sec_axis(~./scale_ci + min(carloads_ISM[-1, ]$Last) - translation_ci / scale_ci, 
                            name = 'ISM Manufacturing Index', labels = number_format(accuracy = 0.1))
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Railcarloads (Red) vs. ISM Manufacturing Index (Blue)')
  )
  
  #Intro section: Rail carloads. vs. GDP plot
  output$CarloadGDP = renderPlot(
    carloads_GDP[-1, ] %>% #Skip 1st row since 1Q17 has incomplete data. 
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Total, group = 1), color = 'red', size = 1.5) +
      #axis transformation
      geom_line(aes(y = (GDP - min(GDP)) * scale_cg + translation_cg, group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation
        sec.axis = sec_axis(~./scale_cg + min(carloads_GDP[-1, ]$GDP) - translation_cg / scale_cg, 
                            name = 'US GDP ($ bn)')
      ) +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Railcarloads (Red) vs. US GDP (Blue)')
    )
  
  #Create a reactive df for the Rails section
  df_reactive = reactive(
    df_main %>%
      filter(Name == input$rail_selected)
  )
  
  #Rails section: Single rail analysis
  output$RelToSelf = renderPlot(
    df_reactive() %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Carloads, group = 1), color = 'red', size = 1.5) +
      #axis transformation (more complicated since it's reactive but the concept is the same)
      geom_line(aes(y = (Price - min(Price, na.rm = T)) * ((max(Carloads) - min(Carloads)) / 
                      (max(Price, na.rm = T) - min(Price, na.rm = T))) + (min(Carloads) - min(Price, na.rm = T)),
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation (more complicated since it's reactive but the concept is the same)
        sec.axis = sec_axis(~./((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                  (max(df_reactive()$Price, na.rm = T) - min(df_reactive()$Price, na.rm = T))) + 
                              min(df_reactive()$Price, na.rm = T) - 
                              (min(df_reactive()$Carloads) - min(df_reactive()$Price, na.rm = T)) / 
                              ((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                 (max(df_reactive()$Price, na.rm = T) - min(df_reactive()$Price, na.rm = T))), 
                            name = 'Stock Price', 
                            labels = dollar_format(accuracy = 0.01))
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Carloads (Red) vs. Stock Price (Blue)')
    )
  
  #Rails section: Rail analysis vs. IYT
  
  }