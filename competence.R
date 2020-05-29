competence = function(data,names, special){## caractére avec lequel on va filitrer!!!
  
  library(stringr)
  library(dplyr)
  #library(tm)
  
  tmp = data$Description %>% 
    str_split(' ')
  
  l = c()
  for (i in 1:length(tmp)) {
    txt = tmp[[i]]
    var = names %in% txt
    l[[i]] = ifelse(var==TRUE,1,0)
  }
  
  var = data.frame(t(data.frame(l[[1]])))
  for (i in 2:length(tmp)) {
    var = rbind(var,data.frame(t(data.frame(l[[i]]))))
  }
  colnames(var) = names 
  var$total = rowSums(var)
  var = cbind(data,var)
  
  data_final= var[which(var[,special]>0 & var$total>0),]
  # %>% filter(special!=0 & total>0) ## selectionner les offres ayant R et une somme supérieur à 0
  ## /!\  Fin de la personnalisation
  return(data_final)
}
