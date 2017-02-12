# ================================== HEADER ====================================

# Project: mtcars App
# Date: Feb 12, 2017
# Creator: MLMV

# ================================== CODE ======================================

# Prep workspace ----------------------------------------------------------

library(shiny)
library(ggplot2)

myCols <- c("#084186", "#2D8D00", "#D32300", "#FFB10A", "#642C8E", "#FF6600", 
            "#4B79B0", "#69B645", "#EE6145", "#FFCD63", "#9C78B7", "#FF9D5C", 
            "#A5BCD7", "#B4DAA2", "#F6B0A2", "#FFE9BC", "#D4C5E0", "#FFC7A2")


# ================================== DATA ======================================

data("mtcars")
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)
mtcars$gear <- as.factor(mtcars$gear)
mtcars$carb <- as.factor(mtcars$carb)


# ================================== APP =======================================

# Define UI for application that draws a histogram
fluidPage(
      titlePanel("Deceiving Data"),
      sidebarLayout(
            sidebarPanel(
                  width = 3,
                  sliderInput(
                        inputId = "slideWt",
                        label = "Max weight in 1000lbs",
                        min = min(mtcars$wt),
                        max = max(mtcars$wt),
                        value = c(min(mtcars$wt),max(mtcars$wt)),
                        step = 0.1
                        ),
                  checkboxGroupInput(
                        inputId = "checkAm",
                        label = "Transmission",
                        choices = c("Automatic" = 0, "Manual" = 1),
                        selected = c(0,1)
                        ),
                  checkboxGroupInput(
                        inputId = "checkGear",
                        label = "Gears",
                        choices = c(3,4,5),
                        selected = c(3,4,5)
                        )
                  ),
            mainPanel(
                  tabsetPanel(
                        tabPanel(
                              title = "Introduction",
                              br(),
                              h4("Simpson's Paradox"),
                              p(
                                    "Simpson's paradox (or the Yule-Simpson effect) 
                                    is a phenomenon in probability and statistics, 
                                    in which a trend appears in different groups 
                                    of data but disappears or reverses when these 
                                    groups are combined."
                              ),
                              p(
                                    "Unfortunately, that is only one example of 
                                    how data (especially the multivariate kind), 
                                    can be misleading. Popular magazines or TV ads 
                                    are frequently found guilty of coming up with 
                                    misleading information. Some common issues with 
                                    data in modern media are:"
                              ),
                              tags$ul(
                                    tags$li("Not showing the entire scale of the data or using irrelevant scales"),
                                    tags$li("Using only a subset of the data to supports a given conclusion"),
                                    tags$li("Showing data out of context"),
                                    tags$li("Using irrelevant or opportunistic subgroups"),
                                    tags$li("Falsely implying relationships between variables")
                              )
                        ),
                        tabPanel(
                              title = "Charts",
                              br(),
                              h4("Deceiving Data"),
                              p(
                                    "The visualization below provides insights into
                                    the relationship between 5 different aspects
                                    of motor vehicles: horsepower, miles per gallon
                                    and cylinders. The sliders and checkboxes on 
                                    the left can be used to filter by weight, 
                                    transmission types and gears."
                              ),
                              p(
                                    "Take a look, and think about what this data 
                                    tells you - for example about the relationship 
                                    between horsepower and miles per gallon."
                              ),
                              tags$ul(
                                    tags$li("What happens if you only include cars 
                                          with a weight of 4,000lbs or more? Does 
                                          it change how you see the interaction 
                                          between cylinders and the other variables?"),
                                    tags$li("What happens if you select only those 
                                            data points between 200 and 300hp? Does 
                                            it change your understanding of the 
                                            relationship between horsepower and 
                                            miles per gallon?")
                              ),
                              br(),
                              plotOutput("mpg1",
                                         brush = brushOpts(
                                               id = "brush1"
                                               )
                                         ),
                              verbatimTextOutput("model1"),
                              plotOutput("mpg2"),
                              verbatimTextOutput("model2")
                              ),
                        tabPanel(
                              br(),
                              title = "User Guide",
                              h4("Using the charts"),
                              p(
                                    "You can manipulate the content of the charts 
                                    by moving the sliders on the left. The sliders 
                                    determine the ranges of several properties for 
                                    the cars you want to see included in the charts. 
                                    You can also use your mouse to drag a box around 
                                    a region of data points. This will bring up a 
                                    second scatter plot that zooms in on the selected 
                                    region."
                              ),
                              br(),
                              h4("Data definitions"),
                              tags$ul(
                                    tags$li("mpg: Miles/(US) gallon"),
                                    tags$li("cyl: Number of cylinders"),
                                    tags$li("disp: Displacement (cu.in.)"),
                                    tags$li("hp: Gross horsepower"),
                                    tags$li("drat: Rear axle ratio"),
                                    tags$li("wt: Weight (1000 lbs)"),
                                    tags$li("qsec: 1/4 mile time"),
                                    tags$li("vs: V/S"),
                                    tags$li("am:Transmission (0 = automatic, 1 = manual)"),
                                    tags$li("gear: Number of forward gears"),
                                    tags$li("carb: Number of carburetors")
                                    )
                              )
                        )
                  )
            )
      )