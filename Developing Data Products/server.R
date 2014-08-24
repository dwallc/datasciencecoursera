library("shiny")

x <- seq(-100, 100, by = 0.01)
norm_dens <- dnorm(x)

shinyServer(function(input, output) {
  
  output$plot <- renderPlot({
    chi2_dens <- dchisq(x, df = input$df)
    t_dens <- dt(x, dr = input$df)
    print(ggplot()
          + geom_line(data = data.frame(x = x, y = norm_dens),
                      mapping = aes(x = x, y = y), colour = "blue")
          + geom_line(data = data.frame(x = x, y = chi2_dens),
                      mapping = aes(x = x, y = y), colour = "red")
          + geom_line(data = data.frame(x = x, y = t_dens),
                      mapping = aes(x = x, y = y), colour = "green")
          + ggtitle(sprintf("Chi-Square and Student-t Distributions (df = %d)", input$df)))
  })
})