library(shiny)

server <- function(input, output) {
  
  react <- reactiveValues()
  react$churn_modeling <- churn_modeling
  
  observe({
    # filtered inputs for customer demographics
    react$churn_modeling <- churn_modeling %>%
      filter(Geography %in% input$Geography_ID) %>%
      filter(if(input$Gender_ID == 'All'){Gender %in% Gender_factor} 
             else {Gender == input$Gender_ID}) %>%
      filter(if(input$Age_ID == 'All'){Age %in% Age_factor}
             else {Age == input$Age_ID}) %>%
      filter(if(input$CreditScore_ID == 'All'){CreditScore %in% CreditScore_factor}
             else {CreditScore == input$CreditScore_ID}) %>%
      filter(EstimatedSalary %in%
               input$EstimatedSalary_ID[1]:input$EstimatedSalary_ID[2]) %>%
      filter(Balance %in% input$Balance_ID[1]:input$Balance_ID[2])
    
    # churn and stayed customer count relative to filtered demographics
    react$churn <- filter(react$churn_modeling, Exited == 'yes')
    react$stayed <- filter(react$churn_modeling, Exited == 'no')
    
    # total customers, total customers churned, total customers stayed
    react$dim <- dim(react$churn_modeling)
    react$dimChurn <- dim(react$churn)
    react$dimStayed <- dim(react$stayed)
      
    # percent churned and percent stayed from filtered demographics
    react$churn_modeling_perc <- react$churn_modeling %>% 
      group_by(Exited) %>%
      reframe(count_percent = c(sum(Exited == 'yes')/nrow(react$churn_modeling)*100,
                                sum(Exited == 'no')/nrow(react$churn_modeling)*100))
    
    # percent churned filtered by selected category and grouped by factors
    react$cat_percent <- react$churn_modeling %>%
      group_by(.dots = input$SelectCategory_ID_1) %>%
      summarise(count_percent_sum = sum(Exited == 'yes'),
                count_percent = sum(Exited == 'yes')/(n())*100) %>%
      mutate(across(count_percent, round, 2)) %>%
      arrange(desc(count_percent))
  })

  # numeric and percentage outputs for filtered values
  output$total <- renderText({
    paste(format(react$dim[1], big.mark = ","))
  })
  output$total_perc <- renderText({
    paste(format(round(react$dim[1]/dim(churn_modeling)[1]*100, 1)), "%")
  })
  output$stayed <- renderText({
    paste(format(react$dimStayed[1], big.mark = ","))
  })
  output$stayed_perc <- renderText({
    paste(format(round(react$dimStayed[1]/dim(churn_modeling)[1]*100, 1)), "%")
  })
  output$churn <- renderText({
    paste(format(react$dimChurn[1], big.mark = ","))
  })
  output$churn_perc <- renderText({
    paste(format(round(react$dimChurn[1]/dim(churn_modeling)[1]*100, 1)), "%")
  })
  
  # pie chart showing percent filtered
  output$pie_chart <- renderPlot({
    data <- c(nrow(react$churn_modeling),
              (nrow(churn_modeling) - nrow(react$churn_modeling)))
    categories <- c("selected", "not select")
    pct <- c(round(data[1]/sum(data)*100),
             round(data[2]/sum(data)*100))
    lbls <- paste(pct,"%")
    lbls <- paste(lbls, categories)
    colors = c("#619CFF", "grey")
    pie_chart <- pie(data,labels = lbls, col=colors)
    pie_chart
  })

  # baseline percent churned within filtered demographics
  output$plot1 <- renderPlot({
    # reference for static "global" baseline 
    churn_modeling_baseline <- filter(churn_modeling, Exited == 'yes') %>%
      reframe(count_percent_baseline = c(n()/dim(churn_modeling)*100))
  
    plot1 <- ggplot(react$churn_modeling_perc,
                    aes(x = Exited, y = count_percent, fill=Exited)) + geom_col() +
      labs(y= "Percent (%)", x = "Churned") +
      scale_fill_manual(values=c('#00a65a', '#f39c12')) + 
      scale_y_continuous(breaks=c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100),
                         limits=c(0, 100)) +
      geom_hline(yintercept=as.numeric(react$churn_modeling_perc[3,2]),
                 linetype="dashed", color = "red", size=1) +
      annotate("text", x=2, y=as.numeric(react$churn_modeling_perc[3,2])*1.1,
               label=paste("baseline = ", round(react$churn_modeling_perc[3,2], 1)),
               size=6, color="black") + theme(text = element_text(size = 15))
    plot1
  })
  
  # map visual for geography filter
  output$map <- renderPlot({
    map <- ggplot(mapdata, aes(x=long, y=lat, group=group)) +
      geom_polygon(aes(fill=eval(as.name(paste(input$Geography_ID[1],
                                               input$Geography_ID[2],
                                               input$Geography_ID[3],
                                               sep="_")))), color="black") +
      scale_fill_gradient(name = "Country Selected",
                          low = "grey", high = "#619CFF") +
      theme_bw() +
      theme(legend.position = "none",
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.ticks = element_blank(),
            axis.title.y = element_blank(),
            axis.title.x = element_blank(), 
            panel.border = element_blank(), 
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank()
            )
    map})

  # vertical bar chart for percent churned by factors within selected categories
  output$plot2 <- renderPlot({
    plot2 <-  ggplot(react$cat_percent,
                     mapping = aes(x=count_percent,
                                   y=reorder(.data[[input$SelectCategory_ID_1]],
                                             count_percent)
                                   )
                     ) + 
      geom_bar(stat="identity",
               aes(fill = .data[[input$SelectCategory_ID_1]]
                   )
               ) +
      geom_text(size = 4,
                aes(label = paste(count_percent, "%")), 
                hjust = -.5, nudge_x = 0) +
      theme(axis.title.y = element_blank()) +
      labs(y= input$SelectCategory_ID_1,
           x = "Percent Churned (%)") +
      scale_x_continuous(expand=c(0,0),
                         limits = c(0, 1.3*max(react$cat_percent['count_percent'])
                                    )
                         ) +
      geom_vline(xintercept=as.numeric(react$churn_modeling_perc[3,2]),
                 linetype="dashed", color = "red", size=1) +
      annotate("text", x=as.numeric(react$churn_modeling_perc[3,2])*1.2,
               y=1, label=paste("baseline = ",
                                round(react$churn_modeling_perc[3,2], 1), "%"),
               size=6, color="black") +
      theme(text = element_text(size = 15))
    plot2}
    )
  
  # vertical bar chart for number churned by factors within selected categories
  output$plot3 <- renderPlot({
    plot3 <-  ggplot(react$cat_percent,
                     mapping = aes(x=count_percent_sum,
                                   y=reorder(.data[[input$SelectCategory_ID_1]],
                                             count_percent_sum))) + 
      geom_bar(stat="identity", aes(fill = .data[[input$SelectCategory_ID_1]])) +
      geom_text(size = 4,
                aes(label = paste(count_percent_sum)),
                hjust = -.5, nudge_x = 0) +
      theme(axis.title.y = element_blank()) +
      labs(y= input$SelectCategory_ID_1, x = "Customers Churn Count") +
      scale_x_continuous(expand=c(0,0),
                         limits = c(0, 1.3*max(react$cat_percent['count_percent_sum'])
                                    )
                         ) +
      theme(text = element_text(size = 15))
    plot3
  })
  
  #table for bar chart output
  output$table = DT::renderDataTable({
    react$cat_percent[drop = TRUE]
  })
}