
function(input, output) {
  #Intro section: Rail carload mix plot
  output$rails = renderPlot(
    carloads_by_type %>%
      ggplot(aes(x = reorder(Variable, Total / sum(Total)), y = Total / sum(Total))) +
      geom_col() +
      scale_y_continuous(name = '% of Total Carloads', label = percent) +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            plot.title = element_text(size = 20)) +
      xlab("Carload Type") +
      labs(fill = 'Carload Type') +
      coord_flip() +
      ggtitle('Rail Carload Mix')
  )
  
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
      ggtitle('Rail carloads (Red) vs. ISM Manufacturing Index (Blue)')
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
      ggtitle('Rail Carloads (Red) vs. US GDP (Blue)')
    )
  
  #Intro section: ISM vs. GDP
  output$ISMGDP = renderPlot(
    ISMGDP %>%
      ggplot(aes(x = Date)) +
      geom_line(aes(y = ISM, group = 1), color = 'red', size = 1.5) +
      #axis transformation
      geom_line(aes(y = (GDP - min(GDP)) * scale_ig + translation_ig,
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'ISM',
        #axis transformation
        sec.axis = sec_axis(~./scale_ig + min(ISMGDP$GDP) - translation_ig / scale_ig, 
                            name = 'US GDP ($ bn)')
      ) +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('ISM (Red) vs. US GDP (Blue)')
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
                      (max(Price, na.rm = T) - min(Price, na.rm = T))) + min(Carloads),
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation (more complicated since it's reactive but the concept is the same)
        sec.axis = sec_axis(~./((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                  (max(df_reactive()$Price, na.rm = T) - min(df_reactive()$Price, na.rm = T))) + 
                              min(df_reactive()$Price, na.rm = T) - 
                              min(df_reactive()$Carloads) / 
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
      ggtitle('Carloads (Red) vs. Stock Price (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_reactive()$Date),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred')
  )
  
  #Rails section: Rail analysis vs. IYT
  output$RelToIYT = renderPlot(
    df_reactive() %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Carloads, group = 1), color = 'red', size = 1.5) +
      #axis transformation (more complicated since it's reactive but the concept is the same)
      geom_line(aes(y = (Relative.To.IYT - min(Relative.To.IYT, na.rm = T)) * ((max(Carloads) - min(Carloads)) / 
                        (max(Relative.To.IYT, na.rm = T) - min(Relative.To.IYT, na.rm = T))) + 
                        min(Carloads),
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation (more complicated since it's reactive but the concept is the same)
        sec.axis = sec_axis(~./((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                  (max(df_reactive()$Relative.To.IYT, na.rm = T) - min(df_reactive()$Relative.To.IYT, na.rm = T))) + 
                              min(df_reactive()$Relative.To.IYT, na.rm = T) - 
                              min(df_reactive()$Carloads) / 
                              ((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                 (max(df_reactive()$Relative.To.IYT, na.rm = T) - min(df_reactive()$Relative.To.IYT, na.rm = T))), 
                            name = 'Stock Price / IYT')
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Carloads (Red) vs. Stock Price/IYT (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_reactive()$Date),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred')
    )
  
  #Rails section: Rail analysis vs. XLI
  output$RelToXLI = renderPlot(
    df_reactive() %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Carloads, group = 1), color = 'red', size = 1.5) +
      #axis transformation (more complicated since it's reactive but the concept is the same)
      geom_line(aes(y = (Relative.To.XLI - min(Relative.To.XLI, na.rm = T)) * ((max(Carloads) - min(Carloads)) / 
                        (max(Relative.To.XLI, na.rm = T) - min(Relative.To.XLI, na.rm = T))) + 
                        min(Carloads),
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation (more complicated since it's reactive but the concept is the same)
        sec.axis = sec_axis(~./((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                  (max(df_reactive()$Relative.To.XLI, na.rm = T) - min(df_reactive()$Relative.To.XLI, na.rm = T))) + 
                              min(df_reactive()$Relative.To.XLI, na.rm = T) - 
                              min(df_reactive()$Carloads) / 
                              ((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                 (max(df_reactive()$Relative.To.XLI, na.rm = T) - min(df_reactive()$Relative.To.XLI, na.rm = T))), 
                            name = 'Stock Price / XLI')
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Carloads (Red) vs. Stock Price/XLI (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_reactive()$Date),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred')
    )
  
  #Rails section: Rail analysis vs. S&P500
  output$RelToSPY = renderPlot(
    df_reactive() %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Carloads, group = 1), color = 'red', size = 1.5) +
      #axis transformation (more complicated since it's reactive but the concept is the same)
      geom_line(aes(y = (Relative.To.SPY - min(Relative.To.SPY, na.rm = T)) * ((max(Carloads) - min(Carloads)) / 
                        (max(Relative.To.SPY, na.rm = T) - min(Relative.To.SPY, na.rm = T))) + 
                        min(Carloads),
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'Total Carloads',
        labels = scientific,
        #axis transformation (more complicated since it's reactive but the concept is the same)
        sec.axis = sec_axis(~./((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                  (max(df_reactive()$Relative.To.SPY, na.rm = T) - min(df_reactive()$Relative.To.SPY, na.rm = T))) + 
                              min(df_reactive()$Relative.To.SPY, na.rm = T) - 
                              min(df_reactive()$Carloads) / 
                              ((max(df_reactive()$Carloads) - min(df_reactive()$Carloads)) / 
                                 (max(df_reactive()$Relative.To.SPY, na.rm = T) - min(df_reactive()$Relative.To.SPY, na.rm = T))), 
                            name = 'Stock Price / S&P500')
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Carloads (Red) vs. Stock Price/S&P500 (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_reactive()$Date),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_reactive()$Carloads), ymax = max(df_reactive()$Carloads),
               alpha = 0.2, fill = 'darkred')
    )
  
  #USCAD section: US rails vs. Canadian rails Chart 1 (relative carloads vs. relative stock price )
  output$uscad.analysis1 = renderPlot(
    df_USCAD %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Relative.Carloads, group = 1), color = 'red', size = 1.5) +
      #axis transformation 
      geom_line(aes(y = (Relative.Price - min(Relative.Price, na.rm = T)) * scale_uc1 + translation_uc1,
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'US carloads / Canadian carloads',
        #axis transformation 
        sec.axis = sec_axis(~./scale_uc1 + min(df_USCAD$Relative.Price, na.rm = T) - translation_uc1 / scale_uc1, 
                            name = 'US Rail Stock Price / Canadian Rail Stock Price')
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('Relative Carloads (Red) vs. Relative Stock Price (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_USCAD$Relative.Carloads), ymax = max(df_USCAD$Relative.Carloads),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_USCAD$Relative.Carloads), ymax = max(df_USCAD$Relative.Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_USCAD$Date),
               ymin = min(df_USCAD$Relative.Carloads), ymax = max(df_USCAD$Relative.Carloads),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_USCAD$Relative.Carloads), ymax = max(df_USCAD$Relative.Carloads),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_USCAD$Relative.Carloads), ymax = max(df_USCAD$Relative.Carloads),
               alpha = 0.2, fill = 'darkred')
    )
  
  #USCAD section: US rails vs. Canadian rails Chart 1 (relative YoY vs. relative stock price )
  output$uscad.analysis2 = renderPlot(
    df_USCAD %>%
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Relative.YoY, group = 1), color = 'red', size = 1.5) +
      #axis transformation 
      geom_line(aes(y = (Relative.Price - min(Relative.Price, na.rm = T)) * scale_uc2 + translation_uc2,
                    group = 1), color = 'blue', size = 1.5) +
      scale_y_continuous(
        name = 'YoY change in US carloads - YoY change in Canadian carloads',
        labels = percent_format(accuracy = 0.1), 
        #axis transformation 
        sec.axis = sec_axis(~./scale_uc2 + min(df_USCAD$Relative.Price, na.rm = T) - translation_uc2 / scale_uc2, 
                            name = 'US Rail Stock Price / Canadian Rail Stock Price')
      ) +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      ggtitle('YoY US Carloads less YoY Canadian Carloads (Red) vs. Relative Stock Price (Blue)') +
      annotate('rect', xmin = as.Date('2017-03-01'), xmax = as.Date('2019-07-31'),
               ymin = min(df_USCAD$Relative.YoY, na.rm = T), ymax = max(df_USCAD$Relative.YoY, na.rm = T),
               alpha = 0.2, fill = 'darkgreen') + 
      annotate('rect', xmin = as.Date('2020-01-01'), xmax = as.Date('2020-02-29'),
               ymin = min(df_USCAD$Relative.YoY, na.rm = T), ymax = max(df_USCAD$Relative.YoY, na.rm = T),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2020-06-01'), xmax = max(df_USCAD$Date),
               ymin = min(df_USCAD$Relative.YoY, na.rm = T), ymax = max(df_USCAD$Relative.YoY, na.rm = T),
               alpha = 0.2, fill = 'darkgreen') +
      annotate('rect', xmin = as.Date('2019-08-01'), xmax = as.Date('2019-12-31'),
               ymin = min(df_USCAD$Relative.YoY, na.rm = T), ymax = max(df_USCAD$Relative.YoY, na.rm = T),
               alpha = 0.2, fill = 'darkred') +
      annotate('rect', xmin = as.Date('2020-03-01'), xmax = as.Date('2020-05-31'),
               ymin = min(df_USCAD$Relative.YoY, na.rm = T), ymax = max(df_USCAD$Relative.YoY, na.rm = T),
               alpha = 0.2, fill = 'darkred')
    )
  
  #Conclusion section: Rail vs. SPY over time
  colnames(stocks)
  output$railhistory = renderPlot(
    stocks_final %>%
      ggplot(aes(x = Date, y = Relative.To.SPY)) +
      geom_line(aes(color = Name), size = 1.5) +
      scale_y_continuous(
        name = 'Stock price relative to S&P500') +
      scale_x_date(breaks = '3 months') +
      theme_bw() +
      theme(panel.grid.major.y = element_blank(), panel.grid.major.x = element_blank(), 
            panel.grid.minor.y = element_blank(), panel.grid.minor.x = element_blank(), 
            axis.text.x = element_text(angle = -45), plot.title = element_text(size = 20)) +
      labs(color = 'Stock') +
      scale_color_brewer(palette = 'Accent') +
      ggtitle('Rail Stock Prices Relative to S&P 500 Over Time')
    )
  }