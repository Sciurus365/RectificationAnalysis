library(shiny)
library(ggplot2)
library(shinythemes)
library(dplyr)

function(input, output) {
  
  pic <- eventReactive(input$update, {
    # 数据的读入
    q <- input$q_
    xF <- input$xF_
    R <- input$R_
    xD <- input$xD_
    xW <- input$xW_
    alpha <- input$alpha_
    
    # 参考线、y-x线、q线和d线的定义
    ref_line <- function(x) {
      x
    }
    yx_line <- function(x) {
      alpha * x/(1 + (alpha - 1) * x)
    }
    q_line <- function(x) {
      q/(q - 1) * x - xF/(q - 1)
    }
    d_line <- function(x) {
      R/(R + 1) * x + xD/(R + 1)
    }
    
    # q=1时的特殊处理
    p1 <- ggplot(data.frame(x = c(0, 1)), aes(x))
    if (near(q, 1)) {
      p1 <- p1 + geom_vline(aes(xintercept = xF, color = "#FF8356"))
      q_point <- c(xF, d_line(xF))
      q_alpha_point <- c(xF, yx_line(xF))
    } else {
      p1 <- p1 + stat_function(fun = q_line, n = 10001, color = "#FF8356")
      lf <- matrix(c(q/(q - 1), -1, R/(R + 1), -1), nrow = 2, byrow = TRUE)
      rf <- matrix(c(xF/(q - 1), -xD/(R + 1)), nrow = 2, byrow = TRUE)
      q_point <- solve(lf, rf)
      xtemp <- 
        uniroot(function(x){yx_line(x)-q_line(x)},c(0,1),tol=0.00000001)$root
      q_alpha_point <- c(xtemp, q_line(xtemp))
    }
    
    # 最小回流比的计算
    Rmin <- (xD-q_alpha_point[2])/(q_alpha_point[2]-q_alpha_point[1])
    
    # w线的定义
    w_line <- function(x) {
      xW + (q_point[2] - xW)/(q_point[1] - xW) * (x - xW)
    }
    
    # 图1初始化
    p1 <- p1 + stat_function(fun = ref_line, color = "gray") + 
      stat_function(fun = yx_line, color = "#40514E") + 
      stat_function(fun = d_line, n = 10001, color ="#11999E") + 
      stat_function(fun = w_line, n = 10001, color = "#30E3CA") + 
      theme_bw() + coord_fixed() + 
      scale_x_continuous(limits = c(0, 1), expand = c(0,0)) + 
      scale_y_continuous(limits = c(0, 1), expand = c(0,0))
    
    # 逐板计算
    n_ <- vector("integer",0)
    x_ <- vector("double",0)
    y_ <- vector("double",0)
    LM <- tibble(
      n = n_,
      x = x_,
      y = y_
    )
    n_ = 1
    y_ <- xD
    result <- uniroot(function(x){yx_line(x)-y_},c(0,1),tol=0.00000001)
    x_ <- result$root
    p2 <- ggplot(LM)
    while(x_ > q_point[1]){
      p1 <- p1 + geom_point(x=x_, y=y_, size = 1)
      result <- uniroot(function(x){yx_line(x)-y_},c(0,1),tol=0.00000001)
      x_ <- result$root
      p1 <- p1 + geom_point(x=x_, y=y_, size = 1)
      LM <- LM %>% add_row(n = n_, x = x_, y = y_)
      y_ <- d_line(x_)
      n_ <- n_+1
    }
    
    nF <- n_ - 0.5
    p2 <- p2 + geom_vline(aes(xintercept = nF)) + geom_hline(aes(yintercept = xW))
    
    while(x_ > xW){
      y_ <- w_line(x_)
      p1 <- p1 + geom_point(x=x_, y=y_, size = 1)
      result <- uniroot(function(x){yx_line(x)-y_},c(0,1),tol=0.00000001)
      x_ <- result$root
      p1 <- p1 + geom_point(x=x_, y=y_, size = 1)
      LM <- LM %>% add_row(n = n_, x = x_, y = y_)
      n_ <- n_+1
    }
    y_ <- w_line(x_)
    p1 <- p1 + geom_point(x=x_, y=y_, size = 1)
    
    p2 <- p2 + 
      geom_point(data = LM, mapping = aes(x = n, y = x), shape = 19, size = 1) +
      geom_point(data = LM, mapping = aes(x = n, y = y), shape = 17, size = 2) +
      theme_bw() +
      scale_x_continuous(breaks = 1:n_)+ 
      ylab("x, y")
    
    # p1 <- p1 +
    #   geom_line(data = LM, mapping = aes(x = x, y = y))
    
    list(p1, p2, Rmin)
  })
  
  output$Rmin <- renderText({
    ptemp <- pic()
    ptemp[[3]]
  })
  output$op_line <- renderPlot({
    ptemp <- pic()
    ptemp[[1]]
  })
  
  output$LM_calc <- renderPlot({
    ptemp <- pic()
    ptemp[[2]]
  })
  
  
}