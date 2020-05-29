clean_text = function(data){
  library(stringr)
  library(dplyr)
  library(tm)
  ## Nettoyage de la description du poste des terme long provenant de l HTML
  contenu = as.character(data$description) %>%
    str_squish()%>%
    str_to_lower()%>%
    removePunctuation()%>%
    str_split(' ')
  
  l1 = c()
  l2 = c()
  
  for (i in 1:length(contenu)) {
    tmp = contenu[[i]]
    l_tmp = nchar(tmp)
    tmp = data.frame(tmp,l_tmp)
    var = paste0(tmp[which(tmp$l_tmp<18),1],collapse = " ") ## a cette etape le contenu est plus ou moins clean...
    
    
    ## extraire les parties liée au terme expérience : 
    
    var2 = as.character(tmp[which(tmp$l_tmp<18),1])
    exp=which(var2 =="expérience" | var2 == "experience" | var2 == "d'expérience")
    tmp_exp =" "
    if(length(exp) !=0){
      for (h in 1:length(exp)) {
        
        if((exp[h]-15)>0 & (exp[h]+15)<length(var2)){
          v = var2[(exp[h]-15):(exp[h]+15)]
          tmp_exp = c(tmp_exp,v,"######")
        }
      }
    }
    tmp_exp = paste(tmp_exp,collapse = ' ')
    l1[i] = var
    l2[i] = tmp_exp
  }
  
  data_clean  = data
  data_clean$description = l1
  data_clean$experience = l2
  colnames(data_clean) = c("Site","Description", "Expérience")
  return(data_clean)
}
