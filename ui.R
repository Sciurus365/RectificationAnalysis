library(shiny)
library(ggplot2)
library(shinythemes)
library(dplyr)

fluidPage(theme = shinytheme("united"),
          navbarPage(
            "化学工程基础：精馏过程分析",
            tabPanel("工作线的绘制和逐板计算",
                     sidebarLayout(
                       sidebarPanel(
                         strong("首次打开或更改数据后请点击"),
                         actionButton("update",
                                      "更新"),
                         numericInput("alpha_",
                                      p(#"相对挥发度", 
                                        em("α"),"=", "（请输入大于1的数值）"),
                                      value = 2),
                         numericInput("q_",
                                      p(em("q"),"="),
                                      value = 0.5),
                         numericInput("R_",
                                      p(#"回流比", 
                                        em("R"),"=", "（请输入大于", HTML('<em>R</em><sub>min</sub>'), "的数值）"),
                                      value = 5),
                         numericInput("xF_",
                                      HTML( "<em>x</em><sub>F</sub>= （请输入(0,1)范围的数值）"),
                                      value = 0.5),
                         numericInput("xD_",
                                      HTML("<em>x</em><sub>D</sub>= （请输入(<em>x</em><sub>F</sub>,1)范围的数值）"),
                                      value = 0.9),
                         numericInput("xW_",
                                      HTML("<em>x</em><sub>W</sub>=（请输入(0,<em>x</em><sub>F</sub>)范围的数值）"),
                                      value = 0.1)
                       ),
                       mainPanel(
                         HTML('
                              <h1> <em>R</em><sub>min</sub> = </h1>
                              '),
                         textOutput("Rmin"),
                         h1("操作线的绘制"),
                         plotOutput("op_line"),
                         HTML('<p style="text-align: center;">图例：
                              <font color="gray"><em>y</em>=<em>x</em>参考线</font> &nbsp;&nbsp;
                              <font color="#FF8356"><em>q</em>线</font> &nbsp;&nbsp;
                              <font color="#40514E"><em>y</em>,<em>x</em>平衡线</font> &nbsp;&nbsp;
                              <font color="#11999E">精馏段操作线</font> &nbsp;&nbsp;
                              <font color="#30E3CA">提馏段操作线</font> &nbsp;&nbsp;
                              </p>
                              '),
                         h1("逐板计算"),
                         plotOutput("LM_calc"),
                         HTML('<div style="text-align: center;">图例：
                              ● <em>x</em> &nbsp;&nbsp;  ▲ <em>y</em> &nbsp;&nbsp;  — <em>x</em><sub>W</sub>  &nbsp;&nbsp;  | &nbsp;加料口位置
                              </div>
                              ')
                         )
                         )
                         ),
            tabPanel("关于",
                     h2("作者"),
                     p(strong("崔竞蒙"),"北京大学化学与分子工程学院 2015级本科生"),
                     h2("联系方式"),
                     p("cuijm@pku.edu.cn"),
                     a("Github: github.com/Sciurus365/RectificationAnalysis", href="https://github.com/Sciurus365/RectificationAnalysis"),
                     h2("更新日期"),
                     p("2017.12.11"),
                     p("Powered by", a("Shiny 1.0.5", href = "http://shiny.rstudio.com/"))
                     
            )
                         )
)