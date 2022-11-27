##source
source('helpers.R')

##Test Web: https://www.cosdna.com/cht/cosmetic_7aa222320.html

##UI
ui <- fluidPage( #建立page
  
  fluidRow(
    column(5,
           textInput("web",h3("輸入保養品之cosDNA網址"), #建立文字Input框
                     value = "Enter the Web Address ..."
           )
    )
  ),
  
  fluidRow(
    column(5,
           DT::dataTableOutput("resultDT") #建立資料Output區域
    )
  )
  
)


##Server
server <- function(input, output) {
  
  dataInput <- reactive({ #處理dataInput #reactive用於當Input發生變動時的更新處理
    
    validate( #判斷Input是否符合要求
      test.web(input$web)
    )
    
    result <- get.chem(input$web)
    
    return(result)
    
  })
  
  output$resultDT <- DT::renderDataTable({#建立datatable輸出
    dataInput()
  })
  
}


## Run Shiny App
shinyApp(ui,server)