fluidPage(theme = shinytheme("sandstone"),
          titlePanel("Customer Churn Analysis"),
          sidebarLayout(
              sidebarPanel(width=2,
                           
                           checkboxGroupInput("Geography_ID", 
                                              label = "Select Region:",
                                              choices = Geography_factor, 
                                              selected = Geography_factor),
                           selectInput("Gender_ID", 
                                       label = "Gender:",
                                       choices = Gender_factor, 
                                       selected = "All"),
                           selectInput("Age_ID", 
                                       label = "Age:",
                                       choices = Age_factor, 
                                       selected = "All"),
                           selectInput("CreditScore_ID", 
                                       label = "Credit Score:",
                                       choices = CreditScore_factor, 
                                       selected = "All"),
                           sliderInput("EstimatedSalary_ID", "Estimated Salary:",
                                       min = 0, max = 200000,
                                       value = c(0,200000))),

            mainPanel(width=10,
              tabsetPanel(type = "tabs",
                          tabPanel("Customer Demographics", 
                                   fluidRow(
                                     column(width = 12, show_col_types = FALSE,
                                            h3("Step 1: select customer demographic filter"),
                                            br(),
                                            fluidRow(
                                              column(width = 9, show_col_types = FALSE,
                                                     column(width = 4, show_col_types = FALSE,
                                                            box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                                column(12, align="center",
                                                                       plotOutput("map", width = "275px", height = "400px")))),
                                                     
                                                     column(width = 8, show_col_types = FALSE,
                                                            box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                                column(12, align="center",
                                                                       plotOutput("pie_chart", width = "475px", height = "475px")))),
                                                     fluidRow(
                                                       column(width = 4, show_col_types = FALSE,
                                                              h4("Total Customer Count: ", verbatimTextOutput("total")),
                                                              h4("Percent of Total: ", verbatimTextOutput("total_perc"))),
                                                       column(width = 4, show_col_types = FALSE,
                                                              h4("Customer Stayed Count: ", verbatimTextOutput("stayed")),
                                                              h4("Percent of Total: ", verbatimTextOutput("stayed_perc"))),
                                                       column(width = 4, show_col_types = FALSE,
                                                              h4("Total Churn Count: ", verbatimTextOutput("churn")),
                                                              h4("Percent of Total: ", verbatimTextOutput("churn_perc"))))),
                                              column(width = 3, show_col_types = FALSE,
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                plotOutput("plot1", height = "650px")))),
                                              )))),
                          tabPanel("Analysis",
                                            fluidRow(
                                              column(width = 12, show_col_types = FALSE,
                                                     h3("Step 2: select categories for factor analysis"),
                                                     br())),
                                            fluidRow(
                                              column(width = 3, show_col_types = FALSE,
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                selectInput("SelectCategory_ID_1", 
                                                                            label = "Select Category",
                                                                            choices = c(SelectCategory_1_factor), 
                                                                            selected = "Age"),
                                                                sliderInput("Balance_ID", "Customer Balance:",
                                                                            min = 0, max = 260000,
                                                                            value = c(0,260000))
                                                                ))),
                                              column(width = 9, show_col_types = FALSE,
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                plotOutput("plot2", height = "375px")))),
                                              fluidRow(
                                                column(title = "Title test test test", width = 12, show_col_types = FALSE,
                                                       h3("Table"),
                                                       DT::dataTableOutput("table")))
                                            )
                          )
              )
            )
          )
)




