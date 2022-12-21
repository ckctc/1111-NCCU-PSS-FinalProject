##引入library

library(shiny) #UI
library(DT) #DataTable
library(rvest) #網頁擷取
library(magrittr) #for chaining commands
library(stringr) #字串處理
library(bslib) #bootstrap sass
library(shinycssloaders)
library(shinyBS)
library(shinydashboard)


##測試Input是否正確，且若不符則顯示警告訊息

test.web <- function(input){
  if (str_detect(input, pattern = "https://www.cosdna.com/cht/", negate = TRUE)){
    "Please Enter a WebSite from cosDNA."
  }else if (str_detect(input, pattern = ".html", negate = TRUE)){
    "Please Enter a Completed Web Address."
  }
}

##擷取網頁資料，並輸出成dataframe

get.chem <- function(web){
  
  url <- as.character(web)
  
  htmlContent <- read_html(url)
  
  chemPath <- "/html/body/div[1]/main/div[1]/div[2]/div[1]/table/tbody/tr/td[1]/a/div[1]" #設定要擷取網頁中何處特定區域之資料（xpath）

  chem <- htmlContent %>% html_nodes(xpath=chemPath) %>% html_text() #建立資料庫
  
  for (i in 1:length(chem)) { #處理資料
    locate_end <- str_locate_all(chem[i],pattern = "\n")
    names(locate_end) <- c("locate") #locate_end為list，將其命名以利索引
    index_end <- locate_end$locate[3,1]
    chem[i] <- str_sub(chem[i],start = 91, end = index_end-1)
  }
  
  chem <- as.data.frame(chem) #將結果轉為dataframe

}

# resultAllergy <- data.frame(Allergy = c())

lan <- get.chem("https://www.cosdna.com/cht/cosmetic_7aa222320.html")
kie <- get.chem("https://www.cosdna.com/cht/cosmetic_a814392059.html")