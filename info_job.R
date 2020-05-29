info_job = function(data){ # fonction qui extrait le nom du poste et le nom de l'entreprise
  library(stringr)
  library(dplyr)
  
  tmp = as.character(data[,'Site'])
  var = str_replace_all(tmp,"%C3%A9|%E2%80%93|%E2%80%94|%E2%82%AC|%E2%82%AC90|%C3%B4","oe")
  ttt_2 = str_extract(var,"([a-z]*-){1,100}")
  name_poste = data.frame(nom_poste=str_extract(ttt_2,".*at") %>%str_remove("-at")%>%str_replace_all("-"," "),
                          nom_entreprise=str_extract(ttt_2,"-at.*|-for.*") %>% str_remove("-at|-for")%>%str_replace_all("-"," "))
  return(cbind(data,name_poste))
  
}

