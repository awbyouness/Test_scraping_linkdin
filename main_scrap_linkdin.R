source("scrap_linkdin2.R") 
source("clean_text.R") 
source("competence.R")
source("info_job.R")
source("clean_name.R")

link = "https://fr.linkedin.com/jobs/search?keywords=Data%20Scientist&location=France&trk=guest_job_search_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1%2C2&f_E=2&f_JT=F"
names = c("sql","r","python","statistique")
special = "r"

library(dplyr)
data =link %>%
  scrap_linkdin2()%>%
  clean_text()%>%
  competence(names,special)%>%
  info_job()

data = data[!duplicated(data[2]),]
rownames(data) = 1:length(data$Site)
data = clean_name(data)
data=data[order(data$total,decreasing = TRUE),]

write.csv(data,"offre_DS_linkdin_28_MAI_FR.csv")
