##source
source('helpers.R')

##蘭蔻 小黑瓶: https://www.cosdna.com/cht/cosmetic_7aa222320.html
##KIEHL'S 淡斑精華: https://www.cosdna.com/cht/cosmetic_a814392059.html

##Header
header <- 
  dashboardHeader(title = HTML("保養品成分"),
                  disable = FALSE,
                  titleWidth = 180
                  )
header$children[[2]]$children[[2]] <- header$children[[2]]$children[[1]]
header$children[[2]]$children[[1]] <- tags$a(href='https://www.cosdna.com/cht/product.php',
                                             tags$i(class = "fa-solid fa-flask-vial"),
                                             target = '_blank')
##Sidebar
sidebar <- 
  dashboardSidebar(
    width=180,
    sidebarMenu(
      id = "sidebar",
      style = "position: relative; overflow: visible;",
      menuItem("輸入保養品網址",tabName = "WebInput",icon = icon("earth-americas")),
      menuItem("儲存的成分表",tabName = "Saved",icon = icon("clipboard-list")),
      menuItem("輸入過敏源",tabName = "Allergy",icon = icon("person-dots-from-line")),
      menuItem("成分比較",tabName = "Compare",icon = icon("code-compare"))
      )
    )

##Body
body <- 
  dashboardBody(
    tabItems(
      tabItem(tabName = "WebInput",
              fluidRow(
                textInput("web",h3("輸入保養品之cosDNA網址"), #建立文字Input框
                                 value = "Enter the Web Address ..."),
                style = "margin-left:10px;"
                ),
              fluidRow(
                DT::dataTableOutput("resultDT"), #建立資料Output區域
                style = "margin-left:10px;"
                ),
              fluidRow(
                textInput("name","儲存此保養品",value = "請在此輸入品名"),
                actionButton("save","儲存"),
                style = "margin-top:30px; margin-left:10px;"
              )
              ),
      tabItem(tabName = "Saved",
              sidebarLayout(
                sidebarPanel(
                  selectInput("choice","請選擇保養品",c("請選擇","小黑瓶","淡斑精華"))
                ),
                mainPanel(
                  DT::dataTableOutput("choiceDT")
                )
              )
              ),
    tabItem(tabName = "Allergy",
            sidebarLayout(
              sidebarPanel(
                textInput("allergy","請輸入過敏源／警示的成分",value = ""),
                actionButton("addAllergy","新增")
              ),
              mainPanel(
                DT::dataTableOutput("allergyDT")
              )
            )
            ),
    tabItem(tabName = "Compare",
            fluidRow(
             column(6,
               selectInput("select","請選擇保養品",c("請選擇","小黑瓶","淡斑精華"))
               ),
             column(6,
               selectInput("select2","請選擇保養品",c("請選擇","小黑瓶","淡斑精華"))
               )
            ),
            fluidRow(
              column(6,
                DT::dataTableOutput("selectChem")
              ),
              column(6,
                DT::dataTableOutput("selectChem2")
              )
            ),
            fluidRow(
              column(5,
                     ),
              column(2,actionButton("compare","開始比對")),
              column(5,),style = "margin-top:30px;"
              
            ),
            fluidRow(
              h1("相衝成分／過敏警告", style = "color: red")
            )
            )
    )
  )

ui <- 
  dashboardPage(header, sidebar, body)


##Server
server <- function(input, output) {
  
  webInput <- reactive({ #處理dataInput #reactive用於當Input發生變動時的更新處理
    
    validate( #判斷Input是否符合要求
      test.web(input$web)
    )
    
    result <- get.chem(input$web)
    
    return(result)
    
  })
  
  output$resultDT <- DT::renderDataTable({#建立datatable輸出
    webInput()
  })
  
  choiceInput <- reactive(
    if(input$choice=="小黑瓶"){
      choiceResult <- lan
    }else if(input$choice=="淡斑精華"){
      choiceResult <- kie
    }else{
      choiceResult <- c()
    }
  )
  
  output$choiceDT <- DT::renderDataTable({
    choiceInput()
  })

  # resultAllergy <- reactiveVal(resultAllergy)
  # 
  # allergyInput <- eventReactive(input$addAllergy,{
  #   new = rbind(data.frame(Allergy = input$allergy),resultAllergy())
  #   resultAllergy(new)
  # })
  # 
  # output$allergyDT <- DT::renderDataTable({
  #   allergyInput()
  # })
  
  selectInput <- reactive(
    if(input$select=="小黑瓶"){
      selectResult <- lan
    }else if(input$select=="淡斑精華"){
      selectResult <- kie
    }else{
      choiceResult <- c()
    }
  )
  
  output$selectChem <- DT::renderDataTable({
    selectInput()
  })
  
  selectInput2 <- reactive(
    if(input$select2=="小黑瓶"){
      selectResult <- lan
    }else if(input$select2=="淡斑精華"){
      selectResult <- kie
    }else{
      choiceResult <- c()
    }
  )
  
  output$selectChem2 <- DT::renderDataTable({
    selectInput2()
  })
  
}

## Run Shiny App
shinyApp(ui,server)