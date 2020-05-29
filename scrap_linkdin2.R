scrap_linkdin2 = function(link ){
  library(RSelenium)
  library(XML)
  library(rvest)
  library(stringr)
  
  system('docker run -d -p 4445:4444 -p 5901:5900 selenium/standalone-chrome-debug:3.5.3')
  Sys.sleep(1)
  rem = remoteDriver(remoteServerAddr = "localhost", port = 4445L, browserName = "chrome")
  Sys.sleep(3)
  rem$open()
  rem$navigate(link)
  
  rem$getTitle()
  
  num_page = rem$getTitle() %>% str_split(" ") %>%unlist()
  num_page = num_page[3]
  num_page = str_sub(num_page,2,nchar(num_page))%>%as.numeric()
 
  webElem <- rem$findElement("css", "body")
  N = round((num_page/25),0)
  for (j in 1:N) {
    webElem$sendKeysToElement(list(key = "end"))
    cat("Extraction of Page",j,"among", N,"Pages","\n")
    #print(j)
    Sys.sleep(4)
  }
  html = rem$getPageSource()
  system('docker stop $(docker ps -q)')
  
  write.table(html, 
              file='code_result2.html', 
              quote = FALSE,
              col.names = FALSE,
              row.names = FALSE)
  
  web_site = read_html("code_result2.html")
  links = web_site %>% ## les liens des offres
    html_nodes(".result-card__full-card-link")%>%
    html_attr('href') 
  
  l = list()
  
  for (i in 1:(length(links)-1)) {
    cat("Extraction of the offer",i,"among",num_page-1,"offers","\n")
    
    tmp_url = links[i]
    download.file(tmp_url, destfile = "linkdin.html", quiet=TRUE)
    web_site = read_html("linkdin.html")
    
    description = web_site %>%
      html_node(".description") %>%
      html_text() %>%
      str_squish()
    l[[i]] = description
    Sys.sleep(1.5)
  }
  scraped_data = data.frame(links[1:(length(links)-1)],description=unlist(l))
  return(scraped_data)
  
}
