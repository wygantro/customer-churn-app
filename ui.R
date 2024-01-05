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
                                       value = c(0,200000)),
                           sliderInput("Balance_ID", "Customer Balance:",
                                       min = 0, max = 260000,
                                       value = c(0,260000))
                           ),

            mainPanel(width=10,
              tabsetPanel(type = "tabs",
                          tabPanel("Customer Demographics", 
                                   fluidRow(
                                     column(width = 12, show_col_types = FALSE,
                                            h2("Step 1: select customer demographic"),
                                            br(),
                                            fluidRow(
                                              column(width = 8, show_col_types = FALSE,
                                                     h3("Selected Customers"),
                                                     fluidRow(
                                                       column(width = 5, show_col_types = FALSE,
                                                              h5("Total Customer Count: ", verbatimTextOutput("total")),
                                                              h5("Percent of Total: ", verbatimTextOutput("total_perc")),
                                                              box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                                  column(12, align="left",
                                                                         plotOutput("pie_chart", width = "450px", height = "450px")))),
                                                       column(width = 7, show_col_types = FALSE,
                                                              box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                                  column(12, align="center",
                                                                         plotOutput("map", width = "400px", height = "600px")))))),

                                              column(width = 4, show_col_types = FALSE,
                                                     h3("Customer Churn"),
                                                     fluidRow(
                                                       column(width = 12, show_col_types = FALSE,
                                                              box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                                  column(12, align="center",
                                                                         plotOutput("plot1", width = "400px", height = "400px"))))),
                                                     fluidRow(
                                                       column(width = 12, show_col_types = FALSE,
                                                              h5("Customer Stayed Count: ", verbatimTextOutput("stayed")),
                                                              h5("Percent of Total: ", verbatimTextOutput("stayed_perc"))),
                                                       column(width = 12, show_col_types = FALSE,
                                                              h5("Total Churn Count: ", verbatimTextOutput("churn")),
                                                              h5("Percent of Total: ", verbatimTextOutput("churn_perc")))))
                                              )))),
                          tabPanel("Analysis",
                                            fluidRow(
                                              column(width = 12, show_col_types = FALSE,
                                                     h2("Step 2: select category for factor analysis"),
                                                     br())),
                                            fluidRow(
                                              column(width = 3, show_col_types = FALSE,
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                selectInput("SelectCategory_ID_1", 
                                                                            label = "Select Category",
                                                                            choices = c(SelectCategory_1_factor), 
                                                                            selected = "CustomerTenure"))))),
                                            fluidRow(
                                              column(width = 12, show_col_types = FALSE,
                                                     h3("Percent churned within customer demographic"),
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                plotOutput("plot2", height = "700px"))))),
                                            fluidRow(
                                              column(width = 12, show_col_types = FALSE,
                                                     h3("Number of customers churned within customer demographic"),
                                                     box(width = NULL, solidHeader = TRUE, status = "primary", color = "#286192",
                                                         column(12, align="center",
                                                                plotOutput("plot3", height = "700px")))))),
                          
                          tabPanel("Tabel",
                                   fluidRow(
                                     column(title = "Title test test test", width = 12, show_col_types = FALSE,
                                            h3("Table"),
                                            DT::dataTableOutput("table"))))
              )
            )
          )
        )