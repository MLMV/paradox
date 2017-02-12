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

# Note that for ggplot to correctly receive the input variable, we need to use
# aes_string instead of aes.

server <- function(input, output) {
      output$mpg1 <- renderPlot({
            
            wtLo <- input$slideWt[1]
            wtHi <- input$slideWt[2]
            
            subData <- subset(mtcars, mtcars$wt >= wtLo & mtcars$wt <= wtHi &
                                    mtcars$am %in% input$checkAm &
                                    mtcars$gear %in% input$checkGear)
            
            ggplot(data = subData, 
                   aes_string(x = "hp", y = "mpg")) +
                  geom_smooth(method = "lm", col = "dimgrey", fill = "lightgrey") +
                  geom_point(aes(color = cyl), size = 6, alpha = 0.6) +
                  labs(title = "Miles per gallon") +
                  theme_bw() +
                  scale_color_manual(values = myCols)
            
            })
      
      output$model1 <- renderPrint({
            
            wtLo <- input$slideWt[1]
            wtHi <- input$slideWt[2]

            subData <- subset(mtcars, mtcars$wt >= wtLo & mtcars$wt <= wtHi &
                                    mtcars$am %in% input$checkAm &
                                    mtcars$gear %in% input$checkGear)
            
            model1 = lm(mpg ~ hp, data = subData)
            summary(model1)$coeff
            })
      
      newData <- reactive({
            brushedData <- brushedPoints(mtcars, input$brush1, xvar = "hp", yvar = "mpg")
            if (nrow(brushedData) < 2) {
                  return(NULL)
            }
            data.frame(brushedData)
      })
      
      newModel <- reactive({
            brushedData <- brushedPoints(mtcars, input$brush1, xvar = "hp", yvar = "mpg")
            if (nrow(brushedData) < 2) {
                  return(NULL)
            }
            tempData <- data.frame(brushedData)
            model2 <- lm(mpg ~ hp, data = tempData)
            summary(model2)$coeff
            
      })
      
      output$mpg2 <- renderPlot({
            if (!is.null(newData())) {
                  ggplot(data = newData(),
                         aes_string(x = "hp", y = "mpg")) +
                        geom_smooth(method = "lm", col = "dimgrey", fill = "lightgrey") +
                        geom_point(size = 6, alpha = 0.6) +
                        labs(title = "Miles per gallon - Zoom") +
                        theme_bw() +
                        scale_color_manual(values = myCols)
            }
      })
      
      output$model2 <- renderPrint({
            if (!is.null(newData())) {
                  newModel()
                  }
            })
}

