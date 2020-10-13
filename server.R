
function(input, output) {
  output$CarloadISM = renderPlot(
    carloads_ISM[-1, ] %>% #Skip 1st row since March 2017 has incomplete data. 
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Total, group = 1), color = 'red') +
      geom_line(aes(y = (Last - min(Last)) * scale_ci + translation_ci, group = 1), color = 'blue') +
      scale_y_continuous(
        sec.axis = sec_axis(~./scale_ci + min(carloads_ISM[-1, ]$Last) - translation_ci / scale_ci)
      ) +
      theme_bw()
  )
  
  output$CarloadGDP = renderPlot(
    carloads_GDP[-1, ] %>% #Skip 1st row since 1Q17 has incomplete data. 
      ggplot(aes(x = Date)) + 
      geom_line(aes(y = Total, group = 1), color = 'red') +
      geom_line(aes(y = (GDP - min(GDP)) * scale_cg + translation_cg, group = 1), color = 'blue') +
      scale_y_continuous(
        sec.axis = sec_axis(~./scale_cg + min(carloads_GDP[-1, ]$GDP) - translation_cg / scale_cg)
      ) +
      theme_bw()
    )
}