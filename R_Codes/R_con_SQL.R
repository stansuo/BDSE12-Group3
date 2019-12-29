
#----------------------------------------R與SQL構連部分----------------------------------------

#連線MySQL資料庫
library(DBI)
con <- dbConnect(RMariaDB::MariaDB(),host="localhost",user="root",password="12345678",port=3306 )
#user及password自行修改...port（windows 的phpadmin預設是3306, mac電腦不同...）


#顯示database
sql_query <- "show databases;"
query_result <- dbGetQuery(con, sql_query)
query_result
#切換到books_test 資料庫 (顯示的資料庫可以自行修改)
sql_query <- "use home_credit;"
query_result <- dbGetQuery(con, sql_query)

#顯示目前的資料庫內所有的table
sql_query <- "show tables;"
query_result <- dbGetQuery(con, sql_query)
query_result




#------------------- 讀取csv檔------------------------------
data <- read.csv("C:/Shared/01.資料交換區/RawData/home-credit-default-risk/previous_application.csv")
data


#-------------------先建立一個table資料表在ＳＱＬ，並將data.frame匯入SQL------------------------------

#只能在ＳＱＬ未建立book資料表前使用，簡單來說只能使用一次...
#不然就要使用insert into方式批次寫入
#將data的data.frame格式整批寫到book資料表內
dbWriteTable(con,"previous_application",data)
dbListTables(con)

#----------------------------------------網路爬蟲部分----------------------------------------

#連到博客來中文排行網站爬取 
library("rvest")
book_url <- "https://www.books.com.tw/web/sys_newtopb/books/"
doc.html <- read_html(book_url)
book_name<- doc.html %>% 
  html_nodes(css=" h4 a ") %>% 
  html_text()  
author_name<- doc.html %>% 
  html_nodes(css=".msg a") %>% 
  html_text()
data <- data.frame(book=book_name,author=author_name)
View(data)



#批次寫入SQL函數  （column跟value要自行增修的話paste內指令要改變）
insert_into <- function(table){
  #函數insert_into選擇要傳入資料庫的table名稱
  for (i in 1:nrow(data)) {
    #nrow(data)->網路爬蟲下來的data.frame有多少列
    column1 <- names(data)[1]   #data.frame內的第1個標題->當成資料表的第1欄位索引位子
    column2 <- names(data)[2]   #data.frame內的第2個標題->當成資料表的第2欄位索引位子
    value1 <- as.character(data$book[i])   #data.frame內的第1個欄位第i列資料->當成第1個values
    value2 <- as.character(data$author[i]) #data.frame內的第2個欄位第i列資料->當成第2個values
    sql_query<- paste0("INSERT INTO " ,table, "(" ,column1,",",column2, ") VALUES ('",value1,"','",value2,"');")
    query_result <- dbSendQuery(con, sql_query)
  }
}

#呼叫寫入SQL函數（資料表可以自行修改，在ＳＱＬ內要先建立（可以用dbWriteTable建立或是下sql指令）才能寫入）
insert_into("book")

#檢視book資料表
sql_query <- "select * from book;"
query_result <- dbGetQuery(con, sql_query)
query_result
